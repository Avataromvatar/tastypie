import 'package:tastypie/src/layer/layer.dart';
import 'package:tastypie/src/taste/taste.dart';
import 'package:tastypie/src/taste/taste_dto.dart';

abstract class ITopping {
  bool addInputTaste(
      String topic,
      void Function(dynamic data, String topic, int state, ITasteOutput? output)
          handler,
      {int stateMask = 0xFFFFFFFF,
      ITasteOutput? link});
  bool addOutputTaste(String topic,
      {List<ITasteInput>? connections, int stateMask = 0xFFFFFFFF});
  bool addTaste(ITaste taste);

  ///send dto if filter outputTaste check ok.
  bool send(ITasteDTO dto);

  ///if [topic]=null return all Taste
  List<ITaste> getTaste({String? topic, int stateMask = 0xFFFFFFFF});
}

abstract class IToppingMechanics implements ITopping {
  ///Then Toping add to TastyPieLayer? TastyPieLayer set self to [layer]
  ITastyPieLayer? get own_layer;
  set own_layer(ITastyPieLayer? layer);
  List<ITasteInput> get inputTaste;
  List<ITasteOutput> get outputTaste;

  ///Send from [taste] to other layer or extern
  void sendFromTaste(ITasteDTO dto, ITasteOutput taste);

  ///TastyPieLayer call then get message
  void call(ITasteDTO dto);

  ///TastyPieLayer call when this topping remove from layer
  void complete();
}

class Topping implements IToppingMechanics {
  List<ITasteInput> _input_taste = List<ITasteInput>.empty(growable: true);
  List<ITasteOutput> _output_taste = List<ITasteOutput>.empty(growable: true);
  List<ITasteInput> get inputTaste => _input_taste;
  List<ITasteOutput> get outputTaste => _output_taste;
  bool addInputTaste(
      String topic,
      void Function(dynamic data, String topic, int state, ITasteOutput? output)
          handler,
      {int stateMask = 0xFFFFFFFF,
      ITasteOutput? link}) {
    //TODO analize _input_taste before add
    _input_taste.add(TasteInput(topic, handler,
        stateMask: stateMask, outputLink: link, ownTopping: this));
    return true;
  }

  bool addOutputTaste(String topic,
      {List<ITasteInput>? connections, int stateMask = 0xFFFFFFFF}) {
    //TODO analize _input_taste before add
    _output_taste
        .add(TasteOutput(topic, stateMask: stateMask, ownTopping: this));
    return true;
  }

  bool addTaste(ITaste taste) {
    if (taste is ITasteToTopping) (taste as ITasteToTopping).ownTopping = this;
    if (taste is ITasteInput) {
      _input_taste.add(taste);
    } else if (taste is ITasteOutput) {
      _output_taste.add(taste);
    }
    return true;
  }

  void sendFromTaste(ITasteDTO dto, ITasteOutput taste) {
    //TODO
  }
  bool send(ITasteDTO dto) {
    bool isSending = false;
    _output_taste.forEach((element) {
      if (element.send(dto)) isSending = true;
    });
    return isSending;
  }

  List<ITaste> getTaste({String? topic, int stateMask = 0xFFFFFFFF}) {
    var ret = List<ITaste>.empty(growable: true);
    if (topic != null) {
      for (var i = 0;
          i <
              (_input_taste.length > _output_taste.length
                  ? _input_taste.length
                  : _output_taste.length);
          i++) {
        if (i < _input_taste.length) if (_input_taste[i].topic == topic &&
            (_input_taste[i].stateMask == stateMask)) {
          ret.add(_input_taste[i]);
        }
        if (i < _output_taste.length) if (_output_taste[i].topic == topic &&
            (_output_taste[i].stateMask == stateMask)) {
          ret.add(_output_taste[i]);
        }
      }
    } else {
      ret.addAll(_input_taste);
      ret.addAll(_output_taste);
    }
    return ret;
  }

  ITastyPieLayer? _own_layer;
  ITastyPieLayer? get own_layer => _own_layer;
  set own_layer(ITastyPieLayer? layer) => _own_layer = layer;

  void call(ITasteDTO dto) {
    _input_taste.forEach((element) {
      if (element.topic == dto.topic && (element.stateMask & dto.state != 0)) {
        element.call(dto);
      }
    });
  }

  ///TastyPieLayer call when this topping remove from layer
  void complete() {
    _output_taste.forEach((element) {
      element.disconnectAll();
    });
    own_layer = null;
  }
}

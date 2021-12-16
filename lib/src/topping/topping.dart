import 'package:tastypie/src/colony/icolony.dart';
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
  List<ITaste> getTaste(String topic, {int stateMask = 0xFFFFFFFF});
}

abstract class IToppingMechanics implements ITopping {
  ///Then Toping add to TastyPieLayer? TastyPieLayer set self to [layer]
  ITastyPieLayer? get own_layer;
  set own_layer(ITastyPieLayer? layer);

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

  bool addInputTaste(
      String topic,
      void Function(dynamic data, String topic, int state, ITasteOutput? output)
          handler,
      {int stateMask = 0xFFFFFFFF,
      ITasteOutput? link}) {
    //TODO analize _input_taste before add
    _input_taste.add(
        TasteInput(topic, handler, stateMask: stateMask, outputLink: link));
    return true;
  }

  bool addOutputTaste(String topic,
      {List<ITasteInput>? connections, int stateMask = 0xFFFFFFFF}) {
    //TODO analize _input_taste before add
    _output_taste.add(TasteOutput(topic, stateMask: stateMask));
    return true;
  }

  bool addTaste(ITaste taste) {
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

  List<ITaste> getTaste(String topic, {int stateMask = 0xFFFFFFFF}) {}

  ITastyPieLayer? _own_layer;
  ITastyPieLayer? get own_layer => _own_layer;
  set own_layer(ITastyPieLayer? layer) => _own_layer = layer;

  ///TastyPieLayer call then get message
  void call(ITasteDTO dto);

  ///TastyPieLayer call when this topping remove from layer
  void complete();
}

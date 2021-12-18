import 'dart:async';

import 'package:tastypie/src/taste/taste.dart';
import 'package:tastypie/src/taste/taste_dto.dart';
import 'package:tastypie/src/topping/topping.dart';
import 'package:tastypie/tastypie.dart';

abstract class ITastyPieLayer {
  void addTopping(IToppingMechanics topping);
  void removeTopping(IToppingMechanics topping);
  List<ITopping>? getTopping(String topic, {int stateMask = 0xFFFFFFFF});

  ///From layer to topping and to taste (down stream)
  bool call(ITasteDTO dto);

  bool sendToAnotherLayer(ITasteDTO dto, {ITastyPieLayer? source});

  ///listen output topic
  // StreamSubscription<ITasteDTO>? listen(
  //     String topic, void Function(ITasteDTO dto) handler,
  //     {int stateMask = 0xFFFFFFFF});
}

abstract class ITastyPieLayerMechanics implements ITastyPieLayer {
  bool callFromAnotherLayer(ITasteDTO dto, {ITastyPieLayer? source});
  void connect(ITastyPieLayerMechanics layer);
  void disconnect(ITastyPieLayerMechanics layer);
}

class TastyPieLayer implements ITastyPieLayerMechanics {
  final List<ITastyPieLayerMechanics> _layers =
      List<ITastyPieLayerMechanics>.empty(growable: true);
  final Map<String, Map<int, List<ITasteInput>>> _inputsTaste =
      Map<String, Map<int, List<ITasteInput>>>();

  ///topic state [IToppingMechanics]
  final Map<String, Map<int, List<ITasteOutput>>> _outputsTaste =
      Map<String, Map<int, List<ITasteOutput>>>();

  // final List<IToppingMechanics> _a =
  //     List<IToppingMechanics>.empty(growable: true);
  final List<IToppingMechanics> _listTopping =
      List<IToppingMechanics>.empty(growable: true);

  void addTopping(IToppingMechanics topping) {
    topping.own_layer = this;
    _addToInput(topping);
    _addToOutput(topping);
    _listTopping.add(topping);
    rebuildDirectNet();
  }

  bool sendToAnotherLayer(ITasteDTO dto, {ITastyPieLayer? source}) {
    bool isSended = false;
    _layers.forEach((element) {
      if (element.callFromAnotherLayer(dto, source: this)) {
        isSended = true;
      }
    });
    return isSended;
  }

  void removeTopping(IToppingMechanics topping) {
    topping.own_layer = null;
    _removeFromOutput(topping);
    _removeFromInput(topping);
    _listTopping.remove(topping);
    // _rebuildDirectNet(topping);
    topping.complete();
    rebuildDirectNet();
  }

  List<ITopping>? getTopping(String topic, {int stateMask = 0xFFFFFFFF}) {}
  bool call(ITasteDTO dto) {
    bool isSended = false;
    if (_inputsTaste.containsKey(dto.topic)) {
      _inputsTaste[dto.topic]!.forEach((key, value) {
        if ((key & dto.state) != 0) {
          value.forEach((element) {
            if (element.call(dto)) {
              isSended = true;
            }
          });
        }
      });
    }
    return isSended;
  }

  bool callFromAnotherLayer(ITasteDTO dto, {ITastyPieLayer? source}) {
    if (source != null) {
      _layers.forEach((element) {
        if (element != source) {
          element.callFromAnotherLayer(dto, source: this);
        }
      });
    }
    return call(dto);
  }

  void connect(ITastyPieLayerMechanics layer) {
    if (!_layers.contains(layer)) _layers.add(layer);
  }

  void disconnect(ITastyPieLayerMechanics layer) {
    _layers.remove(layer);
  }
  // StreamSubscription<ITasteDTO>? listen(
  //     String topic, void Function(ITasteDTO dto) handler,
  //     {int stateMask = 0xFFFFFFFF}) {
  //       _searchAndDo(_outputsTaste,topic,(t){

  //       },stateMask: stateMask);
  //     }

  void _searchAndDo<T extends ITaste>(Map<String, Map<int, List<T>>> dict,
      String topic, void Function(T taste) fun,
      {int stateMask = 0xFFFFFFFF}) {
    dict.forEach((key, value) {
      if (key == topic) {
        value.forEach((sm, lt) {
          if ((sm & stateMask) != 0) {
            lt.forEach((t) {
              fun(t);
            });
          }
        });
      }
    });
  }

  void _addToInput(IToppingMechanics topping) {
    topping.inputTaste.forEach((element) {
      if (!_inputsTaste.containsKey(element.topic)) {
        _inputsTaste[element.topic] = Map<int, List<ITasteInput>>();
        _inputsTaste[element.topic]![element.stateMask] =
            List<ITasteInput>.empty(growable: true)..add(element);
      } else {
        if (!_inputsTaste[element.topic]!.containsKey(element.stateMask)) {
          _inputsTaste[element.topic]![element.stateMask] =
              List<ITasteInput>.empty(growable: true)..add(element);
        } else {
          _inputsTaste[element.topic]![element.stateMask]!.add(element);
        }
      }
    });
  }

  void _addToOutput(IToppingMechanics topping) {
    topping.outputTaste.forEach((element) {
      if (!_outputsTaste.containsKey(element.topic)) {
        _outputsTaste[element.topic] = Map<int, List<ITasteOutput>>();
        _outputsTaste[element.topic]![element.stateMask] =
            List<ITasteOutput>.empty(growable: true)..add(element);
      } else {
        if (!_outputsTaste[element.topic]!.containsKey(element.stateMask)) {
          _outputsTaste[element.topic]![element.stateMask] =
              List<ITasteOutput>.empty(growable: true)..add(element);
        } else {
          _outputsTaste[element.topic]![element.stateMask]!.add(element);
        }
      }
    });
  }

  void _removeFromInput(IToppingMechanics topping) {
    topping.inputTaste.forEach((element) {
      if (_inputsTaste.containsKey(element.topic)) {
        if (_inputsTaste[element.topic]!.containsKey(element.stateMask)) {
          _inputsTaste[element.topic]![element.stateMask]!.remove(element);
        }
      }
    });
  }

  void _removeFromOutput(IToppingMechanics topping) {
    topping.outputTaste.forEach((element) {
      if (_outputsTaste.containsKey(element.topic)) {
        if (_outputsTaste[element.topic]!.containsKey(element.stateMask)) {
          element.disconnectAll();
          _outputsTaste[element.topic]![element.stateMask]!.remove(element);
        }
      }
    });
  }

  void rebuildDirectNet() {
    _listTopping.forEach((element) {
      _rebuildDirectNet(element);
    });
  }

  void _rebuildDirectNet(IToppingMechanics topping) {
    for (var i = 0; i < topping.outputTaste.length; i++) {
      //search topic in input
      var topic = topping.outputTaste[i].topic;
      var stateMask = topping.outputTaste[i].stateMask;
      topping.outputTaste[i].disconnectAll(); //claer all direct link
      if (_inputsTaste.containsKey(topic)) {
        //topic finded. forEach state
        _inputsTaste[topic]!.forEach((key, value) {
          if ((key & stateMask) != 0) {
            //check state OK connect
            value.forEach((element) {
              topping.outputTaste[i].connect([element]);
            });
          }
        });
      }
    }
  }
}

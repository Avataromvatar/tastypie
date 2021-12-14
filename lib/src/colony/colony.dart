import 'dart:math';

import 'package:tastypie/src/archaea/iarchaea.dart';
import 'package:tastypie/src/colony/icolony.dart';
import 'package:tastypie/src/dto/dto.dart';
import 'package:tastypie/src/point/point.dart';

class Colony implements IColonyMechanics {
  ///topic state [IArchaeaMechanics]
  final Map<String, Map<int, List<IArchaeaMechanics>>> _inputs =
      Map<String, Map<int, List<IArchaeaMechanics>>>();

  ///topic state [IArchaeaMechanics]
  final Map<String, Map<int, List<IArchaeaMechanics>>> _outputs =
      Map<String, Map<int, List<IArchaeaMechanics>>>();

  ///name [IArchaeaMechanics]
  final Map<String, List<IArchaeaMechanics>> _archaeas =
      Map<String, List<IArchaeaMechanics>>();
  final List<IArchaeaMechanics> _listArchaea =
      List<IArchaeaMechanics>.empty(growable: true);
  // bool _isUpdating = false;
  // bool get isUpdating => _isUpdating;

  void addArchaea(IArchaeaMechanics archaea) {
    if (!_archaeas.containsKey(archaea.name)) {
      _archaeas[archaea.name] = List<IArchaeaMechanics>.empty(growable: true);
    }
    archaea.colony = this;
    _listArchaea.add(archaea);
    _archaeas[archaea.name]!.add(archaea);
    _addToInput(archaea);
    _addToOutput(archaea);

    // _isUpdating = false;
  }

  void _addToInput(IArchaeaMechanics arc) {
    arc.inpoint.forEach((element) {
      if (!_inputs.containsKey(element.topic)) {
        _inputs[element.topic] = Map<int, List<IArchaeaMechanics>>();
      }
      if (!_inputs[element.topic]!.containsKey(element.stateMask)) {
        _inputs[element.topic]![element.stateMask] =
            List<IArchaeaMechanics>.empty(growable: true);
      }
      _inputs[element.topic]![element.stateMask]!.add(arc);
    });
  }

  void _addToOutput(IArchaeaMechanics arc) {
    arc.outpoint.forEach((element) {
      if (!_outputs.containsKey(element.topic)) {
        _outputs[element.topic] = Map<int, List<IArchaeaMechanics>>();
      }
      if (!_outputs[element.topic]!.containsKey(element.stateMask)) {
        _outputs[element.topic]![element.stateMask] =
            List<IArchaeaMechanics>.empty(growable: true);
      }
      _outputs[element.topic]![element.stateMask]!.add(arc);
    });
  }

  void _removeFromInput(IArchaeaMechanics arc) {
    arc.inpoint.forEach((element) {
      if (_inputs.containsKey(element.topic)) {
        if (_inputs[element.topic]!.containsKey(element.stateMask)) {
          _inputs[element.topic]![element.stateMask]!.remove(arc);
        }
      }
    });
  }

  void _removeFromOutput(IArchaeaMechanics arc) {
    arc.outpoint.forEach((element) {
      if (_outputs.containsKey(element.topic)) {
        if (_outputs[element.topic]!.containsKey(element.stateMask)) {
          _outputs[element.topic]![element.stateMask]!.remove(arc);
        }
      }
    });
  }

  void removeArchaea(IArchaeaMechanics archaea) {
    if (_archaeas.containsKey(archaea.name)) {
      _listArchaea.remove(archaea);
      _removeFromInput(archaea);
      _removeFromOutput(archaea);
      archaea.goOut();
      _listArchaea.forEach((element) {
        element.outpoint.forEach((point) {
          point.disconnect(archaea.inpoint);
        });
      });
      var arr = _archaeas[archaea.name]!;
      for (var i = 0; i < arr.length; i++) {
        if (arr[i] == archaea) {
          // _removeFromInput(archaea);
          // _removeFromOutput(archaea);
          // arr[i].goOut();
          arr.removeAt(i);
          // _isUpdating = false;
          break;
        }
      }
    }
  }

  void directLinkArchaea(IArchaeaMechanics arch) {
    for (var i = 0; i < arch.outpoint.length; i++) {
      //

      if (_inputs.containsKey(arch.outpoint[i].topic)) {
        //we find topic
        // var states = _inputs[arch.outpoint[i].topic]!.keys;

        _inputs[arch.outpoint[i].topic]!.forEach((key, value) {
          if ((key & arch.outpoint[i].stateMask) != 0) {
            //state Ok
            value.forEach((archaea) {
              if (archaea != arch) {
                //add elements

                arch.outpoint[i].connect([
                  archaea.inpoint.singleWhere((input) => input.checkAccess(
                      arch.outpoint[i].topic, arch.outpoint[i].stateMask))
                ]);
              }
            });
          }
        });
      }
    }
  }

  void unlinkArchaea(IArchaeaMechanics arch) {}

  void updateDirectNet() {
    //step 1
    _listArchaea.forEach((element) {
      directLinkArchaea(element);
    });
  }

  bool call(ITastyPieDTO dto) {
    bool isCall = false;
    if (_inputs.containsKey(dto.topic)) {
      _inputs[dto.topic]!.forEach((key, value) {
        if ((key & dto.state) != 0) {
          value.forEach((element) {
            element.call(dto);
            isCall = true;
          });
        }
      });
    }
    return isCall;
  }

  bool sendToExtern(ITastyPieDTO dto) {
    return false;
  }

  List<IArchaea>? getArchaea(String name) {
    if (_archaeas.containsKey(name)) {
      return _archaeas[name];
    }
    return null;
  }

  bool connectColony(IColonyMechanics colony) {
    return false;
  }
}

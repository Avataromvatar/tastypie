import 'package:tastypie/src/archaea/iarchaea.dart';
import 'package:tastypie/src/colony/icolony.dart';
import 'package:tastypie/src/dto/dto.dart';
import 'package:tastypie/src/point/point.dart';

class Archaea implements IArchaeaMechanics {
  // final String name;
  IColony? _colony;
  IColony? get colony => _colony;
  set colony(IColony? c) => _colony = c;
  bool get isInColony => _colony != null ? true : false;
  List<IArchaeaPointInput> _inpoint =
      List<IArchaeaPointInput>.empty(growable: true);
  List<IArchaeaPointOutput> _outpoint =
      List<IArchaeaPointOutput>.empty(growable: true);
  List<IArchaeaPointInput> get inpoint => _inpoint;
  List<IArchaeaPointOutput> get outpoint => _outpoint;

  // Archaea(this.name);

  void addInPoint(IArchaeaPointInput ipoint) {
    if (!_inpoint.contains(ipoint)) {
      _inpoint.add(ipoint);
    }
  }

  void removeInPoint(IArchaeaPointInput ipoint) {
    if (_inpoint.contains(ipoint)) {
      _inpoint.remove(ipoint);
    }
  }

  void addOutPoint(IArchaeaPointOutput opoint) {
    if (!_outpoint.contains(opoint)) {
      _outpoint.add(opoint);
    }
  }

  void removeOutPoint(IArchaeaPointOutput opoint) {
    if (_outpoint.contains(opoint)) {
      _outpoint.remove(opoint);
    }
  }

  void send(ITastyPieDTO dto) {
    bool sendOk = false;
    for (var i = 0; i < _outpoint.length; i++) {
      if (_outpoint[i].sendDTO(dto)) {
        sendOk = true;
      }
    }

    _colony?.sendToExtern(dto);
  }

  void call(ITastyPieDTO dto) {
    for (var i = 0; i < _inpoint.length; i++) {
      _inpoint[i].call(dto);
    }
  }

  void goOut() {
    for (var i = 0; i < _outpoint.length; i++) {
      _outpoint[i].disconnectAll();
    }
  }
}

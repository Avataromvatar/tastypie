import 'package:tastypie/src/archaea/iarchaea.dart';
import 'package:tastypie/src/dto/dto.dart';
import 'package:tastypie/src/filter/filter.dart';

abstract class IArchaeaPointCommon {
  // List<IArchaeaFilter> get filter;

  String get topic;
  int get stateMask;
  bool checkAccess(String topic, int state);
  // bool filterChange(List<IArchaeaFilter> newFilters);
}

abstract class IArchaeaPointOutput implements IArchaeaPointCommon {
  List<IArchaeaPointInput> get connections;
  void connect(List<IArchaeaPointInput> inPoints);
  void disconnect(List<IArchaeaPointInput> inPoints);
  void disconnectAll();
  bool send(dynamic data, {int state = 1});
  bool sendDTO(ITastyPieDTO dto);
}

abstract class IArchaeaPointInput implements IArchaeaPointCommon {
  bool get isPaused;
  void setPause(bool on);
  void call(ITastyPieDTO dto);
  void setHandler(
      ITastyPieDTO? Function(dynamic data, String topic, int state) handler);
}

// abstract class IArchaeaPointOutput implements IArchaeaPointCommon {}

class ArchaeaPointCommon implements IArchaeaPointCommon {
  final String topic;
  final int stateMask;
  ArchaeaPointCommon(this.topic, {this.stateMask = 0xFFFFFFFF});

  @override
  bool checkAccess(String topic, int state) {
    return (topic == topic && (state & stateMask != 0));
  }
}

class ArchaeaPointInput extends ArchaeaPointCommon
    implements IArchaeaPointInput {
  void Function(dynamic data, String topic, int state) _handler;
  bool _isPaused = false;
  bool get isPaused => _isPaused;
  ArchaeaPointInput(String topic, this._handler, {int stateMask = 0xFFFFFFFF})
      : super(topic, stateMask: stateMask);
  @override
  void setPause(bool on) {
    _isPaused = on;
  }

  @override
  void setHandler(
      void Function(dynamic data, String topic, int state) handler) {
    _handler = handler;
  }

  @override
  void call(ITastyPieDTO dto) {
    if (checkAccess(dto.topic, dto.state)) {
      _handler(dto.data, dto.topic, dto.state);
    }
  }
}

class ArchaeaPointOutput extends ArchaeaPointCommon
    implements IArchaeaPointOutput {
  List<IArchaeaPointInput> _connections =
      List<IArchaeaPointInput>.empty(growable: true);
  List<IArchaeaPointInput> get connections => _connections;
  ArchaeaPointOutput(String topic, {int stateMask = 0xFFFFFFFF})
      : super(topic, stateMask: stateMask);

  void connect(List<IArchaeaPointInput> inPoints) {
    inPoints.forEach((element) {
      if (!_connections.contains(element)) {
        _connections.add(element);
      }
    });
  }

  void disconnectAll() {
    _connections.clear();
  }

  void disconnect(List<IArchaeaPointInput> inPoints) {
    inPoints.forEach((element) {
      if (_connections.contains(element)) {
        _connections.remove(element);
      }
    });
  }

  bool sendDTO(ITastyPieDTO dto) {
    if (checkAccess(dto.topic, dto.state)) {
      for (var i = 0; i < _connections.length; i++) {
        _connections[i].call(dto);
      }
      return true;
    }
    return false;
  }

  bool send(dynamic data, {int state = 1}) {
    if ((stateMask & state) != 0) {
      var dto = TastyPieDTO(topic, data, state: state);
      for (var i = 0; i < _connections.length; i++) {
        _connections[i].call(dto);
      }
    }
    return false;
  }
}

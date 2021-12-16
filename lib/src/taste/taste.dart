import 'dart:async';

import 'package:tastypie/src/layer/layer.dart';
import 'package:tastypie/src/taste/taste_dto.dart';

enum ITasteType { INPUT, OUTPUT }

abstract class ITaste {
  ITasteType get type;
  bool get onlyInTheLayer;
  String get topic;
  int get stateMask;
}

abstract class ITasteOutput implements ITaste {
  Stream<ITasteDTO> get outputStream;
  List<ITasteInput> get connections;
  void connect(List<ITasteInput> inputs);
  void disconnect(List<ITasteInput> inputs);
  void disconnectAll();
  bool send(ITasteDTO dto);
}

abstract class ITasteInput implements ITaste {
  StreamSink<ITasteDTO> get inputStream;
  ITasteOutput? get outputTaste;
  set link(ITasteOutput output);
  set handler(
      void Function(dynamic data, String topic, int state, ITasteOutput? output)
          fun);
  bool call(ITasteDTO dto);
}

class TasteCommon implements ITaste {
  final ITasteType type;
  final String topic;
  final int stateMask;
  final bool onlyInTheLayer;
  TasteCommon(this.type, this.topic,
      {this.stateMask = 0xFFFFFFFF, this.onlyInTheLayer = false});
}

class TasteInput extends TasteCommon implements ITasteInput {
  StreamController<ITasteDTO> _streamController = StreamController<ITasteDTO>();
  ITasteOutput? _outputLink;
  void Function(dynamic data, String topic, int state, ITasteOutput? output)
      _handler;
  TasteInput(String topic, this._handler,
      {int stateMask = 0xFFFFFFFF, ITasteOutput? outputLink})
      : _outputLink = outputLink,
        super(ITasteType.INPUT, topic, stateMask: stateMask);

  StreamSink<ITasteDTO> get inputStream => _streamController.sink;
  ITasteOutput? get outputTaste => _outputLink;
  set link(ITasteOutput output) => _outputLink = output;
  set handler(
          void Function(
                  dynamic data, String topic, int state, ITasteOutput? output)
              fun) =>
      _handler = fun;
  bool call(ITasteDTO dto) {
    if (dto.topic == topic && (stateMask & dto.state != 0)) {
      _handler(dto.data, topic, dto.state, _outputLink);
      return true;
    }
    return false;
  }
}

class TasteOutput extends TasteCommon implements ITasteOutput {
  final StreamController<ITasteDTO> _streamController =
      StreamController<ITasteDTO>();
  final List<ITasteInput> _links = List<ITasteInput>.empty(growable: true);

  TasteOutput(String topic,
      {int stateMask = 0xFFFFFFFF, ITasteOutput? outputLink})
      : super(ITasteType.OUTPUT, topic, stateMask: stateMask);

  Stream<ITasteDTO> get outputStream => _streamController.stream;
  List<ITasteInput> get connections => _links;

  bool send(ITasteDTO dto) {
    bool isSended = false;
    if (dto.topic == topic && (stateMask & dto.state != 0)) {
      connections.forEach((element) {
        element.call(dto);
        isSended = true;
      });
    }
    return isSended;
  }

  void connect(List<ITasteInput> inputs) {
    inputs.forEach((element) {
      if (!_links.contains(element)) {
        _links.add(element);
      }
    });
  }

  void disconnect(List<ITasteInput> inputs) {
    inputs.forEach((element) {
      if (_links.contains(element)) {
        _links.remove(element);
      }
    });
  }

  void disconnectAll() {
    _links.clear();
  }
}

import 'dart:async';

import 'package:tastypie/src/taste/taste_dto.dart';

enum ITasteType { INPUT, OUTPUT }

abstract class ITaste {
  ITasteType get type;
  String get topic;
  int get stateMask;
}

abstract class ITasteOutput implements ITaste {
  Stream<ITasteDTO> get outputStream;
  List<ITasteInput> get connections;
  void connect(List<ITasteInput> inputs);
  void disconnect(List<ITasteInput> inputs);
  void disconnectAll();
}

abstract class ITasteInput implements ITaste {
  StreamSink<ITasteDTO> get inputStream;
  ITasteOutput? get outputTaste;
  set link(ITasteOutput output);
  set handler(
      void Function(dynamic data, String topic, int state, ITasteOutput? output)
          fun);
}

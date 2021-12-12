import 'package:equatable/equatable.dart';
import 'package:tastypie/src/archaea/iarchaea.dart';
import 'package:tastypie/src/dto/dto.dart';

abstract class IArchaeaFilter extends Equatable {
  String get topic;
  int get stateMask;
  bool check(String topic, int state);
  bool checkState(int state);
}

abstract class IArchaeaFilterInput extends Equatable implements IArchaeaFilter {
  dynamic Function(dynamic data, String topic, int state) get handler;

  ///call handler if check ok
  dynamic call(ITastyPieDTO dto);

  ///call handler
  dynamic forceCall(ITastyPieDTO dto);
}

class ArchaeaFilter implements IArchaeaFilter {
  @override
  final String topic;
  @override
  final int stateMask;

  ArchaeaFilter(this.topic, this.stateMask);
  ArchaeaFilter.allState(this.topic) : stateMask = 0xFFFFFFFF;

  @override
  bool check(String topic, int state) {
    if (topic == this.topic && (state & stateMask != 0)) return true;
    return false;
  }

  @override
  bool checkState(int state) {
    if ((state & stateMask != 0)) return true;
    return false;
  }

  @override
  List<Object> get props => [topic, stateMask];
  @override
  bool get stringify => true;
}

class ArchaeaFilterInput extends ArchaeaFilter implements IArchaeaFilterInput {
  @override
  final dynamic Function(dynamic data, String topic, int state) handler;

  ArchaeaFilterInput(String topic, int stateMask, this.handler)
      : super(topic, stateMask);
  ArchaeaFilterInput.allState(String topic, this.handler)
      : super.allState(topic);

  @override
  dynamic call(ITastyPieDTO dto) {
    if (check(dto.topic, dto.state)) {
      return handler(dto.data, dto.topic, dto.state);
    }
    return null;
  }

  @override
  dynamic forceCall(ITastyPieDTO dto) {
    return handler(dto.data, dto.topic, dto.state);
  }
}

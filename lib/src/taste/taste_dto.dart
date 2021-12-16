abstract class ITasteDTO {
  String get topic;

  ///event check 1 topic == filter.topic 2 (state & filter.state)!=0
  int get state;

  ///
  dynamic get data;
}

class TasteDTO implements ITasteDTO {
  final String topic;
  final int state;
  final dynamic data;

  TasteDTO(this.topic, this.data, {this.state = 1});
}

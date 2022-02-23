abstract class ITasteDTO {
  String get topic;
  String get source;
  ///event check 1 topic == filter.topic 2 (state & filter.state)!=0
  int get state;
  /// if true DTO travel just in self layer
  bool get isLocal;
  ///
  dynamic get data;
}

class TasteDTO<T> implements ITasteDTO {
  String topic;
  String source;
  int state;
  bool isLocal;
  T data;

  TasteDTO(this.topic, this.data, {this.state = 1});
}

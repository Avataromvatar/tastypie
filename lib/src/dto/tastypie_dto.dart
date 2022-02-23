enum eTastyPieDTOType { notification, request, response, error }
enum eTastyPieDTOStatus {
  inProcessing,

  ///default. Set when start operation
  done,

  /// Set when operation done and for good response
  error

  /// set in response when request is broken. Send notification when something broken
}

abstract class ITastePieDTO {
  String get topic;
  String? get source;
  eTastyPieDTOType get type;

  ///event check 1 topic == filter.topic 2 (state & filter.state)!=0
  eTastyPieDTOStatus get status;

  /// if true DTO travel just in self layer
  bool get isLocal;

  ///
  dynamic get data;
  int get mark;
}

class TastePieDTO<T> implements ITastePieDTO {
  String topic;
  String? source;
  eTastyPieDTOType type;
  eTastyPieDTOStatus status;
  bool isLocal;
  T? data;
  int mark;
  TastePieDTO(this.topic,
      {this.data,
      this.status = eTastyPieDTOStatus.inProcessing,
      this.type = eTastyPieDTOType.notification,
      this.source,
      this.isLocal = false,
      this.mark = 0});
}

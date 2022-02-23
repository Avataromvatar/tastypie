import 'package:tastypie/src/dto/tastypie_dto.dart';

enum eTasteType {
  /// send request get response. Can generate notification
  master,

  ///get request send response. Can generate notification
  worker,

  ///get any topic. Can generate notification
  listener,

  /// just generate notification
  generator,
}
class TasteFilter
{
  String topic;
  eTastyPieDTOType? type;
  eTastyPieDTOStatus? status;
  int? mark;
  TasteFilter(this.topic,{this.type,this.status,this.mark});

  bool check(ITastePieDTO dto)
  {
    //TODO 
    return false;
  }
}
abstract class ITaste {
  eTasteType get type;
  String get topic;

  void notify({String? topic, dynamic data,int? mark});
  // void send(dynamic data);
  // void call(ITastePieDTO dto);
}

abstract class ITasteMaster implements ITaste {
  Function(String topic,eTastyPieDTOType type, eTastyPieDTOStatus status,dynamic data)? get responseHandler;
  Future<void> sendRequest(
      {dynamic data,
      int? mark,
      bool isLocal = false,
      Function(String topic, eTastyPieDTOType type, eTastyPieDTOStatus status,
              dynamic data)?
          responseHandler});

}

abstract class ITasteWorker implements ITaste {
  Future<void> Function({
    String topic,
    eTastyPieDTOType type,
    eTastyPieDTOStatus status,
    dynamic dataRequest,
    Function(eTastyPieDTOStatus status,dynamic data) sendResponse
  }) get parseRequest;
}

abstract class ITasteListener implements ITaste {
  Future<void> Function({
    String topic,
    eTastyPieDTOType type,
    eTastyPieDTOStatus status,
    dynamic dataRequest,
    Function(eTastyPieDTOStatus status,dynamic data) sendResponse
  }) get handler;
  setFilter(Map<String,TasteFilter> filters,{bool add = false});
}


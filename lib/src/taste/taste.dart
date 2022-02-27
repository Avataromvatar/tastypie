import 'dart:async';

import 'package:tastypie/src/dto/tastypie_dto.dart';
import 'package:tastypie/src/layer/layer.dart';


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
typedef Future<void> TastyPieHandler(String topic, eTastyPieDTOType type,
    eTastyPieDTOStatus status, dynamic data,{StreamController? streamController});
typedef Future<void> TastyPieResponseHandler(
    {String topic,
    eTastyPieDTOType type,
    eTastyPieDTOStatus status,
    dynamic data,
    Function(eTastyPieDTOStatus status, dynamic data) sendResponse,
    StreamController? streamController});

class TasteFilter {
  String topic;
  eTastyPieDTOType? type;
  eTastyPieDTOStatus? status;
  int? mark;
  TasteFilter(this.topic, {this.type, this.status, this.mark});

  bool check(ITastePieDTO dto) {
    //TODO
    return false;
  }
}

abstract class ITaste {
  eTasteType get type;
  String get topic;
  String? get layer;
  /// path <layer>/<topic>/ If layer not present <topic>/
  String get path;
  /// FULL path <layer>/<topic>/[filter types]/[filter status]/[filter state]/ If layer not present <topic>/[filter type]/[filter status]/[filter state]/
  String get fullPath; //TODO

  Stream get stream;
  ///
  void notify({String? topic, dynamic data, int? mark});
  ///if type is Taste master
  Future<void> Function(
      {dynamic data,
      int? mark,
      bool? isLocal,
      TastyPieHandler? responseHandler})? get sendRequest;
  /// if type not generator
  void Function(Map<String, TasteFilter> filters, {bool? add})? get setFilter;
  set handler(TastyPieHandler newHandler);
  set responseHandler(TastyPieResponseHandler newHandler);
  void connectToLayer(ITastyPieLayer layer);
  // void send(dynamic data);
  // void call(ITastePieDTO dto);
}

class BasicTaste implements ITaste
{

}

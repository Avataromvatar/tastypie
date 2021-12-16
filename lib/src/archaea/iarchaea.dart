import 'package:tastypie/src/colony/icolony.dart';
import 'package:tastypie/src/dto/dto.dart';
// import 'package:tastypie/src/filter/filter.dart';
import 'package:tastypie/src/point/point.dart';

enum eArchaeaType { IN, OUT, IN_OUT }

abstract class IArchaea {
  // String get name;

  ///if archaea in colony(layer) she can send and get message
  bool get isInTastyPieLayer;

  //if she signals not heard and nobody send signal to she
  // bool get isLonely;
  List<IArchaeaPointInput> get inpoint;
  List<IArchaeaPointOutput> get outpoint;
  void addInPoint(IArchaeaPointInput ipoint);
  void removeInPoint(IArchaeaPointInput ipoint);
  void addOutPoint(IArchaeaPointOutput opoint);
  void removeOutPoint(IArchaeaPointOutput opoint);

  void send(ITastyPieDTO dto);
}

abstract class IArchaeaMechanics implements IArchaea {
  ///Then Archaea add to TastyPieLayer? TastyPieLayer set self to [colony]
  ITastyPieLayer? get colony;
  set colony(ITastyPieLayer? c);

  ///TastyPieLayer call then get message
  void call(ITastyPieDTO dto);

  ///TastyPieLayer call when this archaea remove from colony
  void goOut();
}

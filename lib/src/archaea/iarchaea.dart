import 'package:tastypie/src/colony/icolony.dart';
import 'package:tastypie/src/dto/dto.dart';
// import 'package:tastypie/src/filter/filter.dart';
import 'package:tastypie/src/point/point.dart';

enum eArchaeaType { IN, OUT, IN_OUT }

abstract class IArchaea {
  String get name;

  ///if archaea in colony(layer) she can send and get message
  bool get isInColony;

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
  ///Then Archaea add to Colony? Colony set self to [colony]
  IColony? get colony;
  set colony(IColony? c);

  ///Colony call then get message
  void call(ITastyPieDTO dto);

  ///Colony call when this archaea remove from colony
  void goOut();
}

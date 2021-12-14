import 'package:tastypie/src/archaea/iarchaea.dart';
import 'package:tastypie/src/dto/dto.dart';

abstract class IColony {
  // bool get isUpdating;
  void addArchaea(IArchaeaMechanics archaea);
  void removeArchaea(IArchaeaMechanics archaea);
  // void updateArchaea(IArchaeaMechanics archaea);
  void updateDirectNet();

  ///from extern to in space
  bool call(ITastyPieDTO dto);

  ///from inner space to extern space
  bool sendToExtern(ITastyPieDTO dto);
}

abstract class IColonyMechanics implements IColony {
  List<IArchaea>? getArchaea();

  ///connect another colony and analize all archaea for direct connect
  bool connectColony(IColonyMechanics colony);
}

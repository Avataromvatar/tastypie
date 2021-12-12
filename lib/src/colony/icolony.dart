import 'package:tastypie/src/archaea/iarchaea.dart';
import 'package:tastypie/src/dto/dto.dart';

abstract class IColony {
  bool get isUpdating;
  void addArchaea(IArchaeaMechanics archaea);
  void removeArchaea(IArchaeaMechanics archaea);
  // void updateArchaea(IArchaeaMechanics archaea);
  void updateDirectNet();

  ///Send to extern space (not another colony)
  bool sendToExtern(ITastyPieDTO dto);
}

abstract class IColonyMechanics {
  List<IArchaea>? getArchaea(String name);

  ///connect another colony and analize all archaea for direct connect
  bool connectColony(IColonyMechanics colony);
}

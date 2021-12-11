import 'package:tastypie/src/archaea/iarchaea.dart';

abstract class IColony {
  void addArchaea(IArchaeaMechanics archaea);
  void removeArchaea(IArchaeaMechanics archaea);
}

abstract class IColonyMechanics {
  List<IArchaea> getArchaea(String name);

  ///direct connect out -> input.
  ///This need to unload the processor. Colony search pair topicOUT topicIN and link archaeas
  bool directConnect(IArchaeaMechanics arc);
  bool directDisconnect(IArchaeaMechanics arc);
}

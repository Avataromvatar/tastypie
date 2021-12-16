import 'package:tastypie/src/colony/icolony.dart';
import 'package:tastypie/src/taste/taste.dart';
import 'package:tastypie/src/taste/taste_dto.dart';

abstract class ITopping {
  bool addInputTaste(
      String topic,
      void Function(dynamic data, String topic, int state, ITasteOutput? output)
          handler,
      {int state = 0xFFFFFFFF,
      ITasteOutput? link});
  bool addOutputTaste(String topic,
      {List<ITasteInput>? connections, int state = 0xFFFFFFFF});
  bool addTaste(ITaste taste);
  bool send(ITasteDTO dto);
}

abstract class IToppingMechanics implements ITopping {
  ///Then Toping add to TastyPieLayer? TastyPieLayer set self to [layer]
  ITastyPieLayer? get layer;
  set layer(ITastyPieLayer? layer);

  ///TastyPieLayer call then get message
  void call(ITasteDTO dto);

  ///TastyPieLayer call when this topping remove from layer
  void complete();
}

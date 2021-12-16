import 'dart:async';

import 'package:tastypie/src/taste/taste_dto.dart';
import 'package:tastypie/src/topping/topping.dart';

abstract class ITastyPieLayer {
  void addTopping(IToppingMechanics topping);
  void removeTopping(IToppingMechanics topping);
  ITopping? getTopping(String topic, {int stateMask = 0xFFFFFFFF});
  bool send(ITasteDTO dto);
  StreamSubscription<ITasteDTO>? listen(
      String topic, void Function(ITasteDTO dto) handler,
      {int stateMask = 0xFFFFFFFF});
}

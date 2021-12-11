import 'package:tastypie/src/colony/icolony.dart';
import 'package:tastypie/src/dto/dto.dart';

enum eArchaeaType { IN, OUT, IN_OUT }

abstract class IArchaea {
  eArchaeaType get type;
  String get name;

  ///if archaea in colony(layer) she can send and get message
  bool get isInColony;

  ///if she signals not heard and nobody send signal to she
  bool get isLonely;

  ///If archaea is busy, example wait response and dont want over message set this flag On
  bool get isPaused;

  ///If the data is a DTO, then it will not be packed into a new DTO, but go further with the changed one that you specified when calling the send method
  ///
  ///return false if filter stop sending or EndPoint is just 'IN'
  bool send(dynamic data, {List<String> topic, int state});

  ///if pause on archaea cant send and recive message
  void setPause(bool on);

  ///Change filter setting. key - topic, value - event_state_mask. If mask ==0xFFFFFFFF all message access.
  ///
  ///[noStateCheck] change all value in map to 0xFFFFFFFF
  ///
  ///return false if not change
  bool filterChange(Map<String, int> newFilter,
      {bool isIN = true, bool isOUT = true, bool noStateCheck = true});

  Map<String, int>? getFilter();

  ///if you point IN_OUT you can set handlerIN and handlerIN_OUT if point IN just handlerIN
  ///
  ///if handlerIN_OUT return not null then this data send to out automated.
  ///
  ///If [topic] != null this handler call just in set topic
  ///
  ///return false if not set
  bool setHandler(
      {void Function(dynamic data)? handlerIN,
      dynamic Function(dynamic data)? handlerIN_OUT,
      String? topic});
}

abstract class IArchaeaMechanics implements IArchaea {
  ///Then Archaea add to Colony? Colony set self to [colony]
  IColony? get colony;
  set colony(IColony? c);

  ///Colony call then get message
  void call(ITastyPieDTO dto);
}

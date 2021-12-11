abstract class ITastyPieDTO {
  String get topic;

  ///event check 1 topic == filter.topic 2 (state & filter.state)!=0
  ///
  ///state = 0 never find Archaea and removed from colony
  int get state;

  ///
  dynamic get data;
}

class TastyPieDTO implements ITastyPieDTO
{
  final String topic;
  final int state;
  final dynamic data;
  
  TastyPieDTO(this.topic,this.data,{this.state=1});
}
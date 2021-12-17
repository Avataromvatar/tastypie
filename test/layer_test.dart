import 'package:tastypie/src/layer/layer.dart';
import 'package:tastypie/src/taste/taste_dto.dart';
import 'package:tastypie/src/topping/topping.dart';
import 'package:test/test.dart';

Future<void> main() async {
  TastyPieLayer layer = TastyPieLayer();
  Topping top = Topping();
  Topping top1 = Topping();
  top.addInputTaste('test', (data, topic, state, output) {
    print('Handler:$topic:$state - $data');
  });
  top.addInputTaste('test1', (data, topic, state, output) {
    print('Handler1:$topic:$state - $data');
  });
  top.addOutputTaste('test');
  top1.addInputTaste('test', (data, topic, state, output) {
    print('Handler:$topic:$state - $data');
  });
  top1.addOutputTaste('test');
  top1.addOutputTaste('test1');
  layer.addTopping(top);
  layer.addTopping(top1);
  layer.rebuildDirectNet();
  test('First Test', () async {
    top.send(TasteDTO('test', 'this is test'));
    top1.send(TasteDTO('test1', 'this is test1'));
    await Future.delayed(Duration(seconds: 1));
    expect(true, true);
    layer.removeTopping(top1);
    await Future.delayed(Duration(seconds: 1));
    // layer.rebuildDirectNet();
    top1.send(TasteDTO('test1', 'this is test1'));
  });
}

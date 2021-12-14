import 'package:tastypie/src/archaea/archaea.dart';
import 'package:tastypie/src/colony/colony.dart';
import 'package:tastypie/src/dto/dto.dart';
import 'package:tastypie/src/point/point.dart';
import 'package:tastypie/tastypie.dart';
import 'package:test/test.dart';

Future<void> main() async {
  // group('A group of tests', () async {
  final colony = Colony();
  final a1 = Archaea('a1');
  final a2 = Archaea('a2');
  final a3 = Archaea('a2');
  int count = 0;
  a1.addInPoint(ArchaeaPointInput('test', (data, topic, state) {
    print('${a1.name} get msg: $topic $state $data');
  }));
  a1.addOutPoint(ArchaeaPointOutput('test'));
  a2.addInPoint(ArchaeaPointInput('test', (data, topic, state) {
    print('${a2.name} get msg: $topic $state $data');
    count++;
    a2.send(TastyPieDTO('test3', 111));
  }));
  a2.addOutPoint(ArchaeaPointOutput('test3'));
  a3.addInPoint(ArchaeaPointInput('test3', (data, topic, state) {
    count++;
    print('${a3.name} get msg: $topic $state $data');
  }));
  colony.addArchaea(a1);

  colony.addArchaea(a2);

  colony.addArchaea(a3);

  colony.updateDirectNet();
  // a1.send(TastyPieDTO('test', 'Hi'));
  setUp(() {
    // Additional setup goes here.
  });
  await Future.delayed(Duration(seconds: 1));
  test('First Test', () async {
    count = 0;
    a1.send(TastyPieDTO('test', 'Hi'));
    await Future.delayed(Duration(seconds: 1));
    expect(count, 2);
  });

  test('Second Test', () async {
    colony.removeArchaea(a3);
    count = 0;
    a1.send(TastyPieDTO('test', 'Hi1'));
    await Future.delayed(Duration(seconds: 1));
    expect(count, 1);
  });
  // });
}

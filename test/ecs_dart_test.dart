import 'dart:async';

import 'package:ecs_dart/ecs_dart.dart';
import 'package:test/test.dart';

import 'artefacts/artefacts.dart';

void main() {
  group('ECS dart tests', () {

    test('execute system should increment entity value', (){
      final ecs = EcsDart();
      ecs.registerSystem(IncrementSystem());
      final entity = ecs.addEntity(components: [NumberComponent()..number=0]);
      ecs.update();
      expect(entity.has<NumberComponent>(), isTrue);
      expect(entity.getComponent<NumberComponent>().number, 1);
    });

    test('event handler system should handle event', (){
      final ecs = EcsDart();
      final numberStreamController = StreamController<int>.broadcast(sync: true);
      final entity = ecs.addEntity(components: [NumberComponent()..number=0]);
      ecs.registerSystem(HandleNumberStreamSystem(numberStreamController.stream));
      numberStreamController.add(10);
      numberStreamController.add(20);
      ecs.update();
      expect(entity.getComponent<NumberComponent>().number, 20);
    });

    test('antonym component test', (){
      final ecs = EcsDart();
      final entity = ecs.addEntity(components: [True()]);
      entity.setComponent(False());
      expect(entity.components.length, 1);
      expect(entity.has<False>(), isTrue);
      expect(entity.has<True>(), isFalse);

    });
    test('antonym  component should be added test', (){
      final ecs = EcsDart();
      final entity = ecs.addEntity(components: [True()]);
      expect(entity.components.length, 1);
      expect(entity.has<True>(), isTrue);

    });
    test('components selection tests', () {
      final ecs = EcsDart();
      ecs.addEntity(components: [A(), B()]);
      ecs.addEntity(components: [A(), B(), C(), G()]);
      ecs.addEntity(components: [A(), C(), D()]);
      expect(ecs.select(all: [A]).length, 3);
      expect(ecs.select(none: [B]).length, 1);
      final result = ecs.select(all: [A] , none: [B]);
      expect(result.length, 1);
      expect(result.first.has<C>(), true);
      expect(ecs.select(all: [A]).length, 3);
      expect(ecs.select(any: [D,G]).length, 2);
      expect(ecs.select(any: [D,G]).every((test)=>test.has<C>()), true);
    });
  });
}

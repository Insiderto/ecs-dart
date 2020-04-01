import 'package:ecs_dart/ecs_dart.dart';

class NumberComponent implements Component {
  int number;
}

class A implements Component {}
class B implements Component {}
class C implements Component {}
class D implements Component {}
class G implements Component {}

class False extends AntonymComponent<True> {}
class True extends AntonymComponent<False> {}

class IncrementSystem extends ExecuteSystem {
  @override
  void execute(double deltaTime) {
    entities.select(all: [NumberComponent]).forEach((entity) {
      final intData = entity.getComponent<NumberComponent>();
      intData.number++;
    });
  }
}

class HandleNumberStreamSystem extends StreamSubscriptionSystem<int> {
  HandleNumberStreamSystem(Stream<int> stream) : super(stream);

  @override
  void handle(int event) {
    entities.select(all: [NumberComponent]).forEach((entity){
      final intData = entity.getComponent<NumberComponent>();
      intData.number = event;
    });
  }
}

Dart realisation of ECS pattern

## Usage

A simple usage example:

```dart
import 'package:ecs_dart/ecs_dart.dart';

void main() {
  final ecs = EcsDart();

  final entity = ecs.addEntity('1', components: [NumberComponent()..number=0]);
  final numberStreamController = StreamController<int>.broadcast(sync: true);

  ecs.registerSystem(IncrementSystem());
  ecs.registerSystem(HandleNumberStreamSystem(numberStreamController.stream));

  numberStreamController.add(10);
  ecs.update(); // this can be used in requestAnimationFrame or another loop with fixed update time

  //entity.getComponent<NumberComponent>().number == 11

}
// Execute systems are simple and executes on every update call;
class IncrementSystem extends ExecuteSystem {
  @override
  void execute(double deltaTime) {
    entities.select(all: [NumberComponent]).forEach((entity) {
      final intData = entity.getComponent<NumberComponent>();
      intData.number++;
    });
  }
}

// Event handler system does not guarantee order of execution it may cause problems, but im working on it.
class HandleNumberStreamSystem extends EventHandlerSystem<int> {
  HandleIntStreamSystem(Stream<int> stream) : super(stream);

  @override
  void handle(int event) {
    entities.select(all: [NumberComponent]).forEach((entity){
      final intData = entity.getComponent<NumberComponent>();
      intData.number = event;
    });
  }
}

// Components can be mutable...
class NumberComponent implements Component {
  int number;
}

//.. or not. For update use entity.setComponent(new ImmutableNumberComponent(1))

class ImmutableNumberComponent implements Component {
  final int number;

  ImmutableNumberComponent(this.number);
}

```

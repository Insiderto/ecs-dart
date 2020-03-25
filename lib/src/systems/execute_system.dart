import 'package:ecs_dart/src/systems/system.dart';

abstract class ExecuteSystem extends System {
  void execute(double deltaTime);
}
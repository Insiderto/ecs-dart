import 'package:ecs_dart/src/managers/entity_manager.dart';
import 'package:ecs_dart/src/managers/system_manager.dart';
import 'package:ecs_dart/src/systems/system.dart';

class EcsDart extends EntityManager {
  final SystemManager _systemManager = SystemManager();

  double _lastTime = 0;

  System registerSystem(System system) {
    return _systemManager.register(system..entities = this);
  }

  Iterable<System> registerSystems(Iterable<System> systems) {
    return _systemManager.registerAll(systems.map((system) => system..entities = this));
  }

  void update([num time]) {
    var deltaTime = 0.0;
    if (time != null) {
      final now = time;
      deltaTime = now - _lastTime;
      _lastTime = time;
    }
    _systemManager.executeSystems.forEach((system) => system.execute(deltaTime));
    cleanup();
  }
}

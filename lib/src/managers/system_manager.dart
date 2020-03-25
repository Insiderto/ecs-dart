import 'package:ecs_dart/src/systems/event_handler_system.dart';
import 'package:ecs_dart/src/systems/execute_system.dart';
import 'package:ecs_dart/src/systems/system.dart';

class SystemManager {
  final Map<ExecuteSystem, bool> _systems = <ExecuteSystem, bool>{};
  final Set<EventHandlerSystem> _reactiveSystems = <EventHandlerSystem>{};

  Iterable<ExecuteSystem> get executeSystems => _systems.entries.where((entry)=>entry.value).map((entry)=>entry.key);

  System register(System system) {
    if (system is ExecuteSystem) {
      _systems[system]=true;
    }
    if (system is EventHandlerSystem) {
      system.subscribe();
      _reactiveSystems.add(system);
    }
    return system;
  }


  void deactivateSystem(ExecuteSystem system) =>_systems[system] = false;
  void reactivateSystem(ExecuteSystem system) => _systems[system] = true;

  bool isActive(ExecuteSystem system) => _systems[ExecuteSystem];

  Iterable<System> registerAll(Iterable<System> systems) => systems.map(register);
}
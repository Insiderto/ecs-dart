import 'package:ecs_dart/src/systems/stream_subscription_system.dart';
import 'package:ecs_dart/src/systems/execute_system.dart';
import 'package:ecs_dart/src/systems/system.dart';

class SystemManager {
  final Map<ExecuteSystem, bool> _systems = <ExecuteSystem, bool>{};

  Iterable<ExecuteSystem> get executeSystems => _systems.entries.where((entry)=>entry.value).map((entry)=>entry.key);

  System register(ExecuteSystem system) {
    if (system is OnRegister) {
      (system as OnRegister).onRegister();
    }
    if(system is StreamSubscriptionSystem) {
      system.subscribe();
    }
    _systems[system]=true;
    return system;
  }

  void deactivateSystem(ExecuteSystem system) =>_systems[system] = false;
  void reactivateSystem(ExecuteSystem system) => _systems[system] = true;

  bool isActive(ExecuteSystem system) => _systems[ExecuteSystem];

  Iterable<System> registerAll(Iterable<ExecuteSystem> systems) => systems.map(register).toList();
}

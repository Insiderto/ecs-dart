import 'package:ecs_dart/src/managers/entity_manager.dart';

abstract class System {
  EntityManager _entities;

  EntityManager get entities {
    assert(_entities != null, 'world is not detected, try to register system throuth ECSworld');
    return _entities;
  }

  set entities(EntityManager world) => _entities = world;
}

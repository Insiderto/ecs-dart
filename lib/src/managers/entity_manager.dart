import 'dart:async';
import 'dart:collection';

import 'package:ecs_dart/src/components/component.dart';
import 'package:ecs_dart/src/events/entity_created_event.dart';
import 'package:ecs_dart/src/events/entity_removed_event.dart';

class Entity {
  final int id;
  bool isAlive = true;

  final Map<Type, Component> _components = <Type, Component>{};

  Entity._(this.id);

  Iterable<Component> get components => _components.values;

  @override
  int get hashCode => id.hashCode;

  Entity operator +(Component c) {
    setComponent(c);
    return this;
  }

  Entity operator -(Type t) {
    var c = _components[t];
    if (c != null) {
      _components.remove(t);
    }
    return this;
  }

  @override
  bool operator ==(other) {
    return other is Entity && other.id == id;
  }

  T getComponent<T extends Component>() {
    return _components[T] as T;
  }

  bool has<T extends Component>({Type componentType}) {
    return _components.containsKey(T) || _components.containsKey(componentType);
  }

  bool removeComponent<T extends Component>() {
    if (has<T>()) {
      _components.remove(T);
      return true;
    }
    return false;
  }

  void setComponent(Component component) {
    if (component is AntonymComponent) {
      final antonymType = component.antonym;
      if (has(componentType: antonymType)) {
        _components.remove(antonymType);
        _components[component.runtimeType] = component;
        return;
      }
    }
    _components[component.runtimeType] = component;
  }

  void setComponents(Iterable<Component> components) {
    components.forEach((f) => setComponent(f));
  }
}

abstract class EntityManager {
  final Map<int, Entity> _entities = <int, Entity>{};
  final Set<int> _scheduledToRemove = <int>{};
  final StreamController<EntityCreatedEvent> _onEntityCreated = StreamController.broadcast(sync: true);
  final StreamController<EntityRemovedEvent> _onEntityRemoved = StreamController.broadcast(sync: true);

  int _newEntityId = 0;

  int get count => _entities.length;

  UnmodifiableListView<int> get keys => UnmodifiableListView(_entities.keys);

  Stream<EntityCreatedEvent> get onEntityCreated => _onEntityCreated.stream;

  Stream<EntityRemovedEvent> get onEntityRemoved => _onEntityRemoved.stream;

  Entity operator [](int id) => _entities[id];
  /// Creates entity
  Entity addEntity({Iterable<Component> components = const <Component>[]}) {
    final entity = Entity._(_newEntityId++)..setComponents(components);
    _entities[entity.id] = entity;
    _onEntityCreated.add(EntityCreatedEvent(entity.id));
    return entity;
  }

  void cleanup() {
    for (var id in _scheduledToRemove) {
      _entities.remove(id);
    }
    _scheduledToRemove.clear();
  }

  bool removeEntity(Entity entity) {
    if (_entities.containsKey(entity.id)) {
      _entities[entity.id].isAlive = false;
      _scheduledToRemove.add(entity.id);
      _onEntityRemoved.add(EntityRemovedEvent(entity.id));
      return true;
    }
    return false;
  }

  Iterable<Entity> select({Iterable<Type> all, Iterable<Type> none, Iterable<Type> any}) {
    if (_entities.isEmpty) {
      return [];
    }
    final aliveEntities = _entities.values.where((entity) => entity.isAlive);
    if (aliveEntities.isEmpty) {
      return [];
    }
    if (all == null && none == null && any == null) return aliveEntities;

    final result = <Entity>[
      if (all != null && none == null)
        ...aliveEntities.where((entity) => all.every((test) => entity.has(componentType: test))),
      if (all != null && none != null)
        ...aliveEntities.where((entity) =>
            all.every((test) => entity.has(componentType: test)) &&
            none.every((test) => !entity.has(componentType: test))),
      if (none != null && all == null)
        ...aliveEntities.where((entity) => none.every((test) => !entity.has(componentType: test))),
      if (any != null) ...aliveEntities.where((entity) => any.any((test) => entity.has(componentType: test)))
    ];
    return result.toSet();
  }
}

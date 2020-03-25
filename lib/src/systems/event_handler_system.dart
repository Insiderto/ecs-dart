import 'dart:async';

import 'package:ecs_dart/src/systems/system.dart';

abstract class EventHandlerSystem<T> extends System {
  final Stream<T> _stream;
  StreamSubscription _subscription;

  EventHandlerSystem(this._stream);

  void handle(T event);

  void subscribe() {
    _subscription = _stream.listen((T event) {
      handle(event);
      entities.cleanup();
    });
  }

  void unsubscribe() {
    _subscription.cancel();
  }
}

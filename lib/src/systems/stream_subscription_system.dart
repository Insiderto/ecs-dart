import 'dart:async';

import 'package:ecs_dart/ecs_dart.dart';

abstract class StreamSubscriptionSystem<T> extends ExecuteSystem {
  final Stream<T> _stream;
  final List<Function()> _jobs = [];
  StreamSubscription _subscription;

  StreamSubscriptionSystem(this._stream);

  void handle(T event);

  @override
  void execute(double deltaTime) {
    _jobs.forEach((job) {
      job();
    });
    _jobs.clear();
  }

  void subscribe() {
    _subscription = _stream.listen((T event) {
      _jobs.add(() => handle(event));
    });
  }

  void unsubscribe() {
    _subscription.cancel();
  }
}

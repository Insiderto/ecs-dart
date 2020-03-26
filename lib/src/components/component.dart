abstract class Component {}

abstract class AntonymComponent<T extends Component> extends Component {
  final Type antonym;
  AntonymComponent() : antonym = T {
    assert(T != runtimeType, 'antonym cant be oposite to it self');
  }
}

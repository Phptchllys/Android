import 'package:equatable/equatable.dart';
import 'package:pizza_repository/pizza_repository.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddPizzaToCart extends CartEvent {
  final Pizza pizza;

  const AddPizzaToCart(this.pizza);

  @override
  List<Object?> get props => [pizza];
}

class RemovePizzaFromCart extends CartEvent {
  final Pizza pizza;

  const RemovePizzaFromCart(this.pizza);

  @override
  List<Object?> get props => [pizza];
}

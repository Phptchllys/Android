import 'package:equatable/equatable.dart';
import 'package:pizza_repository/pizza_repository.dart';

class CartItem {
  final Pizza pizza;
  final int quantity;

  const CartItem({
    required this.pizza,
    required this.quantity,
  });
}

class CartState extends Equatable {
  final List<CartItem> items;

  const CartState({this.items = const []});

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  @override
  List<Object?> get props => [items];
}

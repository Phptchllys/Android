import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddPizzaToCart>(_onAddPizza);
    on<RemovePizzaFromCart>(_onRemovePizza);
  }

  void _onAddPizza(
    AddPizzaToCart event,
    Emitter<CartState> emit,
  ) {
    final items = List<CartItem>.from(state.items);
    final index = items.indexWhere(
      (item) => item.pizza.pizzaId == event.pizza.pizzaId,
    );

    if (index >= 0) {
      items[index] = CartItem(
        pizza: items[index].pizza,
        quantity: items[index].quantity + 1,
      );
    } else {
      items.add(CartItem(pizza: event.pizza, quantity: 1));
    }

    emit(CartState(items: items));
  }

  void _onRemovePizza(
    RemovePizzaFromCart event,
    Emitter<CartState> emit,
  ) {
    final items = state.items
        .where((item) => item.pizza.pizzaId != event.pizza.pizzaId)
        .toList();

    emit(CartState(items: items));
  }
}

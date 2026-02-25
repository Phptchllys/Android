import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pizza_app/blocs/cart_bloc/cart_bloc.dart';
import 'package:pizza_app/blocs/cart_bloc/cart_event.dart';
import 'package:pizza_app/blocs/cart_bloc/cart_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        centerTitle: true,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return const Center(
              child: Text(
                '🛒 Cart is empty',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final totalPrice = state.items.fold<double>(
            0,
            (sum, item) =>
                sum +
                (item.pizza.price -
                        (item.pizza.price * item.pizza.discount / 100)) *
                    item.quantity,
          );

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, i) {
                    final item = state.items[i];
                    final pizza = item.pizza;

                    final price =
                        pizza.price - (pizza.price * pizza.discount / 100);

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(pizza.picture),
                      ),
                      title: Text(pizza.name),
                      subtitle: Text(
                        '\$${price.toStringAsFixed(1)} x ${item.quantity}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              context.read<CartBloc>().add(
                                    RemovePizzaFromCart(pizza),
                                  );
                            },
                          ),
                          Text(item.quantity.toString()),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              context.read<CartBloc>().add(
                                    AddPizzaToCart(pizza),
                                  );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              /// 💰 Total + Checkout
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.1),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: \$${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Checkout coming soon 🔥'),
                          ),
                        );
                      },
                      child: const Text('Checkout'),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

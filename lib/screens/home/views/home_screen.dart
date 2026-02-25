import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pizza_app/screens/auth/blocs/sing_in_bloc/sign_in_bloc.dart';
import 'package:pizza_app/screens/home/blocs/get_pizza_bloc/get_pizza_bloc.dart';
import 'package:pizza_app/screens/home/views/details_screen.dart';

import 'package:pizza_app/blocs/cart_bloc/cart_bloc.dart';
import 'package:pizza_app/blocs/cart_bloc/cart_event.dart';
import 'package:pizza_app/blocs/cart_bloc/cart_state.dart';
import 'package:pizza_app/screens/cart/views/cart_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<GetPizzaBloc, GetPizzaState>(
          builder: (context, state) {
            if (state is GetPizzaInitial || state is GetPizzaLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is GetPizzaFailure) {
              return Center(child: Text(state.message));
            }

            if (state is GetPizzaSuccess) {
              return GridView.builder(
                itemCount: state.pizzas.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.68,
                ),
                itemBuilder: (context, i) {
                  final pizza = state.pizzas[i];
                  final price =
                      pizza.price - (pizza.price * pizza.discount / 100);

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailsScreen(pizza),
                        ),
                      );
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        /// 🧾 Card
                        Container(
                          padding: const EdgeInsets.fromLTRB(12, 70, 12, 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 15,
                                color: Colors.black.withOpacity(0.08),
                                offset: const Offset(0, 8),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTags(pizza),
                              const SizedBox(height: 10),
                              Text(
                                pizza.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                pizza.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '\$${price.toStringAsFixed(1)}',
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        '\$${pizza.price}.00',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade500,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ],
                                  ),

                                  /// ➕ Add to Cart (แก้ตรงนี้)
                                  GestureDetector(
                                    onTap: () {
                                      context
                                          .read<CartBloc>()
                                          .add(AddPizzaToCart(pizza));
                                    },
                                    child: const CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.black,
                                      child: Icon(
                                        Icons.add,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),

                        /// 🍕 Floating Image
                        Positioned(
                          top: -35,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(pizza.picture),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  /// 🔝 AppBar (มี Badge)
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Row(
        children: [
          Image.asset('assets/8.png', scale: 14),
          const SizedBox(width: 8),
          const Text(
            'PIZZA',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
          ),
        ],
      ),
      actions: [
        BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            final totalItems = state.items.fold<int>(
              0,
              (sum, item) => sum + item.quantity,
            );

            return Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(CupertinoIcons.cart),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CartScreen(),
                      ),
                    );
                  },
                ),
                if (totalItems > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        totalItems.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        IconButton(
          onPressed: () {
            context.read<SignInBloc>().add(SignOutRequired());
          },
          icon: const Icon(CupertinoIcons.arrow_right_to_line),
        ),
      ],
    );
  }

  /// 🏷 Tags
  Widget _buildTags(pizza) {
    return Row(
      children: [
        _tag(
          text: pizza.isVeg ? 'VEG' : 'NON-VEG',
          color: pizza.isVeg ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 6),
        _tag(
          text: pizza.spicy == 1
              ? '🌶️ BLAND'
              : pizza.spicy == 2
                  ? '🌶️ BALANCE'
                  : '🌶️ SPICY',
          color: pizza.spicy == 1
              ? Colors.green
              : pizza.spicy == 2
                  ? Colors.orange
                  : Colors.red,
          bgOpacity: 0.15,
        ),
      ],
    );
  }

  Widget _tag({
    required String text,
    required Color color,
    double bgOpacity = 1,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(bgOpacity),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: bgOpacity == 1 ? Colors.white : color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

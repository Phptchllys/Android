import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_app/app.dart';
import 'package:pizza_app/simple_bloc_observer.dart';
import 'package:user_repository/user_repository.dart';

import 'package:pizza_app/screens/auth/blocs/sing_in_bloc/sign_in_bloc.dart';
import 'package:pizza_app/screens/home/blocs/get_pizza_bloc/get_pizza_bloc.dart';
import 'package:pizza_repository/pizza_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Bloc.observer = SimpleBlocObserver();

  final userRepo = FirebaseUserRepo();

  // ✅ ใช้ concrete implementation
  final pizzaRepo = FirebasePizzaRepo();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SignInBloc(userRepo),
        ),
        BlocProvider(
          create: (_) => GetPizzaBloc(pizzaRepo)..add(GetPizza()),
        ),
      ],
      child: MyApp(userRepo),
    ),
  );
}

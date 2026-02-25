import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'pizza_repo.dart';
import 'entities/pizza_entity.dart';
import 'models/pizza.dart';

class FirebasePizzaRepo implements PizzaRepo {
  final CollectionReference<Map<String, dynamic>> pizzaCollection =
      FirebaseFirestore.instance.collection('pizza');

  @override
  Future<List<Pizza>> getPizzas() async {
    try {
      final snapshot = await pizzaCollection.get();

      return snapshot.docs
          .map(
            (doc) => Pizza.fromEntity(
              PizzaEntity.fromDocument(doc.data()),
            ),
          )
          .toList();
    } catch (e) {
      log('FirebasePizzaRepo error: $e');
      rethrow;
    }
  }
}

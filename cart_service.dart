import 'package:flutter/material.dart';
import 'models/animal.dart';

class CartService extends ChangeNotifier {
  final List<Animal> _cartItems = [];

  List<Animal> get cartItems => _cartItems;
  int get cartCount => _cartItems.length;

  void addToCart(Animal animal) {
    _cartItems.add(animal);
    notifyListeners(); // Сообщаем UI, что корзина изменилась
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
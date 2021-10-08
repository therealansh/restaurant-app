import 'dart:async';

class CartItems {
  final cartStreamController = StreamController.broadcast();
  Stream get getStream => cartStreamController.stream;
  final Map allItems = {
    'cartItems': [],
  };

  void addToCart(item) {
    allItems['cartItems'].add(item);
    cartStreamController.sink.add(
      allItems,
    );
  }

  void removeFromCart(item) {
    allItems['cartItems'].remove(
      item,
    );
    cartStreamController.sink.add(
      allItems,
    );
  }

  void clearCart() {
    allItems['cartItems'].clear();
    cartStreamController.sink.add(
      allItems,
    );
  }

  void dispose() {
    cartStreamController.close();
  }
}

final bloc = CartItems();

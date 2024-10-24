class Cart {
  final List<CartItem> items;

  Cart() : items = [];

  void addItem(CartItem item) {
    items.add(item);
  }
}

class CartItem {
  final String title;
  final String price;
  final String imgUrl;

  CartItem(this.title, this.price, this.imgUrl);
}

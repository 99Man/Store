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
  final String id;
  final String? sellerId;
  int quantity;

  CartItem(
      {required this.title,
      required this.price,
      required this.imgUrl,
      required this.id,
      this.sellerId,
      this.quantity = 1});
}

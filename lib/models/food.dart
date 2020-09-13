class Food {
  final String name;
  final String toppings;
  final String imageURL;
  final int price;
  final String category;
  final int id;
  Food(
      {this.name,
      this.toppings,
      this.imageURL,
      this.price,
      this.category,
      this.id});

  factory Food.fromJSON(Map<String, dynamic> json) {
    return Food(
        name: json['name'],
        toppings: json['description'],
        imageURL: json['imageURL'],
        price: json['price'],
        category: json['category'],
        id: json['id']);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': toppings,
        'imageURL': imageURL,
        'price': price,
        'category': category,
        'id': id
      };
}

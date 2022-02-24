class ProductModel {
  int? price;
  int? oldPrice;
  int? discount;
  String? image;
  String? name;
  String? description;
  bool? inFavorites;
  bool? inCart;
  String? categoryName;
  String? categoryID;
  String? dateTime;
  Map? favourites;
  Map? carts;
  List<dynamic>? searchKeywords;

  ProductModel(
      {this.price,
      this.oldPrice,
      this.discount,
      this.image,
      this.name,
      this.description,
      this.inFavorites,
      this.inCart,
      this.categoryName,
      this.categoryID,
      this.dateTime,
      this.favourites,
      this.carts,
      this.searchKeywords});

  ProductModel.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
    categoryID = json['categoryID'];
    categoryName = json['categoryName'];
    dateTime = json['dateTime'];
    favourites = json['favourites'];
    carts = json['carts'];
    searchKeywords = json['searchKeywords'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['old_price'] = this.oldPrice;
    data['discount'] = this.discount;
    data['image'] = this.image;
    data['name'] = this.name;
    data['description'] = this.description;
    data['in_favorites'] = this.inFavorites;
    data['in_cart'] = this.inCart;
    data['categoryID'] = this.categoryID;
    data['categoryName'] = this.categoryName;
    data['dateTime'] = this.dateTime;
    data['favourites'] = this.favourites;
    data['carts'] = this.carts;
    data['searchKeywords'] = this.searchKeywords;

    return data;
  }
}

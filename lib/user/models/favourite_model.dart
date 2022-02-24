class FavouriteModel {
  String? userID;
  String? productID;
  bool? inFavourite;

  FavouriteModel(this.userID, this.productID, this.inFavourite);

  FavouriteModel.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    productID = json['productID'];
    inFavourite = json['isFavourite'];
  }

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'productID': productID,
      'inFavourite': inFavourite,
    };
  }
}

class OrderModel {
  String? username;
  String? email;
  String? phone;
  String? userID;
  String? address;
  String? location;
  int? totalPrice;
  int? countOfPieces;
  String? productID;
  String? dateTime;
  String? productName;

  OrderModel(
    this.username,
    this.email,
    this.phone,
    this.userID,
    this.address,
    this.location,
    this.totalPrice,
    this.countOfPieces,
    this.productID,
    this.dateTime,
    this.productName,
  );

  OrderModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    userID = json['userID'];
    address = json['adress'];
    location = json['location'];
    totalPrice = json['totalPrice'];
    countOfPieces = json['countOfPieces'];
    productID = json['productID'];
    dateTime = json['dateTime'];
    productName = json['productName'];
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'phone': phone,
      'userID': userID,
      'address': address,
      'location': location,
      'totalPrice': totalPrice,
      'countOfPieces': countOfPieces,
      'productID': productID,
      'dateTime': dateTime,
      'productName': productName,
    };
  }
}

class CategoryModel {
  String? image;
  String? name;
  String? dateTime;
  List<dynamic>? searchKeywords;

  CategoryModel({this.image, this.name, this.dateTime, this.searchKeywords});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    name = json['name'];
    dateTime = json['dateTime'];
    searchKeywords = json['searchKeywords'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['image'] = this.image;
    data['name'] = this.name;
    data['dateTime'] = this.dateTime;

    data['searchKeywords'] = this.searchKeywords;

    return data;
  }
}

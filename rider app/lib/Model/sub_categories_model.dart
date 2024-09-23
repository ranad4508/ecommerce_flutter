class SubCategoriesModel {
  final String? uid;
  final String category;
  final String name;
  final String image;
  SubCategoriesModel(
      {required this.category,
      this.uid,
      required this.image,
      required this.name});
  Map<String, dynamic> toMap() {
    return {'category': category, 'image': image, 'collection': name};
  }

  SubCategoriesModel.fromMap(data, this.uid)
      : category = data['category'],
        image = data['image'],
        name = data['collection'];
}

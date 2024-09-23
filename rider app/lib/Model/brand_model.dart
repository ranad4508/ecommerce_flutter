class BrandModel {
  final String? uid;
  final String backgroundImage;
  // final String category;
  final String collection;
  final String image;
  BrandModel(
      {
      // required this.category,
      this.uid,
      required this.backgroundImage,
      required this.image,
      required this.collection});
  Map<String, dynamic> toMap() {
    return {
      // 'category': category,
      'image': image,
      'collection': collection,
      'backgroundImage': backgroundImage
    };
  }

  BrandModel.fromMap(data, this.uid)
      : backgroundImage = data['backgroundImage'],
        image = data['image'],
        collection = data['collection'];
  // category = data['category'],
}

class CollectionModel {
  final String? uid;

  final String category;
  final String collection;
  final String image;
  CollectionModel(
      {required this.category,
      this.uid,
      required this.image,
      required this.collection});
  Map<String, dynamic> toMap() {
    return {'category': category, 'image': image, 'collection': collection};
  }

  CollectionModel.fromMap(data, this.uid)
      : category = data['category'],
        image = data['image'],
        collection = data['collection'];
}

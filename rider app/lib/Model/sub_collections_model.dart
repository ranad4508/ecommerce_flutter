class SubCollectionsModel {
  final String? uid;
  final String? id;
  final String category;
  final String subCollection;
  final String collections;
  final String image;
  SubCollectionsModel(
      {required this.category,
      this.uid,
      required this.collections,
      required this.image,
      this.id,
      required this.subCollection});
  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'image': image,
      'id': id,
      'subCollection': subCollection,
      'collection': collections
    };
  }

  SubCollectionsModel.fromMap(data, this.uid)
      : category = data['category'],
        image = data['image'],
        subCollection = data['subCollection'],
        id = data['id'],
        collections = data['collection'];
}

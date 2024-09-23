class PushNotificationsModel {
  final String uid;
  final DateTime timeCreated;
  final String title;
  final String category;
  final String detail;

  PushNotificationsModel({
    required this.uid,
    required this.category,
    required this.timeCreated,
    required this.title,
    required this.detail,
  });
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'title': title,
      'detail': detail,
      'timeCreated': timeCreated,
      'category': category
    };
  }

  PushNotificationsModel.fromMap(data)
      : title = data['title'],
        uid = data['uid'],
        timeCreated = data['timeCreated'],
        category = data['category'],
        detail = data['detail'];
}

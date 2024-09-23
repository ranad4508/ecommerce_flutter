class EmailModel {
  final String title;
  final String message;
  final String emailType;
  final String timeCreated;
  final String uid;

  EmailModel({
    required this.title,
    required this.message,
    required this.uid,
    required this.emailType,
    required this.timeCreated,
  });

  EmailModel.fromMap(
   data,
    this.uid,
  )   : message = data['message'],
        timeCreated = data['timeCreated'],
        title = data['title'],
        emailType = data['emailType'];

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'timeCreated': timeCreated,
      'emailType': emailType,
      'title': title
    };
  }
}

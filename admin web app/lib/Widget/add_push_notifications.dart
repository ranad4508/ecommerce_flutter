import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uuid/uuid.dart';

import '../Models/push_notifications.dart';
import '../Utils/push_notification.dart';

class AddPushNotification extends StatefulWidget {
  const AddPushNotification({super.key});

  @override
  State<AddPushNotification> createState() => _AddPushNotificationState();
}

class _AddPushNotificationState extends State<AddPushNotification> {
  String uid = '';
  String title = '';
  String category = 'All';
  String detail = '';

  Future<void> addPushNotification(
      PushNotificationsModel categoriesModel) async {
    FirebaseFirestore.instance
        .collection('Push Notifications')
        .doc(uid)
        .set(categoriesModel.toMap())
        .then((value) {
      if (category == 'Users') {
        FirebaseFirestore.instance.collection('users').get().then((value) {
          for (var element in value.docs) {
            PushNotificationFunction.sendPushNotification(
                title, detail, element['tokenID']);
          }
        });
      } else if (category == 'Vendors') {
        FirebaseFirestore.instance.collection('vendors').get().then((value) {
          for (var element in value.docs) {
            PushNotificationFunction.sendPushNotification(
                title, detail, element['tokenID']);
          }
        });
      } else if (category == 'Riders') {
        FirebaseFirestore.instance.collection('drivers').get().then((value) {
          for (var element in value.docs) {
            PushNotificationFunction.sendPushNotification(
                title, detail, element['tokenID']);
          }
        });
      } else if (category == 'Service Providers') {
        FirebaseFirestore.instance.collection('workers').get().then((value) {
          for (var element in value.docs) {
            PushNotificationFunction.sendPushNotification(
                title, detail, element['tokenID']);
          }
        });
      } else {
        FirebaseFirestore.instance.collection('workers').get().then((value) {
          for (var element in value.docs) {
            PushNotificationFunction.sendPushNotification(
                title, detail, element['tokenID']);
          }
        });
        FirebaseFirestore.instance.collection('drivers').get().then((value) {
          for (var element in value.docs) {
            PushNotificationFunction.sendPushNotification(
                title, detail, element['tokenID']);
          }
        });
        FirebaseFirestore.instance.collection('vendors').get().then((value) {
          for (var element in value.docs) {
            PushNotificationFunction.sendPushNotification(
                title, detail, element['tokenID']);
          }
        });
        FirebaseFirestore.instance.collection('users').get().then((value) {
          for (var element in value.docs) {
            PushNotificationFunction.sendPushNotification(
                title, detail, element['tokenID']);
          }
        });
      }
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Notification",
        message: "Push Notification has been sent",
        duration: const Duration(seconds: 3),
      ).show(context);
    });
  }

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    var uuid = const Uuid();

    uid = uuid.v1();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Add a new push notification').tr(),
          InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.clear))
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width / 1.5,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  validator: (v) {
                    if (v!.isEmpty) {
                      return 'Field is required';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      title = value;
                    });
                  },
                  decoration:
                      InputDecoration(hintText: "Notification Title".tr()),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  validator: (v) {
                    if (v!.isEmpty) {
                      return 'Field is required';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      detail = value;
                    });
                  },
                  decoration:
                      InputDecoration(hintText: "Notification Message".tr()),
                ),
                const SizedBox(height: 40),
                // DropdownSearch<String>(
                //   selectedItem: category,
                //   validator: (v) => v == null ? "required field" : null,
                //   popupProps: const PopupProps.menu(
                //     showSelectedItems: true,
                //   ),
                //   dropdownDecoratorProps: const DropDownDecoratorProps(
                //       dropdownSearchDecoration: InputDecoration(
                //     hintText: "Category",
                //     // labelText: "Categories *",
                //     border: UnderlineInputBorder(
                //       borderSide: BorderSide(color: Color(0xFF01689A)),
                //     ),
                //   )),
                //   items: const [
                //     'Vendors',
                //     'Users',
                //     "Service Providers",
                //     "Riders",
                //     "All"
                //   ],
                //   onChanged: (value) {
                //     setState(() {
                //       category = value!;
                //     });
                //   },
                // ),
                //  const SizedBox(height: 40),
                SizedBox(
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade800),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            addPushNotification(PushNotificationsModel(
                                    uid: uid,
                                    timeCreated: DateTime.now(),
                                    title: title,
                                    category: 'Users',
                                    detail: detail))
                                .then((value) => Navigator.of(context).pop());
                          }
                        },
                        child: const Text('Send Notification').tr()))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

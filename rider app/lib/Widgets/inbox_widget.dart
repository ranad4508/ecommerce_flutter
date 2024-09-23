import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rider_app/Model/notifications.dart';

class InboxWidget extends StatefulWidget {
  const InboxWidget({super.key});

  @override
  State<InboxWidget> createState() => _InboxWidgetState();
}

class _InboxWidgetState extends State<InboxWidget> {
  List<NotificationsModel> orders = [];

  String? selectedValue;
  String currency = '';
  bool isLoading = true;
  Future<void> fetchInbox() async {
    setState(() {
      isLoading = true;
    });
    context.loaderOverlay.show();
    final FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;

    FirebaseFirestore.instance
        .collection('riders')
        .doc(user!.uid)
        .collection('Notifications')
        .snapshots(includeMetadataChanges: true)
        .listen((data) {
      context.loaderOverlay.hide();
      setState(() {
        isLoading = false;
      });
      orders.clear();
      for (var doc in data.docs) {
        if (mounted) {
          setState(() {
            var result = NotificationsModel.fromMap(doc.data(), doc.id);
            orders.add(result);
          });
        }
      }
    });
  }

  @override
  initState() {
    super.initState();

    fetchInbox();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (MediaQuery.of(context).size.width >= 1100) const Gap(10),
          //   if (MediaQuery.of(context).size.width >= 1100)

        //  const Gap(20),
          isLoading == true
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[300]!,
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 150,
                              height: 20,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 100,
                              height: 16,
                              color: Colors.grey[300],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : orders.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Icon(
                            Icons.notifications,
                            color: Colors.orange,
                            size: MediaQuery.of(context).size.width >= 1100
                                ? MediaQuery.of(context).size.width / 5
                                : MediaQuery.of(context).size.width / 1.5,
                          ),
                        ),
                        const Gap(10),
                        const Text('No notifications').tr(),
                        const Gap(20),
                      ],
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: orders.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        NotificationsModel orderModel2 = orders[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 215, 214, 214))),
                            child: ListTile(
                              trailing: IconButton(
                                onPressed: () {
                                  final FirebaseAuth auth =
                                      FirebaseAuth.instance;

                                  User? user = auth.currentUser;
                                  FirebaseFirestore.instance
                                      .collection('riders')
                                      .doc(user!.uid)
                                      .collection('Notifications')
                                      .doc(orderModel2.uid)
                                      .delete();
                                },
                                icon: const Icon(Icons.delete),
                              ),
                              subtitle: Text(orderModel2.content),
                              title: Text(
                                orderModel2.heading,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        );
                      }),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widget/CategoriesData/sub_collections_datatable.dart';

class SubCollectionsPage extends StatefulWidget {
  const SubCollectionsPage({super.key});

  @override
  State<SubCollectionsPage> createState() =>
      _SubCollectionsPageState();
}

class _SubCollectionsPageState extends State<SubCollectionsPage> {
  DocumentReference? userRef;
  String fullname = 'Olivette Admin';
  String profilePic =
      'https://eitrawmaterials.eu/wp-content/uploads/2016/09/person-icon.png';
  String email = 'admin123@gmail.com';

  @override
  void initState() {
    getSelectedRoute();
    getFirebaseDetails();
    super.initState();
  }

  String adminImage = '';
  String oldPassword = '';
  String adminUsername = '';
  getFirebaseDetails() {
    FirebaseFirestore.instance
        .collection('Admin')
        .doc('Admin')
        .get()
        .then((value) {
      setState(() {
        adminImage = value['ProfilePic'];
        oldPassword = value['password'];
        adminUsername = value['username'];
      });
    });
  }

  bool? loggedIn;

 getSelectedRoute() {
    Future.delayed(const Duration(seconds: 2), () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool? repeat = prefs.getBool('logged in');
      setState(() {
        loggedIn = repeat;
      });
      if (repeat == false || repeat == null) {
        // ignore: use_build_context_synchronously
        context.go('/login');
        // ignore: avoid_print
        print('Repeat is $repeat');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getSelectedRoute();
    return const Scaffold(
      body: SafeArea(
        child: SubCollectionsData(),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widget/add_product_from_page.dart';

import '../Widget/products_datatable.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  DocumentReference? userRef;
  String fullname = 'Olivette Vendor Dashboard';
  String profilePic =
      'https://eitrawmaterials.eu/wp-content/uploads/2016/09/person-icon.png';
  String email = '';
  DocumentReference? userDetails;
  String id = '';

  @override
  void initState() {
    _getUserDetails();
    _getUser();
    getIsLogged();
    super.initState();
  }

  Future<void> _getUser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    User? user = auth.currentUser;
    setState(() {
      userRef = firestore.collection('vendors').doc(user!.uid);
    });
  }

  Future<void> _getUserDetails() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    User? user = auth.currentUser;
    setState(() {
      userDetails =
          firestore.collection('vendors').doc(user!.uid).get().then((value) {
        setState(() {
          email = value['email'];
          fullname = value['fullname'];
          profilePic = value['photoUrl'];
          id = value['id'];
        });
      }) as DocumentReference?;
    });
  }

  bool isLogged = false;

  getIsLogged() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        setState(() {
          isLogged = false;
        });
      } else {
        setState(() {
          isLogged = true;
        });
      }
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

    return Scaffold(
      body: const SafeArea(
        child: ProductsDatatable(),
      ),
      floatingActionButton: MediaQuery.of(context).size.width >= 1100 ||
              MediaQuery.of(context).size.width > 600 &&
                  MediaQuery.of(context).size.width < 1200
          ? null
          : FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (builder) {
                      return const Material(
                        child: AddProductsFromPage(),
                      );
                    });
              },
              backgroundColor: Colors.blue.shade800,
              child: const Icon(Icons.add),
            ),
    );
  }
}

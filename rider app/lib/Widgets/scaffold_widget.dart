// ignore_for_file: avoid_print

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../Model/categories.dart';
import '../Model/menu_model.dart';
import 'language_widget.dart';
import 'mobile_menu.dart';

class ScaffoldWidget extends StatefulWidget {
  final Widget body;
  final String path;
  const ScaffoldWidget({super.key, required this.body, required this.path});

  @override
  State<ScaffoldWidget> createState() => _ScaffoldWidgetState();
}

class _ScaffoldWidgetState extends State<ScaffoldWidget> {
  List<String> categories = [];
  num cartQuantity = 0;
  bool loaded = false;
  String? selectedValue;
  bool isLogged = false;
  String fullname = '';
  num price = 0;
  String currency = '';

  getFullName() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('riders')
        .doc(user!.uid)
        .snapshots()
        .listen((event) {
      setState(() {
        fullname =
            event['fullname'].substring(0, event['fullname'].indexOf(" "));
      });
      //  print('Fullname is $fullName');
    });
  }

  getCart() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;
    firestore
        .collection('riders')
        .doc(user!.uid)
        .collection('Cart')
        .snapshots()
        .listen((val) {
      num tempTotal =
          val.docs.fold(0, (tot, doc) => tot + doc.data()['quantity']);
      num totalPrice =
          val.docs.fold(0, (tot, doc) => tot + doc.data()['price']);
      setState(() {
        cartQuantity = tempTotal;
        price = totalPrice;
      });
    });
  }

  getCategoriesTabs() {
    setState(() {
      loaded = false;
    });
    context.loaderOverlay.show();
    List<String> dataMain = ["Home", "View All Categories"];
    FirebaseFirestore.instance
        .collection('Categories')
        .limit(7)
        .snapshots()
        .listen((event) {
      for (var element in event.docs) {
        context.loaderOverlay.hide();
        setState(() {
          loaded = true;
        });
        dataMain.add(element['category']);
        setState(() {
          categories = dataMain;
        });
      }
    });
  }

  openDrawerHome() {
    _scaffoldHome.currentState!.openDrawer();
  }

  final GlobalKey<ScaffoldState> _scaffoldHome = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    getCategoriesTabs();
    getCats();
    // _retrieveToken();
    getCurrency();
    //getToken();
    getAuth();
    super.initState();
  }

  // void retrieveToken() async {
  //   print("My tokenID is");
  //   final FirebaseAuth auth = FirebaseAuth.instance;
  //   User? user = auth.currentUser;

  //   if (user != null) {
  //     String? token = await FirebaseMessaging.instance.getToken(
  //         vapidKey:
  //             'BCY9BSwyb0PF-Id7hSZelpiQE8AP8iuqz7cNUu8m2HeuRvTEgX_vZOVoviEtmm4D7xI_OA6nM9KcOCOTiCJMFCQ');
  //     FirebaseFirestore.instance
  //         .collection('riders')
  //         .doc(user.uid)
  //         .update({'tokenID': token});
  //     print("My tokenID is $token");
  //   }
  // }

  // getToken() async {
  //   String? token = await FirebaseMessaging.instance.getToken();
  //   print("My tokenID is $token");
  // }

  bool isVerified = false;
  getAuth() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        setState(() {
          isLogged = false;
          cartQuantity = 0;
          price = 0;
        });
      } else {
        setState(() {
          isLogged = true;
        });
        getCart();
        getFullName();
      }
    });
  }

  List<CategoriesModel> cats = [];
  getCats() {
    return FirebaseFirestore.instance
        .collection('Categories')
        .snapshots()
        .listen((value) {
      cats.clear();
      for (var element in value.docs) {
        setState(() {
          var fetchServices =
              CategoriesModel.fromMap(element.data(), element.id);
          cats.add(fetchServices);
        });
      }
    });
  }

  getCurrency() {
    FirebaseFirestore.instance
        .collection('Currency Settings')
        .doc('Currency Settings')
        .get()
        .then((value) {
      setState(() {
        currency = value['Currency symbol'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Path is ${widget.path}');
    String hi = 'Hi'.tr();
    String account = 'Account'.tr();

    return Scaffold(
      key: _scaffoldHome,
      drawer: MediaQuery.of(context).size.width >= 1100
          ? null
          : Drawer(
              shape: const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.zero)),
              width: MediaQuery.of(context).size.width >= 1100
                  ? MediaQuery.of(context).size.width / 3
                  : double.infinity,
              child: MobileMenuWidget(
                isLogged: isLogged,
                cats: cats,
              )),
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width >= 1100 ? 400 : null,
        automaticallyImplyLeading: false,
        leading: MediaQuery.of(context).size.width >= 1100
            ? Image.asset(
                'assets/image/new logo.png',
                color: AdaptiveTheme.of(context).mode.isDark == true
                    ? Colors.white
                    : null,
              )
            // : MediaQuery.of(context).size.width <= 1100 && widget.path != '/'
            //     ? IconButton(
            //         onPressed: () {
            //           context.push('/');
            //         },
            //         icon: const Icon(Icons.arrow_back))
            : widget.path != '/'
                ? IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: const Icon(Icons.arrow_back))
                : IconButton(
                    onPressed: () {
                      openDrawerHome();
                    },
                    icon: const Icon(Icons.menu)),
        title: Image.asset(
          'assets/image/new logo.png',
          height: 100,
          width: 100,
          color: AdaptiveTheme.of(context).mode.isDark == true
              ? Colors.white
              : null,
        ),
        actions: [
          // if (MediaQuery.of(context).size.width <= 1100)
          //   IconButton(
          //       onPressed: () {}, icon: const Icon(Icons.search_outlined)),
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      if (MediaQuery.of(context).size.width >= 1100) {
                        return AlertDialog(
                          content: SizedBox(
                              width: MediaQuery.of(context).size.width >= 1100
                                  ? MediaQuery.of(context).size.width / 3
                                  : MediaQuery.of(context).size.width / 1.3,
                              height: MediaQuery.of(context).size.height / 1.5,
                              child: const LanguageWidget()),
                        );
                      } else {
                        return const Dialog.fullscreen(
                          child: LanguageWidget(),
                        );
                      }
                    });
              },
              icon: const Icon(Icons.language)),
          const Gap(10),
          MediaQuery.of(context).size.width >= 1100
              ? DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    dropdownStyleData: const DropdownStyleData(width: 200),
                    isExpanded: true,
                    customButton: Row(
                      children: [
                        Badge(
                          isLabelVisible: isLogged == true ? true : false,
                          //   padding: EdgeInsets.only(top: 3),
                          backgroundColor: Colors.orange,
                          alignment: Alignment.bottomRight,
                          label: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 6,
                          ),
                          child: const Icon(
                            Icons.person_outline_outlined,
                          ),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Text(
                          isLogged == true ? '$hi, $fullname' : account,
                          style: const TextStyle(
                              //fontSize: 14,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        const Icon(
                          Icons.arrow_drop_down_outlined,
                          //  color: Color.fromRGBO(48, 30, 2, 1),
                        ),
                      ],
                    ),
                    items: [
                      ...MenuItems.firstItems.map(
                        (item) => DropdownMenuItem<MenuItem>(
                          value: item,
                          child: MenuItems.buildItem(item),
                        ),
                      ),
                      const DropdownMenuItem<Divider>(
                          enabled: false, child: Divider()),
                      if (isLogged == true)
                        ...MenuItems.secondItems.map(
                          (item) => DropdownMenuItem<MenuItem>(
                            value: item,
                            child: MenuItems.buildItem(item),
                          ),
                        ),
                      if (isLogged == false)
                        ...MenuItems.secondItems2.map(
                          (item) => DropdownMenuItem<MenuItem>(
                            value: item,
                            child: MenuItems.buildItem(item),
                          ),
                        ),
                    ],
                    value: selectedValue,
                    onChanged: (value) {
                      MenuItems.onChanged(context, value! as MenuItem);
                    },
                  ),
                )
              : Badge(
                  isLabelVisible: isLogged == true ? true : false,
                  backgroundColor: Colors.orange,
                  alignment: Alignment.bottomRight,
                  label: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 8,
                  ),
                  child: IconButton(
                      onPressed: () {
                        if (isLogged == true) {
                          context.push('/profile');
                        } else {
                          context.push('/login');
                        }
                      },
                      icon: const Icon(Icons.person_outline)),
                ),
          const Gap(10),
        ],
      ),
      body: Stack(
        children: [
          widget.body,

          // isLogged == false
          //     ? const SizedBox.shrink()
          //     :
        ],
      ),
    );
  }
}

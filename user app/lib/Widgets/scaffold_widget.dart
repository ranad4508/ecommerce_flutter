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
import 'package:user_app/Model/formatter.dart';
import 'package:user_app/Model/menu_model.dart';
import 'package:user_app/Widgets/cart_widget.dart';
import 'package:user_app/Widgets/cats_tabs.dart';
import 'package:user_app/Widgets/mobile_menu.dart';
import 'package:user_app/Widgets/search_widget.dart';
import '../Model/categories.dart';
import '../Model/constant.dart';
import 'cat_image_widget.dart';
import 'collections_expanded_tile.dart';
import 'language_widget.dart';
// ignore: library_prefixes
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;

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
        .collection('users')
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
        .collection('users')
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
    getAllCats();
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
  //         .collection('users')
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

  int currentIndex = 1;
  List<CategoriesModel> allCats = [];
  bool isLoading = false;
  getAllCats() {
    setState(() {
      isLoading = true;
    });
    List<CategoriesModel> categories = [];
    return FirebaseFirestore.instance
        .collection('Categories')
        .snapshots()
        .listen((value) {
      setState(() {
        isLoading = false;
      });
      allCats.clear();
      for (var element in value.docs) {
        setState(() {
          var fetchServices =
              CategoriesModel.fromMap(element.data(), element.id);
          categories.add(fetchServices);
          allCats = categories;
          //  cats.add(CategoriesModel(category: "View All".tr(), image: ''));
        });
      }
    });
  }

  showBottomSheetTab() {
    modalSheet.showBarModalBottomSheet(
        expand: true,
        bounce: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const Gap(20),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: const Text(
                            'Categories',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ).tr(),
                        ),
                      ],
                    ),
                    const Gap(10),
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: allCats.length,
                        itemBuilder: (context, index) {
                          CategoriesModel categoriesModel = allCats[index];
                          return ExpansionTile(
                            leading: SizedBox(
                              height: 50,
                              width: 50,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: CatImageWidget(
                                    url: categoriesModel.image,
                                    boxFit: 'cover',
                                  ),
                                ),
                              ),
                            ),
                            title: Text(categoriesModel.category),
                            children: [
                              CollectionsExpandedTile(
                                cat: categoriesModel.category,
                              )
                            ],
                          );
                        }),
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    print('Path is ${widget.path}');
    String hi = 'Hi'.tr();
    String account = 'Account'.tr();
    String items = 'items'.tr();
    return Scaffold(
      key: _scaffoldHome,
      bottomNavigationBar: widget.path == '/' || widget.path == '/orders'
          ? BottomNavigationBar(
              selectedItemColor: appColor,
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              onTap: (index) {
                if (index == 0) {
                  // showBottomSheetTab();
                  openDrawerHome();
                } else if (index == 2) {
                  _scaffoldHome.currentState!.openEndDrawer();
                } else if (index == 1) {
                  setState(() {
                    context.go('/');
                    currentIndex = index;
                  });
                } else if (index == 3) {
                  showBottomSheetTab();
                }
              },
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.sort),
                  label: 'Menu'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home_outlined),
                  label: 'Home'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: 'Cart'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.category),
                  label: 'Categories'.tr(),
                ),
              ],
            )
          : null,
      endDrawer: Drawer(
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.zero)),
        width: MediaQuery.of(context).size.width >= 1100
            ? MediaQuery.of(context).size.width / 3
            : double.infinity,
        child: const CartWidget(),
      ),
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
          leading: widget.path != '/'
              ? InkWell(
                  child: const Icon(Icons.arrow_back),
                  onTap: () {
                    context.pop();
                  },
                )
              : null,
          title: MediaQuery.of(context).size.width >= 1100
              ? SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  height: 40,
                  child: const SearchWidget(
                    autoFocus: false,
                  ),
                )
              : Image.asset('assets/image/new logo.png',
                  height: 120,
                  width: 120,
                  color: AdaptiveTheme.of(context).mode.isDark == true
                      ? Colors.white
                      : null),
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
                                height:
                                    MediaQuery.of(context).size.height / 1.5,
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
                            backgroundColor: appColor,
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
                    backgroundColor: appColor,
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
            MediaQuery.of(context).size.width >= 1100
                ? TextButton.icon(
                    onPressed: () {
                      _scaffoldHome.currentState!.openEndDrawer();
                    },
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.black,
                    ),
                    label: const Text(
                      'Cart',
                      style: TextStyle(color: Colors.black),
                    ).tr())
                : const SizedBox.shrink(),
            if (MediaQuery.of(context).size.width >= 1100) const Gap(100)
          ],
          bottom: loaded == true
              ? MediaQuery.of(context).size.width >= 1100
                  ? PreferredSize(
                      preferredSize: const Size.fromHeight(50),
                      child: CatsTabs(data: categories))
                  : const PreferredSize(
                      preferredSize: Size.fromHeight(50),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(left: 8, right: 8),
                          child: SizedBox(
                              height: 40,
                              child: SearchWidget(autoFocus: false)),
                        ),
                      ))
              : null),
      body: Stack(
        children: [
          widget.body,

          // isLogged == false
          //     ? const SizedBox.shrink()
          //     :
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                _scaffoldHome.currentState!.openEndDrawer();
              },
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                    color: appColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Icon(
                            Icons.shopping_bag,
                            color: AdaptiveTheme.of(context).mode.isDark == true
                                ? Colors.black
                                : Colors.white,
                            size: 14,
                          ),
                        ),
                        Text(
                          '$cartQuantity $items',
                          style: TextStyle(
                            color: AdaptiveTheme.of(context).mode.isDark == true
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Container(
                        decoration: BoxDecoration(
                            color: AdaptiveTheme.of(context).mode.isDark == true
                                ? Colors.black
                                : Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: price == 0
                              ? Text(
                                  '$currency 0.00',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                )
                              : Text(
                                  '$currency${Formatter().converter(price.toDouble())}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

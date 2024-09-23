import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:admin_web_app/Widget/languageview.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Theme/theme.dart';
import '../Utils/Theme/theme_data.dart';
import '../Widget/drawer.dart';

class HomePageMain extends StatefulWidget {
  final Widget body;
  const HomePageMain({super.key, required this.body});

  @override
  State<HomePageMain> createState() => _HomePageMainState();
}

class _HomePageMainState extends State<HomePageMain> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DocumentReference? userRef;
  String fullname = 'Olivette Admin';
  String profilePic =
      'https://eitrawmaterials.eu/wp-content/uploads/2016/09/person-icon.png';
  String email = 'admin123@gmail.com';

  @override
  void initState() {
    //  initAuth();
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

  initAuth() async {
    // Get an instance of SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logged in', true);
  }

  dynamic themeMode = true;

  getThemeDetail() async {
    SharedPreferences.getInstance().then((prefs) {
      var lightModeOn = prefs.getBool('lightMode');
      setState(() {
        themeMode = lightModeOn!;
      });
    });
  }

  var _lightTheme = true;
  void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
    (value)
        ? themeNotifier.setTheme(lightTheme)
        : themeNotifier.setTheme(darkTheme);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('lightMode', value);
  }

  @override
  Widget build(BuildContext context) {
    getThemeDetail();
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      backgroundColor: themeMode == true ? Colors.white12 : Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 1,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _lightTheme = !_lightTheme;
                  themeMode = !themeMode;
                });
                onThemeChanged(_lightTheme, themeNotifier);
                debugPrint("tttttt ${_lightTheme.toString()}");
              },
              color: Theme.of(context).iconTheme.color,
              icon: themeMode == false
                  ? Icon(
                      Icons.sunny,
                      size: MediaQuery.of(context).size.width >= 1100 ? 20 : 15,
                    )
                  : Icon(
                      Icons.radio_button_checked,
                      size: MediaQuery.of(context).size.width >= 1100 ? 20 : 15,
                    )),
          IconButton(
              color: Theme.of(context).iconTheme.color,
              onPressed: () {
                context.go(
                  '/notifications',
                );
              },
              icon: Icon(
                Icons.notifications_outlined,
                size: MediaQuery.of(context).size.width >= 1100 ? 20 : 15,
              )),
          TextButton(
            child: Icon(
              Icons.language,
              size: MediaQuery.of(context).size.width >= 1100 ? 20 : 15,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (_) => const LanguageView(),
              //       fullscreenDialog: true),
              // );
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: SizedBox(
                          width: MediaQuery.of(context).size.width >= 1100
                              ? MediaQuery.of(context).size.width / 3
                              : MediaQuery.of(context).size.width / 1.3,
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: const LanguageView()),
                    );
                  });
            },
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              customButton: SizedBox(
                width: MediaQuery.of(context).size.width >= 1100 ? 40: 40,
                height: MediaQuery.of(context).size.width >= 1100 ? 40: 30,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(adminImage),
                  backgroundColor: Colors.transparent,
                ),
              ),
              dropdownStyleData: DropdownStyleData(
                width: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                elevation: 8,
                offset: const Offset(0, 8),
              ),
              items: <String>[
                'Profile'.tr(),
                'Settings'.tr(),
                'Log Out'.tr(),
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) async {
                if (value == 'Log Out') {
                  var prefs = await SharedPreferences.getInstance();
                  prefs.setBool('logged in', false).then((value) {
                    context.go('/login');
                  });
                } else if (value == 'Profile') {
                  context.go(
                    '/profile',
                  );
                } else {
                  context.go(
                    '/settings',
                  );
                }
              },
            ),
          ),
          const SizedBox(
            width: 30,
          )
        ],
        title: MediaQuery.of(context).size.width >= 1100
            ? const SizedBox()
            : Text(
                'Admin Dashboard',
                style: TextStyle(
                    color: Theme.of(context).iconTheme.color, fontSize: 12),
                textAlign: TextAlign.start,
              ).tr(),
        leadingWidth: MediaQuery.of(context).size.width >= 1100 ? 200 : 50,
        leading: MediaQuery.of(context).size.width >= 1100
            ? Center(
                child: Text(
                  'Admin Dashboard',
                  style: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              )
            : InkWell(
                onTap: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
                child: Icon(
                  Icons.menu,
                  color: Theme.of(context).iconTheme.color,
                )),
      ),
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MediaQuery.of(context).size.width >= 1100
                ? const Expanded(
                    child: SideMenu(),
                  )
                : const SizedBox(),
            Expanded(
              flex: 5,
              child: widget.body,
            ),
          ],
        ),
      ),
    );
  }
}

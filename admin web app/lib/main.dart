import 'package:admin_web_app/Pages/Categories%20Settings/brands.dart';
import 'package:admin_web_app/Pages/banners.dart';
import 'package:admin_web_app/Pages/flash_sales.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:admin_web_app/Pages/home_main.dart';
import 'package:admin_web_app/Pages/pickup_address_page.dart';
import 'package:admin_web_app/Pages/push_notifications_page.dart';
import 'package:admin_web_app/Pages/return_products_page.dart';
import 'package:admin_web_app/Utils/Theme/theme.dart';
import 'package:admin_web_app/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Pages/Categories Settings/categories.dart';
import 'Pages/Categories Settings/collections.dart';
import 'Pages/Categories Settings/sub_collections.dart';
import 'Pages/Email_Management_Pages/bulk_email_page.dart';
import 'Pages/Login/login.dart';
import 'Pages/Profile Settings/app_settings.dart';
import 'Pages/Profile Settings/edit_profile.dart';
import 'Pages/Profile Settings/profile.dart';
import 'Pages/Reports Pages/orders_report_page.dart';
import 'Pages/Reports Pages/users_report_pages.dart';
import 'Pages/Users Settings/riders_page.dart';
import 'Pages/Users Settings/users_page.dart';
import 'Pages/coupon_page.dart';
import 'Pages/feeds.dart';
import 'Pages/home.dart';
import 'Pages/hot_deals.dart';
import 'Pages/notifications.dart';
import 'Pages/orders.dart';
import 'Pages/products.dart';
import 'Pages/reviews.dart';
import 'Utils/Theme/theme_data.dart';

int? initScreen;
bool? seen;
String? newPassword;
String? adminUsername;
String? adminImage;
num? commission;

updateAdmin() {
  FirebaseFirestore.instance
      .collection('Admin')
      .doc('Admin')
      .get()
      .then((value) {
    if (!value.exists) {
      defaultUpdate();
    }
  });
}

defaultUpdate() {
  if (newPassword == null && adminImage == null && adminUsername == null) {
    FirebaseFirestore.instance.collection('Admin').doc('Admin').set({
      'password': 'Dinesh@1',
      'ProfilePic': 'https://img.icons8.com/officel/2x/person-male.png',
      'username': 'dinesh123@gmail.com',
      'commission': 0,
      'ParcelID': 0,
      'Delivery Fee': 0,
      'orderID': 0
    });

    // FirebaseFirestore.instance
    //     .collection('Product Slide')
    //     .doc('Product Slide')
    //     .set({
    //   'Product Slide 1': '',
    //   'Product Slide 2': '',
    //   'Product Slide 3': '',
    //   'Product Slide 4': '',
    //   'Product Slide 5': ''
    // });
  }
}

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  var prefsTheme = await SharedPreferences.getInstance();
  var lightModeOn = prefsTheme.getBool('lightMode') ?? true;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    // options: const FirebaseOptions(
    //     apiKey: "AIzaSyBSIiLOIQPOvbPiVtBlXGIrX5FSl4w-6rA",
    //     authDomain: "olivette-ecommerce.firebaseapp.com",
    //     projectId: "olivette-ecommerce",
    //     storageBucket: "olivette-ecommerce.appspot.com",
    //     messagingSenderId: "1095666484809",
    //     appId: "1:1095666484809:web:5447c6812158f62ea2e198",
    //     measurementId: "G-RLX6L2NLDS")
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  updateAdmin();
  await prefs.setBool("seen", true);
  seen = prefs.getBool("seen");

  seen = prefs.getBool("seen");

  await EasyLocalization.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeNotifier>.value(
            value: ThemeNotifier(lightModeOn ? lightTheme : darkTheme)),
      ],
      child: EasyLocalization(
          supportedLocales: const [
            Locale('es', 'ES'),
            Locale('en', 'US'),
            Locale('pt', 'PT')
          ],
          path: 'assets/languagesFile',
          fallbackLocale: const Locale('en', 'US'),
          child: const MyApp()),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FlutterNativeSplash.remove();
    // _retrieveToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      title: 'Emall Admin',
      theme: themeNotifier.getTheme(),
      // theme: ThemeData(
      //   primaryColor: Colors.blue,
      //   textTheme: GoogleFonts.robotoTextTheme(
      //     Theme.of(context).textTheme,
      //   ),
      // ),
    );
  }

  final GoRouter router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/login',
      routes: [
        GoRoute(
            path: '/login',
            builder: (BuildContext context, GoRouterState state) =>
                const Login()),
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (_, GoRouterState state, child) {
            return HomePageMain(
              body: child,
            );
          },
          routes: [
            GoRoute(
              path: '/',
              builder: (BuildContext context, GoRouterState state) =>
                  const HomePage(),
            ),
            GoRoute(
              path: '/bulk-emails',
              builder: (BuildContext context, GoRouterState state) =>
                  const BulkEmailPage(),
            ),
            GoRoute(
              path: '/coupon',
              builder: (BuildContext context, GoRouterState state) =>
                  const CouponPage(),
            ),
            GoRoute(
              path: '/pickup-address',
              builder: (BuildContext context, GoRouterState state) =>
                  const PickupAddressPage(),
            ),
            GoRoute(
              path: '/users-report',
              builder: (BuildContext context, GoRouterState state) =>
                  const UsersReportPage(),
            ),
            GoRoute(
              path: '/push-notifications',
              builder: (BuildContext context, GoRouterState state) =>
                  const PushNotificationPage(),
            ),
            GoRoute(
              path: '/returned-products',
              builder: (BuildContext context, GoRouterState state) =>
                  const ReturnProductsPage(),
            ),
            GoRoute(
              path: '/orders-report',
              builder: (BuildContext context, GoRouterState state) =>
                  const OrdersReportPage(),
            ),
            GoRoute(
              path: '/categories',
              builder: (context, state) => const Categories(),
            ),
            GoRoute(
              path: '/collections',
              builder: (context, state) => const CollectionsPage(),
            ),
            GoRoute(
              path: '/sub-collections',
              builder: (context, state) => const SubCollectionsPage(),
            ),
            GoRoute(
              path: '/brands',
              builder: (context, state) => const BrandsPage(),
            ),
            GoRoute(
              path: '/riders',
              builder: (context, state) => const Riders(),
            ),
            GoRoute(
              path: '/settings',
              builder: (context, state) => const AppSettings(),
            ),
            GoRoute(
              path: '/edit-profile',
              builder: (context, state) => const EditProfile(),
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => const Profile(),
            ),
            GoRoute(
              path: '/users',
              builder: (context, state) => const Users(),
            ),
            GoRoute(
              path: '/feeds',
              builder: (context, state) => const Feeds(),
            ),
            GoRoute(
              path: '/notifications',
              builder: (context, state) => const Notifications(),
            ),
            GoRoute(
              path: '/orders',
              builder: (context, state) => const Orders(),
            ),
            GoRoute(
              path: '/products',
              builder: (context, state) => const ProductsPage(),
            ),
            GoRoute(
              path: '/reviews',
              builder: (context, state) => const Reviews(),
            ),
            GoRoute(
              path: '/hot-deals',
              builder: (context, state) => const HotDealsPage(),
            ),
            GoRoute(
              path: '/banners',
              builder: (context, state) => const BannersPage(),
            ),
            GoRoute(
              path: '/flash-sales',
              builder: (context, state) => const FlashSalesPage(),
            ),
          ],
        ),
      ]);
}

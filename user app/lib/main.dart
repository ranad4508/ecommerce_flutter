// ignore_for_file: avoid_print

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:meta_seo/meta_seo.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:user_app/Model/constant.dart';
// import 'package:url_strategy/url_strategy.dart';
import 'package:user_app/Model/user.dart';
import 'package:user_app/Pages/bottom_nav.dart';
import 'package:user_app/Pages/brand_page.dart';
import 'package:user_app/Pages/check_out_page.dart';
import 'package:user_app/Pages/delivery_address_page.dart';
import 'package:user_app/Pages/favorites_page.dart';
import 'package:user_app/Pages/flash_sales_page.dart';
import 'package:user_app/Pages/forgot_passowrd_page.dart';
import 'package:user_app/Pages/hot_deals_page.dart';
// import 'package:user_app/Pages/hot_deals_page.dart';
import 'package:user_app/Pages/inbox_page.dart';
import 'package:user_app/Pages/onboarding_page.dart';
import 'package:user_app/Pages/policy_page.dart';
import 'package:user_app/Pages/products_by_category.dart';
import 'package:user_app/Pages/profile_page.dart';
import 'package:user_app/Pages/search_page.dart';
import 'package:user_app/Pages/terms_page.dart';
import 'package:user_app/Pages/track_order_page.dart';
import 'package:user_app/Pages/vouchers_page.dart';
import 'package:user_app/Pages/wallet_page.dart';
import 'package:user_app/Providers/auth.dart';
import 'package:user_app/Widgets/scaffold_widget.dart';
// import 'package:user_app/Widgets/scaffold_widget.dart';
import 'package:user_app/firebase_options.dart';

import 'Pages/about_page.dart';
// import 'Pages/home_page.dart';
import 'Pages/login_page.dart';
import 'Pages/order_detail_page.dart';
import 'Pages/orders_page.dart';
import 'Pages/product_details_page.dart';
import 'Pages/products_by_collection.dart';
import 'Pages/signup_page.dart';
import 'Pages/track_order_detail_page.dart';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
int? initScreen;
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await setupFlutterNotifications();
  showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
}

void requestFCMPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print('FCM Permission status: ${settings.authorizationStatus}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

// void _retrieveToken() async {
//   String? token = await FirebaseMessaging.instance.getToken();
//   print('FCM Token: $token');
// }

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: 'launch_background',
        ),
      ),
    );
  }
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
bool isLogged = false;
getAuth() {
  FirebaseAuth.instance.authStateChanges().listen((User? user) async {
    if (user == null) {
      isLogged = false;

      print('Your login status is:$isLogged');
    } else {
      isLogged = true;

      print('Your login status is:$isLogged');
    }
  });
}

main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
//WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences.getInstance().then((prefs) {
    initScreen = prefs.getInt("initScreen");
    prefs.setInt("initScreen", 1);
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  requestFCMPermission();
  if (!kIsWeb) {
    await setupFlutterNotifications();
  }
  await dotenv.load(fileName: ".env");
  // Stripe.publishableKey = dotenv.env['StripePublishableKey']!;
  Stripe.publishableKey =
      "pk_test_51NIYLgCnz4iXNeUbrfv4os7vucNu44LVFwlw5Ym8xO6vvMrAhD0n1RvxfMVDvYS4IvtLpBXnnZslGSPaYvP3CcFx00FS8D6l12";
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // if (!kIsWeb) {
  //   await setupFlutterNotifications();
  // }
  // usePathUrlStrategy();
  setPathUrlStrategy();
  if (kIsWeb) {
    MetaSEO().config();
  }
  await EasyLocalization.ensureInitialized();
  // requestPermission();
  getAuth();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MultiProvider(
      providers: [
        StreamProvider<UserModel>.value(
          value: AuthService().user,
          initialData: UserModel(
            displayName: '',
            email: '',
            phonenumber: '',
            token: '',
            uid: '',
          ),
        ),
      ],
      child: EasyLocalization(
          supportedLocales: const [
            Locale('es', 'ES'),
            Locale('en', 'US'),
            Locale('pt', 'PT')
          ],
          path: 'assets/languagesFile',
          fallbackLocale: const Locale('en', 'US'),
          child: MyApp(
            savedThemeMode: savedThemeMode,
          ))));
}

class MyApp extends StatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const MyApp({super.key, this.savedThemeMode});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void _retrieveToken() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      String? token = await FirebaseMessaging.instance.getToken();
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'tokenID': token});
      print("My tokenID is $token");
    }
  }

  @override
  void initState() {
    FlutterNativeSplash.remove();
    _retrieveToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Add MetaSEO just into Web platform condition
    if (kIsWeb) {
      // Define MetaSEO object
      MetaSEO meta = MetaSEO();
      // add meta seo data for web app as you want
      meta.author(author: 'Dinesh Kumar Rana');
      meta.description(description: 'Emall');
      meta.keywords(keywords: 'Flutter, Dart, SEO, Meta, Web, Emall');
    }
    return AdaptiveTheme(
        light: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorSchemeSeed: Colors.blue,
            fontFamily: 'Graphik'),
        dark: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorSchemeSeed: Colors.blue,
            fontFamily: 'Graphik'),
        initial: widget.savedThemeMode ?? AdaptiveThemeMode.light,
        builder: (theme, darkTheme) {
          return GlobalLoaderOverlay(
            useDefaultLoading: false,
            overlayWidgetBuilder: (_) {
              //ignored progress for the moment
              return Center(
                child: SpinKitCubeGrid(
                  color: appColor,
                  size: 50.0,
                ),
              );
            },
            child: MaterialApp.router(
              routerConfig: router,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              debugShowCheckedModeBanner: false,
              title: 'Emall | Online Shopping',
              theme: theme,
              darkTheme: darkTheme,
            ),
          );
        });
  }

  final GoRouter router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation:
          initScreen == 0 || initScreen == null ? '/onboarding' : '/',
      routes: [
        GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) =>
              const LoginPage(),
          // redirect: (context, state) {
          //   if (isLogged == false) {
          //     return '/login';
          //   } else {
          //     return '/';
          //   }
          // }
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (BuildContext context, GoRouterState state) =>
              const ForgotPasswordPage(),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (BuildContext context, GoRouterState state) =>
              const OnBoardingPage(),
        ),
        GoRoute(
            path: '/track-order',
            builder: (BuildContext context, GoRouterState state) =>
                const TrackOrderPage(),
            redirect: (context, state) {
              if (isLogged == false) {
                return '/login';
              } else {
                return '/track-order';
              }
            }),
        GoRoute(
          path: '/tracking-detail/:orderID',
          builder: (BuildContext context, GoRouterState state) =>
              TrackOrderDetailPage(orderID: state.pathParameters['orderID']!),
          // redirect: (context, state) {
          //   if (isLogged == false) {
          //     return '/login';
          //   } else {
          //     return '/tracking-detail/:orderID';
          //   }
          // }
        ),
        GoRoute(
          path: '/signup',
          builder: (BuildContext context, GoRouterState state) =>
              const SignupPage(),
          // redirect: (context, state) {
          //   if (isLogged == false) {
          //     return '/signup';
          //   } else {
          //     return '/';
          //   }
          // }
        ),
        GoRoute(
            path: '/checkout',
            builder: (BuildContext context, GoRouterState state) =>
                const CheckoutPage(),
            redirect: (context, state) {
              if (isLogged == false) {
                return '/login';
              } else {
                return '/checkout';
              }
            }),
        GoRoute(
          path: '/terms',
          builder: (BuildContext context, GoRouterState state) =>
              const TermsPage(),
        ),
        GoRoute(
          path: '/policy',
          builder: (BuildContext context, GoRouterState state) =>
              const PolicyPage(),
        ),
        GoRoute(
            path: '/wallet',
            builder: (BuildContext context, GoRouterState state) =>
                const WalletPage(),
            redirect: (context, state) {
              if (isLogged == false) {
                return '/login';
              } else {
                return '/wallet';
              }
            }),
        GoRoute(
            path: '/profile',
            builder: (BuildContext context, GoRouterState state) =>
                const ProfilePage(),
            redirect: (context, state) {
              if (isLogged == false) {
                return '/login';
              } else {
                return '/profile';
              }
            }),
        GoRoute(
            path: '/favorites',
            builder: (BuildContext context, GoRouterState state) =>
                const FavoritesPage(),
            redirect: (context, state) {
              if (isLogged == false) {
                return '/login';
              } else {
                return '/favorites';
              }
            }),

        GoRoute(
            path: '/voucher',
            builder: (BuildContext context, GoRouterState state) =>
                const VoucherPage(),
            redirect: (context, state) {
              if (isLogged == false) {
                return '/login';
              } else {
                return '/voucher';
              }
            }),
        GoRoute(
            path: '/delivery-addresses',
            builder: (BuildContext context, GoRouterState state) =>
                const DeliveryAddressPage(),
            redirect: (context, state) {
              if (isLogged == false) {
                return '/login';
              } else {
                return '/delivery-addresses';
              }
            }),
        GoRoute(
            path: '/inbox',
            builder: (BuildContext context, GoRouterState state) =>
                const InboxPage(),
            redirect: (context, state) {
              if (isLogged == false) {
                return '/login';
              } else {
                return '/inbox';
              }
            }),
        GoRoute(
          path: '/about',
          builder: (BuildContext context, GoRouterState state) =>
              const AboutPage(),
        ),
        GoRoute(
          path: '/order-detail/:id',
          builder: (BuildContext context, GoRouterState state) =>
              OderDetailPage(
            uid: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
            path: '/',
            builder: (BuildContext context, GoRouterState state) {
              // Add MetaSEO just into Web platform condition
              if (kIsWeb) {
                // Define MetaSEO object
                MetaSEO meta = MetaSEO();
                // add meta seo data for web app as you want
                meta.ogTitle(ogTitle: 'Home page');
                meta.description(description: 'Home page');
                meta.keywords(keywords: 'Flutter, Dart, SEO, Meta, Web, Emall');
              }
              return ScaffoldWidget(
                path: state.path!,
                body: const BottomNavPage(),
              );
            }),
        GoRoute(
            path: '/orders',
            builder: (BuildContext context, GoRouterState state) =>
                const OrdersPage(),
            redirect: (context, state) {
              if (isLogged == false) {
                return '/login';
              } else {
                return '/orders';
              }
            }),
        GoRoute(
          path: '/brand/:category',
          builder: (BuildContext context, GoRouterState state) =>
              ScaffoldWidget(
            path: state.path!,
            body: BrandPage(
              category: state.pathParameters['category']!,
            ),
          ),
        ),
        GoRoute(
          path: '/product-detail/:id',
          builder: (BuildContext context, GoRouterState state) =>
              ScaffoldWidget(
            path: state.path!,
            body: ProductDetailPage(
              productUID: state.pathParameters['id']!,
            ),
          ),
        ),
        GoRoute(
          path: '/search/:id',
          builder: (BuildContext context, GoRouterState state) => SearchPage(
            productString: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: '/flash-sales',
          builder: (BuildContext context, GoRouterState state) =>
              ScaffoldWidget(path: state.path!, body: const FlashSalesPage()),
        ),
        GoRoute(
          path: '/hot-deals',
          builder: (BuildContext context, GoRouterState state) =>
              ScaffoldWidget(path: state.path!, body: const HotSalesPage()),
        ),
        GoRoute(
          path: '/products/:category',
          builder: (BuildContext context, GoRouterState state) =>
              ScaffoldWidget(
            path: state.path!,
            body: ProductByCategoryPage(
              category: state.pathParameters['category']!,
            ),
          ),
        ),
        GoRoute(
          path: '/collection/:collection',
          builder: (BuildContext context, GoRouterState state) =>
              ScaffoldWidget(
            path: state.path!,
            body: ProductByCollectionPage(
              category: state.pathParameters['collection']!,
            ),
          ),
        ),
        // ShellRoute(
        //   navigatorKey: _shellNavigatorKey,
        //   builder: (_, GoRouterState state, child) {
        //     return ScaffoldWidget(
        //       body: child,
        //       path: state.fullPath.toString(),
        //     );
        //   },
        //   routes: [

        //   ],
        // ),
      ]);
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../Providers/auth.dart';


class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
}

abstract class MenuItems {
  bool isLoggedMenu = false;
  static const List<MenuItem> firstItems = [
    profile,
    wallet,
    order,
    address,
    favorite,
    trackOrder
  ];
  static const List<MenuItem> secondItems = [
    // login,
    signup,
    logout,
  ];
  static const List<MenuItem> secondItems2 = [
    login,
    signup,
    // logout,
  ];
  static const profile = MenuItem(text: 'Profile', icon: Icons.person);
  static const wallet = MenuItem(text: 'Wallet', icon: Icons.wallet);
  static const order = MenuItem(text: 'Order', icon: Icons.list);
  static const address = MenuItem(text: 'Saved Address', icon: Icons.room);
  static const favorite = MenuItem(text: 'Favorite', icon: Icons.favorite);
  static const trackOrder = MenuItem(text: 'Track Order', icon: Icons.room);
  static const login = MenuItem(text: 'Login', icon: Icons.login);
  static const signup = MenuItem(text: 'Signup', icon: Icons.how_to_reg);
  static const logout = MenuItem(text: 'Log Out', icon: Icons.logout);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.black, size: 18),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text.tr(),
            style: const TextStyle(color: Colors.black, fontSize: 12),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.profile:
        //Do something
        context.push('/profile');
        break;
      case MenuItems.order:
        //Do something
        context.push('/orders');
        break;
      case MenuItems.wallet:
        //Do something
        context.push('/wallet');
        break;
      case MenuItems.address:
        //Do something
        context.push('/delivery-addresses');
        break;
      case MenuItems.logout:
        //Do something
        AuthService().signOut(context);
        break;
      case MenuItems.login:
        context.push('/login');
        break;

      case MenuItems.signup:
        context.push('/signup');
        break;
      case MenuItems.favorite:
        context.push('/favorites');
        break;
      case MenuItems.trackOrder:
        context.push('/track-order');
        break;
    }
  }
}

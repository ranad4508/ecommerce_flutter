import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rider_app/Model/categories.dart';
import 'package:rider_app/Model/constant.dart';
import 'package:rider_app/Pages/withdrawal_history_page.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

import '../Providers/auth.dart';

class MobileMenuWidget extends StatefulWidget {
  final bool isLogged;
  final List<CategoriesModel> cats;
  const MobileMenuWidget(
      {super.key, required this.isLogged, required this.cats});

  @override
  State<MobileMenuWidget> createState() => _MobileMenuWidgetState();
}

class _MobileMenuWidgetState extends State<MobileMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
        const Gap(10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Image.asset(
              color: AdaptiveTheme.of(context).mode.isDark == true
                  ? Colors.white
                  : null,
              'assets/image/new logo.png',
              scale: 18,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right:20),
            child: IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: Icon(
                  Icons.close,
                  size: 30,
                  color: appColor,
                )),
          )
        ],
      ),
      const Divider(color: Colors.grey),
      ListTile(
        onTap: () {
          if (widget.isLogged == true) {
            context.push('/profile');
            context.pop();
          } else {
            context.push('/login');
          }
        },
        title: const Text('Profile').tr(),
        leading: const Icon(Icons.person),
        trailing: const Icon(Icons.chevron_right),
      ),
      ListTile(
        onTap: () {
          if (widget.isLogged == true) {
            context.push('/wallet');
            context.pop();
          } else {
            context.push('/login');
          }
        },
        title: const Text('Wallet').tr(),
        leading: const Icon(Icons.wallet),
        trailing: const Icon(Icons.chevron_right),
      ),
      ListTile(
        onTap: () {
          if (widget.isLogged == true) {
            context.push('/bank');
            context.pop();
          } else {
            context.push('/login');
          }
        },
        title: const Text('Bank').tr(),
        leading: const Icon(Icons.account_balance),
        trailing: const Icon(Icons.chevron_right),
      ),
      ListTile(
        onTap: () {
          if (widget.isLogged == true) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const WithdrawalHistoryPage();
            }));
            // context.pop();
          } else {
            context.push('/login');
          }
        },
        title: const Text('Withdrawal History').tr(),
        leading: const Icon(Icons.account_balance),
        trailing: const Icon(Icons.chevron_right),
      ),

      ListTile(
        onTap: () {
          if (widget.isLogged == true) {
            context.push('/inbox');
            context.pop();
          } else {
            context.push('/login');
          }
        },
        title: const Text('Inbox').tr(),
        leading: const Icon(Icons.notifications),
        trailing: const Icon(Icons.chevron_right),
      ),
      // ListTile(
      //   onTap: () {
      //     if (widget.isLogged == true) {
      //       context.push('/track-order');
      //       context.pop();
      //     } else {
      //       context.push('/login');
      //     }
      //   },
      //   title: const Text('Track Order').tr(),
      //   leading: const Icon(Icons.room),
      //   trailing: const Icon(Icons.chevron_right),
      // ),
      const Divider(
        color: Colors.grey,
        thickness: 2,
      ),
      const Gap(10),
      SwitchListTile(
        title: const Text('Theme'),
        value: AdaptiveTheme.of(context).mode.isDark,
        onChanged: (value) {
          if (value) {
            AdaptiveTheme.of(context).setDark();
          } else {
            AdaptiveTheme.of(context).setLight();
          }
        },
      ),
      ListTile(
        onTap: () {
          context.push('/about');
          context.pop();
        },
        title: const Text('About Us').tr(),
        leading: const Icon(Icons.edit),
        // trailing: const Icon(Icons.chevron_right),
      ),
      ListTile(
        onTap: () {
          context.push('/terms');
          context.pop();
        },
        title: const Text('Terms Of Services').tr(),
        leading: const Icon(Icons.library_add_check),
        // trailing: const Icon(Icons.chevron_right),
      ),
      ListTile(
        onTap: () {
          context.push('/policy');
          context.pop();
        },
        title: const Text('Privacy Policy').tr(),
        leading: const Icon(Icons.privacy_tip),
        // trailing: const Icon(Icons.chevron_right),
      ),
      widget.isLogged == true
          ? ListTile(
              onTap: () {
                AuthService().signOut(context);
                context.pop();
              },
              title: const Text('Logout').tr(),
              leading: const Icon(Icons.logout),
              // trailing: const Icon(Icons.chevron_right),
            )
          : ListTile(
              onTap: () {
                context.push('/login');
              },
              title: const Text('Login').tr(),
              leading: const Icon(Icons.login),
              // trailing: const Icon(Icons.chevron_right),
            ),
    ]);
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rider_app/Providers/auth.dart';

class WebMenu extends StatefulWidget {
  final String path;
  const WebMenu({super.key, required this.path});

  @override
  State<WebMenu> createState() => _WebMenuState();
}

class _WebMenuState extends State<WebMenu> {
  @override
  void initState() {
    // getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        title: const Text('Profile').tr(),
        tileColor: widget.path == '/profile' ? Colors.grey : null,
        leading: const Icon(Icons.person),
        onTap: () {
          context.push('/profile');
        },
      ),
      ListTile(
        title: const Text('Wallet').tr(),
        tileColor: widget.path == '/wallet' ? Colors.grey : null,
        leading: const Icon(Icons.wallet),
        onTap: () {
          context.push('/wallet');
        },
      ),
      ListTile(
        title: const Text('Favorites').tr(),
        tileColor: widget.path == '/favorites' ? Colors.grey : null,
        leading: const Icon(Icons.favorite),
        onTap: () {
          context.push('/favorites');
        },
      ),
      ListTile(
        title: const Text('Orders').tr(),
        tileColor: widget.path == '/orders' ? Colors.grey : null,
        leading: const Icon(Icons.list),
        onTap: () {
          context.push('/orders');
        },
      ),
      // ListTile(
      //   title: const Text('Inbox').tr(),
      //   tileColor: widget.path == '/inbox' ? Colors.grey : null,
      //   leading: const Icon(Icons.notifications),
      //   onTap: () {
      //     context.push('/inbox');
      //   },
      // ),
      ListTile(
        title: const Text('Voucher').tr(),
        tileColor: widget.path == '/voucher' ? Colors.grey : null,
        leading: const Icon(Icons.card_giftcard),
        onTap: () {
          context.push('/voucher');
        },
      ),
      ListTile(
        title: const Text('Inbox').tr(),
        tileColor: widget.path == '/inbox' ? Colors.grey : null,
        leading: const Icon(Icons.notifications),
        onTap: () {
          context.push('/inbox');
        },
      ),
      ListTile(
        title: const Text('Address Book').tr(),
        tileColor: widget.path == '/delivery-addresses' ? Colors.grey : null,
        leading: const Icon(Icons.room),
        onTap: () {
          context.push('/delivery-addresses');
        },
      ),
      TextButton(
          onPressed: () {
            AuthService().signOut(context);
          },
          child: const Text(
            'LOG OUT',
            style: TextStyle(color: Colors.orange),
          ).tr()),
      const Gap(20)
    ]);
  }
}

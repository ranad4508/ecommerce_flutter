import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
// import 'package:user_web_app/Widgets/footer_widget.dart';
import 'package:user_app/Widgets/web_menu.dart';

import '../Widgets/wallet_widget.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: const Text(
          'Wallet',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ).tr(),
      ),
      backgroundColor: AdaptiveTheme.of(context).mode.isDark == true
          ? null
          : const Color.fromARGB(255, 247, 240, 240),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (MediaQuery.of(context).size.width >= 1100)
              Padding(
                padding: MediaQuery.of(context).size.width >= 1100
                    ? const EdgeInsets.only(left: 60, right: 50)
                    : const EdgeInsets.all(0),
                child: Column(
                  children: [
                    const Gap(20),
                    if (MediaQuery.of(context).size.width >= 1100)
                      Align(
                        alignment: MediaQuery.of(context).size.width >= 1100
                            ? Alignment.centerLeft
                            : Alignment.center,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                context.push('/');
                              },
                              child: const Text(
                                'Home',
                                style: TextStyle(fontSize: 10),
                              ).tr(),
                            ),
                            const Text(
                              '/ My Wallet',
                              style: TextStyle(fontSize: 10),
                            ).tr(),
                          ],
                        ),
                      ),
                    Align(
                      alignment: MediaQuery.of(context).size.width >= 1100
                          ? Alignment.centerLeft
                          : Alignment.center,
                      child: const Text(
                        'Wallet',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ).tr(),
                    ),
                    const Gap(20),
                  ],
                ),
              ),
            if (MediaQuery.of(context).size.width >= 1100)
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Card(
                          shape: const BeveledRectangleBorder(),
                          color: AdaptiveTheme.of(context).mode.isDark == true
                              ? Colors.black87
                              : Colors.white,
                          surfaceTintColor: Colors.white,
                          child: const WebMenu(path: '/wallet')),
                    ),
                    const Gap(50),
                    Expanded(
                        flex: 6,
                        child: Card(
                            shape: const BeveledRectangleBorder(),
                            color: AdaptiveTheme.of(context).mode.isDark == true
                                ? Colors.black87
                                : Colors.white,
                            surfaceTintColor: Colors.white,
                            child: const WalletWidget()))
                  ],
                ),
              ),
            if (MediaQuery.of(context).size.width <= 1100) const WalletWidget(),
            const Gap(20),
            // const FooterWidget()
          ],
        ),
      ),
    );
  }
}

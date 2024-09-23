import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
//import 'package:rider_app/Widgets/footer_widget.dart';
import 'package:rider_app/Widgets/web_menu.dart';

import '../Widgets/inbox_widget.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
        'Notifications',
        style: TextStyle(fontWeight: FontWeight.bold),
      ).tr()),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: MediaQuery.of(context).size.width >= 1100
                  ? const EdgeInsets.only(left: 100, right: 100)
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
                            '/ Inbox',
                            style: TextStyle(fontSize: 10),
                          ).tr(),
                        ],
                      ),
                    ),
                  // Align(
                  //   alignment: MediaQuery.of(context).size.width >= 1100
                  //       ? Alignment.centerLeft
                  //       : Alignment.center,
                  //   child: const Text(
                  //     'Notifications',
                  //     style:
                  //         TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  //   ).tr(),
                  // ),
                  // const Gap(20),
                ],
              ),
            ),
            MediaQuery.of(context).size.width >= 1100
                ? const Padding(
                    padding: EdgeInsets.only(left: 100, right: 100),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Card(
                              shape: BeveledRectangleBorder(),
                              color: Colors.white,
                              surfaceTintColor: Colors.white,
                              child: WebMenu(path: '/inbox')),
                        ),
                        Gap(20),
                        Expanded(
                            flex: 6,
                            child: Card(
                              shape: BeveledRectangleBorder(),
                              color: Colors.white,
                              surfaceTintColor: Colors.white,
                              child: SingleChildScrollView(
                                child: InboxWidget(),
                              ),
                            ))
                      ],
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: InboxWidget(),
                  ),
            const Gap(20),
            //const FooterWidget()
          ],
        ),
      ),
    );
  }
}

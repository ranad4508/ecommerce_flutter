import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
//import 'package:rider_app/Widgets/footer_widget.dart';
import 'package:rider_app/Widgets/order_detail_widget.dart';
import 'package:rider_app/Widgets/web_menu.dart';

class OderDetailPage extends StatefulWidget {
  final String uid;
  const OderDetailPage({super.key, required this.uid});

  @override
  State<OderDetailPage> createState() => _OderDetailPageState();
}

class _OderDetailPageState extends State<OderDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ).tr(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: MediaQuery.of(context).size.width >= 1100
                  ? const EdgeInsets.only(left: 100, right: 100)
                  : const EdgeInsets.all(0),
              child: Column(
                children: [
                  if (MediaQuery.of(context).size.width >= 1100) const Gap(20),
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
                            '/ My Orders',
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
                  //     'Orders',
                  //     style:
                  //         TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  //   ).tr(),
                  // ),
                 // const Gap(20),
                ],
              ),
            ),
            MediaQuery.of(context).size.width >= 1100
                ? Padding(
                    padding: const EdgeInsets.only(left: 100, right: 100),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          flex: 2,
                          child: Card(
                              shape: BeveledRectangleBorder(),
                              color: Colors.white,
                              surfaceTintColor: Colors.white,
                              child: WebMenu(path: '/orders')),
                        ),
                        const Gap(20),
                        Expanded(
                            flex: 6,
                            child: Card(
                              shape: const BeveledRectangleBorder(),
                              color: Colors.white,
                              surfaceTintColor: Colors.white,
                              child: SingleChildScrollView(
                                child: OrderDetailWidget(
                                  uid: widget.uid,
                                ),
                              ),
                            ))
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OrderDetailWidget(
                      uid: widget.uid,
                    ),
                  ),
          //  const Gap(20),
            //const FooterWidget()
          ],
        ),
      ),
    );
  }
}

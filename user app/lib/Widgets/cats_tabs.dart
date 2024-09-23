// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/Widgets/cat_collection_tab.dart';

import 'view_all_cat_tabs.dart';

class CatsTabs extends StatefulWidget {
  final List<String> data;
  const CatsTabs({super.key, required this.data});

  @override
  State<CatsTabs> createState() => _CatsTabsState();
}

class _CatsTabsState extends State<CatsTabs> with TickerProviderStateMixin {
  TabController? controller;
  int indexTab = 0;
  @override
  void initState() {
    controller = TabController(length: widget.data.length, vsync: this);
    controller!.addListener(() {
      setState(() {
        indexTab = controller!.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        //   labelPadding: const EdgeInsets.all(50),
        padding: const EdgeInsets.only(left: 70, right: 200),
        // splashFactory: NoSplash.splashFactory,
        controller: controller,
        isScrollable: true,
        tabs: List.generate(widget.data.length, (int index) {
          return Tab(
              child: index == 0
                  ? InkWell(
                      onTap: () {
                        context.push('/');
                      },
                      child: const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Icon(
                              Icons.home,
                              color: Colors.black,
                            ),
                          ),
                          Gap(5),
                          Text(
                            'Home',
                            style: TextStyle(fontSize: 11, color: Colors.black),
                          )
                        ],
                      ),
                    )
                  : index == 1
                      ? const ViewAllCatsTab()
                      : DropDownWidget(
                          cat: widget.data[index],
                        )
              //style: const TextStyle(fontSize: 10),
              );
        }),
        unselectedLabelColor: Colors.black,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: Colors.transparent);
  }
}

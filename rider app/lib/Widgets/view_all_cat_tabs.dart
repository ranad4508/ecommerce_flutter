import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ViewAllCatsTab extends StatefulWidget {
  const ViewAllCatsTab({
    super.key,
  });

  @override
  State<ViewAllCatsTab> createState() => _ViewAllCatsTabState();
}

class _ViewAllCatsTabState extends State<ViewAllCatsTab> {
  String? selectedValue;
  bool loaded = false;
  List<String> categories = [];

  getCategoriesTabs() {
    setState(() {
      loaded = false;
    });
    List<String> dataMain = [];
    FirebaseFirestore.instance
        .collection('Categories')
        .snapshots()
        .listen((event) {
      for (var element in event.docs) {
        setState(() {
          loaded = true;
        });
        dataMain.add(element['category']);
        setState(() {
          categories = dataMain;
        });
      }
    });
  }

  @override
  void initState() {
    getCategoriesTabs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        dropdownStyleData: const DropdownStyleData(
          width: 150,
        ),
        isExpanded: true,
        customButton: const Row(children: [
          Text(
            'View All Categories',
            style: TextStyle(fontSize: 11),
          ),
          Gap(5),
          Icon(
            Icons.arrow_drop_down_outlined,
            //  color: Color.fromRGBO(48, 30, 2, 1),
          )
        ]),
        items: categories
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (value) {
          setState(() {
            context.push('/products/$value');
           // context.pop();
          });
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class DropDownWidget extends StatefulWidget {
  final String cat;
  const DropDownWidget({super.key, required this.cat});

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  String? selectedValue;
  bool loaded = false;
  List<String> categories = [];

  getCategoriesTabs() {
    setState(() {
      loaded = false;
    });
    List<String> dataMain = [];
    FirebaseFirestore.instance
        .collection('Collections')
        .where('category', isEqualTo: widget.cat)
        .snapshots()
        .listen((event) {
      for (var element in event.docs) {
        setState(() {
          loaded = true;
        });
        dataMain.add(element['collection']);
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
        dropdownStyleData: const DropdownStyleData(width: 150),
        isExpanded: true,
        customButton: Row(children: [
          Text(
            widget.cat,
            style: const TextStyle(fontSize: 11),
          ),
          const Gap(5),
          const Icon(
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
            context.push('/collection/$value');
          });
        },
      ),
    );
  }
}

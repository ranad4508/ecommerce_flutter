import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/Model/products_model.dart';

import '../Model/constant.dart';

class SearchWidget extends StatefulWidget {
  final bool autoFocus;
  const SearchWidget({super.key, required this.autoFocus});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _controller = TextEditingController();
  final _suggestionBoxController = SuggestionsController<ProductsModel>();
  bool isTypeOpened = false;

  @override
  void initState() {
    _suggestionBoxController.addListener(() {
      if (_suggestionBoxController.isOpen == true) {
        isTypeOpened = true;
        // ignore: avoid_print
        print('type is open $isTypeOpened');
      } else {
        isTypeOpened = false;
      }
    });
    getProducts();
    super.initState();
  }

  List<ProductsModel> products = [];
  // List<ProductsModel> productsFilter = [];
  bool isLoaded = false;

  getProducts() async {
    setState(() {
      isLoaded = true;
    });
    FirebaseFirestore.instance
        .collection('Products')
        .snapshots()
        .listen((event) {
      setState(() {
        isLoaded = false;
      });
      products.clear();
      for (var element in event.docs) {
        var prods = ProductsModel.fromMap(element, element.id);
        setState(() {
          products.add(prods);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String search = "Search For Products On".tr();
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: TypeAheadField<ProductsModel>(
            controller: _controller,
            suggestionsController: _suggestionBoxController,
            // textFieldConfiguration: TextFieldConfiguration(
            //   autofocus: true,
            //   controller: _controller,
            //   decoration: const InputDecoration(
            //     hintText: 'Search country...',
            //   ),
            // ),
            // emptyBuilder: (context) {
            //   if (_controller.text.isEmpty) {
            //     return const Text('');
            //   } else {
            //     return const Text('No result found');
            //   }
            // },
            builder: (context, controller, focusNode) => TextField(
              controller: controller,
              focusNode: focusNode,
              //   autofocus: widget.autoFocus,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: '$search Olivette Store',
                  hintStyle: const TextStyle(fontSize: 13),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                      onPressed: () {
                        // ignore: avoid_print
                        print('suffix is $isTypeOpened');
                        _suggestionBoxController.close();
                        //  _suggestionBoxController.dispose();
                        _controller.clear();
                      },
                      icon: const Icon(Icons.close))),
            ),
            suggestionsCallback: (pattern) {
              if (pattern.isNotEmpty) {
                return products
                    .where((country) => country.name
                        .toLowerCase()
                        .contains(pattern.toLowerCase()))
                    .toList();
              } else {
                return [];
              }
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion.name),
              );
            },
            onSelected: (ProductsModel value) {
              _controller.text = value.name;
              context.push('/product-detail/${value.uid}');
            },
          ),
        ),
        if (MediaQuery.of(context).size.width >= 1100) const Gap(10),
        if (MediaQuery.of(context).size.width >= 1100)
          Expanded(
              flex: 2,
              child: SizedBox(
                height: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape:const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      backgroundColor: appColor,
                    ),
                    onPressed: () {
                      if (_controller.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Use the search field to continue".tr(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 2,
                            fontSize: 14.0);
                      } else if (_controller.text.length <= 4) {
                        Fluttertoast.showToast(
                            msg: "Enter more details to continue".tr(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 2,
                            fontSize: 14.0);
                      } else {
                        context.push('/search/${_controller.text}');
                      }
                    },
                    child: const Text(
                      'Search',
                      style: TextStyle(color: Colors.white),
                    ).tr()),
              ))
      ],
    );
  }
}

import 'dart:typed_data';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../Models/collection_model.dart';

class AddCollection extends StatefulWidget {
  const AddCollection({super.key});

  @override
  State<AddCollection> createState() => _AddCollectionState();
}

class _AddCollectionState extends State<AddCollection> {
  String category = '';
  String firestoreImage = '';
  dynamic image;
  String collection = '';

  Future<void> addCategory(CollectionModel categoriesModel) async {
    FirebaseFirestore.instance
        .collection('Collections')
        .add(categoriesModel.toMap())
        .then((value) => Flushbar(
              flushbarPosition: FlushbarPosition.TOP,
              title: "Notification",
              message: "Category has been added successfully!!!",
              duration: const Duration(seconds: 3),
            )..show(context));
  }

  getImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png','gif'],
    );

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      //String fileName = result.files.first.name;
      setState(() {
        image = fileBytes;
      });
      // Upload file
      TaskSnapshot upload = await FirebaseStorage.instance
          .ref('uploads/${DateTime.now()}')
          .putData(fileBytes!);
      String url = await upload.ref.getDownloadURL();
      //print(url);
      setState(() {
        firestoreImage = url;
      });
    }
  }

  List<String> categories = [];

  getCategoriesTabs() {
    List<String> dataMain = [];
    FirebaseFirestore.instance.collection('Categories').get().then((event) {
      categories.clear();
      for (var element in event.docs) {
        dataMain.add(element['category']);
        setState(() {
          categories = dataMain;
        });
      }
      // ignore: avoid_print
      print(categories);
    });
  }

  @override
  void initState() {
    getCategoriesTabs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Add a new collection').tr(),
          InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.clear))
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width / 1.5,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    collection = value;
                  });
                },
                decoration: InputDecoration(labelText: "Collection name".tr()),
              ),
              const SizedBox(height: 40),
              DropdownSearch<String>(
                popupProps: const PopupProps.menu(
                  showSelectedItems: true,
                ),
                items: categories,
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Category name",
                  ),
                ),
                onChanged: (v) {
                  setState(() {
                    category = v!;
                  });
                },
                selectedItem: category,
              ),
              const SizedBox(height: 40),
              image == null
                  ? const Icon(Icons.image, size: 300, color: Colors.grey)
                  : Image.memory(
                      image,
                      height: 300,
                      width: 300,
                      fit: BoxFit.fill,
                    ),
              const SizedBox(height: 20),
              IconButton(
                onPressed: () {
                  getImage();
                },
                icon: const Icon(Icons.add_a_photo),
                iconSize: 50,
                color: Colors.blue.shade800,
              ),
              const SizedBox(height: 20),
              firestoreImage == ''
                  ? SizedBox(
                      height: 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade800),
                          onPressed: null,
                          child: const Text('Add a new collection').tr()))
                  : SizedBox(
                      height: 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade800),
                          onPressed: () {
                            if (category != '' && collection != '') {
                              addCategory(CollectionModel(
                                      category: category,
                                      image: firestoreImage,
                                      collection: collection))
                                  .then((value) => Navigator.of(context).pop());
                            } else {
                              Flushbar(
                                flushbarPosition: FlushbarPosition.TOP,
                                title: "Notification",
                                message: "Some fields are empty.",
                                duration: const Duration(seconds: 3),
                              ).show(context);
                            }
                          },
                          child: const Text(
                            'Add a new collection',
                            style: TextStyle(color: Colors.white),
                          ).tr()))
            ],
          ),
        ),
      ),
    );
  }
}

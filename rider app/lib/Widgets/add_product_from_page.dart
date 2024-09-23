// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../Model/products_model.dart';

class AddProductsFromPage extends StatefulWidget {
  const AddProductsFromPage({
    super.key,
  });

  @override
  State<AddProductsFromPage> createState() => _AddProductsFromPageState();
}

class _AddProductsFromPageState extends State<AddProductsFromPage> {
  String uid = '';
  String description = '';
  String name = '';
  String category = '';
  String subCategory = '';
  String subSubCategory = '';
  String image1 = '';
  String image2 = '';
  String image3 = '';
  String unitname1 = '';
  String unitname2 = '';
  String unitname3 = '';
  String unitname4 = '';
  String unitname5 = '';
  String unitname6 = '';
  String unitname7 = '';
  num unitPrice1 = 0;
  num unitPrice2 = 0;
  num unitPrice3 = 0;
  num unitPrice4 = 0;
  num unitPrice5 = 0;
  num unitPrice6 = 0;
  num unitPrice7 = 0;
  num unitOldPrice1 = 0;
  num unitOldPrice2 = 0;
  num unitOldPrice3 = 0;
  num unitOldPrice4 = 0;
  num unitOldPrice5 = 0;
  num unitOldPrice6 = 0;
  num unitOldPrice7 = 0;
  num percantageDiscount = 0;
  String productId = '';
  String vendorId = '';
  String vendorName = '';
  String brandName = '';
  bool selected = true;
  XFile? _image1;
  XFile? _image2;
  XFile? _image3;
  bool? loading;
  int quantity = 0;
  final _formKey = GlobalKey<FormState>();
  String id = '';
  String marketCategory = '';
  int returnDuration = 0;

  Future<void> _uploadImage1() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    //print(image);
    setState(() {
      _image1 = image;
      loading = true;
    });
    if (_image1 != null) {
      var snapshot = await FirebaseStorage.instance
          .ref()
          .child(_image1!.path)
          .putFile(File(_image1!.path));
      String downloadUrl =
          await snapshot.ref.getDownloadURL().whenComplete(() => setState(() {
                loading = false;
              }));

      setState(() {
        image1 = downloadUrl;
      });
      //print(image1);
    }
  }

  Future<void> _uploadImage2() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    //print(image);
    setState(() {
      _image2 = image;
      loading = true;
    });
    if (_image2 != null) {
      var snapshot = await FirebaseStorage.instance
          .ref()
          .child(_image2!.path)
          .putFile(File(_image2!.path));
      String downloadUrl =
          await snapshot.ref.getDownloadURL().whenComplete(() => setState(() {
                loading = false;
              }));

      setState(() {
        image2 = downloadUrl;
      });
      //print(image2);
    }
  }

  Future<void> _uploadImage3() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    //print(image);
    setState(() {
      _image3 = image;
      loading = true;
    });
    if (_image3 != null) {
      var snapshot = await FirebaseStorage.instance
          .ref()
          .child(_image3!.path)
          .putFile(File(_image3!.path));
      String downloadUrl =
          await snapshot.ref.getDownloadURL().whenComplete(() => setState(() {
                loading = false;
              }));

      setState(() {
        image3 = downloadUrl;
      });
      //print(image3);
    }
  }

  List<String> categories = [];
  getCategories() {
    List<String> cat = [];
    FirebaseFirestore.instance.collection('Categories').get().then((value) {
      print('Length is ${value.docs.length}');
      categories.clear();
      return value.docs.forEach((element) {
        cat.add(element.data()['category']);
        setState(() {
          categories = cat;
        });
      });
    });
  }

  List<String> collections = [];
  String collection = '';
  getCollections(String category) {
    List<String> cat = [];
    FirebaseFirestore.instance
        .collection('Collections')
        .where('category', isEqualTo: category)
        .get()
        .then((value) {
      print('Length is ${value.docs.length}');
      collections.clear();
      return value.docs.forEach((element) {
        cat.add(element.data()['collection']);
        setState(() {
          collections = cat;
        });
      });
    });
  }

  List<String> brands = [];
  String brand = '';
  getBrands() {
    List<String> cat = [];
    FirebaseFirestore.instance
        .collection('Brands')
        // .where('category', isEqualTo: category)
        .get()
        .then((value) {
      print('Length is ${value.docs.length}');
      brands.clear();
      return value.docs.forEach((element) {
        cat.add(element.data()['collection']);
        setState(() {
          brands = cat;
        });
      });
    });
  }

  List<String> subCollections = [];
  String subCollection = '';
  getSubCollections(String category, String collection) {
    List<String> cat = [];
    FirebaseFirestore.instance
        .collection('Sub Collections')
        .where('category', isEqualTo: category)
        .where('collection', isEqualTo: collection)
        .get()
        .then((value) {
      print('Length is ${value.docs.length}');
      subCollections.clear();
      return value.docs.forEach((element) {
        cat.add(element.data()['subCollection']);
        setState(() {
          subCollections = cat;
        });
      });
    });
  }

  bool uploading = false;

  addProduct(ProductsModel products, String id) {
    setState(() {
      uploading = true;
    });
    FirebaseFirestore.instance
        .collection('Products')
        .doc(id)
        .set(products.toMap())
        .then((value) {
      setState(() {
        uploading = false;
      });
      Fluttertoast.showToast(
          msg: "Product Added Successfully...".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Theme.of(context).primaryColor,
          textColor: Colors.white,
          fontSize: 14.0);
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    var uuid = const Uuid();
    id = uuid.v1();
    getCategories();
    getBrands();
    print(id);
    getUserDetails();
    super.initState();
  }

  getUserDetails() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('riders')
        .doc(user!.uid)
        .snapshots()
        .listen((event) {
      setState(() {
        vendorId = event['id'];
        vendorName = event['fullname'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: MediaQuery.of(context).size.width >= 1100
            ? const EdgeInsets.only(left: 100, right: 100)
            : const EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(children: [
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.clear))
              ]),
              const SizedBox(height: 20),
              const Text('Add a new Product',
                      style: TextStyle(fontWeight: FontWeight.bold))
                  .tr(),

              const SizedBox(height: 20),
              Row(children: [
                const Text('Product Name:').tr(),
              ]),
              const SizedBox(height: 10),

              TextFormField(
                onSaved: (value) {
                  setState(() {
                    name = value!;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Required field'.tr();
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Product name'.tr(),
                  focusColor: Colors.grey,
                  filled: true,
                  fillColor: Colors.white10,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Row(children: [
                const Text('Product Description:').tr(),
              ]),
              const SizedBox(height: 10),
              TextFormField(
                maxLines: 5,
                onSaved: (value) {
                  setState(() {
                    description = value!;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    description = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Required field'.tr();
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Product Description'.tr(),
                  focusColor: Colors.grey,
                  filled: true,
                  fillColor: Colors.white10,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(children: [
                const Text('Return Duration In Days:').tr(),
              ]),
              const SizedBox(height: 10),
              TextFormField(
                // maxLines: 5,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,

                onSaved: (value) {
                  setState(() {
                    returnDuration = int.parse(value!);
                  });
                },
                onChanged: (value) {
                  setState(() {
                    returnDuration = int.parse(value);
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Required field'.tr();
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Return Duration'.tr(),
                  focusColor: Colors.grey,
                  filled: true,
                  fillColor: Colors.white10,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(children: [
                const Text('Product Category:').tr(),
              ]),
              const SizedBox(height: 10),
              SizedBox(
                height: 45,
                child: DropdownSearch<String>(
                  popupProps: const PopupProps.menu(
                    showSelectedItems: true,
                  ),
                  items: categories,
                  // validator: (v) => v == null ? "Required field".tr() : null,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                    hintText: 'Select A Product Category'.tr(),
                  )),
                  onChanged: (value) {
                    setState(() {
                      category = value!;
                      collection = '';
                      brand = '';
                      subCollection = '';
                    });
                    getCollections(category);

                    subCollections.clear();
                  },
                ),
              ),

              const SizedBox(height: 20),
              Row(children: [
                const Text('Product Collection:').tr(),
              ]),
              const SizedBox(height: 10),
              SizedBox(
                height: 45,
                child: DropdownSearch<String>(
                  selectedItem: collection,
                  popupProps: const PopupProps.menu(
                    showSelectedItems: true,
                  ),
                  items: collections,
                  // validator: (v) => v == null ? "Required field".tr() : null,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                    hintText: 'Select A Product Collection'.tr(),
                  )),
                  onChanged: (value) {
                    setState(() {
                      collection = value!;
                      subCollection = '';
                    });
                    getSubCollections(category, collection);
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(children: [
                const Text('Product Sub Collection:').tr(),
              ]),
              const SizedBox(height: 10),
              SizedBox(
                height: 45,
                child: DropdownSearch<String>(
                  selectedItem: subCollection,
                  popupProps: const PopupProps.menu(
                    showSelectedItems: true,
                  ),
                  items: subCollections,
                  // validator: (v) => v == null ? "Required field".tr() : null,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                    hintText: 'Select A Product Sub Collection'.tr(),
                  )),
                  onChanged: (value) {
                    // getSubCollections(category, collection);
                    setState(() {
                      subCollection = value!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(children: [
                const Text('Product Brand:').tr(),
              ]),
              const SizedBox(height: 10),
              SizedBox(
                height: 45,
                child: DropdownSearch<String>(
                  selectedItem: brand,
                  popupProps: const PopupProps.menu(
                    showSelectedItems: true,
                  ),
                  items: brands,
                  validator: (v) => v == null ? "Required field".tr() : null,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                    hintText: 'Select A Product Brand'.tr(),
                  )),
                  onChanged: (value) {
                    // getSubCollections(category, collection);
                    setState(() {
                      brand = value!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),

              Row(children: [
                const Text('Product Price:').tr(),
              ]),
              const SizedBox(height: 10),
              SizedBox(
                height: 45,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    setState(() {
                      unitPrice1 = int.parse(value!);
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      unitPrice1 = int.parse(value);
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Required field'.tr();
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Product Price'.tr(),
                    focusColor: Colors.grey,
                    filled: true,
                    fillColor: Colors.white10,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(children: [
                const Text('Product Initial Price:').tr(),
              ]),
              const SizedBox(height: 10),
              SizedBox(
                height: 45,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    setState(() {
                      unitOldPrice1 = int.parse(value!);
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      unitOldPrice1 = int.parse(value);
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Required field'.tr();
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Product Initial Price'.tr(),
                    focusColor: Colors.grey,
                    filled: true,
                    fillColor: Colors.white10,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(children: [
                const Text('Quantity:').tr(),
              ]),
              const SizedBox(height: 10),
              SizedBox(
                height: 45,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    setState(() {
                      quantity = int.parse(value!);
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      quantity = int.parse(value);
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Required field'.tr();
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Quantity'.tr(),
                    focusColor: Colors.grey,
                    filled: true,
                    fillColor: Colors.white10,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(children: [
                const Text('Product Discount (%):').tr(),
              ]),
              const SizedBox(height: 10),
              SizedBox(
                height: 45,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    setState(() {
                      percantageDiscount = int.parse(value!);
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      percantageDiscount = int.parse(value);
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Required field'.tr();
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Product Discount'.tr(),
                    focusColor: Colors.grey,
                    filled: true,
                    fillColor: Colors.white10,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(children: [
                const Text('Product Unit:').tr(),
              ]),
              const SizedBox(height: 10),
              SizedBox(
                height: 45,
                child: TextFormField(
                  onSaved: (value) {
                    setState(() {
                      unitname1 = value!;
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      unitname1 = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Required field'.tr();
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Kg/mil/gram/pkts',
                    focusColor: Colors.grey,
                    filled: true,
                    fillColor: Colors.white10,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Column(children: [
                const SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('Add on',
                          style: TextStyle(fontWeight: FontWeight.bold))
                      .tr()
                ]),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(flex: 1, child: const Text('Unit').tr()),
                        Flexible(
                            flex: 1, child: const Text('Initial Price').tr()),
                        Flexible(flex: 1, child: const Text('Price').tr())
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            flex: 1,
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  unitname2 = value;
                                });
                              },
                            )),
                        const SizedBox(width: 10),
                        Flexible(
                            flex: 1,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  unitOldPrice2 = int.parse(value);
                                });
                              },
                            )),
                        const SizedBox(width: 10),
                        Flexible(
                            flex: 1,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  unitPrice2 = int.parse(value);
                                });
                              },
                            ))
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            flex: 1,
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  unitname3 = value;
                                });
                              },
                            )),
                        const SizedBox(width: 10),
                        Flexible(
                            flex: 1,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  unitOldPrice3 = int.parse(value);
                                });
                              },
                            )),
                        const SizedBox(width: 10),
                        Flexible(
                            flex: 1,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  unitPrice3 = int.parse(value);
                                });
                              },
                            ))
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            flex: 1,
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  unitname4 = value;
                                });
                              },
                            )),
                        const SizedBox(width: 10),
                        Flexible(
                            flex: 1,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  unitOldPrice4 = int.parse(value);
                                });
                              },
                            )),
                        const SizedBox(width: 10),
                        Flexible(
                            flex: 1,
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  unitPrice4 = int.parse(value);
                                });
                              },
                              keyboardType: TextInputType.number,
                            ))
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            flex: 1,
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  unitname5 = value;
                                });
                              },
                            )),
                        const SizedBox(width: 10),
                        Flexible(
                            flex: 1,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  unitOldPrice5 = int.parse(value);
                                });
                              },
                            )),
                        const SizedBox(width: 10),
                        Flexible(
                            flex: 1,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  unitPrice5 = int.parse(value);
                                });
                              },
                            ))
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            flex: 1,
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  unitname6 = value;
                                });
                              },
                            )),
                        const SizedBox(width: 10),
                        Flexible(
                            flex: 1,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  unitOldPrice6 = int.parse(value);
                                });
                              },
                            )),
                        const SizedBox(width: 10),
                        Flexible(
                            flex: 1,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  unitPrice6 = int.parse(value);
                                });
                              },
                            ))
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            flex: 1,
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  unitname7 = value;
                                });
                              },
                            )),
                        const SizedBox(width: 10),
                        Flexible(
                            flex: 1,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  unitOldPrice7 = int.parse(value);
                                });
                              },
                            )),
                        const SizedBox(width: 10),
                        Flexible(
                            flex: 1,
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  unitPrice7 = int.parse(value);
                                });
                              },
                              keyboardType: TextInputType.number,
                            ))
                      ]),
                ),
                const SizedBox(height: 20),
              ]),
              const SizedBox(height: 20),
              _image1 == null
                  ? const Icon(Icons.image, color: Colors.grey, size: 120)
                  : Image.file(File(_image1!.path), width: 120, height: 120),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.orange,
                          ),
                        ),
                        onPressed: () {
                          _uploadImage1();
                        },
                        child: const Text('Add Image 1',
                                style: TextStyle(color: Colors.white))
                            .tr()),
                  ],
                ),
              ),
              _image2 == null
                  ? const Icon(Icons.image, color: Colors.grey, size: 120)
                  : Image.file(File(_image2!.path), width: 120, height: 120),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.orange,
                          ),
                        ),
                        onPressed: () {
                          _uploadImage2();
                        },
                        child: const Text('Add Image 2',
                                style: TextStyle(color: Colors.white))
                            .tr()),
                  ],
                ),
              ),
              _image3 == null
                  ? const Icon(Icons.image, color: Colors.grey, size: 120)
                  : Image.file(File(_image3!.path), width: 120, height: 120),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.orange,
                          ),
                        ),
                        onPressed: () {
                          _uploadImage3();
                        },
                        child: const Text('Add Image 3',
                                style: TextStyle(color: Colors.white))
                            .tr()),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // Row(
              //   children: [
              //     Text(
              //         'NB: You can add variant after adding the product successfully',
              //         style: TextStyle(fontWeight: FontWeight.bold)),
              //   ],
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              uploading == true || loading == true
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.orange,
                            ),
                          ),
                          onPressed: null,
                          child: const Text('Uploading please wait...',
                                  style: TextStyle(color: Colors.white))
                              .tr()),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.orange,
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate() &&
                                  subCollection != '' &&
                                  collection != '' &&
                                  category != "" &&
                                  image1 != '') {
                                addProduct(
                                    ProductsModel(
                                        returnDuration: returnDuration,
                                        quantity: quantity,
                                        totalRating: 0,
                                        totalNumberOfUserRating: 0,
                                        productID: id,
                                        description: description,
                                        //  marketID: marketID,
                                        vendorName: vendorName,
                                        uid: uid,
                                        name: name,
                                        category: category,
                                        subCollection: subCollection,
                                        collection: collection,
                                        image1: image1,
                                        image2: image2,
                                        image3: image3,
                                        unitname1: unitname1,
                                        unitname2: unitname2,
                                        unitname3: unitname3,
                                        unitname4: unitname4,
                                        unitname5: unitname5,
                                        unitname6: unitname6,
                                        unitname7: unitname7,
                                        unitPrice1: unitPrice1,
                                        unitPrice2: unitPrice2,
                                        unitPrice3: unitPrice3,
                                        unitPrice4: unitPrice4,
                                        unitPrice5: unitPrice5,
                                        unitPrice6: unitPrice6,
                                        unitPrice7: unitPrice7,
                                        unitOldPrice1: unitOldPrice1,
                                        unitOldPrice2: unitOldPrice2,
                                        unitOldPrice3: unitOldPrice3,
                                        unitOldPrice4: unitOldPrice4,
                                        unitOldPrice5: unitOldPrice5,
                                        unitOldPrice6: unitOldPrice6,
                                        unitOldPrice7: unitOldPrice7,
                                        percantageDiscount: percantageDiscount,
                                        vendorId: vendorId,
                                        brand: brand),
                                    id);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Some Fields Are Required".tr(),
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              }
                            },
                            child: const Text('Add Product',
                                    style: TextStyle(color: Colors.white))
                                .tr()),
                      ),
                    )
            ]),
          ),
        ),
      ),
    );
  }
}

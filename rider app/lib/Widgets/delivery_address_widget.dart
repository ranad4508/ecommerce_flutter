import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rider_app/Model/address.dart';
import 'package:rider_app/Widgets/add_delivery_address.dart';

class DeliveryAddressWidget extends StatefulWidget {
  const DeliveryAddressWidget({super.key});

  @override
  State<DeliveryAddressWidget> createState() => _DeliveryAddressWidgetState();
}

class _DeliveryAddressWidgetState extends State<DeliveryAddressWidget> {
  List<AddressModel> products = [];
  List<AddressModel> initProducts = [];
  // List<AddressModel> productsFilter = [];
  bool isLoaded = true;

  getProducts() async {
    setState(() {
      isLoaded = true;
    });
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    context.loaderOverlay.show();
    FirebaseFirestore.instance
        .collection('riders')
        .doc(user!.uid)
        .collection('DeliveryAddress')
        // .limit(10)
        // .where('category', isEqualTo: widget.category)
        .snapshots()
        .listen((event) {
      setState(() {
        isLoaded = false;
      });
      context.loaderOverlay.hide();
      products.clear();
      for (var element in event.docs) {
        var prods = AddressModel.fromMap(element.data(), element.id);
        setState(() {
          products.add(prods);
          initProducts = products;
        });
      }
    });
  }

  String addressID = '';
  Future<void> _getUserDetails() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;
    setState(() {
      firestore.collection('riders').doc(user!.uid).snapshots().listen((value) {
        setState(() {
          addressID = value['DeliveryAddressID'];
        });
      });
    });
  }

  @override
  void initState() {
    getProducts();
    _getUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Delivery Addresses',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ).tr(),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const AddDeliveryAddress();
              }));
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // if (MediaQuery.of(context).size.width >= 1100)
            const Divider(
              color: Color.fromARGB(255, 237, 235, 235),
              thickness: 1,
            ),
            const Gap(20),
            isLoaded == false
                ? products.isEmpty
                    ? Center(
                        child: Icon(
                          Icons.delivery_dining_outlined,
                          color: Colors.orange,
                          size: MediaQuery.of(context).size.width >= 1100
                              ? MediaQuery.of(context).size.width / 5
                              : MediaQuery.of(context).size.width / 1.5,
                        ),
                      )
                    : GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio:
                              MediaQuery.of(context).size.width >= 1100
                                  ? 1.7
                                  : 1.9,
                          crossAxisCount:
                              MediaQuery.of(context).size.width >= 1100 ? 2 : 1,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemBuilder: (context, index) {
                          AddressModel addressModel = products[index];

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5))),
                              child: Column(children: [
                                const Gap(10),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      addressID == addressModel.id
                                          ? Expanded(
                                              flex: 4,
                                              child:
                                                  const Text('Default Address')
                                                      .tr())
                                          : Expanded(
                                              flex: 4,
                                              child: InkWell(
                                                  hoverColor:
                                                      Colors.transparent,
                                                  onTap: () {
                                                    final FirebaseAuth auth =
                                                        FirebaseAuth.instance;
                                                    User? user =
                                                        auth.currentUser;
                                                    FirebaseFirestore.instance
                                                        .collection('riders')
                                                        .doc(user!.uid)
                                                        .update({
                                                      'DeliveryAddress':
                                                          addressModel.address,
                                                      'HouseNumber':
                                                          addressModel
                                                              .houseNumber,
                                                      'ClosestBustStop':
                                                          addressModel
                                                              .closestbusStop,
                                                      'DeliveryAddressID':
                                                          addressModel.id
                                                    });
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Address has been added"
                                                                .tr(),
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.TOP,
                                                        timeInSecForIosWeb: 1,
                                                        fontSize: 14.0);
                                                  },
                                                  child: const Text(
                                                      'Set As Default'))),
                                      Expanded(
                                        flex: 3,
                                        child: addressID == addressModel.id
                                            ? const SizedBox()
                                            : InkWell(
                                                hoverColor: Colors.transparent,
                                                // style: OutlinedButton.styleFrom(
                                                //   shape:
                                                //       const BeveledRectangleBorder(),
                                                // ),
                                                onTap: () {
                                                  final FirebaseAuth auth =
                                                      FirebaseAuth.instance;
                                                  User? user = auth.currentUser;
                                                  FirebaseFirestore.instance
                                                      .collection('riders')
                                                      .doc(user!.uid)
                                                      .collection(
                                                          'DeliveryAddress')
                                                      .doc(addressModel.uid)
                                                      .delete()
                                                      .then((value) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Address has been deleted"
                                                                .tr(),
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.TOP,
                                                        timeInSecForIosWeb: 1,
                                                        fontSize: 14.0);
                                                  });
                                                },
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: const Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ).tr(),
                                                )),
                                      ),
                                      const Gap(5)
                                    ],
                                  ),
                                ),
                                ListTile(
                                  dense: true,
                                  visualDensity:
                                      const VisualDensity(vertical: -4),
                                  leading: const Icon(Icons.room),
                                  title: Text(
                                    addressModel.address,
                                    maxLines: 1,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                const Divider(
                                  endIndent: 20,
                                  indent: 20,
                                ),
                                ListTile(
                                  dense: true,
                                  visualDensity:
                                      const VisualDensity(vertical: -4),
                                  leading: const Icon(Icons.home),
                                  title: Text(addressModel.houseNumber,
                                      maxLines: 1,
                                      style: const TextStyle(fontSize: 12)),
                                ),
                                const Divider(
                                  endIndent: 20,
                                  indent: 20,
                                ),
                                ListTile(
                                  dense: true,
                                  visualDensity:
                                      const VisualDensity(vertical: -4),
                                  title: Text(addressModel.closestbusStop,
                                      maxLines: 1,
                                      style: const TextStyle(fontSize: 12)),
                                  leading: const Icon(Icons.bus_alert),
                                )
                              ]),
                            ),
                          );
                        })
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio:
                            MediaQuery.of(context).size.width >= 1100 ? 1.5 : 2,
                        crossAxisCount:
                            MediaQuery.of(context).size.width >= 1100 ? 2 : 1,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            // height: 200,
                            // width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

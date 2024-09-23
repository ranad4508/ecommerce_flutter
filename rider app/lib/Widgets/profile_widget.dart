import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

import 'add_delivery_address.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  //GlobalKey<FormBuilderState> formKeyNew = GlobalKey<FormBuilderState>();
  String fullname = '';
  String phoneNumber = '';
  String email = '';
  String address = '';
  String referralCode = '';
  bool isLoading = true;
  bool approval = false;

  // getToken() async {
  //   String? token = await FirebaseMessaging.instance.getToken();
  //   setState(() {
  //     tokenID = token!;
  //   });
  // }
  getUserDetail() {
    setState(() {
      isLoading = true;
    });
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('riders')
        .doc(user!.uid)
        .snapshots()
        .listen((event) {
      setState(() {
        isLoading = false;
        fullname = event['fullname'];
        email = event['email'];
        phoneNumber = event['phone'];
        approval = event['approval'];
        referralCode = event['personalReferralCode'];
        address = event['address'];
      });
      //  print('Fullname is $fullName');
    });
  }

  @override
  void initState() {
    // getToken();
    getUserDetail();
    super.initState();
  }

  updateUser() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (phoneNumber.length == 14) {
      FirebaseFirestore.instance.collection('riders').doc(user!.uid).update({
        'fullname': fullname,
        //'email':email,
        'phone': phoneNumber,
        'address': address
      }).then((value) {
        Fluttertoast.showToast(
            msg: "Update completed".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            fontSize: 14.0);
      });
    } else {
      Fluttertoast.showToast(
          msg: "Please check the phone number and try again.".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          fontSize: 14.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Container(
                    width: double.infinity,
                    height: 16.0,
                    color: Colors.white,
                  ),
                  subtitle: Container(
                    width: double.infinity,
                    height: 12.0,
                    color: Colors.white,
                  ),
                );
              },
            ),
          )
        : FormBuilder(
            //  key: formKeyNew,
            child: Column(
              mainAxisAlignment: MediaQuery.of(context).size.width >= 1100
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(10),
                Text('Approval Status: $approval'),
                if (MediaQuery.of(context).size.width >= 1100)
                  Align(
                    alignment: MediaQuery.of(context).size.width >= 1100
                        ? Alignment.bottomLeft
                        : Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width >= 1100
                              ? 50
                              : 0),
                      child: Text(
                        'Account Information',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width >= 1100
                                ? 15
                                : 15),
                      ).tr(),
                    ),
                  ),
                if (MediaQuery.of(context).size.width >= 1100)
                  const Divider(
                    color: Color.fromARGB(255, 237, 235, 235),
                    thickness: 1,
                  ),
                const Gap(20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left:
                            MediaQuery.of(context).size.width >= 1100 ? 50 : 0),
                    child: Text(
                      'Full Name',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width >= 1100
                              ? 15
                              : 12),
                    ).tr(),
                  ),
                ),
                const Gap(10),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width >= 1100 ? 50 : 8,
                      right:
                          MediaQuery.of(context).size.width >= 1100 ? 50 : 8),
                  child: FormBuilderTextField(
                    onChanged: (v) {
                      setState(() {
                        fullname = v!;
                      });
                    },
                    initialValue: fullname,
                    name: 'full name',
                    decoration: const InputDecoration(
                        // filled: true,
                        // // border: InputBorder.none,
                        // fillColor: Colors.white,
                        // hintText: 'Email'.tr(),
                        border: OutlineInputBorder()),
                  ),
                ),
                const Gap(20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left:
                            MediaQuery.of(context).size.width >= 1100 ? 50 : 0),
                    child: Text(
                      'Email Address',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width >= 1100
                              ? 15
                              : 12),
                    ).tr(),
                  ),
                ),
                const Gap(10),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width >= 1100 ? 50 : 8,
                      right:
                          MediaQuery.of(context).size.width >= 1100 ? 50 : 8),
                  child: FormBuilderTextField(
                    readOnly: true,
                    onChanged: (v) {
                      setState(() {
                        email = v!;
                      });
                    },
                    initialValue: email,
                    name: 'email address',
                    decoration: const InputDecoration(
                        // filled: true,
                        // // border: InputBorder.none,
                        // fillColor: Colors.white,
                        // hintText: 'Email'.tr(),
                        border: OutlineInputBorder()),
                  ),
                ),
                const Gap(20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left:
                            MediaQuery.of(context).size.width >= 1100 ? 50 : 0),
                    child: Text(
                      'Phone Number',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width >= 1100
                              ? 15
                              : 12),
                    ).tr(),
                  ),
                ),
                const Gap(10),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width >= 1100 ? 50 : 8,
                      right:
                          MediaQuery.of(context).size.width >= 1100 ? 50 : 8),
                  child: FormBuilderTextField(
                    maxLength: 14,
                    onChanged: (v) {
                      setState(() {
                        phoneNumber = v!;
                      });
                    },
                    initialValue: phoneNumber,
                    name: 'phone number',
                    decoration: const InputDecoration(
                        counterText: '',
                        // filled: true,
                        // // border: InputBorder.none,
                        // fillColor: Colors.white,
                        // hintText: 'Email'.tr(),
                        border: OutlineInputBorder()),
                  ),
                ),
                const Gap(20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left:
                            MediaQuery.of(context).size.width >= 1100 ? 50 : 0),
                    child: Text(
                      'Address',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width >= 1100
                              ? 15
                              : 12),
                    ).tr(),
                  ),
                ),
                const Gap(10),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width >= 1100 ? 50 : 8,
                      right:
                          MediaQuery.of(context).size.width >= 1100 ? 50 : 8),
                  child: FormBuilderTextField(
                    readOnly: true,
                    onChanged: (v) {
                      setState(() {
                        address = v!;
                      });
                    },
                    // initialValue: address,
                    name: 'address',
                    decoration: InputDecoration(
                        // filled: true,
                        // // border: InputBorder.none,
                        // fillColor: Colors.white,
                        hintText: address,
                        suffixIcon: IconButton(
                            onPressed: () async {
                              var result = await Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const OpenStreet();
                              }));
                              // _navigateAndDisplaySelection(context);
                              setState(() {
                                address = result;
                              });
                            },
                            icon: const Icon(Icons.add_circle)),
                        border: const OutlineInputBorder()),
                  ),
                ),
                const SizedBox(height: 20),
                const Gap(20),
                SizedBox(
                  width: MediaQuery.of(context).size.width >= 1100
                      ? MediaQuery.of(context).size.width / 2
                      : MediaQuery.of(context).size.width / 1.2,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const BeveledRectangleBorder(),
                        backgroundColor: Colors.orange,
                        textStyle: const TextStyle(color: Colors.white)),
                    // color: Theme.of(context).colorScheme.secondary,
                    onPressed: () {
                      updateUser();
                      // if (formKeyNew.currentState!.validate()) {
                      //   // context.loaderOverlay.show();
                      //   // AuthService()
                      //   //     .signIn(email, password, context, tokenID)
                      //   //     .then((value) {
                      //   //   context.loaderOverlay.hide();
                      //   // });
                      //   // Validate and save the form values
                      //   // _formKey.currentState?.saveAndValidate();
                      //   // debugPrint(_formKey.currentState?.value.toString());

                      //   // // On another side, can access all field values without saving form with instantValues
                      //   // _formKey.currentState?.validate();
                      //   //   debugPrint(_formKey.currentState?.instantValue.toString());
                      // }
                    },
                    child: const Text(
                      'UPDATE PROFILE',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ).tr(),
                  ),
                ),
                const Gap(20),
              ],
            ),
          );
  }
}

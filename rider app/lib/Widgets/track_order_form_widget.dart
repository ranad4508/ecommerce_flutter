// ignore_for_file: avoid_print

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rider_app/Model/constant.dart';

class TrackOrderFormWidget extends StatefulWidget {
  const TrackOrderFormWidget({super.key});

  @override
  State<TrackOrderFormWidget> createState() => _TrackOrderFormWidgetState();
}

class _TrackOrderFormWidgetState extends State<TrackOrderFormWidget> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _emailFieldKey = GlobalKey<FormBuilderFieldState>();
  bool showPassword = true;
  String email = '';
  String password = '';
  String tokenID = '';
  // getToken() async {
  //   String? token = await FirebaseMessaging.instance.getToken();
  //   setState(() {
  //     tokenID = token!;
  //   });
  // }
  getOrder(String orderID) {
    context.loaderOverlay.show();

    FirebaseFirestore.instance
        .collection('Orders')
        .where('orderID', isEqualTo: orderID)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        for (var item in value.docs) {
          // print(item['uid']);
          context.push('/tracking-detail/${item['uid']}');
          Fluttertoast.showToast(
                  msg: "Package found.".tr(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 1,
                  fontSize: 14.0)
              .then((value) {
            context.loaderOverlay.hide();
          });
        }
      } else {
        context.loaderOverlay.hide();
        Fluttertoast.showToast(
            msg: "Wrong tracking number.".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      }
    });
  }

  @override
  void initState() {
    // getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MediaQuery.of(context).size.width >= 1100
            ? MainAxisAlignment.start
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MediaQuery.of(context).size.width >= 1100
              ? const Gap(50)
              : const Gap(20),
          if (MediaQuery.of(context).size.width <= 1100)
            Image.asset(
              'assets/image/new logo.png',
              scale: 10,
            ),
          const Gap(10),
          Align(
            alignment: MediaQuery.of(context).size.width >= 1100
                ? Alignment.center
                : Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width >= 1100 ? 0 : 0),
              child: Text(
                'Track Your Order',
                style: TextStyle(
                    color: appColor,
                    fontWeight: FontWeight.bold,
                    fontSize:
                        MediaQuery.of(context).size.width >= 1100 ? 20 : 20),
              ).tr(),
            ),
          ),
          Padding(
            padding: MediaQuery.of(context).size.width >= 1100
                ? const EdgeInsets.only(left: 100, right: 100)
                : const EdgeInsets.all(8),
            child: Center(
              child: const Text(
                'Enter Order ID To Track Your Package.',
                textAlign: TextAlign.center,
              ).tr(),
            ),
          ),
          const Gap(20),
          SizedBox(
            width: MediaQuery.of(context).size.width >= 1100
                ? MediaQuery.of(context).size.width / 2
                : MediaQuery.of(context).size.width / 1.2,
            child: FormBuilderTextField(
              style: TextStyle(
                color: AdaptiveTheme.of(context).mode.isDark == true
                    ? Colors.black
                    : null,
              ),
              onChanged: (v) {
                setState(() {
                  email = v!;
                });
              },
              key: _emailFieldKey,
              name: 'email',
              decoration: InputDecoration(
                filled: true,
                border: InputBorder.none,
                fillColor: const Color.fromARGB(255, 236, 234, 234),
                hintStyle: TextStyle(
                    color: AdaptiveTheme.of(context).mode.isDark == true
                        ? Colors.black
                        : null),
                hintText: 'Your Order Id'.tr(),
                //border: OutlineInputBorder()
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.integer(),
              ]),
            ),
          ),
          const SizedBox(height: 20),
          const Gap(10),
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
                if (_formKey.currentState!.validate()) {
                  getOrder(email);
                  // context.loaderOverlay.show();
                  // AuthService().forgotPassword(context, email).then((value) {
                  //   context.loaderOverlay.hide();
                  // });
                  // Validate and save the form values
                  // _formKey.currentState?.saveAndValidate();
                  // debugPrint(_formKey.currentState?.value.toString());

                  // // On another side, can access all field values without saving form with instantValues
                  // _formKey.currentState?.validate();
                  //   debugPrint(_formKey.currentState?.instantValue.toString());
                }
              },
              child: const Text(
                'TRACK ORDER',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ).tr(),
            ),
          )
        ],
      ),
    );
  }
}

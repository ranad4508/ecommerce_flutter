import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rider_app/Model/constant.dart';
import 'package:rider_app/Providers/auth.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKeyLogin = GlobalKey<FormBuilderState>();
  final _emailFieldKeyLogin = GlobalKey<FormBuilderFieldState>();
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

  @override
  void initState() {
    // getToken();
    getTokenID();
    super.initState();
  }

  getTokenID() async {
    String? token = await FirebaseMessaging.instance.getToken();
    setState(() {
      tokenID = token!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKeyLogin,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MediaQuery.of(context).size.width >= 1100
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (MediaQuery.of(context).size.width <= 1100) const Gap(50),
            if (MediaQuery.of(context).size.width <= 1100)
              Image.asset(
                'assets/image/new logo.png',
                scale: 10,
              ),
            const Gap(10),
            Align(
              alignment: MediaQuery.of(context).size.width >= 1100
                  ? Alignment.bottomLeft
                  : Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width >= 1100 ? 50 : 0),
                child: Text(
                  'Sign in to continue.',
                  style: TextStyle(
                      color: appColor,
                      fontWeight: FontWeight.bold,
                      fontSize:
                          MediaQuery.of(context).size.width >= 1100 ? 20 : 15),
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
                key: _emailFieldKeyLogin,
                name: 'login email',
                decoration: InputDecoration(
                  filled: true,
                  border: InputBorder.none,
                  fillColor: const Color.fromARGB(255, 236, 234, 234),
                  hintStyle: TextStyle(
                      color: AdaptiveTheme.of(context).mode.isDark == true
                          ? Colors.black
                          : null),
                  hintText: 'Email'.tr(),

                  //border: OutlineInputBorder()
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.email(),
                ]),
              ),
            ),
            const SizedBox(height: 20),
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
                onChanged: (value) {
                  setState(() {
                    password = value!;
                  });
                },
                name: 'login password',
                decoration: InputDecoration(
                  suffixIcon: showPassword == true
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              showPassword = false;
                            });
                          },
                          child: const Icon(
                            Icons.visibility,
                            color: Colors.grey,
                            size: 30,
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            setState(() {
                              showPassword = true;
                            });
                          },
                          child: const Icon(
                            Icons.visibility_off,
                            color: Colors.grey,
                            size: 30,
                          ),
                        ),
                  filled: true,
                  border: InputBorder.none,
                  fillColor: const Color.fromARGB(255, 236, 234, 234),
                  hintStyle: TextStyle(
                      color: AdaptiveTheme.of(context).mode.isDark == true
                          ? Colors.black
                          : null),
                  hintText: 'Password'.tr(),
                  //   border: OutlineInputBorder()
                ),
                obscureText: showPassword,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
            ),
            const Gap(10),
            SizedBox(
              width: MediaQuery.of(context).size.width >= 1100
                  ? MediaQuery.of(context).size.width / 2
                  : MediaQuery.of(context).size.width / 1.2,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      context.push('/forgot-password');
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: appColor),
                    ).tr(),
                  ),
                ],
              ),
            ),
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
                  if (_formKeyLogin.currentState!.validate()) {
                    context.loaderOverlay.show();
                    AuthService()
                        .signIn(email, password, context, tokenID)
                        .then((value) {
                      context.loaderOverlay.hide();
                    });
                    // Validate and save the form values
                    // _formKeyLogin.currentState?.saveAndValidate();
                    // debugPrint(_formKeyLogin.currentState?.value.toString());

                    // // On another side, can access all field values without saving form with instantValues
                    // _formKeyLogin.currentState?.validate();
                    //   debugPrint(_formKeyLogin.currentState?.instantValue.toString());
                  }
                },
                child: const Text(
                  'SIGN IN',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ).tr(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

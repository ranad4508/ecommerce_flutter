import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rider_app/Model/constant.dart';
import '../Widgets/forgot_password_form_widget.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  void initState() {
    context.loaderOverlay.hide();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MediaQuery.of(context).size.width >= 1100
          ? null
          : AppBar(actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                      text: 'Don\'t have an account?',
                      style: const TextStyle(
                          // color: Colors.black,
                          ),
                      children: <TextSpan>[
                        TextSpan(
                            text: ' Sign up',
                            style: TextStyle(
                              color: appColor,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.push('/signup');
                              })
                      ]),
                ),
              ),
            ]),
      body: MediaQuery.of(context).size.width >= 1100
          ? Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Image.asset(
                          'assets/image/login 2.jpg',
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                          scale: 1,
                        ),
                      ),
                      const Expanded(
                          flex: 7,
                          child: SizedBox(child: ForgotPasswordFormWidget()))
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      context.push('/');
                    },
                    child: Image.asset(
                      'assets/image/new logo.png',
                      scale: 17,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15, right: 15),
                    child: RichText(
                      text: TextSpan(
                          text: 'Don\'t have an account?',
                          style: const TextStyle(
                              // color: Colors.black,
                              ),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' Sign up',
                                style: TextStyle(
                                  color: appColor,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    context.push('/signup');
                                  })
                          ]),
                    ),
                  ),
                )
              ],
            )
          : const Center(child: ForgotPasswordFormWidget()),
    );
  }
}

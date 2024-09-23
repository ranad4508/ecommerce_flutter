import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
//import 'package:rider_app/Widgets/footer_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rider_app/Widgets/guides.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              decoration:  BoxDecoration(
                  color: AdaptiveTheme.of(context).mode.isDark == true
                      ? Colors.black
                      : const Color.fromARGB(255, 230, 224, 237),
                  image: const DecorationImage(
                      fit: BoxFit.cover,
                      opacity: 0.3,
                      image: AssetImage('assets/image/shop.jpg'))),
              child: Center(
                child: const Text(
                  'About us',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ).tr(),
              ),
            ),
            Padding(
              padding: MediaQuery.of(context).size.width >= 1100
                  ? const EdgeInsets.only(left: 100, right: 100)
                  : const EdgeInsets.all(8),
              child: Column(
                children: [
                  const Gap(50),
                  MediaQuery.of(context).size.width >= 1100
                      ? Row(
                          children: [
                            Expanded(
                                flex: 6,
                                child: SvgPicture.asset(
                                  'assets/image/undraw_undraw_shopping_bags_2ude_-1-_mnw3.svg',
                                  height: 300,
                                  width: double.infinity,
                                )),
                            const Expanded(
                              flex: 6,
                              child: Column(
                                children: [
                                  Text(
                                    'About Us',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                    textAlign: TextAlign.left,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            SvgPicture.asset(
                              'assets/image/undraw_undraw_shopping_bags_2ude_-1-_mnw3.svg',
                              height: 300,
                              width: double.infinity,
                            ),
                            const Column(
                              children: [
                                Text(
                                  'About Us',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  textAlign: TextAlign.left,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
                                ),
                              ],
                            ),
                          ],
                        ),
                  const Gap(10),
                  MediaQuery.of(context).size.width >= 1100
                      ? Row(
                          children: [
                            const Expanded(
                              flex: 6,
                              child: Column(
                                children: [
                                  Text(
                                    'Our Mission',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                    textAlign: TextAlign.left,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                flex: 6,
                                child: SvgPicture.asset(
                                  'assets/image/undraw_empty_cart_co35.svg',
                                  height: 300,
                                  width: double.infinity,
                                )),
                          ],
                        )
                      : Column(
                          children: [
                            Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/image/undraw_empty_cart_co35.svg',
                                  height: 300,
                                  width: double.infinity,
                                ),
                                const Gap(10),
                                const Text(
                                  'Our Mission',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  textAlign: TextAlign.left,
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
                                ),
                              ],
                            ),
                          ],
                        ),
                  const Gap(50),
                  // const Text(
                  //   'Our Core Values',
                  //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  //   textAlign: TextAlign.left,
                  // ).tr(),
                  const GuidesWIdget(),
                  const Gap(50),
                  MediaQuery.of(context).size.width >= 1100
                      ? Row(
                          children: [
                            Expanded(
                                flex: 6,
                                child: SvgPicture.asset(
                                  'assets/image/undraw_mobile_payments_re_7udl.svg',
                                  height: 300,
                                  width: double.infinity,
                                )),
                            const Expanded(
                              flex: 6,
                              child: Column(
                                children: [
                                  Text(
                                    'Final Word',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                    textAlign: TextAlign.left,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            SvgPicture.asset(
                              'assets/image/undraw_mobile_payments_re_7udl.svg',
                              height: 300,
                              width: double.infinity,
                            ),
                            const Column(
                              children: [
                                Text(
                                  'Final Word',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  textAlign: TextAlign.left,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
                                ),
                              ],
                            ),
                          ],
                        ),
                  const Gap(50)
                ],
              ),
            ),
            //const FooterWidget()
          ],
        ),
      ),
    );
  }
}

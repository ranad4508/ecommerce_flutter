import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rider_app/Model/constant.dart';

class FooterWidget extends StatefulWidget {
  const FooterWidget({super.key});

  @override
  State<FooterWidget> createState() => _FooterWidgetState();
}

class _FooterWidgetState extends State<FooterWidget> {
  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _makePhoneCall(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 6, 25, 49),
      height: MediaQuery.of(context).size.width >= 1100 ? 300 : 650,
      width: double.infinity,
      child: Column(
        children: [
          const Gap(50),
          MediaQuery.of(context).size.width >= 1100
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Company',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.white))
                            .tr(),
                        const Gap(10),
                        InkWell(
                          onTap: () {
                            context.push('/about');
                          },
                          child: const Text(
                            'About Olivette Store',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ).tr(),
                        ),
                        const Gap(30)
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Products',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.white))
                            .tr(),
                        const Gap(10),
                        InkWell(
                          onTap: () {
                            context.push('/');
                          },
                          child: const Text(
                            'View All Products',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ).tr(),
                        ),
                        const Gap(30)
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const Gap(10),
                        const Text('Get in touch',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.white))
                            .tr(),
                        // const Gap(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                _launchURL(facebookLink);
                              },
                              child: Image.asset(
                                'assets/image/facebook.png',
                                color: Colors.white,
                                height: 20,
                                width: 20,
                              ),
                            ),
                            const Gap(10),
                            InkWell(
                              onTap: () {
                                _launchURL(instagram);
                              },
                              child: Image.asset(
                                'assets/image/instagram.png',
                                height: 20,
                                color: Colors.white,
                                width: 20,
                              ),
                            ),
                            const Gap(10),
                            InkWell(
                              onTap: () {
                                _launchURL(twitterLink);
                              },
                              child: Image.asset(
                                'assets/image/twitter.jpeg',
                                height: 30,
                                width: 20,
                                // color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            _makePhoneCall(email);
                          },
                          child: const Text(
                            'preciousoliver03@gmail.com',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ).tr(),
                        ),
                        const Text(
                          'Olivette Store, Nigeria.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ).tr()
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const Gap(10),
                        const Text('Download Now',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.white))
                            .tr(),

                        InkWell(
                          onTap: () {
                            _launchURL(facebookLink);
                          },
                          child: SvgPicture.asset(
                            'assets/image/playstore.svg',
                            //color: Colors.white,
                            height: 30,
                            // width: 20,
                          ),
                        ),
                        const Gap(2),
                        InkWell(
                          onTap: () {
                            _launchURL(instagram);
                          },
                          child: SvgPicture.asset(
                            'assets/image/appstore.svg',
                            //color: Colors.white,
                            height: 30,
                            // width: 20,
                          ),
                        ),
                        //     const Gap(10),
                      ],
                    )
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Company',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white))
                              .tr(),
                          const Gap(10),
                          InkWell(
                            onTap: () {
                              context.push('/about');
                            },
                            child: const Text(
                              'About Olivette Store',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ).tr(),
                          ),
                          const Gap(30)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Products',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white))
                              .tr(),
                          const Gap(10),
                          InkWell(
                            onTap: () {
                              context.push('/');
                            },
                            child: const Text(
                              'View All Products',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ).tr(),
                          ),
                          const Gap(30)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const Gap(10),
                          const Text('Get in touch',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white))
                              .tr(),
                          // const Gap(10),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  _launchURL(facebookLink);
                                },
                                child: Image.asset(
                                  'assets/image/facebook.png',
                                  color: Colors.white,
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                              const Gap(10),
                              InkWell(
                                onTap: () {
                                  _launchURL(instagram);
                                },
                                child: Image.asset(
                                  'assets/image/instagram.png',
                                  height: 20,
                                  color: Colors.white,
                                  width: 20,
                                ),
                              ),
                              const Gap(10),
                              InkWell(
                                onTap: () {
                                  _launchURL(twitterLink);
                                },
                                child: Image.asset(
                                  'assets/image/twitter.jpeg',
                                  height: 30,
                                  width: 20,
                                  // color: Colors.white,
                                ),
                              )
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              _makePhoneCall(email);
                            },
                            child: const Text(
                              'preciousoliver03@gmail.com',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ).tr(),
                          ),
                          const Text(
                            'Olivette Store, Nigeria.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ).tr()
                        ],
                      ),
                    ),
                    const Gap(20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const Gap(10),
                          const Text('Download Now',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white))
                              .tr(),
                          const Gap(10),
                          InkWell(
                            onTap: () {
                              _launchURL(facebookLink);
                            },
                            child: SvgPicture.asset(
                              'assets/image/playstore.svg',
                              //color: Colors.white,
                              height: 30,
                              // width: 20,
                            ),
                          ),
                          const Gap(10),
                          InkWell(
                            onTap: () {
                              _launchURL(instagram);
                            },
                            child: SvgPicture.asset(
                              'assets/image/appstore.svg',
                              //color: Colors.white,
                              height: 30,
                              // width: 20,
                            ),
                          ),
                          //     const Gap(10),
                        ],
                      ),
                    )
                  ],
                ),
          const Gap(10),
          const Divider(
            color: Colors.white,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          // const Gap(20),
          Image.asset(
            'assets/image/new logo.png',
            scale: 15,
            color: Colors.white,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  context.push('/terms');
                },
                child: const Text(
                  'Terms Of Services',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
              const Text(
                '  |  ',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
              InkWell(
                onTap: () {
                  context.push('/policy');
                },
                child: const Text(
                  'Privacy Policy',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              )
            ],
          ),
          const Gap(5),
          const Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Text(
              'The site is owned and operated by Olivette Store Limited – owners of Marketsquare - a company registered in Nigeria whose registered office is 23 Nzimiro Street, Old GRA, Port Harcourt, Rivers State, Nigeria. Company Registration No. 1181249, TIN No. 17810525 © 2023 olivette-store.web.app All Rights Reserved.',
              style: TextStyle(color: Colors.white, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}

// ignore_for_file: avoid_print

import 'package:clipboard/clipboard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gap/gap.dart';

class ShareToSocials extends StatefulWidget {
  final String productID;
  const ShareToSocials({super.key, required this.productID});

  @override
  State<ShareToSocials> createState() => _ShareToSocialsState();
}

class _ShareToSocialsState extends State<ShareToSocials> {
  void shareToFacebook() async {
    // Construct the Facebook share URL
    final facebookShareUrl =
        'https://www.facebook.com/sharer/sharer.php?u=https://olivette-store.web.app/product-detail/${widget.productID}';

    // Check if the URL can be launched
    if (await canLaunchUrl(Uri.parse(facebookShareUrl))) {
      // Launch the Facebook share dialog
      await launchUrl(Uri.parse(facebookShareUrl));
    } else {
      // Handle if the URL cannot be launched
      print('Could not launch $facebookShareUrl');
    }
  }

  void shareToTwitter() async {
    // Encode the text and URL for Twitter
    final encodedText = Uri.encodeComponent('Olivette Store');
    final encodedUrl = Uri.encodeComponent(
        'https://olivette-store.web.app/product-detail/${widget.productID}');

    // Construct the Twitter share URL
    final twitterShareUrl =
        'https://twitter.com/intent/tweet?text=$encodedText&url=$encodedUrl';

    // Check if the URL can be launched
    if (await canLaunchUrl(Uri.parse(twitterShareUrl))) {
      // Launch the Twitter share dialog
      await launchUrl(Uri.parse(twitterShareUrl));
    } else {
      // Handle if the URL cannot be launched

      print('Could not launch $twitterShareUrl');
    }
  }

  void shareToInstagram() async {
    // Construct the Instagram share URL
    const instagramUrl = 'https://www.instagram.com/';

    // Check if the Instagram app can be launched
    if (await canLaunchUrl(Uri.parse(instagramUrl))) {
      // Launch Instagram with pre-filled caption and image
      await launchUrl(Uri.parse(
          '$instagramUrl?text=Olivette Store&url=https://olivette-store.web.app/product-detail/${widget.productID}'));
    } else {
      // Handle if the app cannot be launched
      print('Could not launch Instagram');
    }
  }

  void launchWhatsApp() async {
    var whatsappUrl = "https://api.whatsapp.com/send?text=https://olivette-store.web.app/product-detail/${widget.productID}";
    await canLaunchUrl(Uri.parse(whatsappUrl))
        ? launchUrl(Uri.parse(whatsappUrl))
        : print(
            "open WhatsApp app link or do a snackbar with notification that there is no WhatsApp installed");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Share with your friends').tr(),
        const Gap(10),
        Row(
          children: [
            InkWell(
                onTap: () {
                  shareToFacebook();
                },
                child:
                    Image.asset('assets/image/facebook share.png', scale: 22)),
            const Gap(10),
            InkWell(
                onTap: () {
                  shareToTwitter();
                },
                child: Image.asset('assets/image/twitter.png', scale: 22)),
            const Gap(10),
            InkWell(
                onTap: () {
                  launchWhatsApp();
                },
                child: Image.asset('assets/image/whatsapp (1).png', scale: 22)),
            const Gap(10),
            InkWell(
                onTap: () {
                  FlutterClipboard.copy(
                          'https://olivette-store.web.app/product-detail/${widget.productID}')
                      .then((value) => print('copied'));
                  Fluttertoast.showToast(
                      msg: "Link has been copied".tr(),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 2,
                      fontSize: 14.0);
                },
                child: Image.asset('assets/image/copy.png', scale: 22)),
          ],
        ),
      ],
    );
  }
}

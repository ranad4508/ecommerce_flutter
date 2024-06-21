import 'package:e_mall/common/styles/spacing_styles.dart';
import 'package:e_mall/common/widgets/login_signup/form_divider.dart';
import 'package:e_mall/common/widgets/login_signup/social_buttons.dart';
import 'package:e_mall/features/authentication/screens/login/widgets/login_form.dart';
import 'package:e_mall/features/authentication/screens/login/widgets/login_header.dart';
import 'package:e_mall/utils/constants/colors.dart';
import 'package:e_mall/utils/constants/image_strings.dart';
import 'package:e_mall/utils/constants/sizes.dart';
import 'package:e_mall/utils/constants/text_strings.dart';
import 'package:e_mall/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              ///logo, title and subtitle
              const LoginHeader(),
              const LoginForm(),

              ///Divider
              FormDivider(dividerText: TTexts.orSignInWith.capitalize!),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),

              ///Footer
              const SocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}



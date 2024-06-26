import 'package:e_mall/features/authentication/screens/password_configuration/forget_password.dart';
import 'package:e_mall/features/authentication/screens/signup/signup.dart';
import 'package:e_mall/navigation_menu.dart';
import 'package:e_mall/utils/constants/sizes.dart';
import 'package:e_mall/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            ///Email
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: TTexts.email,
              ),
            ),
            const SizedBox(
              height: TSizes.spaceBtwInputField / 2,
            ),

            ///Password
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.password_check),
                labelText: TTexts.password,
                suffixIcon: Icon(Iconsax.eye_slash),
              ),
            ),
            const SizedBox(
              height: TSizes.spaceBtwInputField / 2,
            ),

            ///Remember me and forget password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ///Remember me
                Row(
                  children: [
                    Checkbox(value: true, onChanged: (value) {}),
                    const Text(TTexts.rememberMe),
                  ],
                ),

                ///Forget Password
                TextButton(
                    onPressed: ()=> Get.to(()=> const ForgetPassword()),
                    child: const Text(TTexts.forgetPassword)),
              ],
            ),
            const SizedBox(
              height: TSizes.spaceBtwSections,
            ),

            ///Sign In Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: ()=>Get.to(()=> const NavigationMenu()), child: const Text(TTexts.signIn)),
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),

            ///Create Account Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                  onPressed: () =>Get.to(()=>const SignupScreen()),
                  child: const Text(TTexts.createAccount)),
            ),
          ],
        ),
      ),
    );
  }
}

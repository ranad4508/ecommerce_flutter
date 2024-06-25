import 'package:e_mall/utils/constants/sizes.dart';
import 'package:e_mall/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              ///TItle
              Text(
                TTexts.signUpTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),

              ///Form
              Form(
                  child: Column(
                children: [
                  Row(
                    children: [
                      ///Firstname and lastname
                      Expanded(
                        child: TextFormField(
                          expands: false,
                          decoration: const InputDecoration(
                            labelText: TTexts.firstName,
                            prefixIcon: Icon(Iconsax.user),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: TSizes.spaceBtwInputField,
                      ),
                      Expanded(
                        child: TextFormField(
                          expands: false,
                          decoration: const InputDecoration(
                            labelText: TTexts.lastName,
                            prefixIcon: Icon(Iconsax.user),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputField,),
                  ///Username
                  TextFormField(
                    expands: false,
                    decoration: const InputDecoration(
                      labelText: TTexts.username,
                      prefixIcon: Icon(Iconsax.user_edit),
                    ),
                  ),

                  ///Email
                  const SizedBox(height: TSizes.spaceBtwInputField,),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: TTexts.email,
                      prefixIcon: Icon(Iconsax.direct),
                    ),
                  ),

                  ///Phone Number
                  const SizedBox(height: TSizes.spaceBtwInputField,),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: TTexts.phoneNo,
                      prefixIcon: Icon(Iconsax.call),
                    ),
                  ),

                  ///Password
                  const SizedBox(height: TSizes.spaceBtwInputField,),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: TTexts.password,
                      prefixIcon: Icon(Iconsax.password_check),
                      suffixIcon: Icon(Iconsax.eye_slash),
                    ),
                  ),
                  ///Terms & conditions
                  ///Sign In Button
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}

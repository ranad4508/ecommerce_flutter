import 'package:e_mall/utils/constants/sizes.dart';
import 'package:e_mall/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:e_mall/features/authentication/controllers/onboarding/onboarding_controller.dart';


class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: TDeviceUtils.getAppBarHeight(),
        right: TSizes.defaultSpace,
        child: TextButton(
          onPressed: () =>OnboardingController.instance.skipPage(),
          child: const Text('Skip'),
        )
    );
  }
}
import 'package:e_mall/common/widgets/images/circular_image.dart';
import 'package:e_mall/utils/constants/colors.dart';
import 'package:e_mall/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class TUserProfileTile extends StatelessWidget {
  const TUserProfileTile({
    super.key, this.onPressed,
  });
  final void Function()? onPressed;


  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const TCircularImage(
        image: TImages.user1,
        width: 50,
        height: 50,
        padding: 0,
      ),
      title: Text(
        'Dinesh Kumar Rana',
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .apply(color: TColors.white),
      ),subtitle: Text(
      'dineshrana@gmail.com',
      style: Theme.of(context)
          .textTheme
          .bodyMedium!
          .apply(color: TColors.white),
    ),
      trailing: IconButton(onPressed: onPressed, icon: const Icon(Iconsax.edit_copy, color:  TColors.white,),),
    );
  }
}

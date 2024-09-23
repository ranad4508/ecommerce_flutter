import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class LanguageWidget extends StatelessWidget {
  const LanguageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close)),
          ],
        ),
        const Gap(20),
        Container(
          padding: const EdgeInsets.only(top: 26),
          margin: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Row(
            children: [
              const Icon(Icons.language, size: 40, color: Colors.grey),
              const SizedBox(width: 20),
              Text(
                'Select your preferred language'.tr(),
                style: TextStyle(
                  //  color: Colors.blue,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: MediaQuery.of(context).size.width >= 1100 ? 18 : 10,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _SwitchListTileMenuItem(
            flag: 'assets/image/usa.png',
            subtitle: 'English',
            title: 'USA',
            locale: context.supportedLocales[1] //BuildContext extension method
            ),
        _SwitchListTileMenuItem(
            flag: 'assets/image/spanish.gif',
            title: 'PARAGUAY',
            subtitle: 'Spanish',
            locale: context.supportedLocales[0]),
        _SwitchListTileMenuItem(
            flag: 'assets/image/portugal.png',
            subtitle: 'Portueges',
            title: 'BRAZIL- PORTUGUÉS',
            locale: context.supportedLocales[2]),
      ],
    );
  }
}

class _SwitchListTileMenuItem extends StatefulWidget {
  const _SwitchListTileMenuItem({
    required this.title,
    required this.subtitle,
    required this.locale,
    required this.flag,
  });

  final String title;
  final String subtitle;
  final Locale locale;
  final String flag;

  @override
  State<_SwitchListTileMenuItem> createState() =>
      __SwitchListTileMenuItemState();
}

class __SwitchListTileMenuItemState extends State<_SwitchListTileMenuItem> {
  bool isSelected(BuildContext context) => widget.locale == context.locale;

  dynamic themeMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Card(
        elevation: 3,
        child: ListTile(
            tileColor: isSelected(context) ? Colors.grey[300] : null,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                widget.flag,
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            dense: true,
            // isThreeLine: true,
            title: Text(
              widget.title,
              style: TextStyle(
                  color: widget.locale == context.locale
                      ? Colors.black
                      : Theme.of(context).iconTheme.color),
            ),
            subtitle: Text(
              widget.subtitle,
              style: TextStyle(
                  color: widget.locale == context.locale
                      ? Colors.black
                      : Theme.of(context).iconTheme.color),
            ),
            onTap: () async {
              log(widget.locale.toString(), name: toString());
              //print('Country code is ${widget.locale.countryCode}');

              await context
                  .setLocale(widget.locale)
                  .then((value) => context.pop());
              await WidgetsBinding.instance.performReassemble();
            }),
      ),
    );
  }
}

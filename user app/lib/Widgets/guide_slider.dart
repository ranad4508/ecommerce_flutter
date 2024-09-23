import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class GuidesSliderWIdget extends StatefulWidget {
  const GuidesSliderWIdget({super.key});

  @override
  State<GuidesSliderWIdget> createState() => _GuidesSliderWIdgetState();
}

class _GuidesSliderWIdgetState extends State<GuidesSliderWIdget> {
  PageController? pg;
  int currentIndex = 0;

  List<Map<String, dynamic>> ourValue = [
    {
      'title': 'Crediblity',
      'desc': 'We are credible',
      'level': const Icon(Icons.handshake)
    },
    {
      'title': 'Return & Refund',
      'desc': 'Receive your cash back',
      'level': const Icon(Icons.monetization_on)
    },
    {
      'title': 'Secure Payment',
      'desc': 'Complete your payment without issues',
      'level': const Icon(Icons.security)
    },
    {
      'title': '24/7 Support',
      'desc': 'Our support team are available round the clock',
      'level': const Icon(Icons.support)
    },
  ];
  @override
  void initState() {
    pg = PageController(initialPage: 0);
    pg!.addListener(() {
      setState(() {
        currentIndex = pg!.page!.toInt();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1100
        ? Container(
            color: AdaptiveTheme.of(context).mode.isDark == true
                ? Colors.black
                : Colors.white,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    flex: 6,
                    child: ListTile(
                      minLeadingWidth: 100,
                      leading: Icon(
                        Icons.handshake,
                        size: 40,
                      ),
                      title: Text(
                        'Crediblity',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('We are credible'),
                    ),
                  ),
                  Flexible(
                    flex: 6,
                    child: ListTile(
                      minLeadingWidth: 100,
                      leading: Icon(Icons.monetization_on, size: 40),
                      title: Text(
                        'Return & Refund',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Receive your cash back'),
                    ),
                  ),
                  Flexible(
                    flex: 6,
                    child: ListTile(
                      minLeadingWidth: 100,
                      leading: Icon(Icons.security, size: 40),
                      title: Text(
                        'Secure Payment',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Complete your payment without issues'),
                    ),
                  ),
                  Flexible(
                    flex: 6,
                    child: ListTile(
                      minLeadingWidth: 100,
                      leading: Icon(Icons.support, size: 40),
                      title: Text(
                        '24/7 Support',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          'Our support team are available round the clock'),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: PageView.builder(
                      itemCount: ourValue.length,
                      onPageChanged: (e) {
                        setState(() {
                          currentIndex = e;
                        });
                      },
                      controller: pg,
                      itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color:
                                      AdaptiveTheme.of(context).mode.isDark ==
                                              true
                                          ? Colors.black
                                          : Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromRGBO(14, 51, 184, 0.1),
                                          shape: BoxShape.circle),
                                      child: Center(
                                        child: ourValue[index]['level'],
                                      ),
                                    ),
                                    const Gap(20),
                                    Text(
                                      ourValue[index]['title'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    const Gap(20),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: Text(
                                        ourValue[index]['desc'],
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(
                      ourValue.length,
                      (index) => Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                  color: currentIndex == index
                                      ? Colors.red
                                      : Colors.grey,
                                  shape: BoxShape.circle),
                            ),
                          ))
                ],
              ),
            ],
          );
  }
}

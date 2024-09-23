import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class GuidesWIdget extends StatefulWidget {
  const GuidesWIdget({super.key});

  @override
  State<GuidesWIdget> createState() => _GuidesWIdgetState();
}

class _GuidesWIdgetState extends State<GuidesWIdget> {
  PageController? pg;
  int currentIndex = 0;

  List<Map<String, dynamic>> ourValue = [
    {
      'title': 'Crediblity',
      'desc':
          'Lorem ipsum dolor sit amet consectetur. Et eu vitae aliquet aliquet. Posuere vestibulum molestie dolor nullam. Lorem ipsum ',
      'level': '01'
    },
    {
      'title': 'Accountability',
      'desc':
          'Lorem ipsum dolor sit amet consectetur. Et eu vitae aliquet aliquet. Posuere vestibulum molestie dolor nullam. Lorem ipsum ',
      'level': '02'
    },
    {
      'title': 'Trust',
      'desc':
          'Lorem ipsum dolor sit amet consectetur. Et eu vitae aliquet aliquet. Posuere vestibulum molestie dolor nullam. Lorem ipsum ',
      'level': "03"
    },
    {
      'title': 'Flexibility',
      'desc':
          'Lorem ipsum dolor sit amet consectetur. Et eu vitae aliquet aliquet. Posuere vestibulum molestie dolor nullam. Lorem ipsum',
      'level': "04"
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
            height: 500,
            color: AdaptiveTheme.of(context).mode.isDark == true
                ? Colors.black87
                : const Color.fromARGB(255, 249, 243, 243),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Our Core Values',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 6,
                          child: ListTile(
                            minLeadingWidth: 100,
                            leading: Container(
                              height: 100,
                              width: 100,
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(14, 51, 184, 0.1),
                                  shape: BoxShape.circle),
                              child: const Center(
                                child: Text(
                                  '01',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            title: const Text(
                              'Trust',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: const Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text(
                                  'Lorem ipsum dolor sit amet consectetur. Et eu vitae aliquet aliquet. Posuere vestibulum molestie dolor nullam. Lorem ipsum '),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 6,
                          child: ListTile(
                            minLeadingWidth: 100,
                            leading: Container(
                              height: 100,
                              width: 100,
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(14, 51, 184, 0.1),
                                  shape: BoxShape.circle),
                              child: const Center(
                                child: Text(
                                  '02',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            title: const Text(
                              'Credibility',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: const Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text(
                                  'Lorem ipsum dolor sit amet consectetur. Et eu vitae aliquet aliquet. Posuere vestibulum molestie dolor nullam. Lorem ipsum '),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 6,
                          child: ListTile(
                            minLeadingWidth: 100,
                            leading: Container(
                              height: 100,
                              width: 100,
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(14, 51, 184, 0.1),
                                  shape: BoxShape.circle),
                              child: const Center(
                                child: Text(
                                  '03',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            title: const Text(
                              'Flexibility',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: const Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text(
                                  'Lorem ipsum dolor sit amet consectetur. Et eu vitae aliquet aliquet. Posuere vestibulum molestie dolor nullam. Lorem ipsum '),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 6,
                          child: ListTile(
                            minLeadingWidth: 100,
                            leading: Container(
                              height: 100,
                              width: 100,
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(14, 51, 184, 0.1),
                                  shape: BoxShape.circle),
                              child: const Center(
                                child: Text(
                                  '04',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            title: const Text(
                              'Accountability',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: const Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text(
                                  'Lorem ipsum dolor sit amet consectetur. Et eu vitae aliquet aliquet. Posuere vestibulum molestie dolor nullam. Lorem ipsum '),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        : Column(
            children: [
              const Text(
                'Our Core Values',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: SizedBox(
                  height: 330,
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
                                          ? Colors.black87
                                          : const Color.fromARGB(
                                              255, 249, 243, 243),
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
                                        child: Text(
                                          ourValue[index]['level'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
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

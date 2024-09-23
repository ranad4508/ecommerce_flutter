import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rider_app/Widgets/track_order_form_widget.dart';


class TrackOrderPage extends StatefulWidget {
  const TrackOrderPage({super.key});

  @override
  State<TrackOrderPage> createState() => _TrackOrderPageState();
}

class _TrackOrderPageState extends State<TrackOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MediaQuery.of(context).size.width >= 1100 ? null : AppBar(),
      body: MediaQuery.of(context).size.width >= 1100
          ? Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: Row(
                    
                    children: [
                      Expanded(
                        flex: 5,
                        child: Image.network(
                          'https://static.vecteezy.com/system/resources/previews/015/541/158/non_2x/man-hand-holds-smartphone-with-city-map-gps-navigator-on-smartphone-screen-mobile-navigation-concept-modern-simple-flat-design-for-web-banners-web-infographics-flat-cartoon-illustration-vector.jpg',
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                          scale: 1,
                        ),
                      ),
                      const Expanded(
                          flex: 7,
                          child: SizedBox(child: TrackOrderFormWidget()))
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      context.push('/');
                    },
                    child: Image.asset(
                      'assets/image/new logo.png',
                      scale: 17,
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: TrackOrderFormWidget()),
    );
  }
}

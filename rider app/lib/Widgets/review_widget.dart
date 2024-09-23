import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rider_app/Model/rating.dart';

class ReviewWidget extends StatefulWidget {
  final String productUID;
  const ReviewWidget({super.key, required this.productUID});

  @override
  State<ReviewWidget> createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  bool ratingStatus = true;

  Future<List<RatingModel>> getRating() {
    return FirebaseFirestore.instance
        .collection('Products')
        .doc(widget.productUID)
        .collection('Ratings')
        .get()
        .then((event) {
      if (event.docs.isNotEmpty) {
        setState(() {
          ratingStatus = true;
        });
      } else {
        setState(() {
          ratingStatus = false;
        });
      }
      return event.docs
          .map((e) => RatingModel.fromMap(e.data(), e.id))
          .toList();
    });
  }

  @override
  void initState() {
    getRating();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RatingModel>>(
        future: getRating(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ratingStatus == false
                ? SizedBox(
                  width: double.infinity,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                              'No review has been made on this product')
                          .tr()),
                )
                : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        RatingModel ratingModel = snapshot.data![index];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: ClipOval(
                                  child: Image.network(
                                "https://eitrawmaterials.eu/wp-content/uploads/2016/09/person-icon.png",
                                height: 35,
                                fit: BoxFit.cover,
                                width: 35,
                              )),
                              title: Text(ratingModel.fullname),
                              subtitle: RatingBarIndicator(
                                rating: ratingModel.rating.toDouble(),
                                itemBuilder: (context, index) =>
                                    const Icon(
                                  Icons.star,
                                  color: Colors.orange,
                                ),
                                itemCount: 5,
                                itemSize: 15,
                                direction: Axis.horizontal,
                              ),
                              trailing: Text(ratingModel.timeCreated),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20),
                              child: Text(
                                ratingModel.review,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        );
                      }),
                );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

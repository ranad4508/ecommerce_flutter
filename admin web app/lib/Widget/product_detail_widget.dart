// ignore_for_file: avoid_print

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../Models/products_model.dart';
import '../Models/rating_model.dart';

class ProductDetails extends StatefulWidget {
  final ProductsModel productsModel;
  final String currency;
  const ProductDetails(
      {super.key, required this.productsModel, required this.currency});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Future<List<RatingModel>> getRating() {
    return FirebaseFirestore.instance
        .collection('Products')
        .doc(widget.productsModel.productID)
        .collection('Ratings')
        .get()
        .then((event) => event.docs
            .map((e) => RatingModel.fromMap(e.data(), e.id))
            .toList());
  }

  num ratingAndReview = 0;
  num totalUser = 0;
  getRatingAndReview() {
    FirebaseFirestore.instance
        .collection('Products')
        .doc(widget.productsModel.productID)
        .collection('Ratings')
        .get()
        .then((val) {
      num rating = val.docs.fold(0, (tot, doc) => tot + doc.data()['rating']);
      num totalUserRating = val.docs.length;
      setState(() {
        ratingAndReview = (rating / totalUserRating).roundToDouble();
        totalUser = totalUserRating;
      });
    });
    print('$ratingAndReview is the average rating');
    return ratingAndReview;
  }

  @override
  void initState() {
    getRatingAndReview();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      // width: MediaQuery.of(context).size.width >= 1100
      //     ? MediaQuery.of(context).size.width / 1.5
      //     : MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
          child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Product Details').tr(),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.clear))
            ],
          ),
        ),
        SizedBox(
            height: MediaQuery.of(context).size.height / 2.5,
            width: double.infinity,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(40.0),
                    bottomLeft: Radius.circular(40.0)),
              ),
              child: CarouselSlider(
                options: CarouselOptions(),
                items: [
                  widget.productsModel.image1 == ''
                      ? Image.network(
                          'https://cdn.iconscout.com/icon/free/png-256/gallery-187-902099.png',
                          fit: BoxFit.cover)
                      : Image.network(widget.productsModel.image1),
                  widget.productsModel.image2 == ''
                      ? Image.network(
                          'https://cdn.iconscout.com/icon/free/png-256/gallery-187-902099.png',
                          fit: BoxFit.cover)
                      : Image.network(widget.productsModel.image2),
                  widget.productsModel.image3 == ''
                      ? Image.network(
                          'https://cdn.iconscout.com/icon/free/png-256/gallery-187-902099.png',
                          fit: BoxFit.cover)
                      : Image.network(widget.productsModel.image3),
                ],
              ),
            )),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(
                child: Text(widget.productsModel.name,
                    maxLines: 2,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  '${widget.currency}${widget.productsModel.unitPrice1.toString()}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  children: [
                    RatingBarIndicator(
                      rating:
                          totalUser == 0 ? 0 : getRatingAndReview().toDouble(),
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.orange,
                      ),
                      itemCount: 5,
                      itemSize: 20,
                      direction: Axis.horizontal,
                    ),
                    const SizedBox(width: 5),
                    Text('(${totalUser.toString()})',
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            children: [
              Text(
                '${widget.currency}${widget.productsModel.unitOldPrice1.toString()}',
                style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough),
              ),
              const SizedBox(width: 5),
              Text(
                '-${widget.productsModel.percantageDiscount.toString()}',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ),
        ExpansionTile(
          leading: const Icon(Icons.list),
          initiallyExpanded: true,
          title: const Text('Other Variants',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
              .tr(),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: SizedBox(
                height: 60,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.productsModel.unitname1,
                              style: const TextStyle(
                                color: Colors.grey,
                              )),
                          Row(children: [
                            Text(
                                '${widget.currency}${widget.productsModel.unitPrice1.toString()}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 5),
                            Text(
                              '${widget.currency}${widget.productsModel.unitOldPrice1.toString()}',
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough),
                            ),
                          ])
                        ]),
                  ),
                ),
              ),
            ),
            widget.productsModel.unitname2 == ''
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: SizedBox(
                      height: 60,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.productsModel.unitname2,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    )),
                                Row(children: [
                                  Text(
                                      '${widget.currency}${widget.productsModel.unitPrice2.toString()}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 5),
                                  Text(
                                    '${widget.currency}${widget.productsModel.unitOldPrice2.toString()}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                ])
                              ]),
                        ),
                      ),
                    ),
                  ),
            widget.productsModel.unitname3 == ''
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: SizedBox(
                      height: 60,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.productsModel.unitname3,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    )),
                                Row(children: [
                                  Text(
                                      '${widget.currency}${widget.productsModel.unitPrice3.toString()}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 5),
                                  Text(
                                    '${widget.currency}${widget.productsModel.unitOldPrice3.toString()}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                ])
                              ]),
                        ),
                      ),
                    ),
                  ),
            widget.productsModel.unitname4 == ''
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: SizedBox(
                      height: 60,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.productsModel.unitname4,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    )),
                                Row(children: [
                                  Text(
                                      '${widget.currency}${widget.productsModel.unitPrice4.toString()}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 5),
                                  Text(
                                    '${widget.currency}${widget.productsModel.unitOldPrice4.toString()}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                ])
                              ]),
                        ),
                      ),
                    ),
                  ),
            widget.productsModel.unitname5 == ''
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: SizedBox(
                      height: 60,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.productsModel.unitname5,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    )),
                                Row(children: [
                                  Text(
                                      '${widget.currency}${widget.productsModel.unitPrice5.toString()}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 5),
                                  Text(
                                    '${widget.currency}${widget.productsModel.unitOldPrice5.toString()}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                ])
                              ]),
                        ),
                      ),
                    ),
                  ),
            widget.productsModel.unitname6 == ''
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: SizedBox(
                      height: 60,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.productsModel.unitname6,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    )),
                                Row(children: [
                                  Text(
                                      '${widget.currency}${widget.productsModel.unitPrice6.toString()}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 5),
                                  Text(
                                    '${widget.currency}${widget.productsModel.unitOldPrice6.toString()}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                ])
                              ]),
                        ),
                      ),
                    ),
                  ),
            widget.productsModel.unitname7 == ''
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: SizedBox(
                      height: 60,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.productsModel.unitname7,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    )),
                                Row(children: [
                                  Text(
                                      '${widget.currency}${widget.productsModel.unitPrice7.toString()}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 5),
                                  Text(
                                    '${widget.currency}${widget.productsModel.unitOldPrice7.toString()}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                ])
                              ]),
                        ),
                      ),
                    ),
                  )
          ],
        ),
        ExpansionTile(
            initiallyExpanded: true,
            leading: const Icon(
              Icons.rate_review,
            ),
            title: const Text('Product Review',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                .tr(),
            children: [
              FutureBuilder<List<RatingModel>>(
                  future: getRating(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            RatingModel ratingModel = snapshot.data![index];
                            return Column(
                              children: [
                                ListTile(
                                  leading: ratingModel.profilePicture == ''
                                      ? ClipOval(
                                          child: Image.network(
                                          "https://eitrawmaterials.eu/wp-content/uploads/2016/09/person-icon.png",
                                          height: 50,
                                          fit: BoxFit.cover,
                                          width: 50,
                                        ))
                                      : ClipOval(
                                          child: Image.network(
                                            ratingModel.profilePicture,
                                            height: 50,
                                            fit: BoxFit.cover,
                                            width: 50,
                                          ),
                                        ),
                                  title: Text(ratingModel.fullname),
                                  subtitle: RatingBarIndicator(
                                    rating: ratingModel.rating.toDouble(),
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                    ),
                                    itemCount: 5,
                                    itemSize: 20,
                                    direction: Axis.horizontal,
                                  ),
                                  trailing: Text(ratingModel.timeCreated),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      ratingModel.review,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          });
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  })
            ])
      ])),
    ));
  }
}

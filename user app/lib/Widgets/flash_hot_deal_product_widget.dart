import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/Model/formatter.dart';
import 'package:user_app/Model/products_model.dart';
import 'package:user_app/Widgets/cat_image_widget.dart';

import '../Model/constant.dart';

class ProductWidget extends StatefulWidget {
  final ProductsModel productsModel;
  const ProductWidget({super.key, required this.productsModel});

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  String currency = '';
  @override
  void initState() {
    getCurrency();
    super.initState();
  }

  getCurrency() {
    FirebaseFirestore.instance
        .collection('Currency Settings')
        .doc('Currency Settings')
        .get()
        .then((value) {
      setState(() {
        currency = value['Currency symbol'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: 170,
      child: Column(
        children: [
          // const Gap(10),
          Stack(
            children: [
              SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: CatImageWidget(
                    url: widget.productsModel.image1,
                    boxFit: 'cover',
                  )),
              widget.productsModel.percantageDiscount == 0
                  ? const SizedBox.shrink()
                  : Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            color: appColor,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                '-${widget.productsModel.percantageDiscount}%',
                                style: const TextStyle(color: Colors.white),
                              ),
                            )),
                      ))
            ],
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                widget.productsModel.name,
                maxLines: 1,
                // textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                '$currency${Formatter().converter(widget.productsModel.unitPrice1.toDouble())}',
                style: const TextStyle(fontWeight: FontWeight.bold),
                // maxLines: 1,
                // textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                '$currency${Formatter().converter(widget.productsModel.unitOldPrice1.toDouble())}',
                style: const TextStyle(
                    fontSize: 12,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey),
                // maxLines: 1,
                // textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../Model/sub_categories_model.dart';

class CollectionsExpandedTile extends StatefulWidget {
  final String cat;
  const CollectionsExpandedTile({super.key, required this.cat});

  @override
  State<CollectionsExpandedTile> createState() =>
      _CollectionsExpandedTileState();
}

class _CollectionsExpandedTileState extends State<CollectionsExpandedTile> {
  List<SubCategoriesModel> retails = [];
  getSubCollections() {
    return FirebaseFirestore.instance
        .collection('Collections')
        // .orderBy('index')
        .where('category', isEqualTo: widget.cat)
        .snapshots()
        .listen((value) {
      retails.clear();
      for (var element in value.docs) {
        setState(() {
          var fetchServices =
              SubCategoriesModel.fromMap(element.data(), element.id);
          retails.add(fetchServices);
        });
      }
    });
  }

  @override
  initState() {
    getSubCollections();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: retails.length,
        itemBuilder: (context, index) {
          SubCategoriesModel subCategoriesModel = retails[index];
          return ListTile(
            onTap: () {
              context.push('/collection/${subCategoriesModel.name}');
              context.pop();
            },
            title: Text(subCategoriesModel.name),
            // leading: const Icon(Icons.card_travel),
            trailing: const Icon(Icons.chevron_right),
          );
        });
  }
}

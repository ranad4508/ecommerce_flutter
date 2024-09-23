import 'package:admin_web_app/Models/pickup_address_model.dart';
import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class PickupAddressDatatable extends StatefulWidget {
  const PickupAddressDatatable({super.key});

  @override
  State<PickupAddressDatatable> createState() => _PickupAddressDatatableState();
}

class _PickupAddressDatatableState extends State<PickupAddressDatatable> {
  bool isLoaded = false;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int? _sortColumnIndex;
  final bool _sortAscending = true;

  Stream<QuerySnapshot>? yourStream;
  @override
  void initState() {
    getFeeds();
    super.initState();
  }

  List<PickupAddressModel> feeds = [];
  List<PickupAddressModel> feedsFilter = [];
  getFeeds() {
    setState(() {
      isLoaded = true;
    });
    FirebaseFirestore.instance
        .collection('Pickup Address')
        .snapshots()
        .listen((v) {
      setState(() {
        isLoaded = false;
      });
      feeds.clear();
      for (var e in v.docs) {
        var c = PickupAddressModel.fromMap(e.data(), e.id);
        setState(() {
          feeds.add(c);
        });
        // ignore: avoid_print
        print(isLoaded = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoaded == true
            ? const Center(child: CircularProgressIndicator(color: Colors.blue))
            : ListView(
                shrinkWrap: true,
                children: [
                  PaginatedDataTable(
                    header: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Pickup Address'),
                        ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const AlertDialog(
                                      title: Text('Add a new pickup address'),
                                      content: SizedBox(
                                        height: 500,
                                        width: 400,
                                        child: AddPickupAddress(),
                                      ),
                                    );
                                  });
                            },
                            child: const Text('Add a new pickup address'))
                      ],
                    ),
                    rowsPerPage: _rowsPerPage,
                    onRowsPerPageChanged: (int? value) {
                      setState(() {
                        _rowsPerPage = value!;
                      });
                    },
                    source: VendorDataSource(feeds, context),
                    sortColumnIndex: _sortColumnIndex,
                    sortAscending: _sortAscending,
                    columns: <DataColumn>[
                      const DataColumn(
                        label: Text('Index'),
                      ),
                      DataColumn(
                        label: const Text('Store name').tr(),
                      ),
                      DataColumn(
                        label: const Text('Address').tr(),
                      ),
                      DataColumn(
                        label: const Text('Phone number').tr(),
                      ),
                      DataColumn(
                        label: const Text('Delete').tr(),
                      ),
                    ],
                  ),
                ],
              ));
  }
}

int numberOfdelivery = 0;

List<int> categoriesAmount = [];

class VendorDataSource extends DataTableSource {
  final List<PickupAddressModel> vendor;
  VendorDataSource(this.vendor, this.context);
  final BuildContext context;
  final int _selectedCount = 0;

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= vendor.length) return null;
    final PickupAddressModel result = vendor[index];
    return DataRow.byIndex(index: index, cells: <DataCell>[
      DataCell(Text('${index + 1}')),
      DataCell(Text(result.storename)),
      DataCell(Text(result.address)),
      DataCell(Text(result.phonenumber)),
      DataCell(InkWell(
          onTap: () {
            // FirebaseFirestore.instance
            //     .collection('Pickup Address')
            //     .doc(result.uid)
            //     .delete();
            Fluttertoast.showToast(
                msg: "You can't delete this because its a test mode".tr(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Theme.of(context).primaryColor,
                textColor: Colors.white,
                fontSize: 14.0);
          },
          child: const Text('Delete Pickup Address'))),
    ]);
  }

  @override
  int get rowCount => vendor.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}

class AddPickupAddress extends StatefulWidget {
  const AddPickupAddress({super.key});

  @override
  State<AddPickupAddress> createState() => _AddPickupAddressState();
}

class _AddPickupAddressState extends State<AddPickupAddress> {
  String address = '';
  String storename = '';
  String phonenumber = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextFormField(
            //  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.name,
            onChanged: (v) {
              setState(() {
                storename = v;
              });
            },
            decoration: const InputDecoration(hintText: 'Enter Store Name'),
          ),
          const SizedBox(height: 20),
          TextFormField(
            //  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.phone,
            onChanged: (v) {
              setState(() {
                phonenumber = v;
              });
            },
            decoration: const InputDecoration(hintText: '+234 XXXX XXXX XXXX'),
          ),
          const SizedBox(height: 20),
          TextFormField(
            readOnly: true,
            //  inputFormatters: [FilteringTextInputFormatter.digitsOnly],

            decoration: InputDecoration(hintText: address),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () async {
                var result = await showModal(
                    context: context,
                    builder: (context) {
                      return const OpenStreetPage();
                    });
                setState(() {
                  address = result;
                  // ignore: avoid_print
                  print(address);
                });
              },
              child: const Text('Select Address')),
          const SizedBox(height: 40),
          ElevatedButton(
              onPressed: () {
                if (storename == '' || phonenumber == '' || address == '') {
                  Fluttertoast.showToast(
                      msg: "All fields are required",
                      backgroundColor: Colors.blue.shade800,
                      textColor: Colors.white);
                } else {
                  FirebaseFirestore.instance.collection('Pickup Address').add({
                    'address': address,
                    'storename': storename,
                    'phonenumber': phonenumber
                  }).then((value) {
                    context.pop();
                    Fluttertoast.showToast(
                        msg: "Pickup Successfully Created",
                        backgroundColor: Colors.blue.shade800,
                        textColor: Colors.white);
                  });
                }
              },
              child: const Text('Upload Pick up address'))
        ],
      ),
    );
  }
}

class OpenStreetPage extends StatefulWidget {
  const OpenStreetPage({super.key});

  @override
  State<OpenStreetPage> createState() => _OpenStreetPageState();
}

class _OpenStreetPageState extends State<OpenStreetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OpenStreetMapSearchAndPick(
          // center: const LatLong(23, 89),
          buttonColor: Colors.blue,
          buttonText: 'Set Current Location',
          onPicked: (pickedData) {
            Navigator.pop(context, pickedData.addressName);
          }),
    );
  }
}

class OrderModel {
  final int weekNumber;
  final String date;
  final String day;
  final String marketID;
  final String vendorID;
  final String userID;
  final String deliveryAddress;
  final String houseNumber;
  final String closesBusStop;
  final String deliveryBoyID;
  final String status;
  final bool accept;
  final String orderID;
  final DateTime timeCreated;
  final num total;
  final num deliveryFee;
  final bool acceptDelivery;
  final bool? confirmationStatus;
  final String paymentType;
  final List<Map<dynamic, dynamic>> orders;
  final String uid;
  final String pickupAddress;
  final String pickupPhone;
  final String pickupStorename;
  final String instruction;
  final bool useCoupon;
  final num couponPercentage;
  final String couponTitle;

  OrderModel(
      {required this.marketID,
      required this.couponTitle,
      required this.couponPercentage,
      required this.useCoupon,
      required this.day,
      required this.instruction,
      required this.pickupAddress,
      required this.pickupPhone,
      required this.pickupStorename,
      required this.weekNumber,
      required this.date,
      required this.orderID,
      required this.orders,
      required this.uid,
      required this.acceptDelivery,
      required this.deliveryFee,
      required this.total,
      required this.vendorID,
      required this.paymentType,
      this.confirmationStatus,
      required this.userID,
      required this.timeCreated,
      required this.deliveryAddress,
      required this.houseNumber,
      required this.closesBusStop,
      required this.deliveryBoyID,
      required this.status,
      required this.accept});

  Map<String, dynamic> toMap() {
    return {
      'couponTitle': couponTitle,
      'useCoupon': useCoupon,
      'couponPercentage': couponPercentage,
      'pickupAddress': pickupAddress,
      'pickupStorename': pickupStorename,
      'pickupPhone': pickupPhone,
      'instruction': instruction,
      'weekNumber': weekNumber,
      'date': date,
      "day": day,
      'paymentType': paymentType,
      'marketID': marketID,
      'orderID': orderID,
      'orders': orders,
      'acceptDelivery': acceptDelivery,
      'deliveryFee': deliveryFee,
      'total': total,
      'vendorID': vendorID,
      'userID': userID,
      'timeCreated': timeCreated,
      'deliveryAddress': deliveryAddress,
      'houseNumber': houseNumber,
      'closesBusStop': closesBusStop,
      'deliveryBoyID': deliveryBoyID,
      'status': status,
      'confirmationStatus': confirmationStatus,
      'accept': accept,
      'uid': uid
    };
  }
}

class OrderModel2 {
  final String couponTitle;
  final bool? confirmationStatus;
  final String marketID;
  final String vendorID;
  final String userID;
  final String deliveryAddress;
  final String houseNumber;
  final String closesBusStop;
  final String deliveryBoyID;
  final String status;
  final bool accept;
  final String orderID;
  final DateTime timeCreated;
  final num total;
  final String uid;
  final num deliveryFee;
  final bool acceptDelivery;
  final List<OrdersList> orders;
  final String paymentType;
  final String pickupAddress;
  final String pickupPhone;
  final String pickupStorename;
  final String instruction;
  final bool useCoupon;
  final num couponPercentage;

  OrderModel2(
      {required this.marketID,
      required this.couponTitle,
      required this.useCoupon,
      required this.couponPercentage,
      required this.instruction,
      required this.pickupAddress,
      required this.pickupPhone,
      required this.pickupStorename,
      required this.uid,
      required this.orderID,
      required this.orders,
      required this.acceptDelivery,
      required this.deliveryFee,
      required this.total,
      required this.vendorID,
      required this.paymentType,
      required this.userID,
      required this.timeCreated,
      this.confirmationStatus,
      required this.deliveryAddress,
      required this.houseNumber,
      required this.closesBusStop,
      required this.deliveryBoyID,
      required this.status,
      required this.accept});

  OrderModel2.fromMap(
    Map<String, dynamic> data,
    String uid,
  )   : instruction = data['instruction'],
        couponTitle = data['couponTitle'],
        couponPercentage = data['couponPercentage'],
        useCoupon = data['usedCoupon'],
        pickupAddress = data['pickupAddress'],
        pickupPhone = data['pickupPhone'],
        pickupStorename = data['pickupStorename'],
        marketID = data['marketID'],
        orderID = data['orderID'],
        confirmationStatus = data['confirmationStatus'],
        orders = data['orders'],
        acceptDelivery = data['acceptDelivery'],
        deliveryFee = data['deliveryFee'],
        total = data['total'],
        vendorID = data['vendorID'],
        paymentType = data['paymentType'],
        userID = data['userID'],
        timeCreated = DateTime.parse(data['timeCreated']).toLocal(),
        deliveryAddress = data['deliveryAddress'],
        houseNumber = data['houseNumber'],
        closesBusStop = data['closesBusStop'],
        deliveryBoyID = data['deliveryBoyID'],
        status = data['status'],
        accept = data['accept'],
        uid = data['uid'];
}

class OrdersList {
  final int returnDuration;
  final String productName;
  final String selected;
  final num quantity;
  final String image;
  // final int price;
  final String category;
  final dynamic id;
  final num selectedPrice;
  final String productID;
  final num totalRating;
  final num totalNumberOfUserRating;
  final String status;
  // final DateTime? receivedDate;

  OrdersList(
      {required this.productName,
      required this.status,
      required this.id,
      //  this.receivedDate,
      required this.returnDuration,
      required this.selected,
      required this.productID,
      required this.image,
      required this.totalRating,
      required this.totalNumberOfUserRating,
      // required this.price,
      required this.selectedPrice,
      required this.category,
      required this.quantity});
  OrdersList.fromMap(Map<dynamic, dynamic> data)
      : productName = data['name'],
        selected = data['selected'],
        // receivedDate = DateTime.parse(data['receivedDate']).toLocal(),
        status = data['status'],
        returnDuration = data['returnDuration'],
        productID = data['productID'],
        totalNumberOfUserRating = data['totalNumberOfUserRating'],
        totalRating = data['totalRating'],
        image = data['image'],
        // price = data['newPrice'],
        quantity = data['quantity'],
        category = data['category'],
        selectedPrice = data['selectedPrice'],
        id = data['id'];
}

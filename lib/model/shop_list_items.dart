// ignore: camel_case_types
class GetShopList {
  final String id;
  final String name;
  final String shopName;
  final String mobile;
  final String email;
  final String address;
  final String pinCode;
  final String shopImage;
  final String latitude;
  final String longitude;

  // final String userType;

  GetShopList(
      this.id,
      this.shopName,
      this.name,
      this.mobile,
      this.email,
      this.address,
      this.pinCode,
      this.shopImage,
      this.latitude,
      this.longitude);
}

class GetServiceList {
  final String userId;
  final String serviceName;
  final String serviceId;

  GetServiceList(this.userId, this.serviceName, this.serviceId);
}

class GetItemListByService {
  final String itemId;
  final String userId;
  final String serviceId;
  final String itemName;
  final String rate;
  int _qty = 0;
  int _qtyPos = 0;
  String _qtyWisePrice;

  GetItemListByService(this.itemId, this.userId, this.serviceId, this.itemName,
      this.rate, this._qty, this._qtyPos, this._qtyWisePrice);
}
class OrderListModel {
  final String orderId;
  final String userId;
  final String shopId;
  final String orderDetails;
  final String totalAmount;
  final String address;
  final String orderDate;

  OrderListModel(this.orderId, this.userId, this.shopId, this.orderDetails, this.totalAmount, this.address, this.orderDate);
}
class ProductListModel {
  String _itemId;
  String _userId;
  String _serviceId;
  String _itemName;
  String _rate;
  int _qty = 0;
  int _qtyPos = 0;
  String _qtyWisePrice;

  ProductListModel(
      {String itemId,
      String userId,
      String serviceId,
      String itemName,
      String rate,
      int qty,
      int qtyPos,
      String qtyWisePrice}) {
    this._itemId = itemId;
    this._userId = userId;
    this._serviceId = serviceId;
    this._itemName = itemName;
    this._rate = rate;
    this._qty = qty;
    this._qtyPos = qtyPos;
    this._qtyWisePrice = qtyWisePrice;
  }

  String get itemId => _itemId;
  set itemId(String itemId) => _itemId = itemId;

  String get userId => _userId;
  set userId(String userId) => _userId = userId;

  String get serviceId => _serviceId;
  set serviceId(String serviceId) => _serviceId = serviceId;

  String get itemName => _itemName;
  set itemName(String itemName) => _itemName = itemName;

  String get rate => _rate;
  set rate(String rate) => _rate = rate;

  int get qty => _qty;
  set qty(int qty) => _qty = qty;

  int get qtyPos => _qtyPos;
  set qtyPos(int qtyPos) => _qtyPos = qtyPos;

  String get qtyWisePrice => _qtyWisePrice;
  set qtyWisePrice(String qtyWisePrice) => _qtyWisePrice = qtyWisePrice;




  ProductListModel.fromJson(Map<String, dynamic> json) {
    _itemId = json['itemId'];
    _userId = json['userId'];
    _serviceId = json['serviceId'];
    _itemName = json['itemName'];
    _rate = json['rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemId'] = this._itemId;
    data['userId'] = this._userId;
    data['serviceId'] = this._serviceId;
    data['itemName'] = this._itemName;
    data['rate'] = this._rate;

    return data;
  }
}

import 'package:flutter/material.dart';
import 'package:push_notification/OrderDetail/barber_model.dart';
import 'package:push_notification/OrderDetail/grocery_model.dart';
import 'package:push_notification/OrderDetail/order_detail_model.dart';
import 'package:push_notification/Utitlity/Constants.dart';
import 'package:url_launcher/url_launcher.dart';

enum MyTextStyle { largebold, mediumbold, largenormal, normal }
enum OrderedService { grocery, restaurant, maid, laundry, barber }

class OrderDetailWidget extends StatefulWidget {
  final OrderDetailArguments orderDetailArguments;

  const OrderDetailWidget({Key key, this.orderDetailArguments})
      : super(key: key);
  @override
  _OrderDetailWidgetState createState() => _OrderDetailWidgetState();
}

class _OrderDetailWidgetState extends State<OrderDetailWidget> {
  var showPriceBreakDown = false;
  var apiLoaded = false;
  var apiFailed = false;
  OrderDetailsResponse orderDetailsResponse;
  UserAppointmentDetailsResponse appointmentDetailResponse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _callServiceBasedAPIs();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _callServiceBasedAPIs() {
    switch (widget.orderDetailArguments.orderedService) {
      case OrderedService.grocery:
      case OrderedService.restaurant:
        _callOrderDetail(widget.orderDetailArguments.orderedService);
        break;
      default:
        _callAppointmentDetail(widget.orderDetailArguments.orderedService);
    }
  }

  _callOrderDetail(OrderedService service) {
    getOrderDetails(Resource(
      url: service == OrderedService.grocery
          ? 'https://brozapp.com/apiencrypt/morder_detail'
          : 'https://restaurant.brozapp.com/apiencrypt/morder_detail',
      request: orderDetailsRequestToJson(
        OrderDetailsRequest(
          userId: widget.orderDetailArguments.userId ?? "",
          orderId: widget.orderDetailArguments.orderID ?? "",
          language: 'en',
        ),
      ),
    )).then((value) {
      print(value);
      setState(() {
        apiLoaded = true;
        orderDetailsResponse = value;
      });
    }).catchError((onError) {
      setState(() {
        apiLoaded = true;
        apiFailed = true;
      });
    });
  }

  _callAppointmentDetail(OrderedService service) {
    appointmentDetails(
      Resource(
        url: service == OrderedService.barber
            ? 'http://barber.brozapp.com/apiencrypt/appointment/${widget.orderDetailArguments.orderID}'
            : service == OrderedService.maid
                ? 'http://maid.brozapp.com/apiencrypt/appointment/${widget.orderDetailArguments.orderID}'
                : 'http://laundry.brozapp.com/apiencrypt/appointment/${widget.orderDetailArguments.orderID}',
        request: userAppointmentDetailsRequestToJson(
          UserAppointmentDetailsRequest(
              groupId: widget.orderDetailArguments.orderID),
        ),
      ),
    ).then((value) {
      print(value);
      setState(() {
        apiLoaded = true;
        appointmentDetailResponse = value;
      });
    }).catchError((onError) {
      setState(() {
        apiLoaded = true;
        apiFailed = true;
      });
    });
  }

  Widget noDataView(String msg) => SizedBox.expand(
        child: Center(
          child: Text(
            msg,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order #${widget.orderDetailArguments.orderID}",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
      ),
      body: apiLoaded
          ? apiFailed
              ? noDataView(orderDetailsResponse != null
                  ? orderDetailsResponse.message ?? "Oops! something went wrong"
                  : "Oops! something went wrong")
              : _buildBodyWidget()
          : Center(
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.green[300]))),
    );
  }

  _buildBodyWidget() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _orderStatusWidget(),
          _customerInfoWidget(),
          _paymentOptionWidget(),
          _orderListWidget(),
          _priceBreakDownWidget(),
        ],
      ),
    );
  }

  //MARK: ORDER STATUS WIDGET
  Widget _orderStatusWidget() {
    var status = "";
    var id = -1;
    var orderCancellationReason = "";
    switch (widget.orderDetailArguments.orderedService) {
      case OrderedService.grocery:
      case OrderedService.restaurant:
        status = orderDetailsResponse.orderData.name ?? "";
        id = orderDetailsResponse.orderData.orderStatus ?? 0;
        orderCancellationReason = orderDetailsResponse
                .trackData[orderDetailsResponse.trackData.length - 1]
                .orderComments ??
            "";
        break;
      default:
        status = appointmentDetailResponse.responseData.statusName ?? "";
        id = appointmentDetailResponse.responseData.appointmentStatus ?? 0;
        orderCancellationReason =
            appointmentDetailResponse.responseData.description ?? "";
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: customBorder(),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            status,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: getColorForStatus('$id')),
          ),
          status.toLowerCase() == "cancelled" &&
                  orderCancellationReason.isNotEmpty
              ? Text(
                  status.toLowerCase() == "cancelled"
                      ? orderCancellationReason.isEmpty
                          ? ""
                          : "Reason: $orderCancellationReason"
                      : "",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  _customerInfoWidget() {
    var name = "";
    var email = "";
    var phone = "";
    var address = "";
    var date = "";
    var isOrder = false;
    switch (widget.orderDetailArguments.orderedService) {
      case OrderedService.grocery:
      case OrderedService.restaurant:
        name = orderDetailsResponse.deliveryDetails.customerName ?? "";
        email = orderDetailsResponse.deliveryDetails.email ?? "";
        phone = orderDetailsResponse.deliveryDetails.mobileNumber ?? "";
        address = orderDetailsResponse.deliveryDetails.userContactAddress ?? "";
        date = orderDetailsResponse.deliveryDetails.deliveryDate ?? "";
        isOrder = true;
        break;
      default:
        name = appointmentDetailResponse.responseData.client.name ?? "";
        email = appointmentDetailResponse.responseData.client.email ?? "";
        phone = appointmentDetailResponse.responseData.client.phoneNumber ?? "";
        address = appointmentDetailResponse.responseData.userAddress ?? "";
        address = address.isEmpty
            ? appointmentDetailResponse.responseData.outlet.address ?? ""
            : address;
        date = appointmentDetailResponse.responseData.appointmentDate ?? "";
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Container(
        decoration: customBorder(withCorner: true),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: customTextStyle(MyTextStyle.largebold),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    launch(('tel://$phone'));
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.call,
                        color: Colors.green,
                        size: 20,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(phone, style: customTextStyle(MyTextStyle.normal)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.mail_outline,
                      size: 20,
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                        child: Text(email,
                            style: customTextStyle(MyTextStyle.normal))),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_sharp,
                      size: 20,
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(address,
                          style: customTextStyle(MyTextStyle.normal)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.pending,
                      size: 20,
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                          isOrder
                              ? "Delivery at : $date"
                              : "Appointment at : $date",
                          style: customTextStyle(MyTextStyle.normal)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _paymentOptionWidget() {
    var payment = "";
    switch (widget.orderDetailArguments.orderedService) {
      case OrderedService.grocery:
      case OrderedService.restaurant:
        payment = orderDetailsResponse.deliveryDetails.name ?? "";

        break;
      default:
        payment = appointmentDetailResponse.responseData.paymentMode ?? "";
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Container(
        decoration: customBorder(withCorner: true),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  Icons.payment,
                  size: 20,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Payment Option",
                  style: customTextStyle(MyTextStyle.largebold),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      payment,
                      style: customTextStyle(MyTextStyle.normal),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _orderListWidget() {
    List<OrderProductList> orderProductList = [];
    List<Services> servicesList = [];
    var isOrder = widget.orderDetailArguments.orderedService ==
            OrderedService.grocery ||
        widget.orderDetailArguments.orderedService == OrderedService.restaurant;
    switch (widget.orderDetailArguments.orderedService) {
      case OrderedService.grocery:
      case OrderedService.restaurant:
        orderProductList = orderDetailsResponse.orderProductList;

        break;
      default:
        servicesList = appointmentDetailResponse.responseData.services;
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Container(
        decoration: customBorder(withCorner: true),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isOrder ? "Orders List" : "Services List",
                    style: customTextStyle(MyTextStyle.largebold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Text(
                                  isOrder
                                      ? "${orderProductList[index].orderUnit}x"
                                      : servicesList[index].itemCount.isNotEmpty
                                          ? "${servicesList[index].itemCount}x"
                                          : "",
                                  style: customTextStyle(MyTextStyle.normal),
                                ),
                                SizedBox(
                                  width: isOrder
                                      ? 8
                                      : servicesList[index].itemCount.isNotEmpty
                                          ? "${servicesList[index].itemCount}x" ==
                                                  ""
                                              ? 0
                                              : 8
                                          : "" == ""
                                              ? 0
                                              : 8,
                                ),
                                Expanded(
                                  child: Text(
                                    isOrder
                                        ? "${orderProductList[index].productName}"
                                        : servicesList[index].serviceName !=
                                                null
                                            ? "${servicesList[index].serviceName}"
                                            : "${servicesList[index].categoryName}",
                                    style: customTextStyle(MyTextStyle.normal),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  textWithCurrency(double.tryParse(isOrder
                                      ? "${orderProductList[index].discountPrice}"
                                      : "${servicesList[index].cost.replaceAll("AED", "")}")),
                                  style: customTextStyle(MyTextStyle.normal),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                    itemCount:
                        isOrder ? orderProductList.length : servicesList.length,
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              )),
        ),
      ),
    );
  }

  _priceBreakDownWidget() {
    var total = 0.0;
    switch (widget.orderDetailArguments.orderedService) {
      case OrderedService.grocery:
      case OrderedService.restaurant:
        total =
            double.tryParse(orderDetailsResponse.deliveryDetails.totalAmount);

        break;
      default:
        total =
            double.tryParse(appointmentDetailResponse.responseData.totalCost);
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        decoration: customBorder(withCorner: true),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      showPriceBreakDown = !showPriceBreakDown;
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        "Total Payment",
                        style: customTextStyle(MyTextStyle.largebold),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            textWithCurrency(total),
                            style: customTextStyle(MyTextStyle.largenormal),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                          showPriceBreakDown
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          size: 20),
                    ],
                  ),
                ),
                showPriceBreakDown ? _priceDetails() : SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    );
  }

  _priceDetails() {
    var subtotal = 0.0;
    var deliveryCharges = 0.0;
    var brozGold = 0.0;
    var brozSilver = 0.0;
    var couponAmount = 0.0;
    switch (widget.orderDetailArguments.orderedService) {
      case OrderedService.grocery:
      case OrderedService.restaurant:
        subtotal =
            double.tryParse("${orderDetailsResponse.deliveryDetails.subTotal}");
        deliveryCharges = double.tryParse(
            "${orderDetailsResponse.deliveryDetails.deliveryCharge}");
        brozGold = double.tryParse(
            "${orderDetailsResponse.deliveryDetails.walletAmountUsed}");
        couponAmount = double.tryParse(
            "${orderDetailsResponse.deliveryDetails.couponAmount}");
        break;
      default:
    }
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        subtotal > 0
            ? Row(
                children: [
                  Text(
                    "Sub Total",
                    style: customTextStyle(MyTextStyle.largenormal),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        textWithCurrency(subtotal),
                        style: customTextStyle(MyTextStyle.largenormal),
                      ),
                    ),
                  ),
                ],
              )
            : SizedBox.shrink(),
        SizedBox(
          height: subtotal > 0 ? 8 : 0,
        ),
        deliveryCharges > 0
            ? Row(
                children: [
                  Text(
                    "Delivery charge",
                    style: customTextStyle(MyTextStyle.largenormal),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        textWithCurrency(deliveryCharges),
                        style: customTextStyle(MyTextStyle.largenormal),
                      ),
                    ),
                  ),
                ],
              )
            : SizedBox.shrink(),
        SizedBox(
          height: deliveryCharges > 0 ? 8 : 0,
        ),
        brozGold > 0
            ? Row(
                children: [
                  Text(
                    "Broz Gold",
                    style: customTextStyle(MyTextStyle.largenormal),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "- ${textWithCurrency(brozGold)}",
                        style: customTextStyle(MyTextStyle.largenormal),
                      ),
                    ),
                  ),
                ],
              )
            : SizedBox.shrink(),
        SizedBox(
          height: brozSilver > 0 ? 8 : 0,
        ),
        brozSilver > 0
            ? Row(
                children: [
                  Text(
                    "Broz Silver",
                    style: customTextStyle(MyTextStyle.largenormal),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "- ${textWithCurrency(brozSilver)}",
                        style: customTextStyle(MyTextStyle.largenormal),
                      ),
                    ),
                  ),
                ],
              )
            : SizedBox.shrink(),
        SizedBox(
          height: brozSilver > 0 ? 8 : 0,
        ),
        couponAmount > 0
            ? Row(
                children: [
                  Text(
                    "Coupon Discount",
                    style: customTextStyle(MyTextStyle.largenormal),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "- ${textWithCurrency(couponAmount)}",
                        style: customTextStyle(MyTextStyle.largenormal),
                      ),
                    ),
                  ),
                ],
              )
            : SizedBox.shrink(),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  BoxDecoration customBorder(
      {bool withCorner = false, Color bgColor = Colors.white}) {
    return BoxDecoration(
      color: bgColor,
      borderRadius: withCorner
          ? BorderRadius.all(
              Radius.circular(8.0),
            )
          : null,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
      ],
    );
  }

  TextStyle customTextStyle(MyTextStyle textStyle) {
    switch (textStyle) {
      case MyTextStyle.largebold:
        return TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
        break;
      case MyTextStyle.largenormal:
        return TextStyle(fontSize: 16);
        break;
      case MyTextStyle.mediumbold:
        return TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
        break;
      case MyTextStyle.normal:
        return TextStyle(fontSize: 15);
        break;

      default:
        return TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
        break;
    }
  }

  Color getColorForStatus(String status) {
    switch (status.toLowerCase()) {
      case DELIEVERD:
      case COMPLETED:
        return Colors.green;
      case CANCELLED:
        return Colors.red;
      case DISPATCHED:
        return Colors.blueAccent;
      default:
        return Colors.black;
    }
  }

  bool orderProcessed(String status) {
    switch (status.toLowerCase()) {
      case DELIEVERD:
      case CANCELLED:
      case DISPATCHED:
      case COMPLETED:
        return true;
      default:
        return false;
    }
  }

  String textWithCurrency(double price) =>
      'AED ${price.toStringAsFixed(2).endsWith("0") ? removeDecimals(price.toStringAsFixed(2)) : price.toStringAsFixed(2)}';

  String removeDecimals(String price) {
    List<String> c = price.split("");
    c.removeLast();
    return c.join();
  }
}

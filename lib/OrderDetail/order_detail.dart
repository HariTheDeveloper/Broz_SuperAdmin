import 'package:broz_admin/OrderDetail/fitness_model.dart';
import 'package:flutter/material.dart';
import 'package:broz_admin/OrderDetail/barber_model.dart';
import 'package:broz_admin/OrderDetail/grocery_model.dart';
import 'package:broz_admin/OrderDetail/order_detail_model.dart';
import 'package:broz_admin/Utitlity/Constants.dart';
import 'package:url_launcher/url_launcher.dart';

enum MyTextStyle { largebold, mediumbold, largenormal, normal }
enum OrderedService { grocery, restaurant, maid, laundry, barber, fitness }

class OrderDetailWidget extends StatefulWidget {
  final OrderDetailArguments orderDetailArguments;

  const OrderDetailWidget({Key key, this.orderDetailArguments})
      : super(key: key);
  @override
  _OrderDetailWidgetState createState() => _OrderDetailWidgetState();
}

class _OrderDetailWidgetState extends State<OrderDetailWidget>
    with AppFormatter {
  var showPriceBreakDown = false;
  var apiLoaded = false;
  var apiFailed = false;
  OrderDetailsResponse orderDetailsResponse;
  UserAppointmentDetailsResponse appointmentDetailResponse;
  AppointmentDetailResponse trainerAppointmentDetailResponse;
  @override
  void initState() {
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
      case OrderedService.fitness:
        _callFitnessAppointmentDetail();
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

  _callFitnessAppointmentDetail() {
    appointmentDetailAPI(Resource(
            url: "http://brozfit.tk/apiencrypt/appointmentDetail",
            request: appointmentDetailRequestToJson(AppointmentDetailRequest(
                appointmentId: widget.orderDetailArguments.orderID ?? "",
                userId: widget.orderDetailArguments.userId ?? ""))))
        .then((value) {
      setState(() {
        apiLoaded = true;
        trainerAppointmentDetailResponse = value;
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
      case OrderedService.fitness:
        status = trainerAppointmentDetailResponse.responseData.statusName ?? "";
        id = trainerAppointmentDetailResponse.responseData.statusId ?? 0;
        orderCancellationReason =
            trainerAppointmentDetailResponse.responseData.description ?? "";
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
      case OrderedService.fitness:
        name = trainerAppointmentDetailResponse.responseData.userName;
        email = trainerAppointmentDetailResponse.responseData.userEmail;
        phone = trainerAppointmentDetailResponse.responseData.userNumber;
        address =
            trainerAppointmentDetailResponse.responseData.userAddress ?? "";
        date = trainerAppointmentDetailResponse.responseData.deliveryDate ?? "";
        isOrder = false;
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
              isOrder == true
                  ? _replacemetInfoWidget(orderDetailsResponse.deliveryDetails)
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  _replacemetInfoWidget(DeliveryDetails deliveryDetails) {
    bool showWidget = false;
    double subTotal = double.tryParse(deliveryDetails.oldSubtotal) ?? 0;
    if (subTotal != 0) {
      showWidget = subTotal != deliveryDetails.subTotal &&
          deliveryDetails.replacementDescription != "";
    }
    return showWidget
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  Icons.info,
                  size: 20,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(deliveryDetails.replacementDescription,
                      style: customTextStyle(MyTextStyle.normal)),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  _paymentOptionWidget() {
    var payment = "";
    switch (widget.orderDetailArguments.orderedService) {
      case OrderedService.grocery:
      case OrderedService.restaurant:
        payment = orderDetailsResponse.deliveryDetails.name ?? "";
        break;
      case OrderedService.fitness:
        payment =
            trainerAppointmentDetailResponse.responseData.paymentMode ?? "";
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
    List<ServicesList> trainerServicesList = [];
    var isOrder = widget.orderDetailArguments.orderedService ==
            OrderedService.grocery ||
        widget.orderDetailArguments.orderedService == OrderedService.restaurant;

    switch (widget.orderDetailArguments.orderedService) {
      case OrderedService.grocery:
      case OrderedService.restaurant:
        orderProductList = orderDetailsResponse.orderProductList;
        break;
      case OrderedService.fitness:
        trainerServicesList =
            trainerAppointmentDetailResponse.responseData.servicesList;
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
                      var itemCount = "";
                      var spacing = 8.0;
                      var serviceName = "";
                      var servicePrice = "0";
                      switch (widget.orderDetailArguments.orderedService) {
                        case OrderedService.grocery:
                        case OrderedService.restaurant:
                          itemCount = "${orderProductList[index].orderUnit}x";
                          serviceName =
                              "${orderProductList[index].productName}";
                          servicePrice =
                              "${orderProductList[index].discountPrice}";
                          break;
                        case OrderedService.fitness:
                          itemCount = "";
                          spacing = 0;
                          serviceName = trainerServicesList[index].name;
                          servicePrice =
                              trainerServicesList[index].discountPrice;
                          break;
                        default:
                          itemCount = servicesList[index].itemCount.isNotEmpty
                              ? "${servicesList[index].itemCount}x"
                              : "1x";
                          spacing = servicesList[index].itemCount.isNotEmpty
                              ? "${servicesList[index].itemCount}x" == ""
                                  ? 0
                                  : 8
                              : 0;
                          serviceName = servicesList[index].serviceName != null
                              ? "${servicesList[index].serviceName}"
                              : "${servicesList[index].categoryName}";
                          servicePrice =
                              "${servicesList[index].cost.replaceAll("AED", "")}";
                      }
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Text(
                                  itemCount,
                                  style: customTextStyle(MyTextStyle.normal),
                                ),
                                SizedBox(
                                  width: spacing,
                                ),
                                Expanded(
                                  child: Text(
                                    serviceName,
                                    style: customTextStyle(MyTextStyle.normal),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  textWithCurrency(
                                      double.tryParse(servicePrice)),
                                  style: customTextStyle(MyTextStyle.normal),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                    itemCount: isOrder
                        ? orderProductList.length
                        : widget.orderDetailArguments.orderedService ==
                                OrderedService.fitness
                            ? trainerServicesList.length
                            : servicesList.length,
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
      case OrderedService.fitness:
        total = double.tryParse(
            trainerAppointmentDetailResponse.responseData.totalPrice);
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
    var transActionAmount = 0.0;
    var toPay = 0.0;
    switch (widget.orderDetailArguments.orderedService) {
      case OrderedService.grocery:
      case OrderedService.restaurant:
        subtotal = double.tryParse(
                "${orderDetailsResponse.deliveryDetails.subTotal}") ??
            0;
        deliveryCharges = double.tryParse(
                "${orderDetailsResponse.deliveryDetails.deliveryCharge}") ??
            0;
        brozGold = double.tryParse(
                "${orderDetailsResponse.deliveryDetails.brozGold ?? orderDetailsResponse.deliveryDetails.walletAmountUsed}") ??
            0;
        brozSilver = double.tryParse(
                "${orderDetailsResponse.deliveryDetails.brozSilver}") ??
            0;
        couponAmount = double.tryParse(
                "${orderDetailsResponse.deliveryDetails.couponAmount}") ??
            0;
        transActionAmount = double.tryParse(
                "${orderDetailsResponse.deliveryDetails.transactionAmount}") ??
            0;
        toPay =
            double.tryParse("${orderDetailsResponse.deliveryDetails.toPay}") ??
                0;
        break;
      case OrderedService.fitness:
        brozGold = double.tryParse(
                "${trainerAppointmentDetailResponse.responseData.brozGold}") ??
            0;
        brozSilver = double.tryParse(
                "${trainerAppointmentDetailResponse.responseData.brozSilver}") ??
            0;
        transActionAmount = double.tryParse(
                "${trainerAppointmentDetailResponse.responseData.transactionAmount}") ??
            0;
        toPay = double.tryParse(
                "${trainerAppointmentDetailResponse.responseData.toPay}") ??
            0;
        break;
      default:
        brozGold = double.tryParse(
                "${appointmentDetailResponse.responseData.brozGold}") ??
            0;
        brozSilver = double.tryParse(
                "${appointmentDetailResponse.responseData.brozSilver}") ??
            0;
        transActionAmount = double.tryParse(
                "${appointmentDetailResponse.responseData.transactionAmount}") ??
            0;
        toPay = double.tryParse(
                "${appointmentDetailResponse.responseData.toPay}") ??
            0;
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
          height: brozGold > 0 ? 8 : 0,
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
          height: couponAmount > 0 ? 10 : 0,
        ),
        transActionAmount > 0
            ? Row(
                children: [
                  Text(
                    "Paid online",
                    style: customTextStyle(MyTextStyle.largenormal),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "- ${textWithCurrency(transActionAmount)}",
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
        Row(
          children: [
            Text(
              "To Pay",
              style: customTextStyle(MyTextStyle.largebold),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${textWithCurrency(toPay)}",
                  style: customTextStyle(MyTextStyle.largebold),
                ),
              ),
            ),
          ],
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

  @override
  StatefulElement createElement() {
    // TODO: implement createElement
    throw UnimplementedError();
  }

  @override
  _OrderDetailWidgetState createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

mixin AppFormatter {
  String removeDecimals(String price) {
    List<String> c = price.split("");
    c.removeLast();
    return c.join();
  }
}

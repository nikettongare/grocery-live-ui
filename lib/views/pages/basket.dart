import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/app.dart';
import '../dialogs/custom_snackbar.dart';
import './product_detail.dart';
import '../../config/base_client.dart';
import '../../controllers/basket_controller.dart';
import '../components/custom_appbar.dart';
import '../components/custom_drawer.dart';
import '../dialogs/loading.dart';

class MyBasket extends StatefulWidget {
  const MyBasket({Key? key}) : super(key: key);

  @override
  State<MyBasket> createState() => _MyBasketState();
}

class _MyBasketState extends State<MyBasket> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout({required double amount}) async {
    var options = {
      'key': 'rzp_test_Ht6uWiAdlZdVHA',
      'amount': num.parse(amount.toString()) * 100,
      'name': AppConfig.appName,
      'description': 'Basket checkout payment',
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    log('SUCCESS');
    log(response.paymentId.toString());
    LoadingDialog.show();

    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      dynamic res = await jsonDecode(prefs.getString('userData')!);

      BaseClient client = BaseClient();
      client
          .post(url: AppConfig.updateUser + res['_id'], payload: {
            'basket': [],
            'orders': res['orders'] +
                [
                  {
                    'paymentId': response.paymentId.toString(),
                    'orderItems': res['basket'],
                  }
                ]
          })
          .then((value) async => {
                await prefs.setString('userData', jsonEncode(value)),
                Get.find<BasketController>().getBasketList(),
                Get.back(),
                Get.toNamed('/orders'),
              })
          .catchError((error) => {
                Get.back(),
                CustomSnackBar.show(
                    "Error", "Unable To Update User Data On Sever!"),
              });
    } else {
      Get.back();
      CustomSnackBar.show("Error", "No User Found!");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    CustomSnackBar.show("Error", response.message.toString());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const CustomDrawer(),
        appBar: customAppbar(context),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: GetBuilder<BasketController>(
                    init: BasketController(),
                    builder: (basketController) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Basket Total",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20),
                                ),
                                Text(
                                  "₹${basketController.basketOurAmountTotal().toString()}",
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                              visible: basketController.basketList.isEmpty,
                              child: const Center(
                                child: Text(
                                  "Your basket is empty",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )),
                          Visibility(
                            visible: basketController.basketList.isNotEmpty,
                            child: Table(
                              border: TableBorder(
                                horizontalInside: BorderSide(
                                  width: 1,
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                              ),
                              children:
                                  basketController.basketList.map((product) {
                                return TableRow(children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 8, 5, 8),
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(() => ProductDetail(
                                            productId: product['id']));
                                      },
                                      child: SizedBox(
                                        height: 100,
                                        child: Card(
                                          elevation: 0,
                                          margin: EdgeInsets.zero,
                                          child: Row(
                                            children: [
                                              FadeInImage(
                                                height: 100,
                                                width: 100,
                                                placeholder: NetworkImage(
                                                    product['thumbnail']),
                                                image: NetworkImage(
                                                    product['thumbnail']),
                                                fit: BoxFit.cover,
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 4,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        product['title'],
                                                        maxLines: 2,
                                                        softWrap: true,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    ),
                                                    Text(
                                                      "₹ ${product['ourAmount']}",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 18),
                                                    ),
                                                    GetBuilder<
                                                            BasketController>(
                                                        init:
                                                            BasketController(),
                                                        builder:
                                                            (basketController) {
                                                          return Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  if (basketController.checkQuantity(
                                                                          productId:
                                                                              product['id']) ==
                                                                      1) {
                                                                    basketController.removeFromBasket(
                                                                        productId:
                                                                            product['id']);
                                                                  } else {
                                                                    basketController.decrement(
                                                                        productId:
                                                                            product['id']);
                                                                  }
                                                                },
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .remove_circle_outline_rounded,
                                                                  color: Color(
                                                                      0xff316879),
                                                                  size: 30,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                "${basketController.checkQuantity(productId: product['id'])}",
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Color(
                                                                      0xff316879),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              InkWell(
                                                                onTap: () => basketController
                                                                    .increment(
                                                                        productId:
                                                                            product['id']),
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .add_circle_outline_rounded,
                                                                  color: Color(
                                                                      0xff316879),
                                                                  size: 30,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                            ],
                                                          );
                                                        }),
                                                    const SizedBox(
                                                      height: 4,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]);
                              }).toList(),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          const Divider(
                            thickness: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Apply Coupon",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Wrap(
                                    children: const [
                                      Text(
                                        "See all",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                      Image(
                                        height: 25,
                                        width: 25,
                                        image: AssetImage(
                                            "assets/images/rightArrow.png"),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                            child: TextField(
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  helperText: "This is Valid coupon",
                                  helperStyle: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.green,
                                  ),
                                  hintText: "Enter Coupon Code",
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Image(
                                      height: 6,
                                      width: 6,
                                      image: AssetImage(
                                          "assets/images/offer_grey.png"),
                                    ),
                                  ),
                                  suffixIcon: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    child: InkWell(
                                        onTap: () {},
                                        child: const Text(
                                          "Apply",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w600),
                                        )),
                                  ),
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      10, 10, 10, 10)),
                            ),
                          ),
                          const Divider(
                            thickness: 10,
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(15, 20, 0, 20),
                            child: Text(
                              "Payment Detail",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Table(
                                border: TableBorder(
                                  horizontalInside: BorderSide(
                                    width: 1,
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                ),
                                columnWidths: const <int, TableColumnWidth>{
                                  0: FlexColumnWidth(1), // fixed to 100 width
                                  1: FlexColumnWidth(1),
                                },
                                children: [
                                  TableRow(children: [
                                    const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 4, 20, 4),
                                        child: Text(
                                          "MRP Total",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 4, 20, 4),
                                        child: Text(
                                            "₹${basketController.basketMrpAmountTotal().toString()}",
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300))),
                                  ]),
                                  TableRow(children: [
                                    const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 4, 20, 4),
                                        child: Text(
                                          "Saved Amount",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 4, 20, 4),
                                        child: Text(
                                            "₹${basketController.basketMrpAmountTotal() - basketController.basketOurAmountTotal()}",
                                            style: const TextStyle(
                                                color: Colors.green,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300))),
                                  ]),
                                  TableRow(children: [
                                    const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 4, 20, 4),
                                        child: Text(
                                          "Net Amount",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 4, 20, 4),
                                        child: Text(
                                            "₹${basketController.basketOurAmountTotal().toString()}",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300))),
                                  ]),
                                  TableRow(children: [
                                    const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 4, 20, 4),
                                        child: Text(
                                          "Delivery Charges",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 4, 20, 4),
                                        child: Text(
                                            basketController
                                                        .basketOurAmountTotal() >
                                                    500
                                                ? "0"
                                                : "40",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300))),
                                  ]),
                                ]),
                          ),
                          const SizedBox(
                            height: 100,
                          ),
                        ],
                      );
                    }),
              ),
            ),
            BottomAppBar(
              child: Container(
                height: 70,
                decoration: const BoxDecoration(
                  color: Colors.indigoAccent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: GetBuilder<BasketController>(
                    init: BasketController(),
                    builder: (basketController) {
                      return Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 8, 0, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Payable Amount",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "₹${basketController.basketOurAmountTotal()}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 22,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible:
                                basketController.basketOurAmountTotal() > 10,
                            child: InkWell(
                              onTap: () {
                                if (!kIsWeb) {
                                  openCheckout(
                                      amount: basketController
                                          .basketOurAmountTotal());
                                } else {
                                  CustomSnackBar.show("Msg",
                                      "Not Supported for web we working on it");
                                }
                              },
                              child: SizedBox(
                                height: 70,
                                width: 180,
                                child: Stack(
                                  children: [
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Card(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomLeft:
                                                    Radius.circular(10))),
                                        color: Colors.white,
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 5, 10, 5),
                                          child: Text(
                                            "Place Order",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Card(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        color: Colors.black,
                                        child: const Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.chevron_right_rounded,
                                              size: 50,
                                              color: Colors.white,
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

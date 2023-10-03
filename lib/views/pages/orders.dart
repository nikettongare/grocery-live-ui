import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './product_detail.dart';
import '../components/custom_appbar.dart';
import '../components/custom_drawer.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List ordersList = [];

  @override
  void didChangeDependencies() {
    voidUpdateOrdersList();
    super.didChangeDependencies();
  }

  void voidUpdateOrdersList() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      dynamic res = await jsonDecode(prefs.getString('userData')!);

      setState(() {
        ordersList = res['orders'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const CustomDrawer(),
        appBar: customAppbar(context),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Text(
                  "Your Orders",
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                ),
              ),
              const Divider(
                thickness: 10,
              ),
              Visibility(
                  visible: ordersList.isEmpty,
                  child: const Center(
                    child: Text(
                      "You Dont place any Orders yet \n Please go and buy something!",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )),
              Visibility(
                visible: ordersList.isNotEmpty,
                child: Table(
                  border: TableBorder(
                    horizontalInside: BorderSide(
                      width: 10,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  children: ordersList.map((order) {
                    List productList = order['orderItems'];

                    return TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Order Id ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16),
                                ),
                                Text(
                                  order['paymentId'].toString(),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Column(
                              children: productList.map((product) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(() => ProductDetail(
                                          productId: product['id']));
                                    },
                                    child: SizedBox(
                                      height: 80,
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
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "₹ ${product['ourAmount']}",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 18),
                                                      ),
                                                      Text(
                                                        "Quantity ${product['selectedCount']}",
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
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
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/product.dart';
import '../pages/product_detail.dart';
import '../../controllers/basket_controller.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BasketController>(
        init: BasketController(),
        builder: (basketController) {
          return InkWell(
            onTap: () {
              Get.to(() => ProductDetail(productId: product.id));
            },
            child: Card(
              elevation: 5,
              color: Colors.white,
              shape: const RoundedRectangleBorder(
                side: BorderSide(
                  width: 0.5,
                  color: Color(0xff316879),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                    child: FadeInImage(
                      image: NetworkImage(product.thumbnail),
                      fit: BoxFit.cover,
                      placeholder: NetworkImage(product.thumbnail),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 8, 8, 0),
                            child: Text(
                              product.title,
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 12),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 4, 10, 0),
                          child: Row(
                            children: [
                              Text(
                                "₹${product.ourAmount.toString()}",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "₹${product.mrpAmount.toString()}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  decorationColor: Colors.red,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 2, bottom: 8),
                          child: Text(
                            "Save ₹ ${product.mrpAmount - product.ourAmount}",
                            style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ),
                  (basketController.checkQuantity(productId: product.id) == 0)
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 6),
                          child: SizedBox(
                            height: 30,
                            child: Center(
                              child: MaterialButton(
                                onPressed: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  if (prefs.containsKey('userData')) {
                                    dynamic res = await jsonDecode(
                                        prefs.getString('userData')!);
                                    if (res['_id'].length > 0) {
                                      basketController.addToBasket(
                                          product: product);
                                    } else {
                                      Get.toNamed('/login');
                                    }
                                  } else {
                                    Get.toNamed('/login');
                                  }
                                },
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                color: Colors.indigoAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                height: 34,
                                child: Row(
                                  children: const [
                                    Expanded(
                                        child: Center(
                                      child: Text("ADD",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white)),
                                    )),
                                    SizedBox(
                                      height: 26,
                                      child: VerticalDivider(
                                          thickness: 1, color: Colors.white),
                                    ),
                                    Icon(Icons.add_circle_outline_rounded,
                                        color: Colors.white),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: SizedBox(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (basketController.checkQuantity(
                                            productId: product.id) ==
                                        1) {
                                      basketController.removeFromBasket(
                                          productId: product.id);
                                    } else {
                                      basketController.decrement(
                                          productId: product.id);
                                    }
                                  },
                                  child: const Icon(
                                    Icons.remove_circle_outline_rounded,
                                    color: Color(0xff316879),
                                    size: 32,
                                  ),
                                ),
                                Text(
                                  "${basketController.checkQuantity(productId: product.id)}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff316879),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => basketController.increment(
                                      productId: product.id),
                                  child: const Icon(
                                    Icons.add_circle_outline_rounded,
                                    color: Color(0xff316879),
                                    size: 32,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          );
        });
  }
}

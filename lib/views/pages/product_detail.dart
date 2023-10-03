import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/poster.dart';
import '../../models/product.dart';
import '../../config/app.dart';
import '../../config/base_client.dart';
import '../../controllers/basket_controller.dart';
import '../../models/product_detail.dart';
import '../components/carousel_slider.dart';
import '../components/custom_appbar.dart';
import '../components/custom_drawer.dart';

class ProductDetail extends StatelessWidget {
  final String productId;
  const ProductDetail({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const CustomDrawer(),
        appBar: customAppbar(context),
        body: FutureBuilder(
          initialData: {},
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    snapshot.error.toString(),
                  ),
                );
              } else if (snapshot.hasData) {
                List _response = snapshot.data as List;

                ProductD product = ProductD.fromJson(_response[0]);

                List<Poster> _sliderPosterList = [];

                for (var item in product.images) {
                  {
                    _sliderPosterList.add(Poster(thumbnail: item));
                  }
                }

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 15, 10, 10),
                              child: Text(
                                product.title,
                                textAlign: TextAlign.start,
                                softWrap: true,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: InkWell(
                                onTap: () {},
                                child: Text(
                                  product.brand,
                                  textAlign: TextAlign.start,
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                            CarouselSlider(
                              posterList: _sliderPosterList,
                              autoSlide: false,
                              hasLink: false,
                              height: 310,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 15, 16, 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "You Save ₹\t${product.mrpAmount.toDouble() - product.ourAmount.toDouble()}",
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "₹\t${product.ourAmount.toDouble()}",
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        "MRP: ₹ ${product.mrpAmount.toDouble()}\t",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey,
                                          decorationColor: Colors.red,
                                          fontWeight: FontWeight.w400,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Text(
                                    "\t(Inclusive of all taxes)",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 8,
                              color: Colors.grey[200],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 15, 16, 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "In Stock",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Sold by\t",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black
                                                  .withOpacity(0.6)),
                                        ),
                                        TextSpan(
                                          text: "${AppConfig.appName} Retail",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.lightBlue),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 8,
                              color: Colors.grey[200],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 15, 16, 5),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Product Description",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Column(
                                      children: product.description.map((item) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(item["key"],
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black)),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(item["value"],
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.black)),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    )
                                  ]),
                            ),
                            Divider(
                              thickness: 8,
                              color: Colors.grey[200],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 15, 16, 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Product Information",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Table(
                                    border: TableBorder(
                                      horizontalInside: BorderSide(
                                        width: 1,
                                        color: Colors.grey.withOpacity(0.3),
                                      ),
                                    ),
                                    children:
                                        product.information.map((listItem) {
                                      return TableRow(children: [
                                        Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 8, 20, 8),
                                            child: Text(
                                              listItem["key"],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w400),
                                            )),
                                        Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 8, 20, 8),
                                            child: Text(listItem["value"],
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w300))),
                                      ]);
                                    }).toList(),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    children: [
                                      Image(
                                        height: 20,
                                        width: 20,
                                        image: AssetImage((product.isVeg)
                                            ? "assets/images/veg.png"
                                            : "assets/images/non-veg.png"),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: "This is a ",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            TextSpan(
                                              text: (product.isVeg)
                                                  ? "Vegetarian "
                                                  : "Non-Vegetarian ",
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const TextSpan(
                                              text: "product.",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ), // ProductInformation(
                            Divider(
                              thickness: 8,
                              color: Colors.grey[200],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 15, 16, 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Product Features & Details",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Table(
                                    columnWidths: const <int, TableColumnWidth>{
                                      0: FixedColumnWidth(
                                          12.0), // fixed to 100 width
                                      1: FlexColumnWidth(),
                                    },
                                    children: product.feature.map((listItem) {
                                      return TableRow(children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Icon(
                                            Icons.circle,
                                            size: 8,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 5, 10, 10),
                                          child: Text(listItem,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w300)),
                                        ),
                                      ]);
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 8,
                              color: Colors.grey[200],
                            ),
                          ],
                        ),
                      ),
                    ),
                    BottomAppBar(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        height: 60,
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  "₹\t${product.ourAmount}",
                                  style: const TextStyle(
                                      fontSize: 24, color: Colors.white),
                                ),
                              ),
                            ),
                            GetBuilder<BasketController>(
                                init: BasketController(),
                                builder: (basketController) {
                                  return (basketController.checkQuantity(
                                              productId: product.id) ==
                                          0)
                                      ? SizedBox(
                                          height: 34,
                                          width: 110,
                                          child: Center(
                                            child: MaterialButton(
                                              onPressed: () async {
                                                final prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                if (prefs
                                                    .containsKey('userData')) {
                                                  dynamic res =
                                                      await jsonDecode(
                                                          prefs.getString(
                                                              'userData')!);
                                                  if (res['_id'].length > 0) {
                                                    basketController.addToBasket(
                                                        product: Product(
                                                            id: product.id,
                                                            title:
                                                                product.title,
                                                            thumbnail: product
                                                                .thumbnail,
                                                            mrpAmount: product
                                                                .mrpAmount,
                                                            ourAmount: product
                                                                .ourAmount,
                                                            brand:
                                                                product.brand,
                                                            isVeg:
                                                                product.isVeg,
                                                            keywords: product
                                                                .keywords));
                                                  } else {
                                                    Get.toNamed('/login');
                                                  }
                                                } else {
                                                  Get.toNamed('/login');
                                                }
                                              },
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              height: 34,
                                              child: Row(
                                                children: const [
                                                  Expanded(
                                                      child: Center(
                                                    child: Text("Add",
                                                        style: TextStyle()),
                                                  )),
                                                  SizedBox(
                                                    height: 26,
                                                    child: VerticalDivider(
                                                        thickness: 1,
                                                        color: Colors.black),
                                                  ),
                                                  Image(
                                                    height: 20,
                                                    width: 20,
                                                    image: AssetImage(
                                                        "assets/images/addToBasket.png"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          width: 130,
                                          height: 44,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  if (basketController
                                                          .checkQuantity(
                                                              productId:
                                                                  product.id) ==
                                                      1) {
                                                    basketController
                                                        .removeFromBasket(
                                                            productId:
                                                                product.id);
                                                  } else {
                                                    basketController.decrement(
                                                        productId: product.id);
                                                  }
                                                },
                                                child: const Icon(
                                                  Icons
                                                      .remove_circle_outline_rounded,
                                                  color: Colors.white,
                                                  size: 34,
                                                ),
                                              ),
                                              Text(
                                                "${basketController.checkQuantity(productId: product.id)}",
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () =>
                                                    basketController.increment(
                                                        productId: product.id),
                                                child: const Icon(
                                                  Icons
                                                      .add_circle_outline_rounded,
                                                  color: Colors.white,
                                                  size: 34,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                }),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            }

            return Column(
              children: [
                const SizedBox(
                  height: 200,
                ),
                Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Get.theme.primaryColor),
                  ),
                ),
              ],
            );
          },
          future: BaseClient().get(AppConfig.getProductDetail + productId),
        ),
      ),
    );
  }
}

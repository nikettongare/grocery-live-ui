import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/app.dart';
import '../../config/base_client.dart';
import '../../models/product.dart';
import '../components/custom_appbar.dart';
import '../components/custom_drawer.dart';
import '../components/product_card.dart';

class Explore extends StatelessWidget {
  final String keywords;

  const Explore({Key? key, required this.keywords}) : super(key: key);

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

                List<Product> _productList = [];

                for (var element in _response) {
                  _productList.add(Product.fromJson(element));
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: _productList.isNotEmpty,
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 180,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              mainAxisExtent: 280,
                            ),
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 20),
                            shrinkWrap: true,
                            itemCount: _productList.length,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, i) {
                              return ProductCard(product: _productList[i]);
                            }),
                      ),
                      Visibility(
                        visible: _productList.isEmpty,
                        child: const Text(
                          "No Product Found!",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 14),
                        ),
                      )
                    ],
                  ),
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
          future: BaseClient().post(
              url: AppConfig.productSearch, payload: {"keywords": keywords}),
        ),
      ),
    );
  }
}

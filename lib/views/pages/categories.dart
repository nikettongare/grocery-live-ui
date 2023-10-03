import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/categories.dart';
import './explore.dart';
import '../../config/app.dart';
import '../../config/base_client.dart';
import '../components/custom_appbar.dart';
import '../components/custom_drawer.dart';

class AllCategories extends StatelessWidget {
  const AllCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const CustomDrawer(),
        appBar: customAppbar(context),
        body: SingleChildScrollView(
            child: FutureBuilder(
          initialData: {},
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                log(snapshot.error.toString());
                return Center(
                  child: Text(
                    snapshot.error.toString(),
                  ),
                );
              } else if (snapshot.hasData) {
                List _response = snapshot.data as List;

                List<Categories> _categoriesList = [];

                for (var element in _response) {
                  _categoriesList.add(Categories.fromJson(element));
                }
                log(_response.toString());
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
                      child: Text(
                        "All Catagories",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w400),
                      ),
                    ),
                    GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          mainAxisExtent: 140,
                        ),
                        padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                        shrinkWrap: true,
                        itemCount: _categoriesList.length,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, i) {
                          return InkWell(
                            onTap: () {
                              Get.to(() => Explore(
                                    keywords: _categoriesList[i].keywords[0],
                                  ));
                            },
                            child: Card(
                              elevation: 5,
                              margin: EdgeInsets.zero,
                              shape: const RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1, color: Colors.black)),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Image(
                                    height: 90,
                                    width: 90,
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        _categoriesList[i].thumbnail),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        _categoriesList[i].title,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                        maxLines: 2,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
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
          future: BaseClient().get(AppConfig.getAllCategories),
        )),
      ),
    );
  }
}

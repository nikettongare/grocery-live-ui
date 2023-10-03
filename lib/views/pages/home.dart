import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/app.dart';
import '../../config/base_client.dart';
import '../../models/poster.dart';
import '../components/carousel_slider.dart';
import '../components/custom_appbar.dart';
import '../components/custom_drawer.dart';
import '../../models/product.dart';
import '../components/product_card.dart';
import '../../models/categories.dart';
import '../pages/explore.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                    ),
                  );
                } else if (snapshot.hasData) {
                  Map<String, dynamic> _response =
                      snapshot.data as Map<String, dynamic>;

                  List<Categories> _categoriesList = [];
                  List<Product> _productList = [];
                  List<Poster> _topPosterList = [];
                  List<Poster> _bottomPosterList = [];
                  List<Poster> _sliderPosterList = [];

                  if (_response.containsKey("categories")) {
                    _response["categories"].forEach((element) {
                      _categoriesList.add(Categories.fromJson(element));
                    });
                  }

                  if (_response.containsKey("products")) {
                    _response["products"].forEach((element) {
                      _productList.add(Product.fromJson(element));
                    });
                  }

                  if (_response.containsKey("posters")) {
                    _response["posters"].forEach((element) {
                      if (element["type"] == "top") {
                        _topPosterList.add(Poster.fromJson(element));
                      } else if (element["type"] == "bottom") {
                        _bottomPosterList.add(Poster.fromJson(element));
                      } else {
                        _sliderPosterList.add(Poster.fromJson(element));
                      }
                    });
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //// Categories --
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SizedBox(
                          height: 80,
                          child: ListView.builder(
                              itemExtent: 80,
                              scrollDirection: Axis.horizontal,
                              itemCount: _categoriesList.length,
                              itemBuilder: (context, i) {
                                return InkWell(
                                  onTap: () {
                                    Get.to(() => Explore(
                                          keywords:
                                              _categoriesList[i].keywords[0],
                                        ));
                                  },
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        height: 50,
                                        child: Center(
                                          child: Image(
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              _categoriesList[i].thumbnail,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            2, 0, 4, 0),
                                        child: Text(
                                          _categoriesList[i].title,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ),
                      //// Categories --/
                      /// Slider --
                      Table(
                        border: TableBorder(
                          horizontalInside: BorderSide(
                            width: 1,
                            color: Colors.grey.withOpacity(0.3),
                          ),
                        ),
                        children: _topPosterList.map((poster) {
                          return TableRow(children: [
                            InkWell(
                              onTap: () {
                                Get.to(() =>
                                    Explore(keywords: poster.keywords![0]));
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: poster.height!.toDouble(),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(poster.thumbnail),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),

                      CarouselSlider(
                        posterList: _sliderPosterList,
                        autoSlide: false, //Make it true in production
                        hasLink: true,
                        height: 160,
                      ),

                      Table(
                        border: TableBorder(
                          horizontalInside: BorderSide(
                            width: 1,
                            color: Colors.grey.withOpacity(0.3),
                          ),
                        ),
                        children: _bottomPosterList.map((poster) {
                          return TableRow(children: [
                            InkWell(
                              onTap: () {
                                Get.to(() =>
                                    Explore(keywords: poster.keywords![0]));
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: poster.height!.toDouble(),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(poster.thumbnail),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),

                      /// Slider --/
                      //// Top deals --
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                        child: Row(
                          children: [
                            const Text(
                              "Top Deals This Week",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 20),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                //TODO nav to explore product with all
                              },
                              child: Wrap(
                                children: const [
                                  Text(
                                    "See all",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
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
                      //// Top deals --/
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
            future: BaseClient().get(AppConfig.homePageData),
          ),
        ),
      ),
    );
  }
}

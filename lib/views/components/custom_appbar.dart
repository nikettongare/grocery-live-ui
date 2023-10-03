import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/app.dart';
import '../pages/explore.dart';
import '../../controllers/basket_controller.dart';

AppBar customAppbar(BuildContext context) {
  String keyword = '';
  return AppBar(
    elevation: 10,
    centerTitle: true,
    title: InkWell(
      onTap: () {
        Get.toNamed('/');
      },
      child: Text(
        AppConfig.appName,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w400, fontSize: 20),
      ),
    ),
    actions: [
      InkWell(
        onTap: () {
          Get.toNamed('/basket');
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 20, 10),
          child: SizedBox(
            height: 20,
            width: 30,
            child: Stack(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Image(
                    height: 20,
                    width: 20,
                    image: AssetImage("assets/images/basket white.png"),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: GetBuilder<BasketController>(
                      init: BasketController(),
                      builder: (basketController) {
                        return Container(
                          alignment: Alignment.lerp(
                              Alignment.topLeft, Alignment.topLeft, 0.2),
                          height: 18,
                          width: 18,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: (basketController.basketList.isNotEmpty)
                                  ? Colors.redAccent
                                  : Colors.transparent),
                          child: Center(
                              child: Text(
                            (basketController.basketList.isNotEmpty)
                                ? "${basketController.basketList.length}"
                                : " ",
                            style: const TextStyle(color: Colors.white),
                          )),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(55.0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 260,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
                cursorColor: Colors.black,
                maxLines: 1,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                    child: Image(
                      image: AssetImage("assets/images/search.png"),
                    ),
                  ),
                  hintText: "Find Something Yummy",
                  hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.black.withOpacity(0.6),
                      fontWeight: FontWeight.w600),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      )),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      )),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      )),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      5,
                    ),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
                onChanged: (value) {
                  keyword = value;
                },
                onSubmitted: (value) {
                  Get.to(() => Explore(keywords: keyword));
                },
              ),
            ),
            MaterialButton(
                minWidth: 60,
                height: 40,
                color: Colors.white,
                disabledColor: Colors.white,
                onPressed: () {
                  Get.to(() => Explore(keywords: keyword));
                },
                child: const Text(
                  "SEARCH",
                  style: TextStyle(color: Colors.black),
                ))
          ],
        ),
      ),
    ),
  );
}

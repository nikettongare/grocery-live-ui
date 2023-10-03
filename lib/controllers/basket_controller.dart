import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app.dart';
import '../models/product.dart';
import '../config/base_client.dart';
import '../views/dialogs/loading.dart';
import '../views/dialogs/custom_snackbar.dart';

class BasketController extends GetxController {
  List basketList = [];
  BaseClient client = BaseClient();

  @override
  void onInit() {
    getBasketList();
    super.onInit();
  }

  void getBasketList() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      dynamic res = await jsonDecode(prefs.getString('userData')!);
      basketList = res['basket'];
    }
    update();
  }

  void updateBasket() async {
    LoadingDialog.show();

    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      dynamic res = await jsonDecode(prefs.getString('userData')!);
      if (res['_id'].length > 0) {
        client
            .post(
                url: AppConfig.updateUser + res['_id'],
                payload: {'basket': basketList})
            .then((value) async => {
                  await prefs.setString('userData', jsonEncode(value)),
                  getBasketList(),
                  Get.back(),
                })
            .catchError((error) => {
                  Get.back(),
                  CustomSnackBar.show(
                      "Error", "Unable To Update Basket On Sever!"),
                });
      } else {
        Get.back();
        CustomSnackBar.show("Error", "Please Login First!");
      }
    } else {
      Get.back();
      CustomSnackBar.show("Error", "Please Login First!");
    }
  }

  void addToBasket({required Product product}) {
    basketList.add({
      'id': product.id,
      'title': product.title,
      'thumbnail': product.thumbnail,
      'mrpAmount': product.mrpAmount,
      'ourAmount': product.ourAmount,
      'brand': product.brand,
      'isVeg': product.isVeg,
      'keywords': product.keywords,
      'selectedCount': 1,
    });
    updateBasket();
  }

  void removeFromBasket({required String productId}) {
    basketList.removeWhere((element) => element["id"] == productId);
    updateBasket();
  }

  void increment({required String productId}) async {
    for (var element in basketList) {
      if (element["id"] == productId) {
        element["selectedCount"] += 1;
      }
    }
    updateBasket();
  }

  void decrement({required String productId}) async {
    for (var element in basketList) {
      if (element["id"] == productId) {
        element["selectedCount"] -= 1;
      }
    }
    updateBasket();
  }

  int checkQuantity({required String productId}) {
    int quantity = 0;
    for (var element in basketList) {
      if (element["id"] == productId && element["selectedCount"] > 0) {
        quantity = element["selectedCount"];
      }
    }
    return quantity;
  }

  double basketOurAmountTotal() {
    double basketTotal = 00.00;
    for (var element in basketList) {
      basketTotal += element["ourAmount"] * element["selectedCount"];
    }
    return basketTotal;
  }

  double basketMrpAmountTotal() {
    double basketTotal = 00.00;
    for (var element in basketList) {
      basketTotal += element["mrpAmount"] * element["selectedCount"];
    }
    return basketTotal;
  }
}

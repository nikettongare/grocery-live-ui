class AppConfig {
  static String appName = "MegaMart";

  static String baseURL =
      "https://e0a4-2405-201-1000-9eda-4d5a-bd73-6520-592e.ngrok-free.app"; //http://192.168.29.243:8080
  static String loginUser = '$baseURL/user/login';
  static String createUser = '$baseURL/user/create';
  static String updateUser = '$baseURL/user/update/';
  static String getUserOrders = '$baseURL/user/getOrders/';

  static String getAllCategories = '$baseURL/categories/all';

  static String homePageData = '$baseURL/homepagedata';
  static String productSearch = '$baseURL/product/search';
  static String getProductDetail = '$baseURL/product/detail/';
}

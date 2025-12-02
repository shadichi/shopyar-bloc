import 'package:shopyar/features/feature_home/domain/entities/home_data_entity.dart';

import '../../features/feature_add_edit_order/domain/entities/add_order_product_entity.dart';
import '../../features/feature_orders/domain/entities/orders_entity.dart';
import '../../features/feature_products/domain/entities/product_entity.dart';

class StaticValues{
  ///base INF
  static String shopName = '';
  static String userName = '';
  static String webService = '';
  static String passWord = '';
  static List shippingMethods= [];
  static List paymentMethods= [];
  static Map<String, dynamic> status= {};
  static HomeDataEntity? staticHomeDataEntity;

  static bool isDrawerOpen = false;

  static String versionNo = '';
  static String packageInfoVersionNo = '';

  ///order, product
  static List<OrdersEntity> staticOrders = [];
  static List<ProductEntity> staticProducts = [];
  static List<ProductEntity> staticAddOrderProducts = [];
  static List<ProductEntity> searchedProducts = [];
  static List<AddOrderProductEntity> staticCardProducts = [];
}
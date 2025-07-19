import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:shapyar_bloc/features/feature_orders/data/models/orders_model.dart';
import 'package:shapyar_bloc/features/feature_orders/presentation/widgets/show_pdf.dart';
import 'package:shapyar_bloc/test3.dart';
import '../../../feature_home/domain/entities/orders_entity.dart';
import '../../functions/OrderBottomSheet.dart';
import 'show_post_label.dart';
import '../../data/models/store_info.dart';
import '../screens/enter_inf_data.dart';

void OrderOptions(BuildContext context, dynamic ordersData, item) {
  String selectedStatus = '';

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Container(
       decoration: BoxDecoration(
         borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
         color: AppColors.background,
       ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildListTile(
                icon: Icons.edit,
                title: 'ویرایش سفارش',
                onTap: () => Navigator.pop(context),
              ),
              _buildDivider(),
              _buildListTile(
                icon: Icons.change_circle,
                title: 'تغییر وضعیت سفارش',
                onTap: () {
                  showFilterBottomSheet(context, (value) {
                    selectedStatus = value;
                  }, ordersData.id, selectedStatus);
                },
              ),
              _buildDivider(),
              _buildListTile(
                icon: Icons.local_post_office,
                title: 'ایجاد برچسب پستی',
                onTap: () => _handleStoreInfo(context),
              ),
              _buildDivider(),
              _buildListTile(
                icon: Icons.sticky_note_2,
                title: 'ایجاد فاکتور سفارش',
                onTap: () => Navigator.pushNamed(context, ShowPDF.routeName,arguments: PdfData(ordersEntity: ordersData, item: item)),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class PdfData {
  final OrdersModel ordersEntity;
  final int item;

  PdfData({required this.ordersEntity, required this.item});
}


Widget _buildListTile({required IconData icon, required String title, required VoidCallback onTap}) {
  return ListTile(
    leading: Icon(icon, color: AppColors.white),
    title: Text(title, style: TextStyle(color: AppColors.white)),
    onTap: onTap,
  );
}


Widget _buildDivider() {
  return Divider(color: AppColors.white70);
}


Future<void> _handleStoreInfo(BuildContext context) async {
  await Hive.openBox<StoreInfo>('storeBox');
  var storeBox = Hive.box<StoreInfo>('storeBox');
  var store = storeBox.get('storeInfo');

  if (store == null || store.storeName.isEmpty) {
    Navigator.pushNamed(context, EnterInfData.routeName);
  } else {
    Navigator.pushNamed(context, PdfViewerScreen.routeName, arguments: store);
  }

  await storeBox.close();
 // Navigator.pop(context);
}

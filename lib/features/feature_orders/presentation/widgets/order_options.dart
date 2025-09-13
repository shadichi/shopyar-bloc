import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:shapyar_bloc/features/feature_orders/data/models/orders_model.dart';
import 'package:shapyar_bloc/features/feature_orders/presentation/widgets/show_pdf.dart';
import '../../../../core/config/app-colors.dart';
import '../../../feature_add_edit_order/presentation/screens/product_form_screen.dart';
import '../../domain/entities/orders_entity.dart';
import '../../functions/OrderBottomSheet.dart';
import 'show_post_label.dart';
import '../../data/models/store_info.dart';
import '../screens/enter_inf_data.dart';

void OrderOptions(BuildContext context, dynamic ordersData, item, OrdersEntity? ordersEntity) {
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
         color: AppConfig.backgroundColor,
       ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildListTile(
                icon: Icons.edit,
                title: 'ویرایش سفارش',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ProductFormScreen.edit(ordersEntity: ordersEntity!)));

                  }, context: context
              ),
              _buildDivider(context),
              _buildListTile(
                icon: Icons.change_circle,
                title: 'تغییر وضعیت سفارش',
                onTap: () {
                  showFilterBottomSheet(context, (value) {
                    selectedStatus = value;
                  }, ordersData.id, selectedStatus);
                },
                  context: context
              ),
              _buildDivider(context),
              _buildListTile(
                icon: Icons.local_post_office,
                title: 'ایجاد برچسب پستی',
                onTap: () => _handleStoreInfo(context, ordersEntity),
                  context: context
              ),
              _buildDivider(context),
              _buildListTile(
                icon: Icons.sticky_note_2,
                title: 'ایجاد فاکتور سفارش',
                onTap: () => Navigator.pushNamed(context, ShowPDF.routeName,arguments: PdfData(ordersEntity: ordersData, item: item)),
                  context: context
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


Widget _buildListTile({required IconData icon, required String title, required VoidCallback onTap, required BuildContext context}) {
  return ListTile(
    leading: Icon(icon, color: AppConfig.white,size: AppConfig.calHeight(context, 3),),
    title: Text(title, style: TextStyle(color: AppConfig.white,fontSize: AppConfig.calFontSize(context, 3.5))),
    onTap: onTap,
  );
}


Widget _buildDivider(context) {
  return    Container(
      width: AppConfig.calWidth(context, 90),
      height: AppConfig.calHeight(context, 0.1),
      decoration: BoxDecoration(
          gradient:LinearGradient(
            colors: [AppConfig.firstLinearColor, AppConfig.secondLinearColor],)
      )
  );
}


Future<void> _handleStoreInfo(BuildContext context, ordersEntity) async {
  await Hive.openBox<StoreInfo>('storeBox');
  var storeBox = Hive.box<StoreInfo>('storeBox');
  var store = storeBox.get('storeInfo');

  if (store == null || store.storeName.isEmpty) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
      return EnterInfData(isFirstTime: true,ordersEntity: ordersEntity,);
    }));
  } else {
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return PdfViewerScreen(ordersEntity);
    }));
  }

 // await storeBox.close();
 // Navigator.pop(context);
}

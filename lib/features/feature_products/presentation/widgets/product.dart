import 'package:flutter/material.dart';
import 'package:shapyar_bloc/features/feature_products/domain/entities/product_entity.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../../core/colors/app-colors.dart';
import '../../../../core/config/app-colors.dart';
import '../bloc/products_status.dart';

class Product extends StatelessWidget {
  ProductEntity productsLoadedStatus;

  Product(this.productsLoadedStatus);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Card(
    //shadowColor: AppConfig.piChartSection3,
      child: Container(padding: EdgeInsets.symmetric(horizontal: AppConfig.calWidth(context, 3)),
        height: height * 0.17,
        width: width * 0.7,
        decoration: BoxDecoration(
          border: Border.all(color: AppConfig.borderColor, width: 0.2),
          /*gradient: LinearGradient(
              colors: [AppConfig.secondaryColor, Color(0xff6C7A96)]),*/
          color: AppConfig.secondaryColor,
          borderRadius: BorderRadius.circular(width * 0.02),
        ),
        child: Row(spacing: AppConfig.calWidth(context, 2),
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          Container(
          height: height * 0.09,
          width:  width * 0.17,
          decoration: BoxDecoration(color: Colors.green,
            borderRadius: BorderRadius.circular(AppConfig.calBorderRadiusSize(context)),

          ),
       //   clipBehavior: Clip.antiAlias,  // برای کلیپ شدن کانتینر
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConfig.calBorderRadiusSize(context)),
            child: (productsLoadedStatus.image != null &&
                productsLoadedStatus.image!.isNotEmpty)
                ? Image.network(
              productsLoadedStatus.image!,
              fit: BoxFit.cover,
            )
                : Image.asset(
              'assets/images/index.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
            SizedBox(
              width: AppConfig.calWidth(context, 59),
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                  productsLoadedStatus.name.toString(),
                                style:
                                TextStyle(fontSize: width * 0.03, color: Colors.white),
                                minFontSize: width * 0.001.toInt(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                  Container(
                    alignment: Alignment.center,
                    width: width * 0.2,
                    height: height * 0.03,
                    child: AutoSizeText(
                      productsLoadedStatus.price.toString().isEmpty
                          ? 'قیمت نامشخص'
                          : '${productsLoadedStatus.price.toString()} تومان',
                      style: TextStyle(
                          fontSize: width * 0.03,fontWeight: FontWeight.bold,
                          color: productsLoadedStatus.price.toString().isEmpty
                              ? Colors.red
                              : Colors.white),
                      minFontSize: width * 0.01.toInt(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
        Container(
          child: AutoSizeText(
            productsLoadedStatus.stockQuantity.toString().isEmpty
                ? 'موجودی نامشخص'
                : '${productsLoadedStatus.stockQuantity.toString()} موجودی',
            style: TextStyle(
                fontSize: width * 0.025,
                color: productsLoadedStatus.stockQuantity
                    .toString()
                    .isEmpty
                    ? Colors.red
                    : Colors.white),
            minFontSize: width * 0.01.toInt(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

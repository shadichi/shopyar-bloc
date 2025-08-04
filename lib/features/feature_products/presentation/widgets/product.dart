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
      child: Container(
        height: height * 0.13,
        width: width * 0.7,
        decoration: BoxDecoration(
          color: AppConfig.secondaryColor,
          borderRadius: BorderRadius.circular(width * 0.02),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(

                height: height * 0.07,
                width: width * 0.15,
                child: productsLoadedStatus.image.toString().isNotEmpty
                    ? Image.network(productsLoadedStatus.image.toString())
                    : Image.asset('assets/images/index.png')),
            Container(
padding: EdgeInsets.all(width*0.02),
              width: width*0.45,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(


                      child: AutoSizeText(
                        productsLoadedStatus.name.toString(),
                        style: TextStyle(
                            fontSize: width * 0.03, color: Colors.white),
                        minFontSize: width * 0.001.toInt(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                  Container(

                      // color: Colors.orange,
                      child: AutoSizeText(
                        productsLoadedStatus.stockQuantity.toString().isEmpty
                            ? 'موجودی نامشخص'
                            : '${productsLoadedStatus.stockQuantity.toString()} موجودی',
                        style: TextStyle(
                            fontSize: width * 0.025, color: productsLoadedStatus.stockQuantity.toString().isEmpty?Colors.red:Colors.white),
                        minFontSize: width * 0.01.toInt(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: width*0.22,
              child: AutoSizeText(
                productsLoadedStatus.price.toString().isEmpty
                    ? 'قیمت نامشخص'
                    : '${productsLoadedStatus.price.toString()} تومان',
                style: TextStyle(
                    fontSize: width * 0.025, color: productsLoadedStatus.price.toString().isEmpty?Colors.red:Colors.white),
                minFontSize: width * 0.01.toInt(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shapyar_bloc/extension/persian_digits.dart';
import 'package:shapyar_bloc/features/feature_products/domain/entities/product_entity.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../../core/config/app-colors.dart';
import 'package:intl/intl.dart';
import 'package:dotted_line/dotted_line.dart';

class Product extends StatelessWidget {
  ProductEntity productsLoadedStatus;
  bool isChild;

  Product(this.productsLoadedStatus, this.isChild);

  String formatFaThousands(dynamic value) {
    final n = (value is num) ? value : num.tryParse(value.toString()) ?? 0;
    return NumberFormat.decimalPattern('fa').format(n);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppConfig.calWidth(context, 3)),
      margin: EdgeInsets.all(width * 0.02),
      height: isChild ? height * 0.3 : height * 0.15,
      width: width * 0.7,
      decoration: BoxDecoration(
        border: Border.all(color: AppConfig.borderColor, width: 0.2),
        color: AppConfig.secondaryColor,
        borderRadius: BorderRadius.circular(width * 0.02),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            spacing: AppConfig.calWidth(context, 2),
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: height * 0.09,
                width: width * 0.17,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      AppConfig.calBorderRadiusSize(context)),
                ),
                //   clipBehavior: Clip.antiAlias,  // برای کلیپ شدن کانتینر
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      AppConfig.calBorderRadiusSize(context)),
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
              Container(

                width: AppConfig.calWidth(context, 70),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppConfig.calWidth(context, isChild?1:3),
                  children: [
                    AutoSizeText(
                      productsLoadedStatus.name.toString(),
                      style: TextStyle(
                          fontSize: isChild?width * 0.025:width * 0.027, color: Colors.white),
                      minFontSize: width * 0.001.toInt(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Container(color: Colors.white24,
                      child: Row(mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            width: width * 0.3,
                            height: height * 0.03,
                            child: AutoSizeText('شناسه: ${productsLoadedStatus.id}',
                              style: TextStyle(
                                  fontSize: width * 0.03,
                               //   fontWeight: FontWeight.bold,
                                  color: productsLoadedStatus.price.toString().isEmpty
                                      ? Colors.red
                                      : Colors.white),
                              minFontSize: width * 0.01.toInt(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            width: width * 0.3,
                            height: height * 0.03,
                            child: AutoSizeText(
                              productsLoadedStatus.price.toString().isEmpty
                                  ? 'قیمت نامشخص'
                                  : '${formatFaThousands(productsLoadedStatus.price).toString().stringToPersianDigits()} ریال',
                              style: TextStyle(
                                  fontSize: width * 0.03,
                                  fontWeight:isChild? FontWeight.normal: FontWeight.bold,
                                  color: productsLoadedStatus.price.toString().isEmpty
                                      ? Colors.red
                                      : Colors.white),
                              minFontSize: width * 0.01.toInt(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: AutoSizeText(
                        productsLoadedStatus.stockQuantity.toString().isEmpty
                            ? 'موجودی نامشخص'
                            : '${productsLoadedStatus.stockQuantity.toString().stringToPersianDigits()} موجودی',
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
          if (isChild)
            Container(
              width: AppConfig.calWidth(context, 90),
              height: AppConfig.calHeight(context, 18),
           /*   color: Colors.orange,*/
              child: Column(
                children: [
                  Container(
                    /*color: Colors.blue, */
                    width: AppConfig.calWidth(context, 88),
                    alignment: Alignment.centerRight,
                    height: AppConfig.calHeight(context, 4),
                    child: Text(
                      'محصولات متغیر:',
                      style: TextStyle(
                          fontSize: AppConfig.calFontSize(context, 2.7),
                          color: Colors.white60),
                    ),
                  ),
               /*   Container(
                    width: AppConfig.calWidth(context, 80),
                    height: AppConfig.calHeight(context, 0.52),
                    alignment: Alignment.center,
                    child: DottedLine(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.center,
                      lineLength: double.infinity,
                      lineThickness: 1.0,
                      dashLength: 4.0,
                      dashColor: Colors.black,
                      dashGradient: [
                        AppConfig.firstLinearColor,
                        AppConfig.secondLinearColor
                      ],
                      dashRadius: 0.0,
                      dashGapLength: 4.0,
                      dashGapColor: Colors.transparent,
                      dashGapGradient: [
                        AppConfig.firstLinearColor,
                        AppConfig.secondLinearColor
                      ],
                      dashGapRadius: 0.0,
                    ),
                  ),*/
                  Container(
                  /*  color: Colors.red,*/
                    width: AppConfig.calWidth(context, 90),
                    height: AppConfig.calHeight(context, 14),
                    child: ListView.builder(itemCount: productsLoadedStatus.childes!.length,itemBuilder: (context, index) {
                      final product = productsLoadedStatus.childes![index];
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(alignment: Alignment.centerRight,
                               /* color: Colors.green,*/
                                width: AppConfig.calWidth(context, 43),
                                height: AppConfig.calHeight(context, 3),
                                child: Text('شناسه: ${product.id}',
                                    style: TextStyle(
                                        fontSize:
                                            AppConfig.calFontSize(context, 2.7),
                                        color: Colors.white)),
                              ),
                              Container(alignment: Alignment.centerRight,
                                /*  color: Colors.grey,*/
                                  width: AppConfig.calWidth(context, 43),
                                  height: AppConfig.calHeight(context, 3),
                                  child: AutoSizeText(
                                    'قیمت: ${formatFaThousands(product.price).toString().stringToPersianDigits()} ریال',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: AppConfig.calFontSize(context, 2.7), color: Colors.white),
                                    maxLines: 1,
                                    minFontSize: 9,
                                    overflow: TextOverflow.ellipsis,
                                  ))
                            ],
                          ),
                          Container(alignment: Alignment.centerRight,
                          /*  color: Colors.yellow,*/
                            width: AppConfig.calWidth(context, 88),
                            height: AppConfig.calHeight(context, 5),
                            child: AutoSizeText(
                              product.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: AppConfig.calFontSize(context, 2.5), color: Colors.white),
                              maxLines: 1,
                              minFontSize: 9,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            width: AppConfig.calWidth(context, 90),
                            height: AppConfig.calHeight(context, 3),
                            alignment: Alignment.center,
                            child: DottedLine(
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.center,
                              lineLength: double.infinity,
                              lineThickness: 1.0,
                              dashLength: 4.0,
                              dashColor: Colors.black,
                              dashGradient: [
                                AppConfig.firstLinearColor,
                                AppConfig.secondLinearColor
                              ],
                              dashRadius: 0.0,
                              dashGapLength: 4.0,
                              dashGapColor: Colors.transparent,
                              dashGapGradient: [
                                AppConfig.firstLinearColor,
                                AppConfig.secondLinearColor
                              ],
                              dashGapRadius: 0.0,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}

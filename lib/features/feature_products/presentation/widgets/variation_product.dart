import 'package:flutter/material.dart';

import '../../../../core/utils/static_values.dart';
import '../bloc/products_status.dart';

class VariationProduct extends StatelessWidget {
  ProductsLoadedStatus productsLoadedStatus;
  int item;
  int childItem;

  VariationProduct(this.productsLoadedStatus, this.item, this.childItem);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      child: Column(
        children: [
          Container(margin: EdgeInsets.symmetric(vertical: width*0.02),
            width: width * 0.3,
            height: height * 0.01,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),color: Color(int.parse('0xFF03045E')),),
          ),
          Card(
            elevation: 8,
            color: Colors.white,
            child: Container(
              width: width * 0.9,
              height: height * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(width * 0.03)),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: height * 0.03, vertical: height * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Container(
                                  width: width * 0.6,
                                  alignment: Alignment.centerRight,
                                  child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          final width = constraints.maxWidth;
                                          var fontSize = 13.0;
                                          if (width <= 480) {
                                            fontSize = 13.0;
                                          } else if (width > 480 &&
                                              width <= 960) {
                                            fontSize = 14.0;
                                          } else {
                                            fontSize = 15;
                                          }
                                          return Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  StaticValues.staticProducts![item]
                                                      .childes![childItem]
                                                      .name
                                                      .toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: fontSize),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ))),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Container(
                                width: width * 0.6,
                                alignment: Alignment.centerRight,
                                child: Text(
                                    '${StaticValues.staticProducts![item].childes![childItem].price.toString()} تومان'),
                              ),
                            ],
                          ),
                          /*color: Colors.grey,*/
                        ),
                        Container(
                          width: width * 0.14,
                          height: height * 0.07,
                          alignment: Alignment.centerLeft,
                          child: StaticValues.staticProducts![item]
                                  .childes![childItem].image
                                  .toString()
                                  .isNotEmpty
                              ? Image.network(StaticValues.staticProducts![item]
                                  .childes![childItem]
                                  .image
                                  .toString())
                              : Image.asset("assets/images/index.png"),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: height * 0.07,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    /*color: Colors.red,*/
                                    width: width * 0.3,
                                    height: height * 0.025,
                                    /*color: Colors.red,*/
                                    child: Text(
                                      StaticValues.staticProducts![item]
                                          .childes![childItem]
                                          .stockQuantity
                                          .toString(),
                                      style: TextStyle(
                                          color: int.tryParse(StaticValues.staticProducts![
                                                              item]
                                                          .childes![childItem]
                                                          .stockQuantity
                                                          .toString()) ==
                                                  null
                                              ? Colors.green
                                              : int.tryParse(StaticValues.staticProducts![
                                                              item]
                                                          .childes![childItem]
                                                          .stockQuantity
                                                          .toString())! <
                                                      30
                                                  ? Colors.red
                                                  : Colors.green),
                                    ) /*,color: Colors.grey*/,
                                  ),
                                  Container(
                                    width: width * 0.3,
                                    height: height * 0.025,
                                    child: Text(
                                      "موجودی انبار",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: height * 0.07,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: width * 0.3,
                                    height: height * 0.025,
                                    child: Text(StaticValues.staticProducts![item]
                                        .childes![childItem]
                                        .price
                                        .toString()),
                                  ),
                                  Container(
                                    width: width * 0.3,
                                    height: height * 0.025,
                                    child: Text(
                                      "فروش کلی",
                                      style: TextStyle(color: Colors.grey),
                                    ) /*,color: Colors.green*/,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        /*  color: Colors.blueGrey,*/
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

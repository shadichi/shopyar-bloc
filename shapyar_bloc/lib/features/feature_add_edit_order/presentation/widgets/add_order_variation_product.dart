import 'package:flutter/material.dart';

import '../../../../core/utils/static_values.dart';
import '../bloc/add_order_status.dart';

class AddOrderVariationProduct extends StatelessWidget {
  AddOrderProductsLoadedStatus addOrderProductsLoadedStatus;
  int item;
  int childItem;

  AddOrderVariationProduct(this.addOrderProductsLoadedStatus, this.item, this.childItem);

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
                    child: Row(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Container(
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
                                                  StaticValues.staticProducts[item]
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
                                      )),
                                  width: width * 0.6,
                                  alignment: Alignment.centerRight),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Container(
                                child: Text(
                                    '${StaticValues.staticProducts[item].childes![childItem].price.toString()} تومان'),
color: Colors.yellow,

                                width: width * 0.6,
                                alignment: Alignment.centerRight,
                              ),
                            ],
                          ),
color: Colors.grey,

                        ),
                        Container(
                          child: StaticValues.staticProducts[item]
                                  .childes![childItem].image
                                  .toString()
                                  .isNotEmpty
                              ? Image.network(StaticValues.staticProducts[item]
                                  .childes![childItem]
                                  .image
                                  .toString())
                              : Image.asset("assets/images/index.png"),
                          width: width * 0.14,
                          height: height * 0.07,
                          alignment: Alignment.centerLeft,
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
color: Colors.red,

                    padding: EdgeInsets.symmetric(
                        horizontal: height * 0.03, vertical: height * 0.01),
                  ),
                  Divider(),
                  Column(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Container(
color: Colors.red,

                                    child: Text(
                                      StaticValues.staticProducts[item]
                                          .childes![childItem]
                                          .stockQuantity
                                          .toString(),
                                      style: TextStyle(
                                          color: int.tryParse(
                                              StaticValues.staticProducts[
                                                              item]
                                                          .childes![childItem]
                                                          .stockQuantity
                                                          .toString()) ==
                                                  null
                                              ? Colors.green
                                              : int.tryParse(StaticValues.staticProducts[
                                                              item]
                                                          .childes![childItem]
                                                          .stockQuantity
                                                          .toString())! <
                                                      30
                                                  ? Colors.red
                                                  : Colors.green),
                                    )
,
                                    width: width * 0.3,
                                    height: height * 0.025,
                                  ),
                                  Container(
                                    child: Text(
                                      "موجودی انبار",
                                      style: TextStyle(color: Colors.grey),
                                    ),
color: Colors.green,

                                    width: width * 0.3,
                                    height: height * 0.025,
                                  ),
                                ],
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                              ),
color: Colors.blue,

                              height: height * 0.07,
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    child: Text(StaticValues.staticProducts[item]
                                        .childes![childItem]
                                        .price
                                        .toString()),
color: Colors.grey,

                                    width: width * 0.3,
                                    height: height * 0.025,
                                  ),
                                  Container(
                                    child: Text(
                                      "فروش کلی",
                                      style: TextStyle(color: Colors.grey),
                                    )
,color: Colors.green
,
                                    width: width * 0.3,
                                    height: height * 0.025,
                                  ),
                                ],
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                              ),
color: Colors.blue,

                              height: height * 0.07,
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                        ),
  color: Colors.blueGrey,

                      )
                    ],
                  )
                ],
              ),
            ),
            elevation: 8,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shapyar_bloc/features/feature_products/presentation/widgets/product.dart';

import '../../../../test3.dart';
import '../../domain/entities/product_entity.dart';

class EndingProduct extends StatelessWidget {
  ProductEntity productsLoadedStatus;

  EndingProduct(this.productsLoadedStatus);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.05,
      width: width * 0.28,
      child: ListView.builder(scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Card(
            child: Container(
              height: height * 0.14,
              width: width * 0.27,
              decoration: BoxDecoration(
                color: AppColors.section4,
                borderRadius: BorderRadius.circular(width * 0.02),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      height: height * 0.07,
                      width: width * 0.5,
                      child: productsLoadedStatus.image.toString().isNotEmpty
                          ? Image.network(productsLoadedStatus.image.toString())
                          : Image.asset('assets/images/index.png')),
                  Container(
                    child: Text('productsLoadedStatus.name.toString()',
                        style: TextStyle(fontSize: width * 0.03),
                        textAlign: TextAlign.center),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

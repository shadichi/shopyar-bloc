import 'package:flutter/material.dart';
import 'package:shapyar_bloc/features/feature_products/domain/entities/product_entity.dart';

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
        height: height * 0.3,
        width: width * 0.1,
        decoration: BoxDecoration(
          color: Color(int.parse('0xffedf2f4')),
          borderRadius: BorderRadius.circular(width * 0.02),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: height*0.07,width: width*0.5,
                child: productsLoadedStatus.image.toString().isNotEmpty
                    ? Image.network(productsLoadedStatus.image.toString())
                    : Image.asset('assets/images/index.png')),
            Container(child: Text(productsLoadedStatus.name.toString(),style: TextStyle(fontSize: width*0.03),textAlign: TextAlign.center),)
          ],
        ),
      ),
    );
  }
}

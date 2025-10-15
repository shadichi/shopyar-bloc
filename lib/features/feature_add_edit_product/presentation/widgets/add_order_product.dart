/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopyar/core/config/app-colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../feature_orders/domain/entities/orders_entity.dart';
import '../../../feature_products/data/models/product_model.dart';
import '../../../feature_products/domain/entities/product_entity.dart';
import '../bloc/add_product_bloc.dart';
import '../bloc/add_order_card_product_status.dart';
import '../screens/product_form_screen.dart';

/// A widget that displays a product card for adding to an order
class AddOrderProduct extends StatefulWidget {
  final ProductEntity product;
  final OrdersEntity? ordersEntity;
  final Function(Map<int, int>) onCartSelected;

  AddOrderProduct(
    this.product, this.ordersEntity, this.onCartSelected)
      ;

  @override
  State<AddOrderProduct> createState() => _AddOrderProductState();
}

class _AddOrderProductState extends State<AddOrderProduct> {

  bool isPurchasedPCalculated = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print('widget.isEditMode');


  }

  final ScrollController _scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    print(widget.product.name);
    print(widget.product.childes);

    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Card(
      elevation: 8,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size.width * 0.03),
      ),
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.02),
        child: Column(
          children: [
            _buildProductInfo(context, size, theme),
            if (widget.product.childes!.isEmpty) const Divider(),
            Container(
                alignment: Alignment.center,
                height: widget.product.childes!.isEmpty
                    ? AppConfig.calHeight(context, 5)
                    : AppConfig.calHeight(context, 5),
                child: _buildProductControls(context, size, theme)),
            if (widget.product.childes!.isNotEmpty)
              Column(
                children: [
                  const Divider(),
                  Container(
                    width: AppConfig.calWidth(context, 85),
                    height: AppConfig.calHeight(context, 4),
                    alignment: Alignment.centerRight,
                    child: Text(
                      'محصولات متغیر :',
                      style:
                          TextStyle(fontSize: AppConfig.calWidth(context, 3.5)),
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      height: widget.product.childes!.isEmpty
                          ? AppConfig.calHeight(context, 5)
                          : AppConfig.calHeight(context, 12),
                      child: Scrollbar(
                        thumbVisibility: true,
                        thickness: 4.0,
                        controller: _scrollController,
                        radius: Radius.circular(3.0),
                        child: ListView.builder(
                          controller: _scrollController,
                          itemBuilder: (context, index) => _buildProductControls(
                              context, size, theme,
                              isChild: true, index: index),
                          itemCount: widget.product.childes!.length,
                        ),
                      )),
                ],
              ),
          ],
        ),
      ),
    );
  }

  /// Builds the product information section
  Widget _buildProductInfo(BuildContext context, Size size, ThemeData theme) {
    return Container(
      width: AppConfig.calWidth(context, 80),
      padding: EdgeInsets.symmetric(
        horizontal: size.height * 0.01,
        vertical: size.height * 0.01,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildProductName(size, theme),
          _buildProductImage(size, context),
        ],
      ),
    );
  }

  /// Builds the product name display
  Widget _buildProductName(Size size, ThemeData theme) {
    return Container(
      width: size.width * 0.45,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final fontSize = _calculateFontSize(constraints.maxWidth);
          return AutoSizeText(
            '${widget.product.name}${widget.product.id}',
            style: TextStyle(
                fontSize: AppConfig.calWidth(context, 3), color: Colors.black),
            maxLines: 1,
            minFontSize: 11,
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
    );
  }

  /// Builds the product image display
  Widget _buildProductImage(Size size, context) {
    return Container(
      margin: EdgeInsets.only(left: AppConfig.calWidth(context, 6)),
      width: size.width * 0.17,
      height: size.height * 0.07,
      child: widget.product.image!.isNotEmpty
          ? Image.network(widget.product.image.toString())
          : Image.asset('assets/images/index.png'),
    );
  }

  /// Builds the product controls section (price and quantity controls)
  Widget _buildProductControls(BuildContext context, Size size, ThemeData theme,
      {bool isChild = false, index = 0}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          padding:
              EdgeInsets.symmetric(vertical: AppConfig.calWidth(context, 1)),
          alignment: Alignment.center,
          width: AppConfig.calWidth(context, 53),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isChild)
                Expanded(
                  child: Container(
                    alignment: Alignment.center,

                    child: AutoSizeText(
                      widget.product.childes![index].variable,
                      style: TextStyle(
                          fontSize: AppConfig.calWidth(context, 4),
                          color: Colors.black),
                      maxLines: 1,
                      minFontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              Expanded(
                child: Container(
                  //color: AppConfig.topOrderColor,
                  alignment: Alignment.center,
                  height: AppConfig.calHeight(context, 4),
                  width: AppConfig.calWidth(context, 20),
                  child: AutoSizeText(
                    isChild
                        ? '${widget.product.childes![index].price} ریال'
                        : '${widget.product.price} ریال',
                    style: TextStyle(
                        fontSize: AppConfig.calWidth(context,4),
                        color: Colors.black,fontWeight: FontWeight.bold),
                    maxLines: 1,
                    minFontSize: 7,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildQuantityControls(context, size, theme, index, isChild),
      ],
    );
  }

  /// Builds the quantity controls (add/remove buttons and count)
  Widget _buildQuantityControls(
      BuildContext context, Size size, ThemeData theme, int index, isChild) {
    return BlocConsumer<AddProductBloc, AddProductState>(
      listener: (context, state) {
        final status = state.addOrderCardProductStatus;
        if (status is AddOrderCardProductLoaded) {
          widget.onCartSelected(status.cart);
        }
      },
      builder: (context, state) {
        print('state.addOrderCardProductStatus');
        print(state.addOrderCardProductStatus);
        if (state.addOrderCardProductStatus is AddOrderCardProductNotLoaded) {
          return const SizedBox.shrink();
        }

        if (state.addOrderCardProductStatus is AddOrderCardProductLoaded) {
          final status =
              state.addOrderCardProductStatus as AddOrderCardProductLoaded;
          int count = 0;
          print('yes');
          print(widget.product.id);

          if (isChild) {
            print('widget.product.childes![index].id');
            print(widget.product.childes![index].id);
            print(status.cart[widget.product.childes![index].id]);
            print(status.cart);



            if (status.cart[widget.product.childes![index].id] != 0) {
              count = status.cart[widget.product.childes![index].id] ?? 0;
            }
            ProductEntity productChilde =
                ProductEntity(id: widget.product.childes![index].id);
            return count == 0
                ? _buildAddButton(context, size, theme, isChild, index)
                : _buildQuantitySelector(
                    context, size, theme, count, productChilde);
          } else {
            print('widget.product.iddddddddddddd');
            print(widget.product.id);
            print(status.cart);
            count = status.cart[widget.product.id] ?? 0;
            return count == 0
                ? _buildAddButton(context, size, theme, isChild, index)
                : _buildQuantitySelector(context, size, theme, count, widget.product);
          }
        }

        return _buildAddButton(context, size, theme, isChild, index);
      },
    );
  }

  /// Builds the "Add Product" button
  Widget _buildAddButton(BuildContext context, Size size, ThemeData theme,
      bool isChild, int index) {
    return SizedBox(
      width: size.width * 0.25,
      height: size.height * 0.04,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConfig.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size.width * 0.02),
          ),
        ),
        onPressed: () {
          if (isChild) {
            ProductEntity productEntity = ProductEntity(
              id: widget.product.childes![index].id,
              name: widget.product.childes![index].name,
              price: widget.product.childes![index].price,
            );
            context.read<AddProductBloc>().add(AddOrderAddProduct(productEntity));
          } else {
            context.read<AddProductBloc>().add(AddOrderAddProduct(widget.product));
          }
        },
        child: Text(
          'انتخاب',
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: size.width * 0.032,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// Builds the quantity selector (add/remove buttons with count)
  Widget _buildQuantitySelector(BuildContext context, Size size,
      ThemeData theme, int count, ProductEntity product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildIconButton(
          context: context,
          icon: Icons.add_circle,
          color: Colors.green,
          size: size.width * 0.07,
          onPressed: () =>
              context.read<AddProductBloc>().add(AddOrderAddProduct(product)),
        ),
        SizedBox(
          width: size.width * 0.1,
          child: Text(
            count.toString(),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: size.width * 0.04,
            ),
          ),
        ),
        _buildIconButton(
          context: context,
          icon: Icons.remove_circle,
          color: Colors.red,
          size: size.width * 0.07,
          onPressed: () =>
              context.read<AddProductBloc>().add(DecreaseProductCount(product)),
        ),
      ],
    );
  }

  /// Builds an icon button for quantity controls
  Widget _buildIconButton({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required double size,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Icon(icon, color: color, size: size),
    );
  }

  /// Calculates responsive font size based on available width
  double _calculateFontSize(double width) {
    if (width <= 480) return 10.0;
    if (width <= 960) return 12.0;
    return 11.0;
  }
}
*/

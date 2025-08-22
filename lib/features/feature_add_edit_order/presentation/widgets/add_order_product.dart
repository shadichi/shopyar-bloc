import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shapyar_bloc/core/config/app-colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../feature_orders/domain/entities/orders_entity.dart';
import '../../../feature_products/data/models/product_model.dart';
import '../../../feature_products/domain/entities/product_entity.dart';
import '../bloc/add_order_bloc.dart';
import '../bloc/add_order_card_product_status.dart';
import '../screens/product_form_screen.dart';

/// A widget that displays a product card for adding to an order
class AddOrderProduct extends StatelessWidget {
  final ProductEntity product;
  final ProductFormMode? isEditMode;
  final OrdersEntity? ordersEntity;
  final Function(Map<int, int>) onCartSelected;

  AddOrderProduct(
      this.isEditMode, this.product, this.ordersEntity, this.onCartSelected)
      : assert(
          isEditMode == ProductFormMode.create || ordersEntity != null,
          'در حالت edit باید ordersEntity مقدار داشته باشد',
        );

  bool isPurchasedPCalculated = false;

  @override
  Widget build(BuildContext context) {
    print(product.name);
    print(product.childes);

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
            if (product.childes!.isEmpty) const Divider(),
            Container(
                alignment: Alignment.center,
                height: product.childes!.isEmpty
                    ? AppConfig.calHeight(context, 5)
                    : AppConfig.calHeight(context, 5),
                child: _buildProductControls(context, size, theme)),
            if (product.childes!.isNotEmpty)
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
                          TextStyle(fontSize: AppConfig.calWidth(context, 2.5)),
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      height: product.childes!.isEmpty
                          ? AppConfig.calHeight(context, 5)
                          : AppConfig.calHeight(context, 12),
                      child: ListView.builder(
                        itemBuilder: (context, index) => _buildProductControls(
                            context, size, theme,
                            isChild: true, index: index),
                        itemCount: product.childes!.length,
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
            '${product.name}${product.id}',
            style: TextStyle(
                fontSize: AppConfig.calWidth(context, 3), color: Colors.black),
            maxLines: 1,
            minFontSize: 7,
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
      child: product.image!.isNotEmpty
          ? Image.network(product.image.toString())
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
          width: AppConfig.calWidth(context, 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isChild)
                Container(
                  alignment: Alignment.center,
                  height: AppConfig.calHeight(context, 4),
                  width: AppConfig.calWidth(context, 20),
                  child: AutoSizeText(
                    product.childes![index].variable,
                    style: TextStyle(
                        fontSize: AppConfig.calWidth(context, 3),
                        color: Colors.black),
                    maxLines: 1,
                    minFontSize: 7,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              Container(
                alignment: Alignment.center,
                height: AppConfig.calHeight(context, 4),
                width: AppConfig.calWidth(context, 20),
                child: AutoSizeText(
                  isChild
                      ? '${product.childes![index].price} تومان'
                      : '${product.price} تومان',
                  style: TextStyle(
                      fontSize: AppConfig.calWidth(context, 3),
                      color: Colors.black),
                  maxLines: 1,
                  minFontSize: 7,
                  overflow: TextOverflow.ellipsis,
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
    return BlocConsumer<AddOrderBloc, AddOrderState>(
      listener: (context, state) {
        final status = state.addOrderCardProductStatus;
        if (status is AddOrderCardProductLoaded) {
          onCartSelected(status.cart);
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
          print(product.id);

          if (isChild) {
            print(product.childes![index].id);
            print(status.cart[product.childes![index].id]);
            print(status.cart);

            if (status.cart[product.childes![index].id] != 0) {
              count = status.cart[product.childes![index].id] ?? 0;
            }
            ProductEntity productChilde =
                ProductEntity(id: product.childes![index].id);
            return count == 0
                ? _buildAddButton(context, size, theme, isChild, index)
                : _buildQuantitySelector(
                    context, size, theme, count, productChilde);
          } else {
            count = status.cart[product.id] ?? 0;
            return count == 0
                ? _buildAddButton(context, size, theme, isChild, index)
                : _buildQuantitySelector(context, size, theme, count, product);
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
      width: size.width * 0.3,
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
              id: product.childes![index].id,
              name: product.childes![index].name,
              price: product.childes![index].price,
            );
            context.read<AddOrderBloc>().add(AddOrderAddProduct(productEntity));
          } else {
            context.read<AddOrderBloc>().add(AddOrderAddProduct(product));
          }
        },
        child: Text(
          'انتخاب محصول',
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: size.width * 0.022,
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
              context.read<AddOrderBloc>().add(AddOrderAddProduct(product)),
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
              context.read<AddOrderBloc>().add(DecreaseProductCount(product)),
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shapyar_bloc/core/config/app-colors.dart';

import '../../../../core/params/add_order_get_selected_products_params.dart';
import '../../../feature_products/domain/entities/product_entity.dart';
import '../bloc/add_order_bloc.dart';
import '../bloc/add_order_card_product_status.dart';

/// A widget that displays a product card for adding to an order
class AddOrderProduct extends StatelessWidget {
  final ProductEntity product;
  final ProductEntity? purchasedProducts;

  const AddOrderProduct({required this.product, this.purchasedProducts, super.key});

  @override
  Widget build(BuildContext context) {


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
            const Divider(),
            Container(
                height: AppConfig.calHeight(context, 4),
                child: ListView.builder(
                  itemBuilder: (context, index) =>
                      _buildProductControls(context, size, theme),
                  itemCount: product.childes!.isEmpty?1:product.childes!.length,
                )),
          ],
        ),
      ),
    );
  }

  /// Builds the product information section
  Widget _buildProductInfo(BuildContext context, Size size, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.height * 0.01,
        vertical: size.height * 0.01,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildProductName(size, theme),
          _buildProductImage(size),
        ],
      ),
    );
  }

  /// Builds the product name display
  Widget _buildProductName(Size size, ThemeData theme) {
    return SizedBox(
      width: size.width * 0.5,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final fontSize = _calculateFontSize(constraints.maxWidth);
          return Text(
            '${product.name}${product.id}',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(fontSize: fontSize),
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
    );
  }

  /// Builds the product image display
  Widget _buildProductImage(Size size) {
    return SizedBox(
      width: size.width * 0.14,
      height: size.height * 0.07,
      child: product.image!.isNotEmpty
          ? Image.network(product.image.toString())
          : Image.asset('assets/images/index.png'),
    );
  }

  /// Builds the product controls section (price and quantity controls)
  Widget _buildProductControls(
      BuildContext context, Size size, ThemeData theme) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            alignment: Alignment.center,
            width: AppConfig.calWidth(context, 40),
            child: Text(
              '${product.price} تومان',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildQuantityControls(context, size, theme),
        ],
      ),
    );
  }

  /// Builds the quantity controls (add/remove buttons and count)
  Widget _buildQuantityControls(
      BuildContext context, Size size, ThemeData theme) {
    return BlocBuilder<AddOrderBloc, AddOrderState>(
      builder: (context, state) {
        if (state.addOrderCardProductStatus is AddOrderCardProductNotLoaded) {
          return const SizedBox.shrink();
        }

        if (state.addOrderCardProductStatus is AddOrderCardProductLoaded) {
          final status =
              state.addOrderCardProductStatus as AddOrderCardProductLoaded;
          final count = status.cart[product.id] ?? 0;

          return count == 0
              ? _buildAddButton(context, size, theme)
              : _buildQuantitySelector(context, size, theme, count);
        }

        return _buildAddButton(context, size, theme);
      },
    );
  }

  /// Builds the "Add Product" button
  Widget _buildAddButton(BuildContext context, Size size, ThemeData theme) {
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
        onPressed: () =>
            context.read<AddOrderBloc>().add(AddOrderAddProduct(product)),
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
  Widget _buildQuantitySelector(
      BuildContext context, Size size, ThemeData theme, int count) {
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

import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:shapyar_bloc/features/feature_orders/presentation/screens/orders_screen.dart';
import 'package:shapyar_bloc/features/feature_orders/presentation/widgets/order.dart';
import '../../../../core/params/setOrderPArams.dart';
import '../../../../core/widgets/snackBar.dart';
import '../../../feature_orders/domain/entities/orders_entity.dart';
import '../../../../core/config/app-colors.dart';
import '../../../../core/utils/static_values.dart';
import '../../../../core/widgets/alert_dialog.dart';
import '../../../../core/widgets/progress-bar.dart';
import '../../../feature_orders/presentation/bloc/orders_bloc.dart';
import '../../../feature_products/domain/entities/product_entity.dart';
import '../../data/models/add_order_data_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/add_order_orders_model.dart';
import '../../domain/entities/add_order_orders_entity.dart';
import '../bloc/add_order_bloc.dart';
import '../bloc/add_order_card_product_status.dart';
import '../bloc/add_order_status.dart';
import '../widgets/add_order_bill.dart';
import '../widgets/add_order_product.dart';

enum ProductFormMode {
  create,
  edit(),
}

class ProductFormScreen extends StatefulWidget {
  static const createRoute = '/orders-create';
  static const editRoute = '/orders-edit';

  final ProductFormMode mode;
  final OrdersEntity? ordersEntity;

  const ProductFormScreen._({required this.mode, this.ordersEntity});

  factory ProductFormScreen.create() => ProductFormScreen._(mode: ProductFormMode.create);

  factory ProductFormScreen.edit({required OrdersEntity ordersEntity}) =>
      ProductFormScreen._(mode: ProductFormMode.edit, ordersEntity: ordersEntity);

  @override
  _AddOrderTest createState() => _AddOrderTest();
}

class _AddOrderTest extends State<ProductFormScreen> {
  int activeStep = 0;
  int upperBound = 1;

  List<PaymentMethod>? paymentMethod = [];
  List<ShippingMethod>? shipmentMethod = [];

  List pay = [];
  List ship = [];

  String customerLNBill = '';
  String customerFNBill = '';
  String cityBill = '';
  String provinceBill = '';
  String addressBill = '';
  String postalCodeBill = '';
  String emailBill = '';
  String phoneBill = '';
  String shipmentBill = '';
  String paymentBill = '';
  String shipPriceBill = '';
  List<ShippingLine> shippingLine = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<LineItem> _cartToLineItems(Map<int, int> cart) {
    return cart.entries
        .map((e) => LineItem(
      id: 0,
      productId: e.key,
      name: "",
      quantity: e.value,
      total: '0',
    ))
        .toList();
  }

  bool _hydratedOnce = false;
  AddOrderProductsLoadedStatus? _lastLoaded;

  @override
  void initState() {
    super.initState();
    // 1) همیشه cart قبلی رو صفر کن
    context.read<AddOrderBloc>().add(ClearCart());
    // 2) محصولات رو لود کن
    context.read<AddOrderBloc>().add(LoadAddOrderProductsData());
    // 3) Hydrate فقط بعد از ProductsLoaded و فقط یک بار (در listener)
    print('widget.ordersEntity!.billing!.email');
    print(widget.ordersEntity!.billing!.email);
    print(widget.ordersEntity!.billing!.phone);
  }


  final TextEditingController controller = TextEditingController();

  final TextEditingController step1CustomerFNBill = TextEditingController();
  final TextEditingController step1CustomerLNBill = TextEditingController();
  final TextEditingController step1AddressBill = TextEditingController();
  final TextEditingController step1CityBill = TextEditingController();
  final TextEditingController step1PostalCodeBill = TextEditingController();
  final TextEditingController step1EmailBill = TextEditingController();
  final TextEditingController step1PhoneBill = TextEditingController();
  final TextEditingController step1ShipPrice = TextEditingController();

  // خط کمکی برای مشتق‌کردن LineItem از state (بدون setState)
  List<LineItem> _deriveLineItemsFromState(AddOrderState s) {
    if (s.addOrderCardProductStatus is AddOrderCardProductLoaded) {
      final cart = (s.addOrderCardProductStatus as AddOrderCardProductLoaded).cart;
      return _cartToLineItems(cart);
    }
    if (s.addOrderStatus is AddOrderProductsLoadedStatus) {
      final cart = (s.addOrderStatus as AddOrderProductsLoadedStatus).cart;
      return _cartToLineItems(cart);
    }
    return const [];
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final List<TextEditingController> textEditing = [
      step1CustomerFNBill,
      step1CustomerLNBill,
      step1AddressBill,
      step1CityBill,
      step1PostalCodeBill,
      step1EmailBill,
      step1PhoneBill,
      step1ShipPrice,
    ];

    final List<Function(String)> onTextChange = [
          (value) => customerLNBill = value,
          (value) => customerFNBill = value,
          (value) => cityBill = value,
          (value) => provinceBill = value,
          (value) => addressBill = value,
          (value) => postalCodeBill = value,
          (value) => emailBill = value,
          (value) => phoneBill = value,
          (value) => shipmentBill = value,
          (value) => paymentBill = value,
          (value) => shipPriceBill = value,
    ];

    paymentMethod = StaticValues.paymentMethods.map((m) => PaymentMethod.fromJson(m)).toList();
    shipmentMethod = StaticValues.shippingMethods.map((m) => ShippingMethod.fromJson(m)).toList();

    return BlocConsumer<AddOrderBloc, AddOrderState>(
      listener: (context, state) async {
        // فقط یک‌بار بعد از لودشدن محصولات، Hydrate کن
        if (!_hydratedOnce &&
            widget.mode == ProductFormMode.edit &&
            state.addOrderStatus is AddOrderProductsLoadedStatus) {
          _hydratedOnce = true;
          context.read<AddOrderBloc>().add(HydrateCartFromOrder(widget.ordersEntity!));
        }

        if (state.addOrderStatus is AddOrderSuccessStatus) {
          final isSuccess = await alertDialogScreen(
            context,
            widget.mode == ProductFormMode.edit ? 'سفارش با موفقیت ویرایش شد.' : 'سفارش با موفقیت ایجاد شد.',
            2,
            false,
            icon: Icons.check_circle,
          );
          if(isSuccess!){
            context.read<OrdersBloc>().add(
              LoadOrdersData(
                false,
                '',
                false,
                (
                    10).toString(),
                '',
                isChangeStatus: true,
              ),
            );
            if(widget.mode == ProductFormMode.edit){
              Navigator.pop(context);
              Navigator.pop(context);
            }
           // Navigator.pop(context);
            Navigator.pop(context);
          }

        }
        if (state.addOrderStatus is AddOrderErrorStatus) {
          alertDialogScreen(context, 'خطا در ایجاد سفارش.', 2, false, icon: Icons.check_circle);
        }
      },
      builder: (context, state) {
        final isSubmitting = state.addOrderStatus is AddOrderLoadingStatus;
        final isLoadError = state.addOrderStatus is AddOrderProductsErrorStatus;
        final isLoadingProducts = state.addOrderStatus is AddOrderProductsLoadingStatus;

        if (state.addOrderStatus is AddOrderProductsLoadedStatus) {
          _lastLoaded = state.addOrderStatus as AddOrderProductsLoadedStatus;
        }

        Widget mainContent;
        if (isLoadingProducts) {
          mainContent = Center(child: ProgressBar());
        } else if (isLoadError && _lastLoaded == null) {
          mainContent = const Center(child: Text('خطا!', style: TextStyle(color: Colors.white)));
        } else if (_lastLoaded != null) {
          final loaded = _lastLoaded!;
          final products = state.visibleProducts;

          mainContent = Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                stepper(),
                ListTile(
                  title: Text(
                    activeStep == 0 ? 'مشخصات صورتحساب' : 'محصولات',
                    style:  TextStyle(color: Colors.white, fontSize: AppConfig.calFontSize(context, 4.5)),
                  ),
                  subtitle: Text(
                    activeStep == 0 ? 'لطفا مشخصات صورتحساب را وارد فرمایید.' : 'لطفا محصولات را انتخاب فرمایید.',
                    style:  TextStyle(color: Colors.grey, fontSize:  AppConfig.calFontSize(context, 4.3)),
                  ),
                ),
                Expanded(
                  child: Container(
                   // color: Colors.green,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) => SlideTransition(
                        position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(animation),
                        child: child,
                      ),
                      child: Padding(
                        
                        key: ValueKey<int>(activeStep),
                        //width: 500,
                        padding: EdgeInsets.symmetric(horizontal: width*0.01),
                        child: _buildSection(onTextChange, textEditing, widget.mode, widget.ordersEntity, products),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    nextButton(loaded),
                    previousButton(),
                  ],
                ),
              ],
            ),
          );
        } else {
          mainContent =
          const Center(child: Text("خطا در پردازش داده‌ها", style: TextStyle(color: Colors.white)));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.mode == ProductFormMode.create
                  ? 'ایجاد سفارش جدید'
                  : 'ویرایش سفارش ${widget.ordersEntity?.id ?? ""}',
              style:  TextStyle(color: Colors.white, fontSize: AppConfig.calTitleFontSize(context))
            ),
          ),
          body: Stack(
            children: [
              mainContent,
              if (isSubmitting) _loadingBarrier(widget.mode == ProductFormMode.edit?'در حال ویرایش سفارش...':'در حال ثبت سفارش...'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection(
      List<Function(String)> onTextChange,
      List<TextEditingController> textEditing,
      ProductFormMode isEditMode,
      OrdersEntity? ordersEntity,
      List<ProductEntity> products,
      ) {
    switch (activeStep) {
      case 0:
        return AddOrderBill(
          paymentMethod,
          shipmentMethod,
          onTextChange,
          _formKey,
          textEditing,
          isEditMode,
          ordersEntity: ordersEntity,
        );

      case 1:
        return Column(
          children: [
            Container(
              height: AppConfig.calHeight(context, 6),
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.02,
                vertical: MediaQuery.of(context).size.width * 0.01,
              ),
              child: SearchBar(
                backgroundColor: WidgetStateProperty.all(AppConfig.secondaryColor),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConfig.calBorderRadiusSize(context)),
                  ),
                ),
                leading: Icon(Icons.search, color: Colors.white, size: AppConfig.calWidth(context, 5)),
                hintText: 'جستجو',
                textStyle: WidgetStateProperty.all(
                  TextStyle(color: Colors.white, fontSize: AppConfig.calFontSize(context, 3)),
                ),
                hintStyle: WidgetStateProperty.all(
                  TextStyle(fontSize: AppConfig.calFontSize(context, 3), color: Colors.white60),
                ),
                onChanged: (q) => context.read<AddOrderBloc>().add(LoadOnChangedAddOrderProductsData(q)),
                onSubmitted: (q) => context.read<AddOrderBloc>().add(LoadOnChangedAddOrderProductsData(q)),
              ),
            ),
            Expanded(

              child: ListView.builder(
                shrinkWrap: true, // ← Add this
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return KeyedSubtree(
                    key: ValueKey(product.id),
                    child: AddOrderProduct(
                      isEditMode,
                      product,
                      ordersEntity,
                      // ⚠️ این کال‌بک دیگه state محلی lineItem رو دستکاری نمی‌کنه
                      // چون ثبت سفارش مستقیم از state مشتق میشه
                          (p0) {},
                    ),
                  );
                },
              ),
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget nextButton(AddOrderProductsLoadedStatus _) {
    return Container(
    //  margin: const EdgeInsets.all(10),
      width: AppConfig.calWidth(context, 31),
      child: ElevatedButton(
        onPressed: () {
          if (activeStep == 0) {
            final payIdx = paymentMethod?.indexWhere((m) => (m.methodTitle ?? '').trim() == paymentBill.trim()) ?? -1;
            final shipIdx =
                shipmentMethod?.indexWhere((m) => (m.methodTitle ?? '').trim() == shipmentBill.trim()) ?? -1;

            if ((_formKey.currentState?.validate() ?? false) && payIdx >= 0 && shipIdx >= 0) {
              setState(() => activeStep = 1);
            } else {
              showSnack(context, "لطفاً همه فیلدهای مورد نیاز را پر کنید!");
            }
            return;
          }

          if (activeStep == 1) {
            // ✅ lineItems را از state مشتق بگیر، نه از متغیر لوکال
            final st = context.read<AddOrderBloc>().state;
            final derived = _deriveLineItemsFromState(st);

            if (derived.isEmpty) {
              alertDialogScreen(context, 'هیچ محصولی انتخاب نشده است!', 1, true);
              return;
            }

            final selectedPay = (paymentMethod ?? []).firstWhere(
                  (m) => (m.methodTitle ?? '').trim() == paymentBill.trim(),
              orElse: () => paymentMethod!.first,
            );
            final selectedShip = (shipmentMethod ?? []).firstWhere(
                  (m) => (m.methodTitle ?? '').trim() == shipmentBill.trim(),
              orElse: () => shipmentMethod!.first,
            );

            final payType = selectedPay.methodId?.toString() ?? "";
            final shipType = selectedShip.methodId?.toString() ?? "";
            final shipTypeTitle = selectedShip.methodTitle?.toString() ?? "";
            final priceShip = shipPriceBill.isEmpty ? "" : shipPriceBill;

            shippingLine = [ShippingLine(methodId: shipType, methodTitle: shipTypeTitle)];

            final billing = Ing(
              firstName: customerLNBill,
              lastName: customerFNBill,
              address1: addressBill,
              city: cityBill,
              email: emailBill,
              state: provinceBill,
              postcode: postalCodeBill,
              country: "IR",
              phone: phoneBill,
            );

            final shipping = Ing(
              firstName: customerLNBill,
              lastName: customerFNBill,
              address1: addressBill,
              city: cityBill,
              email: emailBill,
              state: provinceBill,
              postcode: postalCodeBill,
              country: "IR",
              phone: phoneBill,
            );

            final int orderIdForEdit =
            (widget.mode == ProductFormMode.edit) ? (widget.ordersEntity?.id ?? 0) : 0;

            final order = AddOrderOrdersEntity(
              id: orderIdForEdit,
              status: 'pending',
              billing: billing,
              shipping: shipping,
              paymentMethod: payType,
              paymentMethodTitle: paymentBill,
              lineItems: derived,
              shippingLines: shippingLine,
            );

            context.read<AddOrderBloc>().add(SetOrderEvent(SetOrderParams(order, payType, shipType, priceShip)));
            return;
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConfig.secondaryColor,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
        ),
        child: Text(
          activeStep == 1 ? (widget.mode == ProductFormMode.edit ? 'ویرایش' : 'ثبت') : 'بعدی',
          style: TextStyle(color: Colors.white, fontSize: AppConfig.calFontSize(context, 4)),textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget previousButton() {
    return Container(
      width: AppConfig.calWidth(context, 30),
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () {
          if (activeStep > 0) {
            setState(() {
              activeStep--;
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConfig.secondaryColor,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
        ),
        child: Text('قبلی', style: TextStyle(color: Colors.white, fontSize: AppConfig.calFontSize(context, 4))),
      ),
    );
  }

  Widget stepper() {
    return SizedBox(
      width: 320,
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 40,
            decoration: BoxDecoration(
              color: AppConfig.backgroundColor,
              border: activeStep == 1 ? Border.all(width: 2, color: Colors.grey) : null,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: FractionallySizedBox(
                heightFactor: 0.6,
                widthFactor: 0.9,
                child: CircleAvatar(backgroundColor: Colors.white, child: Text('2')),
              ),
            ),
          ),
          SizedBox(
            width: 200,
            height: 20,
            child: DottedLine(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              lineLength: double.infinity,
              lineThickness: 1.0,
              dashLength: 4.0,
              dashColor: Colors.black,
              dashGradient: [AppConfig.firstLinearColor, AppConfig.secondLinearColor],
              dashRadius: 0.0,
              dashGapLength: 4.0,
              dashGapColor: Colors.transparent,
              dashGapGradient: [AppConfig.firstLinearColor, AppConfig.secondLinearColor],
              dashGapRadius: 0.0,
            ),
          ),
          Container(
            width: 40,
            decoration: BoxDecoration(
              color: AppConfig.backgroundColor,
              border: activeStep == 0 ? Border.all(width: 2, color: Colors.grey) : null,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: FractionallySizedBox(
                heightFactor: 0.6,
                widthFactor: 0.9,
                child: CircleAvatar(backgroundColor: Colors.white, child: Text('1')),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loadingBarrier([String? message]) {
    return Stack(
      children: [
        const ModalBarrier(dismissible: false, color: Colors.black54),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               ProgressBar(),
              if (message != null) ...[
                SizedBox(height: AppConfig.calHeight(context, 8)),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppConfig.calWidth(context, 3.5),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

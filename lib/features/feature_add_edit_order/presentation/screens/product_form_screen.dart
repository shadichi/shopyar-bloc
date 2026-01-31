import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:collection/collection.dart'; // اول اضافه کن
import '../../../../core/params/products_params.dart';
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

enum AddOrderProductFormMode {
  create,
  edit(),
}

class AddOrderProductFormScreen extends StatefulWidget {
  static const createRoute = '/orders-create';
  static const editRoute = '/orders-edit';

  final AddOrderProductFormMode mode;
  final OrdersEntity? ordersEntity;


  const AddOrderProductFormScreen._({required this.mode, this.ordersEntity});

  factory AddOrderProductFormScreen.create() =>
      AddOrderProductFormScreen._(mode: AddOrderProductFormMode.create);

  factory AddOrderProductFormScreen.edit(
      {required OrdersEntity ordersEntity}) =>
      AddOrderProductFormScreen._(
          mode: AddOrderProductFormMode.edit, ordersEntity: ordersEntity);

  @override
  _AddOrderTest createState() => _AddOrderTest();
}

class _AddOrderTest extends State<AddOrderProductFormScreen> {
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

  String _searchQuery = '';


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<LineItem> _cartToLineItems(Map<int, int> cart) {
    return cart.entries
        .map((e) =>
        LineItem(
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
  bool _initialSearchDone = false;


  @override
  void initState() {
    super.initState();
    // clear cart
    context.read<AddOrderBloc>().add(ClearCart());


    // load product
    context.read<AddOrderBloc>().add(
        LoadAddOrderProductsData(InfParams('10', false, '', false)));

    // اگر در حالت ویرایش هستیم و سفارش داریم، یکبار لیست id ها را سرچ کن
    if (!_initialSearchDone && widget.mode == AddOrderProductFormMode.edit &&
        widget.ordersEntity != null) {
      _initialSearchDone = true;

      // استخراج id ها از lineItems (فرض می‌کنیم کلاس LineItem دارای فیلد productId هست)
      final ids = (widget.ordersEntity!.lineItems ?? [])
          .map((li) => li.productId)
          .where((id) => id != null && id > 0)
          .map((id) => id.toString())
          .toSet() // حذف تکراری
          .toList();

      print("ids");
      print(ids);

      if (ids.isNotEmpty) {
        context.read<AddOrderBloc>().add(
            LoadOnChangedAddOrderProductsData('')); // خالی باشه، فقط hydrate کن
      }
    }
    context
        .read<AddOrderBloc>()
        .add(LoadOnChangedAddOrderProductsData(
        "")); // فقط برای انه که لیست اپدیت بشه nothing elseeeeeeee
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

  List<LineItem> _deriveLineItemsFromState(AddOrderState s) {
    if (s.addOrderCardProductStatus is AddOrderCardProductLoaded) {
      final cart =
          (s.addOrderCardProductStatus as AddOrderCardProductLoaded).cart;
      return _cartToLineItems(cart);
    }
    if (s.addOrderStatus is AddOrderProductsLoadedStatus) {
      final cart = (s.addOrderStatus as AddOrderProductsLoadedStatus).cart;
      return _cartToLineItems(cart);
    }
    return const [];
  }

  final ScrollController _billingController = ScrollController();


  @override
  void dispose() {
    _billingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;
    final width = MediaQuery
        .of(context)
        .size
        .width;

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

    paymentMethod = StaticValues.paymentMethods
        .map((m) => PaymentMethod.fromJson(m))
        .toList();
    shipmentMethod = StaticValues.shippingMethods
        .map((m) => ShippingMethod.fromJson(m))
        .toList();

    return BlocConsumer<AddOrderBloc, AddOrderState>(
      listener: (context, state) async {
        // فقط یک‌بار بعد از لودشدن محصولات، Hydrate کن
        if (!_hydratedOnce &&
            widget.mode == AddOrderProductFormMode.edit &&
            state.addOrderStatus is AddOrderProductsLoadedStatus) {
          _hydratedOnce = true;
          context
              .read<AddOrderBloc>()
              .add(HydrateCartFromOrder(widget.ordersEntity!));
        }

        if (state.addOrderStatus is AddOrderSuccessStatus) {
          final isSuccess = await alertDialogScreen(
            context,
            widget.mode == AddOrderProductFormMode.edit
                ? 'سفارش با موفقیت ویرایش شد.'
                : 'سفارش با موفقیت ایجاد شد.',
            2,
            false,
            icon: Icons.check_circle,
          );
          if (isSuccess!) {
            context.read<OrdersBloc>().add(
              LoadOrdersData(
                false,
                '',
                false,
                (10).toString(),
                '',
                isChangeStatus: true,
              ),
            );
            if (widget.mode == AddOrderProductFormMode.edit) {
              Navigator.pop(context);
              Navigator.pop(context);
            }
            // Navigator.pop(context);
            Navigator.pop(context);
          }
        }
        if (state.addOrderStatus is AddOrderErrorStatus) {
          alertDialogScreen(context, 'خطا در ایجاد سفارش.', 2, false,
              icon: Icons.check_circle);
        }
      },
      builder: (context, state) {
        final isSubmitting = state.addOrderStatus is AddOrderLoadingStatus;
        final isLoadError = state.addOrderStatus is AddOrderProductsErrorStatus;
        final isLoadingProducts =
        state.addOrderStatus is AddOrderProductsLoadingStatus;


        if (state.addOrderStatus is AddOrderProductsLoadedStatus) {
          _lastLoaded = state.addOrderStatus as AddOrderProductsLoadedStatus;
        }

        Widget mainContent;
        if (isLoadingProducts) {
          mainContent = Center(child: ProgressBar());
        } else if (isLoadError && _lastLoaded == null) {
          mainContent = const Center(
              child: Text('خطا!', style: TextStyle(color: Colors.white)));
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
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: AppConfig.calFontSize(context, 4.5)),
                  ),
                  subtitle: Text(
                    activeStep == 0
                        ? 'لطفا مشخصات صورتحساب را وارد فرمایید.'
                        : 'لطفا محصولات را انتخاب فرمایید.',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: AppConfig.calFontSize(context, 4.3)),
                  ),
                ),
                Expanded(
                  child: Container(
                    // color: Colors.green,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) =>
                          SlideTransition(
                            position: Tween<Offset>(
                                begin: const Offset(1, 0), end: Offset.zero)
                                .animate(animation),
                            child: child,
                          ),
                      child: Padding(
                        key: ValueKey<int>(activeStep),
                        //width: 500,
                        padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                        child: _buildSection(onTextChange, textEditing,
                            widget.mode, widget.ordersEntity, products),
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
          mainContent = const Center(
              child: Text("خطا در پردازش داده‌ها",
                  style: TextStyle(color: Colors.white)));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
                widget.mode == AddOrderProductFormMode.create
                    ? 'ایجاد سفارش جدید'
                    : 'ویرایش سفارش ${widget.ordersEntity?.id ?? ""}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: AppConfig.calTitleFontSize(context))),
          ),
          body: Stack(
            children: [
              mainContent,
              if (isSubmitting)
                _loadingBarrier(widget.mode == AddOrderProductFormMode.edit
                    ? 'در حال ویرایش سفارش...'
                    : 'در حال ثبت سفارش...'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection(List<Function(String)> onTextChange,
      List<TextEditingController> textEditing,
      AddOrderProductFormMode isEditMode,
      OrdersEntity? ordersEntity,
      List<ProductEntity> products,) {
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

            // 🔍 SearchBar (بیرون از لیست)
            Container(
              width: AppConfig.calWidth(context, 90),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: AppConfig.calWidth(context, 60),
                    height: AppConfig.calWidth(context, 9),
                    child: SearchBar(
                      controller: controller,
                      backgroundColor:
                      MaterialStateProperty.all(AppConfig.secondaryColor),
                      leading: Icon(Icons.search,
                        size: AppConfig.calWidth(context, 6),
                        color: Colors.white,),
                      hintText: 'جستجو',
                      textStyle: MaterialStateProperty.all(
                        TextStyle(
                            color: Colors.white,
                            fontSize: AppConfig.calFontSize(context, 4.3)),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppConfig.calBorderRadiusSize(context),
                          ),
                        ),
                      ),
                      hintStyle: MaterialStateProperty.all(
                        TextStyle(
                            fontSize: AppConfig.calFontSize(context, 4.3),
                            color: Colors.white60),
                      ),
                      onSubmitted: (value) {
                        context
                            .read<AddOrderBloc>()
                            .add(LoadOnChangedAddOrderProductsData(value));
                      },
                    ),
                  ),
                  Container(width: AppConfig.calWidth(context, 27),
                      height: AppConfig.calWidth(context, 9),
                      child: ElevatedButton(onPressed: () {
                        controller.clear();
                        context.read<AddOrderBloc>().add(LoadOnChangedAddOrderProductsData(''));
                      },
                          child: Text(
                            "پاک کردن", style: TextStyle(fontSize:AppConfig.calFontSize(context, 3),color: Colors.white),)))
                ],
              ),
            ),

            const SizedBox(height: 8),

            // 🧾 لیست محصولات
            Expanded(
              child: BlocBuilder<AddOrderBloc, AddOrderState>(
                builder: (context, state) {
                  if (state.isSearching) {
                    return Center(child: ProgressBar());
                  }

                  if (state.visibleProducts.isEmpty && state.isRemoteResult) {
                    return Center(child: Text('محصولی یافت نشد !',style: TextStyle(fontSize: AppConfig.calFontSize(context, 3.5), color: Colors.white),));
                  }

                  final cart = (state.addOrderCardProductStatus
                  is AddOrderCardProductLoaded)
                      ? (state.addOrderCardProductStatus as AddOrderCardProductLoaded).cart
                      : <int, int>{};

                  final selected = <ProductEntity>[];
                  final selectedIds = <int>{};

                  for (final id in cart.keys) {
                    ProductEntity? p = state.visibleProducts
                        .firstWhereOrNull((prod) => prod.id == id) ??
                        state.apiSearchedProducts
                            .firstWhereOrNull((prod) => prod.id == id) ??
                        StaticValues.staticProducts
                            .firstWhereOrNull((prod) => prod.id == id);

                    if (p != null) {
                      selected.add(p);
                      selectedIds.add(p.id!);
                    }
                  }

                  final remaining =
                  state.visibleProducts.where((p) => !selectedIds.contains(p.id)).toList();

                  final finalList = [...selected, ...remaining];

                  return ListView.builder(
                    itemCount: finalList.length,
                    itemBuilder: (context, index) {
                      final product = finalList[index];
                      return AddOrderProduct(
                        isEditMode,
                        product,
                        ordersEntity,
                            (_) {},
                      );
                    },
                  );
                },
              )


            )
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
            final payIdx = paymentMethod?.indexWhere((m) =>
            (m.methodTitle ?? '').trim() == paymentBill.trim()) ??
                -1;
            final shipIdx = shipmentMethod?.indexWhere((m) =>
            (m.methodTitle ?? '').trim() == shipmentBill.trim()) ??
                -1;
            if (emailBill.isNotEmpty) {
              if (!isValidEmail(emailBill)) {
                showSnack(context, "ایمیل حتما باید به فرمت صحیح باشد!");
                return;
              }
            }

            if ((_formKey.currentState?.validate() ?? false) &&
                payIdx >= 0 &&
                shipIdx >= 0) {
              setState(() => activeStep = 1);
            } else {
              showSnack(context, "لطفاً فیلدهای مورد نیاز را پر کنید!");
            }
            return;
          }

          if (activeStep == 1) {
            final st = context
                .read<AddOrderBloc>()
                .state;
            final derived = _deriveLineItemsFromState(st);

            if (derived.isEmpty) {
              alertDialogScreen(
                  context, 'هیچ محصولی انتخاب نشده است!', 1, true);
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

            shippingLine = [
              ShippingLine(methodId: shipType, methodTitle: shipTypeTitle)
            ];

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
            (widget.mode == AddOrderProductFormMode.edit)
                ? (widget.ordersEntity?.id ?? 0)
                : 0;

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

            context.read<AddOrderBloc>().add(SetOrderEvent(
                SetOrderParams(order, payType, shipType, priceShip)));
            return;
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConfig.secondaryColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
        ),
        child: Text(
          activeStep == 1
              ? (widget.mode == AddOrderProductFormMode.edit ? 'ویرایش' : 'ثبت')
              : 'بعدی',
          style: TextStyle(
              color: Colors.white, fontSize: AppConfig.calFontSize(context, 4)),
          textAlign: TextAlign.center,
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
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
        ),
        child: Text('قبلی',
            style: TextStyle(
                color: Colors.white,
                fontSize: AppConfig.calFontSize(context, 4))),
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
              border: activeStep == 1
                  ? Border.all(width: 2, color: Colors.grey)
                  : null,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: FractionallySizedBox(
                heightFactor: 0.6,
                widthFactor: 0.9,
                child: CircleAvatar(
                    backgroundColor: Colors.white, child: Text('2')),
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
          Container(
            width: 40,
            decoration: BoxDecoration(
              color: AppConfig.backgroundColor,
              border: activeStep == 0
                  ? Border.all(width: 2, color: Colors.grey)
                  : null,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: FractionallySizedBox(
                heightFactor: 0.6,
                widthFactor: 0.9,
                child: CircleAvatar(
                    backgroundColor: Colors.white, child: Text('1')),
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

bool isValidEmail(String email) {
  final RegExp regex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  if (email.isEmpty) return false;
  return regex.hasMatch(email);
}

class _LoadMoreButton extends StatelessWidget {
  int listCount;

  _LoadMoreButton(this.listCount);

  @override
  Widget build(BuildContext context) {
    final state = context
        .watch<AddOrderBloc>()
        .state;
    final isLoadingMore = state.isLoadingMore == true;

    return ElevatedButton(
      onPressed: isLoadingMore
          ? null
          : () {
        final currentCount = StaticValues.staticProducts.length;
        context.read<AddOrderBloc>().add(
          LoadAddOrderProductsData(
            InfParams((currentCount + 10).toString(), false, '', true),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConfig.secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(width: 0.3, color: Colors.grey[300]!),
        ),
      ),
      child: isLoadingMore
          ? SizedBox(
        height: AppConfig.calHeight(context, 4),
        child: ProgressBar(size: 3),
      )
          : Text(
        "بارگیری بیشتر",
        style: TextStyle(
          fontSize: AppConfig.calFontSize(context, 3.4),
          color: Colors.white,
        ),
      ),
    );
  }
}

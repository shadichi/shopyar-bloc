import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:shapyar_bloc/features/feature_orders/presentation/widgets/order.dart';
import '../../../../core/params/setOrderPArams.dart';
import '../../../../core/widgets/snackBar.dart';
import '../../../feature_orders/domain/entities/orders_entity.dart';
import '../../../../core/config/app-colors.dart';
import '../../../../core/utils/static_values.dart';
import '../../../../core/widgets/alert_dialog.dart';
import '../../../../core/widgets/progress-bar.dart';
import '../../data/models/add_order_data_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/add_order_orders_model.dart';
import '../../domain/entities/add_order_orders_entity.dart';
import '../bloc/add_order_bloc.dart';
import '../bloc/add_order_status.dart';
import '../widgets/AddOrderBillTest.dart';
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

  const ProductFormScreen._(
      {required this.mode, this.ordersEntity}); // 👈 private constructor

  factory ProductFormScreen.create() =>
      ProductFormScreen._(mode: ProductFormMode.create);

  factory ProductFormScreen.edit({required OrdersEntity ordersEntity}) =>
      ProductFormScreen._(
        mode: ProductFormMode.edit,
        ordersEntity: ordersEntity,
      );

//کلمه‌ی factory یعنی «این سازنده لزوماً همیشه یک آبجکت جدید نمی‌سازه، می‌تونه یک نمونه‌ی موجود رو برگردونه یا منطق اضافه اجرا کنه».
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
  List<LineItem> lineItem = [];
  List<ShippingLine> shippingLine = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _validateForm() {
    if (_formKey.currentState?.validate() ?? false) {
      print("Form is valid ✅");
    } else {
      print("Form is invalid ❌");
    }
  }

  @override
  void initState() {
    super.initState();

    context.read<AddOrderBloc>().add(LoadAddOrderProductsData());
    if (widget.mode == ProductFormMode.edit) {
      context
          .read<AddOrderBloc>()
          .add(HydrateCartFromOrder(widget.ordersEntity!));
    } else {
      context.read<AddOrderBloc>().add(ClearCart());
    }
  }

  String get _nextButtonLabel {
    if (activeStep == 0) return 'بعدی';
    return widget.mode == ProductFormMode.edit ? 'ویرایش سفارش' : 'ثبت سفارش';
  }

  final TextEditingController controller = TextEditingController();

  TextEditingController step1CustomerFNBill = TextEditingController();
  TextEditingController step1CustomerLNBill = TextEditingController();
  TextEditingController step1AddressBill = TextEditingController();
  TextEditingController step1CityBill = TextEditingController();
  TextEditingController step1PostalCodeBill = TextEditingController();
  TextEditingController step1EmailBill = TextEditingController();
  TextEditingController step1PhoneBill = TextEditingController();
  TextEditingController step1ShipPrice = TextEditingController();

  AddOrderProductsLoadedStatus? _lastLoaded;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    List<TextEditingController> textEditing = [
      step1CustomerFNBill,
      step1CustomerLNBill,
      step1AddressBill,
      step1CityBill,
      step1PostalCodeBill,
      step1EmailBill,
      step1PhoneBill,
      step1ShipPrice,
    ];

    List<Function(String)> onTextChange = [
      (value) {
        customerLNBill = value;
        print("نام خانوادگی خریدار");
        print(customerLNBill);
      },
      (value) {
        customerFNBill = value;
        print("نام خریدار");
        print(customerFNBill);
      },
      (value) {
        cityBill = value;
        print("شهر محل زندگی");
        print(cityBill);
      },
      (value) {
        provinceBill = value;
        print("استان");
        print(provinceBill);
      },
      (value) {
        addressBill = value;
        print("آدرس خریدار");
        print(addressBill);
      },
      (value) {
        postalCodeBill = value;
        print("کد پستی خریدار");
        print(postalCodeBill);
      },
      (value) {
        emailBill = value;
        print("ایمیل");
        print(emailBill);
      },
      (value) {
        phoneBill = value;
        print("شماره همراه");
        print(phoneBill);
      },
      (value) {
        shipmentBill = value;
        print("روش حمل و نقل در ویجت اصلی");
        print(shipmentBill);
      },
      (value) {
        paymentBill = value;
        print("روش پرداخت");
        print(paymentBill);
      },
      (value) {
        shipPriceBill = value;
        print("هزینه حمل و نقل");
        print(shipPriceBill);
      }
    ];

    paymentMethod = StaticValues.paymentMethods
        .map((method) => PaymentMethod.fromJson(method))
        .toList();
    shipmentMethod = StaticValues.shippingMethods
        .map((method) => ShippingMethod.fromJson(method))
        .toList();

    return BlocConsumer<AddOrderBloc, AddOrderState>(
      listener: (context, state) {
        if (state.addOrderStatus is AddOrderSuccessStatus) {
          alertDialogScreen(context, 'سفارش با موفقیت ایجاد شد.', 2, false,
              icon: Icons.check_circle);
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
              child: Text(
            'خطا!',
            style: TextStyle(color: Colors.white),
          ));
        } else if (_lastLoaded != null) {
          // ⚠️ از _lastLoaded برای پر کردن pay/ship استفاده کن
          final loaded = _lastLoaded!;

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
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  subtitle: Text(
                    activeStep == 0
                        ? 'لطفا مشخصات صورتحساب را وارد فرمایید.'
                        : 'لطفا محصولات را انتخاب فرمایید.',
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) => SlideTransition(
                      position: Tween<Offset>(
                              begin: const Offset(1, 0), end: Offset.zero)
                          .animate(animation),
                      child: child,
                    ),
                    child: SizedBox(
                      key: ValueKey<int>(activeStep),
                      width: 350,
                      child: _buildSection(onTextChange, textEditing,
                          widget.mode, widget.ordersEntity),
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
          backgroundColor: AppConfig.background,
          appBar: AppBar(
            backgroundColor: AppConfig.background,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              widget.mode == ProductFormMode.create
                  ? 'ایجاد سفارش جدید'
                  : 'ویرایش سفارش ${widget.ordersEntity?.id ?? ""}',
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
          body: Stack(
            children: [
              mainContent,
              if (isSubmitting) _loadingBarrier('در حال ثبت سفارش...'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection(
    onTextChange,
    textEditing,
    isEditMode,
    OrdersEntity? ordersEntity,
  ) {
    switch (activeStep) {
      case 0:
        return Addorderbilltest(paymentMethod, shipmentMethod, onTextChange,
            _formKey, textEditing, isEditMode,
            ordersEntity: ordersEntity);
      case 1:
        return ListView.builder(
            itemCount: StaticValues.staticProducts.length,
            itemBuilder: (context, index) {
              final product = StaticValues.staticProducts[index];
              return AddOrderProduct(
                isEditMode,
                product,
                ordersEntity,
                (p0) {
                  // فرض: p0 = Map<int, int>  // productId -> quantity
                  lineItem
                    ..clear()
                    ..addAll(
                      p0.entries.map((e) => LineItem(
                            id: 0,
                            productId: e.key,
                            name: "",
                            // اگه اسم داری اینجا بذار
                            quantity: e.value,
                            total:
                                '1000', // اگه total واحدی می‌خوای: (unitPrice[e.key] * e.value).toString()
                          )),
                    );
                },
              );
            });
      default:
        return Container();
    }
  }

  Widget nextButton(AddOrderProductsLoadedStatus addOrderProductsLoadedStatus) {
    return Container(
      margin: EdgeInsets.all(10),
      width: AppConfig.calWidth(context, 30),
      child: ElevatedButton(
        onPressed: () {
          // برای دیباگ
          print(
              'paymentBill: $paymentBill | shipmentBill: $shipmentBill | provinceBill: $provinceBill');

          if (activeStep == 0) {
            // پیش‌فرض‌ها اگر کاربر انتخاب نکرده
            if ((paymentBill).trim().isEmpty &&
                (paymentMethod?.isNotEmpty ?? false)) {
              paymentBill = (paymentMethod!.first.methodTitle ?? '').trim();
            }
            if ((shipmentBill).trim().isEmpty &&
                (shipmentMethod?.isNotEmpty ?? false)) {
              shipmentBill = (shipmentMethod!.first.methodTitle ?? '').trim();
            }
            if ((provinceBill).trim().isEmpty) {
              provinceBill = 'تهران';
            }

            // اعتبارسنجی فرم + وجود انتخاب‌ها
            final payIdx = paymentMethod?.indexWhere(
                  (m) => (m.methodTitle ?? '').trim() == paymentBill.trim(),
                ) ??
                -1;
            final shipIdx = shipmentMethod?.indexWhere(
                  (m) => (m.methodTitle ?? '').trim() == shipmentBill.trim(),
                ) ??
                -1;

            print('payIdx: $payIdx, shipIdx: $shipIdx');

            if ((_formKey.currentState?.validate() ?? false) &&
                payIdx >= 0 &&
                shipIdx >= 0) {
              setState(() => activeStep = 1); // برو به صفحهٔ محصولات
            } else {
              showSnack(context, "لطفاً همه فیلدهای مورد نیاز را پر کنید!");
            }
            return;
          }

          // استپ ۱: محصولات → ثبت/ویرایش سفارش
          if (activeStep == 1) {
            _validateForm();

            if (lineItem.isEmpty) {
              alertDialogScreen(
                  context, 'هیچ محصولی انتخاب نشده است!', 1, true);
              return;
            }

            // Resolve امن و نهایی بر اساس عنوان (در آینده بهتره با ID کار کنی)
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

            // اگر خواستی هم‌زمان برای UI خودت نگه داری
            shippingLine = [
              ShippingLine(methodId: shipType, methodTitle: shipTypeTitle),
            ];

            // ساخت آدرس‌ها (بهتره country=IR باشه)
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

            // اگر حالت ویرایشه، id سفارش قبلی رو بذار تا API همون رو آپدیت کنه
            final int orderIdForEdit = (widget.mode == ProductFormMode.edit)
                ? (widget.ordersEntity?.id ?? 0)
                : 0;

            // ساخت سفارش برای ارسال به ایونت
            final order = AddOrderOrdersEntity(
              id: orderIdForEdit,
              // ۰ = ایجاد جدید، >۰ = ویرایش
              status: 'pending',
              // اختیاری؛ API تو لازم نداره
              billing: billing,
              shipping: shipping,
              paymentMethod: payType,
              // برای نمایش داخلی؛ API مقدار واقعی رو از payType می‌خونه
              paymentMethodTitle: paymentBill,
              // اگر نیاز داری در UI بعداً نشون بدی
              lineItems: lineItem,
              // از استپ محصولات
              shippingLines:
                  shippingLine, // فقط برای UI خودت؛ API از پارام جداگانه استفاده می‌کنه
            );

            // 🔔 ارسال ایونت Bloc
            context.read<AddOrderBloc>().add(
                  SetOrderEvent(
                    SetOrderParams(order, payType, shipType, priceShip),
                  ),
                );

            // اینجا activeStep رو افزایش نده؛ بگذار تو همین استپ بمونه تا لودینگ نمایش داده بشه
            // وقتی Success اومد (listenerت)، می‌تونی پیام بدی/برگردی
            return;
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: AppConfig.secondaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)))),
        child: Text(
          activeStep == 1
              ? widget.mode == ProductFormMode.edit
                  ? 'ویرایش سفارش'
                  : 'ثبت سفارش'
              : 'بعدی',
          style: TextStyle(
              color: Colors.white,
              fontSize: AppConfig.calFontSize(context, 2.5)),
        ),
      ),
    );
  }

  Widget previousButton() {
    return Container(
      width: AppConfig.calWidth(context, 30),
      margin: EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () {
          // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
          if (activeStep > 0) {
            setState(() {
              activeStep--;
            });
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: AppConfig.secondaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)))),
        child: Text(
          'قبلی',
          style: TextStyle(
              color: Colors.white,
              fontSize: AppConfig.calFontSize(context, 2.5)),
        ),
      ),
    );
  }

  Widget stepper() {
    return Container(
      width: 320,
      height: 50,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 40,
            decoration: BoxDecoration(
              color: AppConfig.background,
              border: activeStep == 1
                  ? Border.all(width: 2, color: Colors.grey)
                  : null,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FractionallySizedBox(
                heightFactor: 0.6,
                // Adjust those two for the white space
                widthFactor: 0.9,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Text('2'),
                ),
              ),
            ),
          ),
          Container(
              width: 200,
              height: 20,
              /*color: Colors.green,*/
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 5),
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
              )),
          Container(
            width: 40,
            decoration: BoxDecoration(
              color: AppConfig.background,
              border: activeStep == 0
                  ? Border.all(width: 2, color: Colors.grey)
                  : null,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FractionallySizedBox(
                heightFactor: 0.6,
                // Adjust those two for the white space
                widthFactor: 0.9,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Text('1'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget section1() {
    return Container(
      padding: EdgeInsets.all(8),
      // color: Colors.green,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            spacing: 20,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textField(controller, 'نام'),
                  textField(controller, ' نام خانوادگی'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textField(controller, 'استان'),
                  textField(controller, 'شهر محل زندگی')
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textField(controller, 'آدرس خریدار', isOnlyChild: true)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textField(controller, 'کد پستی خریدار'),
                  textField(controller, 'ایمیل خریدار'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textField(controller, 'شماره همراه خریدار', isOnlyChild: true)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textField(controller, 'روش پرداخت'),
                  textField(controller, 'روش حمل ونقل')
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textField(controller, 'هزینه حمل ونقل', isOnlyChild: true)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget section2() {
    return Container(
      padding: EdgeInsets.all(8),
      color: Colors.grey,
      /*  decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(5),
      ),*/
    );
  }

  Widget textField(controller, hintText, {bool isOnlyChild = false}) {
    return Container(
      width: isOnlyChild ? 310 : 150,
      height: 30,
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 10, color: Colors.black87),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          //prefixIcon: Icon(Icons.add, color: Colors.deepPurple),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade500),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            //  borderSide: BorderSide(color: Colors.grey, width: 1.4),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
          // Optional:
          // errorBorder, focusedErrorBorder, suffixIcon
        ),
      ),
    );
  }

  Widget _loadingBarrier([String? message]) {
    return Stack(
      children: [
        const ModalBarrier(
          dismissible: false,
          color: Colors.black54,
        ),
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

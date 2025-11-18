import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shopyar/core/config/app-colors.dart';
import 'package:dropdown_button2/src/dropdown_button2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopyar/core/widgets/progress-bar.dart';
import 'package:shopyar/features/feature_add_edit_product/presentation/bloc/add_product_bloc.dart';

import '../../data/models/add_order_data_model.dart';
import '../../data/models/variation_model.dart';
import '../screens/product_form_screen.dart' hide ProductStatus;

class AddProductBillAdditional extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  AddProductDataModel addProductDataModel;
  final List<Function(String)> onTextChange;
  final Function(List<int>) catOnTextChange;
  final Function(List<int>) brandOnTextChange;
  final Function(BuiltAttributePayload) attributeChooser;
  final Function(List<VariationUiModel>) variationUiModel;
  final Function(int) countOnTextChange;

  AddProductBillAdditional(this.formKey,
      this.addProductDataModel, this.onTextChange, this.catOnTextChange, this.brandOnTextChange, this.attributeChooser, this.variationUiModel, this.countOnTextChange);

  @override
  State<AddProductBillAdditional> createState() =>
      _AddProductBillAdditionalState();
}

class _AddProductBillAdditionalState extends State<AddProductBillAdditional> {
  @override
  void initState() {
    super.initState();
    context
        .read<AddProductBloc>()
        .add(AddAttributeEvent(widget.addProductDataModel.attributes));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }



  List<String> productTypeList = ["ساده", "متغیر"];

  List<String> productStatusList = ["منتشر شده", "پیش نویس", "در انتظار بازبینی"];

  String customerLNBill = 'dd';

   ProductType pt = ProductType.simple;


  TextEditingController controller = TextEditingController();

  int activeStep = 0;
  final _picker = ImagePicker();
  String indexImagePath = '';

  // === Helpers (بالای فایل، بعد از importها) ===
  String nameBySlug(Attribute attr, String slug) {
    final m = attr.terms.firstWhere(
      (b) => b.slug == slug,
      orElse: () => Brand(id: -1, name: slug, slug: slug),
    );
    return m.name;
  }

  String slugByName(Attribute attr, String name) {
    final m = attr.terms.firstWhere(
      (b) => b.name == name,
      orElse: () => Brand(id: -1, name: name, slug: name),
    );
    return m.slug;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    Widget mainContent;
    mainContent = Form(
        key: widget.formKey,
      child: Container(
        // height: height,
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  // height:AppConfig.calHeight(context, 50),
                  // color: Colors.green,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) => SlideTransition(
                      position: Tween<Offset>(
                              begin: const Offset(1, 0), end: Offset.zero)
                          .animate(animation),
                      child: child,
                    ),
                    child: Padding(
                      key: ValueKey<int>(activeStep),
                      //width: 500,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Expanded(child: _buildSection())],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return mainContent;
  }


  Widget _buildSection() {
    switch (activeStep) {
      case 0:
        return Column(
          spacing: AppConfig.calHeight(context, 2),
          children: [
            AppDropdown<String>(
              items: productTypeList,
              label: 'نوع محصول',
              getLabel: (c) => c,
              onChanged: (c) {
                print('type picked: $c');
                 pt = c == productTypeList[0] ? ProductType.simple : ProductType.variable;
                context
                    .read<AddProductBloc>()
                    .add(SetTypeOfProductEvent(pt));
                widget.onTextChange[0](pt.name);
              },
            ),

            AttributeSection(
              key1: '',
              attributeChooser: widget.attributeChooser,
              variationUiModel: widget.variationUiModel,
            ),
            AppMultiSelect<Category>(
              items: widget.addProductDataModel.categories,
              label: 'دسته‌بندی',
              getLabel: (c) => c.name,
              onChanged: (selectedCategories) {
                // لیست کامل مدل‌ها:
                print('picked categories: '
                    '${selectedCategories.map((c) => '${c.id}-${c.name}').join(', ')}');

                // اگر فقط آیدی‌ها رو میخوای برای ارسال:
                final ids = selectedCategories.map((c) => c.id).toList();
                widget.catOnTextChange(ids); // مثلا "12,45,9"
              },
            ),
            AppMultiSelect<Brand>(
              items: widget.addProductDataModel.brands,
              label: 'برند',
              getLabel: (b) => b.name,
              onChanged: (selectedCategories) {
                // لیست کامل مدل‌ها:
                print('picked brands: '
                    '${selectedCategories.map((b) => '${b.id}-${b.name}').join(', ')}');

                // اگر فقط آیدی‌ها رو میخوای برای ارسال:
                final ids = selectedCategories.map((b) => b.id).toList();
                widget.brandOnTextChange(ids); // مثلا "12,45,9"
              },
            ),
            AppDropdown<ProductStatus>(
              items: ProductStatus.values,
              label: 'وضعیت',
              getLabel: (a) => a.faLabel,
              onChanged: (a) {
                print('Status picked: ${a.apiValue}');
                widget.onTextChange[1](a.apiValue);

              },
            ),
            SizedBox(
              height: AppConfig.calHeight(context, 0.5),
            ),
            pt == ProductType.simple ?
            textField(
              controller,
              'موجودی',
              context,
              onChanged: (String value) {
                print('brand picked: $value');
                widget.countOnTextChange(int.parse(value));
              },
            ):SizedBox.shrink()
            // checkBoxs()
          ],
        );

      case 1:
        return textField(
          controller,
          'نام',
          context,
          onChanged: (String value) {},
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget checkBoxs() {
    return Container(
      width: double.infinity,
      // height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            child: Container(
              child: CheckboxListTile(
                title: Text(
                  "مدیریت انبار",
                  style: TextStyle(color: AppConfig.white),
                ),
                value: true,
                onChanged: (newValue) {},
              ),
            ),
          ),
          Flexible(
            child: Container(
              child: CheckboxListTile(
                title: Text(
                  "در انبار",
                  style: TextStyle(color: AppConfig.white),
                ),
                value: true,
                onChanged: (newValue) {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget textField(
      TextEditingController controller, String hintText, BuildContext context,
      {bool isOnlyChild = false,
      required ValueChanged<String> onChanged,
      bool isNec = false,
      bool isDigit = false,
      bool isLongExpression = false}) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
        //width: double.infinity,
        height: isLongExpression ? height * 0.15 : height * 0.08,
        child: TextFormField(
          controller: controller,
          onChanged: onChanged,
          maxLines: isLongExpression ? null : 1,
          minLines: isLongExpression ? 4 : 1,
          keyboardType: isDigit ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          ),
          validator: isNec
              ? (value) => (value == null || value.trim().isEmpty) ? ' ' : null
              : null,
        ));
  }
}

class AttributeSection extends StatefulWidget {
  final String key1;
  /// خروجی نهایی: attributes + variations
  final Function(BuiltAttributePayload) attributeChooser;
  final Function(List<VariationUiModel>) variationUiModel;

  const AttributeSection({
    super.key,
    required this.key1,
    required this.attributeChooser,
    required this.variationUiModel,
  });

  @override
  State<AttributeSection> createState() => _AttributeSectionState();
}

class _AttributeSectionState extends State<AttributeSection> {


  // اطلاعات UI برای هر ورییشن (قیمت، موجودی، ...)
  List<VariationUiModel> _variationUi = [];


  // === Helpers (بالای فایل، بعد از importها) ===
  String nameBySlug(Attribute attr, String slug) {
    final m = attr.terms.firstWhere(
          (b) => b.slug == slug,
      orElse: () => Brand(id: -1, name: slug, slug: slug),
    );
    return m.name;
  }

  void _notifyVariationUi() {
    // بهتره یک کپی غیرقابل‌تغییر بفرستی
    widget.variationUiModel(List<VariationUiModel>.unmodifiable(_variationUi));
  }


  String slugByName(Attribute attr, String name) {
    final m = attr.terms.firstWhere(
          (b) => b.name == name,
      orElse: () => Brand(id: -1, name: name, slug: name),
    );
    return m.slug;
  }

  /// از state فعلی BLoC، payload می‌سازیم و با توجه به advancedMode
  /// variationها رو enrich می‌کنیم و به بالا پاس می‌دیم.
  void _rebuildAndNotify(AddProductState state) {
    final basePayload = buildSelectedAttributesPayload(
      state.selectedAttributes,
      state.selectedTerms,
    );

    print("basePayload");
    print(basePayload.attributes);


    if (basePayload.variations.isEmpty) {
      _variationUi = [];
      widget.attributeChooser(basePayload);
      _notifyVariationUi(); // لیست خالی
      return;
    }

    final attrsList = state.selectedAttributes;

    // 1) map از UI قدیمی براساس key ترکیب
    final oldByKey = <String, VariationUiModel>{};
    for (final v in _variationUi) {
      final key = _variationKey(v.attributes);
      oldByKey[key] = v;
    }

    // 2) لیست جدید بر اساس basePayload.variations
    final List<VariationUiModel> newUi = [];

    for (final v in basePayload.variations) {
      final rawAttrs = Map<String, String>.from(v['attributes'] ?? {});
      final key = _variationKey(rawAttrs);
      final old = oldByKey[key];

      final displayMap = <String, String>{};

      rawAttrs.forEach((tax, slug) {
        final attr = attrsList.firstWhere(
              (a) => a.taxonomy == tax,
          orElse: () => Attribute(
            id: -1,
            name: tax,
            slug: tax,
            taxonomy: tax,
            terms: [],
          ),
        );

        final attrLabel = attr.name;
        final termLabel = nameBySlug(attr, slug);

        displayMap[attrLabel] = termLabel;
      });

      newUi.add(
        VariationUiModel(
          attributes: rawAttrs,
          displayAttributes: displayMap,
          regularPrice: old?.regularPrice,
          salePrice: old?.salePrice,
          manageStock: old?.manageStock ?? false,
          stockQuantity: old?.stockQuantity,
          inStock: old?.inStock ?? true,
          imageFile: old?.imageFile,      // اگر داری
          imageMediaId: old?.imageMediaId,
        ),
      );
    }

    _variationUi = newUi;

    // ⬅️ همیشه بعد از سینک، لیست کامل رو بفرست بالا
    _notifyVariationUi();

    // حالت فول: merge با extra fields
    final List<Map<String, dynamic>> enrichedVariations = [];

    for (int i = 0; i < basePayload.variations.length; i++) {
      final base = Map<String, dynamic>.from(basePayload.variations[i]);
      final ui = _variationUi[i];

      if (ui.regularPrice != null && ui.regularPrice!.isNotEmpty) {
        base['regular_price'] = ui.regularPrice;
      }
      if (ui.salePrice != null && ui.salePrice!.isNotEmpty) {
        base['sale_price'] = ui.salePrice;
      }
      base['manage_stock'] = ui.manageStock;
      if (ui.manageStock && ui.stockQuantity != null && ui.stockQuantity!.isNotEmpty) {
        base['stock_quantity'] = int.tryParse(ui.stockQuantity!) ?? 0;
      }
      base['in_stock'] = ui.inStock;

      enrichedVariations.add(base);
    }

    final fullPayload = BuiltAttributePayload(
      attributes: basePayload.attributes,
      variations: enrichedVariations,
    );

    widget.attributeChooser(fullPayload);
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return BlocConsumer<AddProductBloc, AddProductState>(
      listener: (context, state) {
        // اینجا همیشه آخرین state رو داری
        _rebuildAndNotify(state);
      },
      builder: (context, state) {
        // اگر محصول ساده است، این سکشن نمایش داده نشود
        if (state.productType == ProductType.simple) {
          return const SizedBox.shrink();
        }

        // ➊ ویژگی‌های قابل افزودن (available) و انتخاب‌شده (selected)
        final available = state.availableAttributes.toSet().toList();
        final selected = state.selectedAttributes;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ➋ هدر سکشن + سوییچ حالت پیشرفته
              Row(
                children: [
                  const Icon(Icons.category_outlined, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'ویژگی‌های محصول متغیر',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),

                ],
              ),
              const SizedBox(height: 12),

              // ➌ DROPDOWN افزودن ویژگی جدید از لیست available
              Row(
                children: [
                  Expanded(
                    child: AppDropdown<Attribute>(
                      key: ValueKey(
                        'add-attr-${available.map((e) => e.name).join(',')}',
                      ),
                      items: available,
                      label: 'افزودن ویژگی',
                      getLabel: (a) => a.name,
                      onChanged: (picked) {
                        context
                            .read<AddProductBloc>()
                            .add(SelectAttributeEvent(picked));
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Tooltip(
                    message:
                    'از لیست یک ویژگی انتخاب کنید تا به پایین اضافه شود',
                    child: Icon(Icons.add_circle_outline, size: 18),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ➍ اگر هنوز هیچ ویژگی انتخاب نشده:
              if (selected.isEmpty)
                _EmptyHint(
                  width: w,
                  text:
                  'هیچ ویژگی‌ای انتخاب نشده است.\nاز بالا یک ویژگی انتخاب کنید تا مقادیر آن را تعیین کنید.',
                ),

              // ➎ لیست ویژگی‌های انتخاب‌شده + چیپ‌های انتخاب/حذف مقدارها
              if (selected.isNotEmpty)
                SizedBox(
                  height: h * 0.24,
                  child: ListView.separated(
                    itemCount: selected.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final attr = selected[index];

                      // همه‌ی slugهای این ویژگی (کلید منطقی ما)
                      final allSlugs = attr.terms.map((b) => b.slug).toList();

                      // ستِ انتخاب‌شده‌ها از state (بر اساس slug)
                      final chosen =
                          state.selectedTerms[attr.taxonomy] ?? <String>{};

                      // باقی‌مانده‌ها برای افزودن
                      final remainingSlugs = allSlugs
                          .where((slug) => !chosen.contains(slug))
                          .toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ➏ سرتیتر هر ویژگی + حذف کل ویژگی
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  attr.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: 'حذف کل ویژگی',
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () {
                                  context
                                      .read<AddProductBloc>()
                                      .add(RemoveSelectedAttributeEvent(attr));
                                  // بقیه‌اش لازم نیست؛ BlocConsumer.listener خودش کارو می‌کنه
                                },

                              ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          // ➐ مقادیر انتخاب‌شده (چیپ با ضربدر برای حذف تکی)
                          if (chosen.isNotEmpty) ...[
                            Text(
                              'انتخاب‌شده‌ها',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: chosen.map((slug) {
                                final name = nameBySlug(attr, slug);
                                return InputChip(
                                  label: Text(name),
                                  onDeleted: () {
                                    context.read<AddProductBloc>().add(
                                      ToggleTermEvent(attr.taxonomy, slug, false),
                                    );
                                  },

                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 10),
                          ],

                          // ➑ افزودن مقدار جدید (چیپ‌های اضافه‌کردن)
                          Text(
                            'افزودن مقدار',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          if (remainingSlugs.isEmpty)
                            Text(
                              'مقداری برای افزودن باقی نمانده',
                              style: Theme.of(context).textTheme.bodySmall,
                            )
                          else
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: remainingSlugs.map((slug) {
                                final name = nameBySlug(attr, slug);
                                return ActionChip(
                                  label: Text(name),
                                  onPressed: () {
                                    context.read<AddProductBloc>().add(
                                      ToggleTermEvent(attr.taxonomy, slug, true),
                                    );
                                    // دیگه اینجا کاری نکن؛ listener خودش بعد از آپدیت صدا می‌خوره
                                  },
                                )
                                ;
                              }).toList(),
                            ),
                        ],
                      );
                    },
                  ),
                ),

              // ➒ اگر حالت پیشرفته روشن است و variation داریم، UI ورییشن‌ها

                const Divider(height: 24),
                Text(
                  'تنظیمات ویژگی‌های متغیر',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildVariationsEditor(context),

            ],
          ),
        );
      },
    );
  }

  Widget _buildVariationsEditor(BuildContext context) {
    if (_variationUi.isEmpty) {
      return Text(
        'ابتدا مقدارهایی برای ویژگی‌ها انتخاب کنید تا متغیرها ساخته شوند.',
        style: Theme.of(context).textTheme.bodySmall,
      );
    }

    return Column(
      children: _variationUi.asMap().entries.map((entry) {
        final index = entry.key;
        final v = entry.value;

        final attrsLabel = v.displayAttributes.entries
            .map((e) => '${e.key}: ${e.value}')
            .join(' | ');


        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attrsLabel,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                        hintText: 'قیمت',
                        //  fillColor: const Color(0xffededed),
                          contentPadding: EdgeInsets.symmetric(vertical: AppConfig.calHeight(context, 0.5), horizontal: 8),
                          enabledBorder:  OutlineInputBorder(
                            borderSide: BorderSide(width: 0.5, color: Theme.of(context).colorScheme.primary,),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                          ),
                        ),

                        keyboardType: TextInputType.number,
                        initialValue: v.regularPrice,
                        onChanged: (val) {
                          setState(() {
                            _variationUi[index].regularPrice = val;
                          });
                          _notifyVariationUi();
                        },

                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          hintText: 'قیمت  تخفیفی',
                          //  fillColor: const Color(0xffededed),
                          contentPadding: EdgeInsets.symmetric(vertical: AppConfig.calHeight(context, 0.5), horizontal: 8),
                          enabledBorder:  OutlineInputBorder(
                            borderSide: BorderSide(width: 0.5, color: Theme.of(context).colorScheme.primary,),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: v.salePrice,
                        onChanged: (val) {
                          setState(() => _variationUi[index].salePrice = val);
                          _notifyVariationUi();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
            Row(
              children: [
                // ستون اول: چک‌باکس + متن (نصف عرض کارد)
                Expanded(
                  child: Container(


                    child: Row(
                      children: [
                        Checkbox(
                          value: v.manageStock,
                          onChanged: (val) {
                            setState(() {
                              _variationUi[index].manageStock = val ?? false;
                            });
                            _notifyVariationUi();
                          },
                        ),
 Text('مدیریت موجودی',style: TextStyle(fontSize: AppConfig.calFontSize(context, 3.5)),),
                      ],
                    ),
                  ),
                ),

                // فاصله بین ستون چپ و راست
                if (v.manageStock) const SizedBox(width: 8),

                // ستون دوم: تکست فیلد (نصف عرض کارد، هم‌تراز با TextFieldهای بالا)
                if (v.manageStock)
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        hintText: 'تعداد موجودی',
                        contentPadding: EdgeInsets.symmetric(
                          vertical: AppConfig.calHeight(context, 0.5),
                          horizontal: 8,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0.5,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: v.stockQuantity,
                      onChanged: (val) {
                        setState(() => _variationUi[index].stockQuantity = val);
                        _notifyVariationUi();
                      },
                    ),
                  ),
              ],
            ),

            Row(
                  children: [
                    Checkbox(
                      value: v.inStock,
                      onChanged: (val) {
                        setState(
                              () => _variationUi[index].inStock = val ?? true,
                        );
                        _notifyVariationUi();
                      },
                    ),
                     Text('موجود است',style: TextStyle(fontSize: AppConfig.calFontSize(context, 3.5))),
                    const Spacer(),

                  ],
                ),
                _variationUi[index].imageFile == null
                    ? TextButton.icon(
                  onPressed: () async {
                    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (picked == null) return;
                    final file = File(picked.path);

                    setState(() {
                      _variationUi[index].imageFile = file;
                    });
                    _notifyVariationUi();
                  },
                  icon: const Icon(Icons.image_outlined),
                  label: const Text('انتخاب تصویر'),
                )
                    : Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.file(_variationUi[index].imageFile!, fit: BoxFit.cover),
                      ),
                    ),

                    TextButton.icon(
                      onPressed: () async {
                        final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if (picked == null) return;
                        final file = File(picked.path);

                        setState(() {
                          _variationUi[index].imageFile = file;
                        });
                        _notifyVariationUi();
                      },
                      icon: const Icon(Icons.image_outlined),
                      label: const Text('تغییر تصویر'),
                    ),

                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _variationUi[index].imageFile = null;
                        });
                        _notifyVariationUi();
                      },
                      icon: const Icon(Icons.delete_forever_rounded),
                      label: const Text('حذف تصویر', ),
                    ),
                  ],
                ),


              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
class _EmptyHint extends StatelessWidget {
  final double width;
  final String text;

  const _EmptyHint({required this.width, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

class AppMultiSelect<T> extends StatefulWidget {
  final List<T> items;
  final List<T> initialValues;
  final String label;
  final String Function(T) getLabel;
  final void Function(List<T>) onChanged;
  final bool isShouldHalf;

  const AppMultiSelect({
    super.key,
    required this.items,
    required this.getLabel,
    required this.onChanged,
    required this.label,
    this.initialValues = const [],
    this.isShouldHalf = false,
  });

  @override
  State<AppMultiSelect<T>> createState() => _AppMultiSelectState<T>();
}

class _AppMultiSelectState<T> extends State<AppMultiSelect<T>> {
  late List<T> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List<T>.from(widget.initialValues);
  }

  Future<void> _openDialog() async {
    final List<T> tempSelected = List<T>.from(_selected);

    final result = await showDialog<List<T>>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(widget.label),
          content: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (ctx, setStateDialog) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.items.map((item) {
                    final isChecked = tempSelected.contains(item);
                    return CheckboxListTile(
                      value: isChecked,
                      title: Text(widget.getLabel(item)),
                      onChanged: (checked) {
                        setStateDialog(() {
                          if (checked == true) {
                            if (!tempSelected.contains(item)) {
                              tempSelected.add(item);
                            }
                          } else {
                            tempSelected.remove(item);
                          }
                        });
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('انصراف'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(tempSelected),
              child: const Text('تأیید'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        _selected = result;
      });
      widget.onChanged(_selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    final selectedText = _selected.isEmpty
        ? 'انتخاب کنید'
        : _selected.map((e) => widget.getLabel(e)).join('، ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.isShouldHalf)
          Text(
            widget.label,
            style: TextStyle(color: AppConfig.white),
          ),
        SizedBox(
          height: h * 0.05,
          width: widget.isShouldHalf ? w / 3 : w,
          child: InkWell(
            onTap: _openDialog,
            child: InputDecorator(
           //   isDense: true,
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: const Color(0xffededed),
                contentPadding: EdgeInsets.symmetric(
                  vertical: w * 0.02,
                  horizontal: 8,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 0.5),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedText,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: AppConfig.calFontSize(context, 4),
                        color: _selected.isEmpty
                            ? Colors.grey
                            : Colors.black87,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AppDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? initialValue;
  final String label;
  final String Function(T) getLabel;
  final void Function(T) onChanged;
  final bool isShouldHalf;

  const AppDropdown(
      {super.key,
      required this.items,
      required this.getLabel,
      required this.onChanged,
      required this.label,
      this.initialValue,
      this.isShouldHalf = false});

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown<T>> {
  T? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue ??
        (widget.items.isNotEmpty ? widget.items.first : null);
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        !widget.isShouldHalf
            ? Text(
                widget.label,
                style: TextStyle(color: AppConfig.white),
              )
            : SizedBox.shrink(),
        SizedBox(
          height: h * 0.05,
          width: widget.isShouldHalf ? w / 3 : w,
          child: DropdownButtonFormField2<T>(
            isExpanded: true,
            value: _selected,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: const Color(0xffededed),
              contentPadding:
                  EdgeInsets.symmetric(vertical: w * 0.02, horizontal: 8),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 0.5),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 1),
              ),
            ),
            hint: const Text('انتخاب کنید'),
            items: widget.items
                .map(
                  (item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(
                      widget.getLabel(item),
                      style: TextStyle(
                        fontSize: AppConfig.calFontSize(context, 4),
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _selected = value;
              });
              widget.onChanged(value);
            },
          ),
        ),
      ],
    );
  }
}


BuiltAttributePayload buildSelectedAttributesPayload(
    List<Attribute> selectedAttributes,
    Map<String, Set<String>> selectedTerms,
    ) {
  final List<Map<String, dynamic>> attributes = [];
  final List<Map<String, dynamic>> variations = [];

  // 1) اول attributes را بسازیم و فقط attrهایی که حداقل یک term دارند نگه داریم
  final List<Attribute> activeAttrs = [];

  for (final attr in selectedAttributes) {
    final chosenSlugs = selectedTerms[attr.taxonomy] ?? <String>{};

    print("attributesssssssssssssssss");
    print(attributes);


    if (chosenSlugs.isNotEmpty) {
      activeAttrs.add(attr);


      attributes.add({
        "name": attr.taxonomy,              // مثل "pa_color"
        "options": chosenSlugs.toList(),    // مثل ["red","blue"]
        "visible": true,
        "variation": true,
      });
    }
  }

  // اگر هیچ attribute فعالی نداریم، نیازی به variations نیست
  if (activeAttrs.isEmpty) {
    return BuiltAttributePayload(
      attributes: attributes,
      variations: variations,
    );
  }

  // 2) ساخت cartesian product برای variations
  // هر variation = {"attributes": { "pa_color": "red", "pa_size": "m" }, ...}

  void buildCombination(int index, Map<String, String> current) {
    if (index == activeAttrs.length) {
      // اینجا یک ترکیب کامل داریم
      variations.add({
        "attributes": Map<String, String>.from(current),
        "regular_price": "0",
        "sale_price": null,
        "manage_stock": false,
        "stock_quantity": 0,
      });
      return;
    }

    final attr = activeAttrs[index];
    final chosenSlugs = selectedTerms[attr.taxonomy]!.toList(); // مطمئنیم خالی نیست چون فعال است

    for (final slug in chosenSlugs) {
      current[attr.taxonomy] = slug;        // مثلا current["pa_color"] = "red"
      buildCombination(index + 1, current); // برو سراغ بعدی
      current.remove(attr.taxonomy);        // پاک کن برای ترکیب‌های بعدی
    }
  }

  buildCombination(0, {});

  return BuiltAttributePayload(
    attributes: attributes,
    variations: variations,
  );
}


class BuiltAttributePayload {
  final List<Map<String, dynamic>> attributes;
  final List<Map<String, dynamic>> variations;

  BuiltAttributePayload({
    required this.attributes,
    required this.variations,
  });
}


String _variationKey(Map<String, String> attrs) {
  // کلید پایدار بر اساس attributes مرتب‌شده
  final entries = attrs.entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key));
  return entries.map((e) => '${e.key}=${e.value}').join('|');
}

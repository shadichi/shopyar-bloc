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
import '../screens/product_form_screen.dart' hide ProductStatus;

class AddProductBillAdditional extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  AddProductDataModel addProductDataModel;
  final List<Function(String)> onTextChange;
  final Function(List<Map<String, dynamic>>) attributeChooser;

  AddProductBillAdditional(this.formKey,
      this.addProductDataModel, this.onTextChange, this.attributeChooser);

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

  List<String> productTypeList = ["ساده", "متغیر"];

  List<String> productStatusList = ["منتشر شده", "پیش نویس", "در انتظار بازبینی"];

  String customerLNBill = 'dd';


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
                ProductType pt = c == productTypeList[0] ? ProductType.simple : ProductType.variable;
                context
                    .read<AddProductBloc>()
                    .add(SetTypeOfProductEvent(pt));
                widget.onTextChange[0](pt.name);
              },
            ),

            AttributeSection(
              key1: '',
              attributeChooser: widget.attributeChooser,
            ),
            AppDropdown<Category>(
              items: widget.addProductDataModel.categories,
              label: 'دسته‌بندی',
              getLabel: (c) => c.name,
              onChanged: (c) {
                print('category picked: ${c.id} - ${c.name}');
                widget.onTextChange[1](c.id.toString());
              },
            ),
            AppDropdown<Brand>(
              items: widget.addProductDataModel.brands,
              label: 'برند',
              getLabel: (b) => b.name,
              onChanged: (b) {
                print('brand picked: ${b.id}');
                widget.onTextChange[2](b.id.toString());
              },
            ),

            AppDropdown<ProductStatus>(
              items: ProductStatus.values,
              label: 'وضعیت',
              getLabel: (a) => a.faLabel,
              onChanged: (a) {
                print('Status picked: ${a.apiValue}');
                widget.onTextChange[4](a.apiValue);

              },
            ),
            SizedBox(
              height: AppConfig.calHeight(context, 0.5),
            ),
            textField(
              controller,
              'موجودی',
              context,
              onChanged: (String value) {
                print('brand picked: $value');
                widget.onTextChange[4](value.toString());
              },
            ),
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

/*  Widget _CustomElevatedButton(String label, void Function() onPress,
      {Color color = Colors.black}) {
    return ElevatedButton(
      onPressed: onPress,
      child: Text(
        label,
        style: TextStyle(
            color: color, fontSize: AppConfig.calFontSize(context, 2.5)),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(AppConfig.white),
      ),
    );
  }*/
}

class AttributeSection extends StatefulWidget {
  final String key1;
  final Function(List<Map<String, dynamic>>) attributeChooser;

  const AttributeSection(
      {super.key, required this.key1, required this.attributeChooser});

  @override
  State<AttributeSection> createState() => _AttributeSectionState();
}

class _AttributeSectionState extends State<AttributeSection> {
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
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return  BlocBuilder<AddProductBloc, AddProductState>(
        builder: (context, state) {
          // اگر محصول ساده است، این سکشن نمایش داده نشود
          if (state.productType == ProductType.simple) return const SizedBox.shrink();

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
                // ➋ هدر سکشن
                Row(
                  children: [
                    const Icon(Icons.category_outlined, size: 18),
                    const SizedBox(width: 6),
                    Text('ویژگی‌های محصول متغیر',
                        style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
                const SizedBox(height: 12),

                // ➌ DROPDOWN افزودن ویژگی جدید از لیست available
                Row(
                  children: [
                    Expanded(
                      child: // ➌ DROPDOWN افزودن ویژگی از available
                      AppDropdown<Attribute>(
                        key: ValueKey(
                            'add-attr-${available.map((e) => e.name).join(',')}'),
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
                            state.selectedTerms[attr.name] ?? <String>{};

                        // نمایش نام‌ها برای چیپ‌ها
                        final chosenNames =
                        chosen.map((slug) => nameBySlug(attr, slug)).toList();

                        // باقی‌مانده‌ها برای افزودن (slug) + نام‌شان
                        final remainingSlugs = allSlugs
                            .where((slug) => !chosen.contains(slug))
                            .toList();
                        final remainingNames = remainingSlugs
                            .map((slug) => nameBySlug(attr, slug))
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
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'حذف کل ویژگی',
                                  icon: const Icon(Icons.close, size: 18),
                                  onPressed: () {
                                    context
                                        .read<AddProductBloc>()
                                        .add(RemoveSelectedAttributeEvent(attr));
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),

                            // ➐ مقادیر انتخاب‌شده (چیپ با ضربدر برای حذف تکی)
                            if (chosen.isNotEmpty) ...[
                              Text('انتخاب‌شده‌ها',
                                  style: Theme.of(context).textTheme.bodySmall),
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: chosen.map((slug) {
                                  final name = nameBySlug(attr, slug);
                                  return InputChip(
                                    label: Text(name),
                                    onDeleted: () {
                                      // حذف فقط همین مقدار (slug)
                                      context.read<AddProductBloc>().add(
                                        ToggleTermEvent(attr.name, slug, false),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 10),
                            ],

                            // ➑ افزودن مقدار جدید (چیپ‌های اضافه‌کردن)
                            Text('افزودن مقدار',
                                style: Theme.of(context).textTheme.bodySmall),
                            const SizedBox(height: 4),
                            if (remainingSlugs.isEmpty)
                              Text('مقداری برای افزودن باقی نمانده',
                                  style: Theme.of(context).textTheme.bodySmall)
                            else
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: remainingNames.map((name) {
                                  final slug = slugByName(attr, name);
                                  return ActionChip(
                                    label: Text(name),
                                      onPressed: () {
                                        context.read<AddProductBloc>().add(ToggleTermEvent(attr.name, slug, true));
                                        // بعد از آپدیت state در فریم بعدی
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          final state = context.read<AddProductBloc>().state;
                                          final result = buildSelectedAttributesMap(
                                            state.selectedAttributes,
                                            state.selectedTerms,
                                          );
/*
                                          print("✅ لیست ویژگی‌های انتخاب‌شده:");
                                          print(result); // ساختار Dart
                                          print(jsonEncode(result)); // خروجی JSON واقعی*/
                                          widget.attributeChooser(result);
                                        });
                                      }
                                  );
                                }).toList(),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
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

/*/// Dropdown بالای سکشن برای "افزودن ویژگی"
class _AddAttributeDropdown extends StatelessWidget {
  final List<Attribute> available;
  final ValueChanged<String> onPick;

  const _AddAttributeDropdown({
    required this.available,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            key: ValueKey(available.map((e) => e.name).join(',')),
            isExpanded: true,
            value: null,
            hint: const Text('افزودن ویژگی'),
            items: available
                .map((attr) =>
                    DropdownMenuItem(value: attr.name, child: Text(attr.name)))
                .toList(),
            onChanged: (val) {
              if (val == null) return;
              onPick(val);
            },
          ),
        ),
        const SizedBox(width: 8),
        const Tooltip(
          message: 'از لیست یک ویژگی انتخاب کنید تا به پایین اضافه شود',
          child: Icon(Icons.add_circle_outline, size: 18),
        ),
      ],
    );
  }
}

/// یک ردیف برای هر ویژگی انتخاب‌شده: عنوان + چیپ‌های Toggle + دکمه حذف کل ویژگی
class _AttributeRow extends StatelessWidget {
  final String attributeName;
  final List<String> allTerms; // همه‌ی termها
  final Set<String> chosenTerms; // termهای انتخاب‌شده
  final void Function(String termName, bool selected) onToggleTerm;
  final VoidCallback onRemoveAttribute;

  const _AttributeRow({
    required this.attributeName,
    required this.allTerms,
    required this.chosenTerms,
    required this.onToggleTerm,
    required this.onRemoveAttribute,
  });

  @override
  Widget build(BuildContext context) {
    // اگر دوست داری، می‌توانی چیپ‌های انتخاب‌شده را اول نشان دهی
    final sorted = [...allTerms]..sort((a, b) {
        final aSel = chosenTerms.contains(a) ? 0 : 1;
        final bSel = chosenTerms.contains(b) ? 0 : 1;
        return aSel != bSel ? aSel - bSel : a.compareTo(b);
      });

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // نام ویژگی + حذف کل ویژگی
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 120, maxWidth: 180),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  attributeName,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                tooltip: 'حذف کل ویژگی',
                icon: const Icon(Icons.close, size: 18),
                onPressed: onRemoveAttribute,
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        // چیپ‌های Toggle برای termها (اضافه/حذف تکی)
        Expanded(
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: sorted.map((term) {
              final isOn = chosenTerms.contains(term);
              return FilterChip(
                label: Text(term),
                selected: isOn,
                onSelected: (val) => onToggleTerm(term, val),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}*/

class AppDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? initialValue;
  final String label; // مثلا: "دسته‌بندی" یا "برند"
  final String Function(T) getLabel; // بگه از این مدل چی نشون بدم
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

List<Map<String, dynamic>> buildSelectedAttributesMap(
    List<Attribute> selectedAttributes,
    Map<String, Set<String>> selectedTerms,
    ) {
  final List<Map<String, dynamic>> result = [];

  for (final attr in selectedAttributes) {
    // termهایی که برای این ویژگی انتخاب شدن
    final chosenSlugs = selectedTerms[attr.name] ?? <String>{};

    // فقط اگه چیزی انتخاب شده بود
    if (chosenSlugs.isNotEmpty) {
      result.add({
        "name": attr.taxonomy,   // مثل pa_color
        "options": chosenSlugs.toList(), // مثل ["red","blue"]
        "visible": true,
        "variation": true,
      });
    }
  }

  return result;
}
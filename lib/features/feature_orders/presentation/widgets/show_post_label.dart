import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:shopyar/extension/persian_digits.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:jdate/jdate.dart';
import 'package:intl/intl.dart';
import '../../../../../../../../core/utils/static_values.dart';
import '../../data/models/store_info.dart';
import '../../domain/entities/orders_entity.dart';
import 'package:hive/hive.dart';

import 'show_post_label.dart';

Future orderPostLabelPDF( OrdersEntity ordersEntity) async {
  final dteNow = DateTimeExt(DateTime.now()).toJalali();
  var jd = JDate(dteNow.year, dteNow.month, dteNow.day);

  List<pw.Widget> widgets = [];
  StoreInfo storeInfo = StoreInfo(
      storeName: '',
      storeAddress: '',
      phoneNumber: '',
      instagram: '',
      postalCode: '',
      website: '',
      storeIcon: '',
      storeSenderName: '',
      storeNote: '');

  final box = await Hive.openBox<StoreInfo>('storeBox');
  final stored = box.get('storeInfo');
  if (stored != null) {
    storeInfo = stored;
  } else {
    storeInfo = StoreInfo(
        storeName: '',
        storeAddress: '',
        phoneNumber: '',
        instagram: '',
        postalCode: '',
        website: '',
        storeIcon: '',
        storeSenderName: '',
        storeNote: '');
  }
  final ByteData imageData =
      await rootBundle.load('assets/images/post_label.jpg');
  final Uint8List imageBytes = imageData.buffer.asUint8List();
  final image = pw.MemoryImage(imageBytes);

  final ByteData instaIcon = await rootBundle.load('assets/images/insta.png');
  final Uint8List instaIconImageBytes = instaIcon.buffer.asUint8List();
  final instaImage = pw.MemoryImage(instaIconImageBytes);

  debugPrint('storeIcon raw: "${storeInfo.storeIcon}"');
  if (storeInfo.storeIcon.isNotEmpty && storeInfo.storeIcon != 'null') {
    debugPrint('icon exists? ${await File(storeInfo.storeIcon).exists()}');
  }

  final File storeIconFile = File(storeInfo.storeIcon);
  final Uint8List storeIconBytes = await storeIconFile.readAsBytes();
  final storeIconImage = pw.MemoryImage(storeIconBytes);

  final ttfData = await rootBundle.load("assets/fonts/Vazir.ttf");
  final ttf = pw.Font.ttf(ttfData.buffer.asByteData());

  String formatFaThousands(dynamic value) {
    final n = (value is num) ? value : num.tryParse(value.toString()) ?? 0;
    return NumberFormat.decimalPattern('fa').format(n);
  }

  final pdf = pw.Document();
  var arabicFont =
      Font.ttf(await rootBundle.load("assets/fonts/IRANSansWeb.ttf"));
  pdf.addPage(
    pw.Page(
      theme: pw.ThemeData.withFont(
        base: arabicFont,
      ),
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        final w = context.page.pageFormat.width;
        final h = context.page.pageFormat.height;
      return  pw.Stack(
          children: [
            pw.Image(image, fit: pw.BoxFit.fitWidth),
            pw.Positioned(
                left: w * 0.55,
                top: h * 0.25,
                child: pw.Container(
                  width: w * 0.1,
                  height: h * 0.1,
                  // color: PdfColors.red,
                  alignment: pw.Alignment.center,
                  child: pw.Image(storeIconImage,
                      width: w * 0.1, height: h * 0.1),
                )),
            pw.Positioned(
                left: w * 0.5,
                top: h * 0.38,
                child: pw.Container(
                    width: w * 0.27,
                    height: h * 0.02,
                    //    color: PdfColors.red,
                    alignment: pw.Alignment.center,
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          storeInfo.instagram.isNotEmpty
                              ? pw.Image(instaImage,
                              width: w * 0.03, height: w * 0.03)
                              : pw.Container(),
                          pw.SizedBox(width: w * 0.01),
                          storeInfo.instagram.isNotEmpty ||
                              storeInfo.website.isNotEmpty
                              ? positionedTextWidget(
                              text: storeInfo.instagram.isNotEmpty
                                  ? storeInfo.instagram
                                  : storeInfo.website.isNotEmpty
                                  ? storeInfo.website
                                  : '',
                              heightContainer: h * 0.027,
                              widthContainer: w * 0.1,
                              leftPositioned: w * 0.45,
                              topPositioned: h * 0.34,
                              fontSize: w * 0.02,
                              alignment: pw.Alignment.center,
                              fontWeight: pw.FontWeight.bold,
                              maxLine: 1)
                              : pw.Container(),
                        ]))),
            positionedTextWidget(
                text:
                "${ordersEntity.billing!.lastName} ${ordersEntity.billing!.firstName}",
                //نام گیرنده
                heightContainer: h * 0.02,
                widthContainer: w * 0.28,
                leftPositioned: w * 0.443,
                topPositioned: h * 0.448,
                fontSize: w * 0.018,
                alignment: pw.Alignment.centerRight,
                fontWeight: pw.FontWeight.normal,
                maxLine: 1),
            positionedTextWidget(
                text: storeInfo.storeName,
                heightContainer: h * 0.027,
                widthContainer: w * 0.3,
                leftPositioned: w * 0.45,
                topPositioned: h * 0.34,
                fontSize: w * 0.025,
                alignment: pw.Alignment.center,
                fontWeight: pw.FontWeight.bold,
                maxLine: 1),
            positionedTextWidget(
                text: ordersEntity.billing!.address1,
                //ادرس گیرنده
                heightContainer: h * 0.066,
                widthContainer: w * 0.36,
                leftPositioned: w * 0.42,
                topPositioned: h * 0.49,
                fontSize: w * 0.017,
                alignment: pw.Alignment.topRight,
                fontWeight: pw.FontWeight.normal,
                maxLine: 4),
            positionedTextWidget(
                text: storeInfo.storeNote.toString(),
                //یادداشت
                heightContainer: h * 0.023,
                widthContainer: w * 0.36,
                leftPositioned: w * 0.42,
                topPositioned: h * 0.57,
                fontSize: w * 0.015,
                alignment: pw.Alignment.topRight,
                fontWeight: pw.FontWeight.normal,
                maxLine: 2),
            positionedTextWidget(
                text: ordersEntity.billing!.postcode,
                //کد پستی گیرنده
                heightContainer: h * 0.017,
                widthContainer: w * 0.115,
                leftPositioned: w * 0.6,
                topPositioned: h * 0.595,
                fontSize: w * 0.018,
                alignment: pw.Alignment.center,
                fontWeight: pw.FontWeight.normal,
                maxLine: 1),
            positionedTextWidget(
                text: ordersEntity.billing!.phone,
                //تلفن گیرنده
                heightContainer: h * 0.017,
                widthContainer: w * 0.13,
                leftPositioned: w * 0.415,
                topPositioned: h * 0.595,
                fontSize: w * 0.018,
                alignment: pw.Alignment.center,
                fontWeight: pw.FontWeight.normal,
                maxLine: 1),
            positionedTextWidget(
                text: storeInfo.storeSenderName.toString(),
                //نام فرستنده
                heightContainer: h * 0.027,
                widthContainer: w * 0.35,
                leftPositioned: w * 0.05,
                topPositioned: h * 0.28,
                fontSize: w * 0.027,
                alignment: pw.Alignment.centerRight,
                fontWeight: pw.FontWeight.bold,
                maxLine: 1),
            positionedTextWidget(
                text: storeInfo.storeAddress,
                //ادرس فرستنده
                heightContainer: h * 0.07,
                widthContainer: w * 0.352,
                leftPositioned: w * 0.04,
                topPositioned: h * 0.34,
                fontSize: w * 0.02,
                alignment: pw.Alignment.topRight,
                fontWeight: pw.FontWeight.normal,
                maxLine: 6),
            positionedTextWidget(
                text: storeInfo.postalCode,
                //کد پستی فرستنده
                heightContainer: h * 0.017,
                widthContainer: w * 0.115,
                leftPositioned: w * 0.224,
                topPositioned: h * 0.417,
                fontSize: w * 0.018,
                alignment: pw.Alignment.center,
                fontWeight: pw.FontWeight.normal,
                maxLine: 1),
            positionedTextWidget(
                text: storeInfo.phoneNumber,
                heightContainer: h * 0.017,
                widthContainer: w * 0.13,
                leftPositioned: w * 0.0591,
                topPositioned: h * 0.417,
                fontSize: w * 0.018,
                alignment: pw.Alignment.center,
                fontWeight: pw.FontWeight.normal,
                maxLine: 1),
          ],
        );

      }
    ),
  );
  Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
  /* Printing.sharePdf(bytes: await pdf.save());
  ElevatedButton(onPressed: (){},child:w.Text("ghhggb"),);*/
}

pw.Widget positionedTextWidget({
  required String text,
  required double leftPositioned,
  required double topPositioned,
  required double widthContainer,
  required double heightContainer,
  required double fontSize,
  required pw.Alignment alignment,
  required pw.FontWeight fontWeight,
  required int maxLine,
}) {
  return pw.Positioned(
      left: leftPositioned,
      top: topPositioned,
      child: pw.Container(
      //  color: PdfColors.blue,
          alignment: alignment,
          width: widthContainer,
          height: heightContainer,
          child: pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Text(
              text,
              style: pw.TextStyle(
                fontSize: fontSize,
                color: PdfColors.black,
                // fontWeight: fontWeight,
              ),
              maxLines: maxLine,
              overflow: pw.TextOverflow.clip,
            ),
          )));
}

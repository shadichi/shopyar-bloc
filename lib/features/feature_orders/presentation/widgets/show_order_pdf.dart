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
import '../../../../core/utils/static_values.dart';
import '../../data/models/orders_model.dart';
import '../../domain/entities/orders_entity.dart';

Future orderFactorPDF(
    shopName, OrdersEntity ordersEntity, int item, width, height) async {
  final dteNow = DateTimeExt(DateTime.now()).toJalali();
  var jd = JDate(dteNow.year, dteNow.month, dteNow.day);

  List<pw.Widget> widgets = [];
  final Map<int, bool> receivedFactorData = {};

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  for (int i = 0; i < 9; i++) {
    if (prefs.containsKey('factor-data-$i')) {
      bool? value = prefs.getBool('factor-data-$i');
      print('eeeeeeeeeeeeeee');
      print(value);
      receivedFactorData[i] = value!;
      print('receivedFactorData[i]');
      print(receivedFactorData[i]);
    } else {
      receivedFactorData[i] = false;
    }
  }
  print(receivedFactorData);
  print(receivedFactorData[0].runtimeType);

  String formatFaThousands(dynamic value) {
    final n = (value is num) ? value : num.tryParse(value.toString()) ?? 0;
    return NumberFormat.decimalPattern('fa').format(n);
  }

  widgets.add(pw.Center(
    child: pw.Container(
      // height: height ,
      child:
          pw.Column(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
        pw.Container(
            padding: pw.EdgeInsets.all(width * 0.02),
            child: pw.Text(
              StaticValues.shopName,
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(fontSize: 10, ),
              overflow: pw.TextOverflow.clip,
            )),
        // pw.SizedBox(height: height*0.02),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Container(
              //    color: PdfColors.yellow,
              width: width * 0.4,
              height: height * 0.07,
              alignment: pw.Alignment.centerRight,
              child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    if (receivedFactorData[2] ?? false)
                      pw.Text(
                        "کد پستی: ${ordersEntity.billing!.postcode.stringToPersianDigits()}",
                        textDirection: pw.TextDirection.rtl,
                        style: pw.TextStyle(fontSize: 10, ),
                        overflow: pw.TextOverflow.clip,
                      ),
                    if (receivedFactorData[3] ?? false)
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Text(
                                ordersEntity.billing!.email.toString() == 'null'
                                    ? ''
                                    : ordersEntity.billing!.email.toString(),
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(fontSize: 10)),
                            pw.Text(
                              "ایمیل: ",
                              textDirection: pw.TextDirection.rtl,
                              style: pw.TextStyle(fontSize: 10,
                              ),
                              overflow: pw.TextOverflow.clip,
                            ),
                          ])
                  ])),
          pw.Container(
              padding: pw.EdgeInsets.all(width * 0.01),
              //  color: PdfColors.red,
              width: width * 0.4,
              height: height * 0.07,
              alignment: pw.Alignment.centerRight,
              child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      "شماره سفارش: ${ordersEntity.id.toString().stringToPersianDigits()}",
                      textDirection: pw.TextDirection.rtl,
                      style: pw.TextStyle(fontSize: 10, ),
                      overflow: pw.TextOverflow.clip,
                    ),
                    pw.Text(
                      "تاریخ: ${ordersEntity.dateCreated!.year}/${ordersEntity.dateCreated!.month}/${ordersEntity.dateCreated!.day}"
                          .stringToPersianDigits(),
                      textDirection: pw.TextDirection.rtl,
                      style: pw.TextStyle(fontSize: 10, ),
                      overflow: pw.TextOverflow.clip,
                    ),
                    if (receivedFactorData[0] ?? false)
                      pw.Text(
                        "تلفن: ${ordersEntity.billing!.phone}",
                        textDirection: pw.TextDirection.rtl,
                        style: pw.TextStyle(fontSize: 10, ),
                        overflow: pw.TextOverflow.clip,
                      ),
                    if (receivedFactorData[1] ?? false)
                      pw.Text(
                        "نشانی: ${ordersEntity.billing!.address1}",
                        textDirection: pw.TextDirection.rtl,
                        style: pw.TextStyle(fontSize: 10, ),
                        overflow: pw.TextOverflow.clip,
                      ),
                  ])),
        ]),
        pw.Divider(),
        pw.Center(
          child: pw.Container(
            height: height * 0.1,
           // width: width * 0.95,
            child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                  pw.Container(
                      width: width * 0.35,
                      height: height * 0.08,
                      //  color: PdfColors.yellow,
                      alignment: pw.Alignment.centerRight,
                      child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            if (receivedFactorData[6] ?? false)
                              pw.Text(
                                "کد پستی: ${ordersEntity.billing!.postcode.stringToPersianDigits()}",
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(fontSize: 10,
                                ),
                                overflow: pw.TextOverflow.clip,
                              ),
                            if (receivedFactorData[7] ?? false)
                              pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.end,
                                  children: [
                                    pw.Text(
                                      ordersEntity.billing!.email.toString() ==
                                              'null'
                                          ? ''
                                          : ordersEntity.billing!.email
                                              .toString(),
                                      textDirection: pw.TextDirection.rtl,
                                      style: pw.TextStyle(fontSize: 10),
                                      overflow: pw.TextOverflow.clip,
                                    ),
                                    pw.Text(
                                      "ایمیل: ",
                                      textDirection: pw.TextDirection.rtl,
                                      style:
                                          pw.TextStyle(fontSize: 10,),
                                      overflow: pw.TextOverflow.clip,
                                    ),
                                  ]),
                          ])),
                  pw.Container(
                      width: width * 0.35,
                      height: height * 0.08,
                      // color: PdfColors.blue,
                      alignment: pw.Alignment.centerRight,
                      child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text(
                                "خریدار: ${ordersEntity.billing!.lastName + " " + ordersEntity.billing!.firstName}",
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(fontSize: 10, ),
                                overflow: pw.TextOverflow.clip),
                            if (receivedFactorData[4] ?? false)
                              pw.Text(
                                "شماره تماس: ${ordersEntity.billing!.phone}",
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(fontSize: 10, ),
                                overflow: pw.TextOverflow.clip,
                              ),
                            if (receivedFactorData[5] ?? false)
                              pw.Text(
                                "آدرس: ${ordersEntity.billing!.address1}",
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(fontSize: 10, ),
                                overflow: pw.TextOverflow.clip,
                              ),
                            if (receivedFactorData[8] ?? false)
                              pw.Container(
                                  width: 250,
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(
                                    "توضیحات:",
                                    textDirection: pw.TextDirection.rtl,
                                    style:
                                        pw.TextStyle(fontSize: 10,
                                        ),
                                    overflow: pw.TextOverflow.clip,
                                  )),
                          ])),
                ]),
            padding: const pw.EdgeInsets.all(5),
            decoration: pw.BoxDecoration(
              //color: PdfColors.blueGrey,
              border: pw.Border.all(
                  //  color: PdfColors.blue,
                  // width: 2,
                  ),
            ),
          ),
        ),
        pw.Container(
          alignment: pw.Alignment.centerRight,
          child: pw.Table(
              border: pw.TableBorder.all(
                color: PdfColors.black,
                width: 0.5,
              ),
              children: [
                for (var i = 0; i < ordersEntity.lineItems!.length; i++)
                  pw.TableRow(children: [
                    pw.Container(
                      alignment: pw.Alignment.centerRight,
                      width: width * 0.1,
                      height: height * 0.05,
                      padding: pw.EdgeInsets.all(width * 0.01),
                      // color: PdfColors.brown,
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(
                              "تعداد: ${ordersEntity.lineItems![i].quantity.toPersianDigits()}",
                              style: pw.TextStyle(fontSize: 10,),
                              textDirection: pw.TextDirection.rtl,
                              overflow: pw.TextOverflow.clip,
                            ),
                            //   pw.Divider(thickness: 1)
                          ]),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.all(width * 0.01),
                      height: height * 0.05,
                      // color: PdfColors.amber50,
                      alignment: pw.Alignment.centerRight,
                      width: width * 0.2,
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(
                              "قیمت: ${formatFaThousands(
                                ordersEntity.lineItems![i].price.toString(),
                              )}",
                              style: pw.TextStyle(fontSize: 10, ),
                              textDirection: pw.TextDirection.rtl,
                              overflow: pw.TextOverflow.clip,
                            ),
                            //pw.Divider(thickness: 1)
                          ]),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.all(width * 0.01),
                      height: height * 0.05,
                      //color: PdfColors.deepPurple,
                      alignment: pw.Alignment.centerRight,
                      width: width * 0.3,
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(ordersEntity.lineItems![i].name.toString(),
                                softWrap: false,
                                overflow: pw.TextOverflow.clip,
                                // Use ellipsis (...) for overflow
                                maxLines: 1,
                                // Display only one line of text

                                style: pw.TextStyle(fontSize: 10, ),
                                textDirection: pw.TextDirection.rtl),
                            //    pw.Divider(thickness: 1)
                          ]),
                    )
                  ]),
              ]),
          /* decoration: pw.BoxDecoration(
              color: PdfColors.cyan,
              border: pw.Border.all(),
            ),*/
        ),
        pw.Container(
            width: width * 0.8,
            alignment: pw.Alignment.centerLeft,
            height: height * 0.05,
            //color: PdfColors.amber50,
            child: pw.Text(
              "جمع کل: ${formatFaThousands(ordersEntity.total)}",
              style: pw.TextStyle(

              ),
              textDirection: pw.TextDirection.rtl,
              overflow: pw.TextOverflow.clip,
            ))
      ]),
      padding: const pw.EdgeInsets.all(5),
      decoration: pw.BoxDecoration(
        // color: PdfColors.green,
        border: pw.Border.all(),
      ),
    ),
  ));
  // widgets.add(p.SizedBox(height: 5));
  //  widgets.add(p.SizedBox(height: 10));

  final pdf = pw.Document();
  var arabicFont =
      Font.ttf(await rootBundle.load("assets/fonts/IRANSansWeb.ttf"));
  pdf.addPage(
    pw.MultiPage(
      theme: pw.ThemeData.withFont(
        base: arabicFont,
      ),
      pageFormat: PdfPageFormat.a4,
      build: (context) => widgets,
    ),
  );
  Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
  /* Printing.sharePdf(bytes: await pdf.save());
  ElevatedButton(onPressed: (){},child:w.Text("ghhggb"),);*/
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shapyar_bloc/core/utils/static_values.dart';
import 'package:shapyar_bloc/features/feature_orders/data/models/orders_model.dart';
import '../../../../core/config/app-colors.dart';
import '../../../../core/widgets/progress-bar.dart';
import 'order_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shapyar_bloc/extension/persian_digits.dart';
import 'package:intl/intl.dart';

class ShowPDF extends StatefulWidget {
  static String routeName = 'ShowPDF';

  const ShowPDF({super.key});

  @override
  _ShowPDFState createState() => _ShowPDFState();
}

class _ShowPDFState extends State<ShowPDF> {
  String? pdfPath;

  Map<int, dynamic> factorData = {};

  late PdfData args;
  bool _inited = false;
  bool _loading = true;
  final Map<int, bool> receivedFactorData = {};


  @override
  void initState() {
    super.initState();
    getFactorData();
    _generatePdf();
  }

  Future<bool> getFactorData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < 9; i++) {
      if (prefs.containsKey('factor-data-$i')) {
        bool? value = prefs.getBool('factor-data-$i');
        receivedFactorData[i] = value!;
        print('receivedFactorData[i]');
        print(receivedFactorData[i]);
      } else {
        receivedFactorData[i] = false;
      }
    }
    print(receivedFactorData);
    print(receivedFactorData[0].runtimeType);

    return true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_inited) return;
    _inited = true;
    args = ModalRoute.of(context)!.settings.arguments as PdfData;
    _prepare(); // ترتیب: prefs -> pdf
  }
  Future<void> _prepare() async {
    await _getFactorData();
    await _generatePdf();
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _getFactorData() async {
    final prefs = await SharedPreferences.getInstance();
    for (var i = 0; i < 9; i++) {
      receivedFactorData[i] = prefs.getBool('factor-data-$i') ?? false;
    }
  }



  String formatFaThousands(dynamic value) {
    final n = (value is num) ? value : num.tryParse(value.toString()) ?? 0;
    return NumberFormat.decimalPattern('fa').format(n);
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    final ttfData = await rootBundle.load("assets/fonts/IRANSansWeb.ttf");
    final ttf = pw.Font.ttf(ttfData.buffer.asByteData());

    final b = args.ordersEntity.billing;
    final items = args.ordersEntity.lineItems ?? [];


    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          final width = PdfPageFormat.a4.width;
          final height = PdfPageFormat.a4.height;
          return pw.Center(
            child: pw.Container(
              // height: height ,
              child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Container(
                        padding: pw.EdgeInsets.all(width * 0.02),
                        child: pw.Text(
                          /*mainPage.shopName.toString()*/
                          StaticValues.shopName ?? "",
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(fontSize: 10, font: ttf),
                          overflow: pw.TextOverflow.clip,
                        )),
                    // pw.SizedBox(height: height*0.02),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Container(
                              //    color: PdfColors.yellow,
                              width: width * 0.4,
                              height: height * 0.07,
                              alignment: pw.Alignment.centerRight,
                              child: pw.Column(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                                  children: [
                                    if (receivedFactorData[2]??false)
                                      pw.Text(
                                        "کد پستی: ${args.ordersEntity.billing!.postcode.stringToPersianDigits()}",
                                        textDirection: pw.TextDirection.rtl,
                                        style: pw.TextStyle(
                                            fontSize: 10, font: ttf),
                                        overflow: pw.TextOverflow.clip,
                                      ),
                                    if (receivedFactorData[3]??false)
                                      pw.Row(
                                          mainAxisAlignment:
                                              pw.MainAxisAlignment.end,
                                          children: [
                                            pw.Text(
                                                args.ordersEntity.billing!.email
                                                            .toString() ==
                                                        'null'
                                                    ? ''
                                                    : args.ordersEntity.billing!
                                                        .email
                                                        .toString(),
                                                textDirection:
                                                    pw.TextDirection.rtl,
                                                style:
                                                    pw.TextStyle(fontSize: 10)),
                                            pw.Text(
                                              "ایمیل: ",
                                              textDirection:
                                                  pw.TextDirection.rtl,
                                              style: pw.TextStyle(
                                                  fontSize: 10, font: ttf),
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
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                                  children: [
                                    pw.Text(
                                      "شماره سفارش: ${args.ordersEntity.id.toString().stringToPersianDigits()}",
                                      textDirection: pw.TextDirection.rtl,
                                      style:
                                          pw.TextStyle(fontSize: 10, font: ttf),
                                      overflow: pw.TextOverflow.clip,
                                    ),
                                    pw.Text(
                                      "تاریخ: ${args.ordersEntity.dateCreated!.year}/${args.ordersEntity.dateCreated!.month}/${args.ordersEntity.dateCreated!.day}"
                                          .stringToPersianDigits(),
                                      textDirection: pw.TextDirection.rtl,
                                      style:
                                          pw.TextStyle(fontSize: 10, font: ttf),
                                      overflow: pw.TextOverflow.clip,
                                    ),
                                    if (receivedFactorData[0]??false)
                                      pw.Text(
                                        "تلفن: ${args.ordersEntity.billing!.phone}",
                                        textDirection: pw.TextDirection.rtl,
                                        style: pw.TextStyle(
                                            fontSize: 10, font: ttf),
                                        overflow: pw.TextOverflow.clip,
                                      ),
                                    if (receivedFactorData[1]??false)
                                      pw.Text(
                                        "نشانی: ${args.ordersEntity.billing!.address1}",
                                        textDirection: pw.TextDirection.rtl,
                                        style: pw.TextStyle(
                                            fontSize: 10, font: ttf),
                                        overflow: pw.TextOverflow.clip,
                                      ),
                                  ])),
                        ]),
                    pw.Divider(),
                    pw.Center(
                      child: pw.Container(
                        height: height * 0.1,
                        width: width * 0.8,
                        child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                            children: [
                              pw.Container(
                                  width: width * 0.35,
                                  height: height * 0.08,
                                  //  color: PdfColors.yellow,
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Column(
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.end,
                                      children: [
                                        if (receivedFactorData[6]??false)
                                          pw.Text(
                                            "کد پستی: ${args.ordersEntity.billing!.postcode.stringToPersianDigits()}",
                                            textDirection: pw.TextDirection.rtl,
                                            style: pw.TextStyle(
                                                fontSize: 10, font: ttf),
                                            overflow: pw.TextOverflow.clip,
                                          ),
                                        if (receivedFactorData[7]??false)
                                          pw.Row(
                                              mainAxisAlignment:
                                                  pw.MainAxisAlignment.end,
                                              children: [
                                                pw.Text(
                                                  args.ordersEntity.billing!
                                                              .email
                                                              .toString() ==
                                                          'null'
                                                      ? ''
                                                      : args.ordersEntity
                                                          .billing!.email
                                                          .toString(),
                                                  textDirection:
                                                      pw.TextDirection.rtl,
                                                  style: pw.TextStyle(
                                                      fontSize: 10),
                                                  overflow:
                                                      pw.TextOverflow.clip,
                                                ),
                                                pw.Text(
                                                  "ایمیل: ",
                                                  textDirection:
                                                      pw.TextDirection.rtl,
                                                  style: pw.TextStyle(
                                                      fontSize: 10, font: ttf),
                                                  overflow:
                                                      pw.TextOverflow.clip,
                                                ),
                                              ]),
                                      ])),
                              pw.Container(
                                  width: width * 0.35,
                                  height: height * 0.08,
                                  // color: PdfColors.blue,
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Column(
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.end,
                                      children: [
                                        pw.Text(
                                            "خریدار: ${args.ordersEntity.billing!.lastName + " " + args.ordersEntity.billing!.firstName}",
                                            textDirection: pw.TextDirection.rtl,
                                            style: pw.TextStyle(
                                                fontSize: 10, font: ttf),
                                            overflow: pw.TextOverflow.clip),
                                        if (receivedFactorData[4]??false)
                                          pw.Text(
                                            "شماره تماس: ${args.ordersEntity.billing!.phone}",
                                            textDirection: pw.TextDirection.rtl,
                                            style: pw.TextStyle(
                                                fontSize: 10, font: ttf),
                                            overflow: pw.TextOverflow.clip,
                                          ),
                                        if (receivedFactorData[5]??false)
                                          pw.Text(
                                            "آدرس: ${args.ordersEntity.billing!.address1}",
                                            textDirection: pw.TextDirection.rtl,
                                            style: pw.TextStyle(
                                                fontSize: 10, font: ttf),
                                            overflow: pw.TextOverflow.clip,
                                          ),
                                        if (receivedFactorData[8]??false)
                                          pw.Container(
                                              width: 250,
                                              alignment:
                                                  pw.Alignment.centerRight,
                                              child: pw.Text(
                                                "توضیحات:",
                                                textDirection:
                                                    pw.TextDirection.rtl,
                                                style: pw.TextStyle(
                                                    fontSize: 10, font: ttf),
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
                            for (var i = 0;
                                i < args.ordersEntity.lineItems!.length;
                                i++)
                              pw.TableRow(children: [
                                pw.Container(
                                  alignment: pw.Alignment.centerRight,
                                  width: width * 0.1,
                                  height: height * 0.05,
                                  padding: pw.EdgeInsets.all(width * 0.01),
                                  // color: PdfColors.brown,
                                  child: pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.center,
                                      children: [
                                        pw.Text(
                                          "تعداد: ${args.ordersEntity.lineItems![i].quantity.toPersianDigits()}",
                                          style: pw.TextStyle(
                                              fontSize: 10, font: ttf),
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
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.center,
                                      children: [
                                        pw.Text(
                                          "قیمت: ${formatFaThousands(args.ordersEntity.lineItems![i].price
                                              .toString(),)}",
                                          style: pw.TextStyle(
                                              fontSize: 10, font: ttf),
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
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.center,
                                      children: [
                                        pw.Text(
                                            args.ordersEntity.lineItems![i].name
                                                .toString(),
                                            softWrap: false,
                                            overflow: pw.TextOverflow.clip,
                                            // Use ellipsis (...) for overflow
                                            maxLines: 1,
                                            // Display only one line of text

                                            style: pw.TextStyle(
                                                fontSize: 10, font: ttf),
                                            textDirection:
                                                pw.TextDirection.rtl),
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
                          "جمع کل: ${formatFaThousands(args.ordersEntity.total)}",
                          style: pw.TextStyle(
                            font: ttf,
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
          );
        }));

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/factor.pdf');
    await file.writeAsBytes(await pdf.save());
    pdfPath = file.path;

  }

  Future<void> _savePdf() async {
    if (pdfPath == null) return;
    final output = await getExternalStorageDirectory();
    final savedFile = File('${output!.path}/factor.pdf');
    await File(pdfPath!).copy(savedFile.path);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("PDF ذخیره شد! ✅ در: ${savedFile.path}")),
    );
    print("args.ordersEntity.status");
    print(args.ordersEntity.status);
    print(args.item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "فاکتور فروش",
          style: TextStyle(
              color: AppConfig.white,
              fontSize: AppConfig.calTitleFontSize(context)),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppConfig.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
     body: (_loading || pdfPath == null)
        ?  Center(child: ProgressBar())
        : PDFView(
      filePath: pdfPath!,
      enableSwipe: true,
      swipeHorizontal: false,
      autoSpacing: true,
      pageSnap: true,
      fitPolicy: FitPolicy.BOTH,
    ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppConfig.backgroundColor,
        onPressed: _savePdf,
        tooltip: "ذخیره PDF",
        child: Icon(
          Icons.save,
          color: AppConfig.white,
        ),
      ),
    );
  }
}

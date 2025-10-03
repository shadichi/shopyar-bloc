import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as p;
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:jdate/jdate.dart';

Future pdfExport(shopName) async {
  final dteNow = DateTimeExt(DateTime.now()).toJalali();
  var jd = JDate(dteNow.year, dteNow.month, dteNow.day);

  List<p.Widget> widgets = [];
  final container = p.Center(
    child: p.Container(
      child: p.Column(children: [
        p.Container(
            child: p.Text(
                /*mainPage.shopName.toString()*/
                shopName ?? "",
                textDirection: p.TextDirection.rtl,
                style: p.TextStyle(fontSize: 12))),
        p.Row(mainAxisAlignment: p.MainAxisAlignment.spaceBetween, children: [
          p.Container(
            width: 200,
            alignment: Alignment.centerRight,
            child:
                p.Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              p.Text("کد پستی: ",
                  textDirection: p.TextDirection.rtl,
                  style: p.TextStyle(fontSize: 12)),
              p.Text("ایمیل: ",
                  textDirection: p.TextDirection.rtl,
                  style: p.TextStyle(fontSize: 12)),
            ]),
          ),
          p.Container(
              width: 200,
              alignment: Alignment.centerRight,
              child: p.Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    p.Text("شماره سفارش: ${shopName}",
                        textDirection: p.TextDirection.rtl,
                        style: p.TextStyle(fontSize: 12)),
                    p.Text("تاریخ: ${jd.echo('d F Y')}",
                        textDirection: p.TextDirection.rtl,
                        style: p.TextStyle(fontSize: 12)),
                    p.Text("تلفن: $shopName",
                        textDirection: p.TextDirection.rtl,
                        style: p.TextStyle(fontSize: 12)),
                    p.Text("نشانی: $shopName",
                        textDirection: p.TextDirection.rtl,
                        style: p.TextStyle(fontSize: 12)),
                  ])),
        ]),
      ]),
      padding: const p.EdgeInsets.all(5),
      decoration: p.BoxDecoration(
        border: p.Border.all(),
      ),
    ),
  );
  final container2 = p.Center(
    child: p.Container(
      child:
          p.Row(mainAxisAlignment: p.MainAxisAlignment.spaceEvenly, children: [
        p.Container(
            width: 200,
            alignment: Alignment.centerRight,
            child:
                p.Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              p.Text("کد پستی: ${shopName}",
                  textDirection: p.TextDirection.rtl,
                  style: p.TextStyle(fontSize: 10)),
              p.Text("ایمیل: ${shopName}",
                  textDirection: p.TextDirection.rtl,
                  style: p.TextStyle(fontSize: 10)),
            ])),
      ]),
      padding: const p.EdgeInsets.all(5),
      decoration: p.BoxDecoration(
        border: p.Border.all(
            //  color: PdfColors.blue,
            // width: 2,
            ),
      ),
    ),
  );

  widgets.add(container);
  widgets.add(container2);

  widgets.add(
    p.Container(
      alignment: Alignment.centerRight,
      child: p.Table(children: [
        for (var i = 0; i < 3; i++)
          p.TableRow(children: [
            p.Container(
              alignment: Alignment.centerRight,
              width: 40,
              child: p.Column(
                  crossAxisAlignment: p.CrossAxisAlignment.center,
                  mainAxisAlignment: p.MainAxisAlignment.center,
                  children: [
                    p.Text("",
                        style: p.TextStyle(fontSize: 6),
                        textDirection: p.TextDirection.rtl),
                    p.Divider(thickness: 1)
                  ]),
            ),
            p.Container(
              alignment: Alignment.centerRight,
              width: 80,
              child: p.Column(
                  crossAxisAlignment: p.CrossAxisAlignment.center,
                  mainAxisAlignment: p.MainAxisAlignment.center,
                  children: [
                    p.Text("قیمت: ",
                        style: p.TextStyle(fontSize: 4),
                        textDirection: p.TextDirection.rtl),
                    p.Divider(thickness: 1)
                  ]),
            ),
            p.Container(
              alignment: Alignment.centerRight,
              width: 80,
              child: p.Column(
                  crossAxisAlignment: p.CrossAxisAlignment.center,
                  mainAxisAlignment: p.MainAxisAlignment.center,
                  children: [
                    p.Text('kk',
                        softWrap: false,
                        overflow: TextOverflow.clip,
                        // Use ellipsis (...) for overflow
                        maxLines: 1,
                        // Display only one line of text

                        style: p.TextStyle(fontSize: 4),
                        textDirection: p.TextDirection.rtl),
                    p.Divider(thickness: 1)
                  ]),
            )
          ]),

      ]),
      decoration: p.BoxDecoration(
        border: p.Border.all(),
      ),
    ),
  );
  // widgets.add(p.SizedBox(height: 5));
  //  widgets.add(p.SizedBox(height: 10));

  final pdf = p.Document();
  var arabicFont = Font.ttf(await rootBundle.load("assets/fonts/IRANSansWeb.ttf"));
  pdf.addPage(
    p.MultiPage(
      theme: p.ThemeData.withFont(
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

// file: extensions/persian_digits.dart
extension PersianDigits on String {
  String stringToPersianDigits() {
    const en = ['0','1','2','3','4','5','6','7','8','9'];
    const fa = ['۰','۱','۲','۳','۴','۵','۶','۷','۸','۹'];
    var result = this;// اینجا this یعنی همون رشته‌ای که روش اکستنشن صدا زده میشه
    for (int i = 0; i < 10; i++) {
      result = result.replaceAll(en[i], fa[i]);
    }
    return result;
  }
}
extension IntPersianDigits on int {
  String toPersianDigits() => toString().stringToPersianDigits();
}

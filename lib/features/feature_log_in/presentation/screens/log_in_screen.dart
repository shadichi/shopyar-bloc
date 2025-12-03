import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopyar/core/config/app-colors.dart';
import 'package:shopyar/core/utils/static_values.dart';
import 'package:shopyar/core/widgets/alert_dialog.dart';
import 'package:shopyar/extension/persian_digits.dart';
import 'package:shopyar/features/feature_log_in/presentation/bloc/log_in_bloc.dart';
import '../../../../core/params/whole_user_data_params.dart';
import '../../../../core/widgets/main_wrapper.dart';
import '../../../../core/widgets/progress-bar.dart';
import '../../../../core/widgets/snackBar.dart';
import '../bloc/log_in_status.dart';
import '../widgets/cusrom_clippath_login.dart';
import '../widgets/log_in_text_form_widget.dart';


class LogInScreen extends StatefulWidget {
  static const routeName = '/login_widget';

  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _webServiceController;
  late final TextEditingController _tokenController;

  String _version = "";

  @override
  void initState() {
    super.initState();
    _webServiceController = TextEditingController();
    _tokenController = TextEditingController();

  }

  @override
  void dispose() {
    _webServiceController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_webServiceController.text.trim().isEmpty ||
        _tokenController.text.trim().isEmpty) {
      showSnack(context, "خطا: لطفاً فیلدهای خالی را تکمیل کنید!");
      return;
    }

    context.read<LogInBloc>().add(
          DataLoginEvent(
            WholeUserDataParams(
              _webServiceController.text.trim(),
              _tokenController.text.trim(),
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppConfig.white,
        resizeToAvoidBottomInset: false,
        body: BlocListener<LogInBloc, LogInState>(
          listener: (context, state) {
            final status = state.logInStatus;

            if (status is LoginErrorState) {
              showSnack(
                context,
                "خطا: آدرس وب‌سرویس یا توکن نادرست است!",
              );
            }
            if (status is LoginEmptyFieldErrorState) {
              showSnack(
                context,
                "خطا: در این سایت شیوه های پرداخت یا حمل و نقل وجود ندارد!",
              );
            } else if (status is EmptyTextFieldsStatus) {
              showSnack(
                context,
                "خطا: لطفاً فیلدهای خالی را تکمیل فرمایید!",
              );
            } else if (status is SharedPErrorState) {
              showSnack(
                context,
                "خطا!",
              );
            } else if (status is UserDataLoadedStatus) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => MainWrapper()),
              );
            }
          },
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag, // 👈 با اسکرول کیبورد بسته میشه

              // padding: const EdgeInsets.symmetric(vertical: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height, // یا هر ارتفاع دلخواه
                ),
                child: Stack(
                  children: [
                
                    header(context),
                  //  SizedBox(height: AppConfig.calHeight(context, 4)),
                    Positioned(
                      top: 250,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: loginForm(
                          context,
                          _formKey,
                          _webServiceController,
                          _tokenController,
                            _submit
                        ),
                      ),
                    ),
                    SizedBox(height: AppConfig.calHeight(context, 2)),
                   /* Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: loginButton(context, () => _submit(context)),
                    ),*/
                    SizedBox(height: AppConfig.calHeight(context, 4)),
                    Positioned(child: helpButton(context), bottom: 40,
                      left: 0,
                      right: 0,),
                    SizedBox(height: AppConfig.calHeight(context, 4)),
                    Positioned(child: versionText(context), bottom: 20,
                      left: 0,
                      right: 0,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget header(context) {
  return ClipPath(
    clipper: CustomClipPathSignUp(),
    child: Container(
      padding: EdgeInsets.only(top: AppConfig.calHeight(context, 12)),
      alignment: Alignment.topCenter,
      height: AppConfig.calHeight(context, 80),
      color: AppConfig.secondaryColor,
      child: ListTile(
        title: Text(
          'ورود به اپلیکیشن شاپ‌یار',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppConfig.calFontSize(context, 5),
            fontWeight: FontWeight.bold,
            color: AppConfig.white
          ),
        ),
        subtitle: Text(
          'جهت ورود به اپلیکیشن، آدرس وب سرویس و توکن دریافتی از افزونه را وارد کنید.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppConfig.calFontSize(context, 3.8),
            fontWeight: FontWeight.bold,
              color: AppConfig.borderColor
          ),
        ),
      ),
    ),
  );
}

Widget loginForm(context, formKey, webServiceController, tokenController, _submit) {
  final gap = SizedBox(height: AppConfig.calHeight(context, 2));
  final labelStyle = TextStyle(
    fontSize: AppConfig.calFontSize(context, 5),
    fontWeight: FontWeight.bold,
    color: AppConfig.backgroundColor,
  );

  return Form(
    key: formKey,
    child: Card(
      elevation: 10,
      child: Container(
        height: AppConfig.calHeight(context, 50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(AppConfig.calBorderRadiusSize(context))),
          color: AppConfig.white,
        ),
        padding: EdgeInsets.all(AppConfig.calHeight(context, 0.8)),
      
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: AppConfig.calHeight(context, 1)),
            Text('فرم ورود به اپلیکیشن', style: labelStyle),
            gap,
            LogInTextFormWidget(webServiceController, "آدرس وب سرویس"),
          //  SizedBox(height: AppConfig.calHeight(context, 2)),
            //Text('توکن', style: labelStyle),
            gap,
            LogInTextFormWidget(tokenController, "توکن"),
            loginButton(context, () => _submit(context))
          ],
        ),
      ),
    ),
  );
}

Widget loginButton(context, onPressed) {
  final buttonWidth = AppConfig.calWidth(context, 70);
  final buttonHeight = AppConfig.calHeight(context, 6);

  return SizedBox(
    width: buttonWidth,
    height: buttonHeight,
    child: BlocBuilder<LogInBloc, LogInState>(
      buildWhen: (prev, curr) => prev.logInStatus != curr.logInStatus,
      builder: (context, state) {
        final isLoading = state.logInStatus is LoadingLogInStatus;

        final style = ElevatedButton.styleFrom(
          backgroundColor:
              isLoading ? AppConfig.backgroundColor : AppConfig.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(width: 1, color: Colors.grey[300]!),
          ),
        );

        return ElevatedButton(
          style: style,
          onPressed: isLoading ? null : onPressed,
          child: isLoading
              ? SizedBox(
                  width: buttonWidth * 0.12,
                  height: buttonHeight * 0.25,
                  child: ProgressBar(
                    size: 5,
                  ), // رنگش اگر خواستی بده: ProgressBar(color: Colors.white)
                )
              :  Text(
                  'ورود',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppConfig.calFontSize(context, 4.7),
                    fontWeight: FontWeight.bold,
                  ),
                ),
        );
      },
    ),
  );
}

Widget helpButton(context) {
  return InkWell(
    onTap: () {
      alertDialogScreen(
        context,
        'پس از نصب افزونه شاپ‌یار، از مسیر ووکامرس ← شاپ‌یار یک کلید جدید برای نام کاربری دلخواه ایجاد کنید. سپس آدرس کامل سایت (به همراه http یا https) و توکن دریافت‌شده را در فیلدهای مربوطه وارد نمایید.',
        1,
        true,
        icon: Icons.help,
      );
    },
    child: SizedBox(
      width: AppConfig.calWidth(context, 25),
      height: AppConfig.calHeight(context, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'راهنمایی',
            style: TextStyle(
              color: AppConfig.backgroundColor,
              fontSize: AppConfig.calWidth(context, 4),
            ),
          ),
          SizedBox(width: AppConfig.calWidth(context, 2)),
          Icon(
            Icons.help,
            color: AppConfig.backgroundColor,
            size: AppConfig.calWidth(context, 4.3),
          ),
        ],
      ),
    ),
  );
}

Widget versionText(context) {
  return SizedBox(
    width: AppConfig.calWidth(context, 25),
    height: AppConfig.calHeight(context, 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'نسخه ${StaticValues.packageInfoVersionNo.stringToPersianDigits()}',
          style: TextStyle(
            color: AppConfig.backgroundColor,
            fontSize: AppConfig.calWidth(context, 3.4),
          ),
        ),
        SizedBox(width: AppConfig.calWidth(context, 2)),
      ],
    ),
  );
}

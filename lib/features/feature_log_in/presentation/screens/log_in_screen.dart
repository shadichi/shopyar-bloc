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

    FocusManager.instance.primaryFocus?.unfocus();// close keyboard

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
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height, // یا هر ارتفاع دلخواه
                ),
                child: Column(
                  children: [
                    SizedBox(height: AppConfig.calHeight(context, 15),),

                    Container(
                      child: Image.asset('assets/logo-png.png', fit: BoxFit.contain),
                      height: AppConfig.calHeight(context, 14),
                    ),               SizedBox(height: AppConfig.calHeight(context, 5),),
               Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: loginForm(
                          context,
                          _formKey,
                          _webServiceController,
                          _tokenController,
                            _submit
                        ),
                      ),


                    SizedBox(height: AppConfig.calHeight(context, 2)),
                  helpButton(context),
                    SizedBox(height: AppConfig.calHeight(context, 24)),
                  versionText(context)
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

Widget loginForm(context, formKey, webServiceController, tokenController, _submit) {
  return Container(
    child: Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: AppConfig.calHeight(context, 1)),
          LogInTextFormWidget(webServiceController, "آدرس وب سرویس"),
          LogInTextFormWidget(tokenController, "توکن"),
          loginButton(context, () => _submit(context))
        ],
      ),
    ),
  );
}

Widget loginButton(context, onPressed) {
  final buttonWidth = AppConfig.calWidth(context, 90);
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
                  ),
                )
              :  Text(
                  'ورود به شاپ‌یار',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppConfig.calFontSize(context, 3.7),
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
              color: AppConfig.borderColor,
              fontSize: AppConfig.calWidth(context, 4),
            ),
          ),
          SizedBox(width: AppConfig.calWidth(context, 2)),
          Icon(
            Icons.help,
            color: AppConfig.borderColor,
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
            color: AppConfig.borderColor,
            fontSize: AppConfig.calWidth(context, 3.4),
          ),
        ),
        SizedBox(width: AppConfig.calWidth(context, 2)),
      ],
    ),
  );
}

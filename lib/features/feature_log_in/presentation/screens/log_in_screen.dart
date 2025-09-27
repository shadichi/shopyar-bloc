import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shapyar_bloc/core/config/app-colors.dart';
import 'package:shapyar_bloc/core/widgets/alert_dialog.dart';
import 'package:shapyar_bloc/extension/persian_digits.dart';
import 'package:shapyar_bloc/features/feature_log_in/presentation/bloc/log_in_bloc.dart';
import '../../../../core/params/whole_user_data_params.dart';
import '../../../../core/widgets/main_wrapper.dart';
import '../../../../core/widgets/progress-bar.dart';
import '../../../../core/widgets/snackBar.dart';
import '../bloc/log_in_status.dart';
import '../widgets/cusrom_clippath_login.dart';
import 'package:shimmer/shimmer.dart';
import '../widgets/log_in_text_form_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
    _loadVersion();
    _webServiceController = TextEditingController();
    _tokenController = TextEditingController();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = info.version;
      print('info.version');
      print(info.version);
      // info.version => همون versionName
      // info.buildNumber => همون versionCode
    });
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
        body: BlocListener<LogInBloc, LogInState>(
          listener: (context, state) {
            final status = state.logInStatus;

            if (status is LoginErrorState) {
              showSnack(
                context,
                "خطا: آدرس وب‌سرویس یا توکن نادرست است!",
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
          child: SingleChildScrollView(
            // padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                header(context),
                SizedBox(height: AppConfig.calHeight(context, 4)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: loginForm(
                    context,
                    _formKey,
                    _webServiceController,
                    _tokenController,
                  ),
                ),
                SizedBox(height: AppConfig.calHeight(context, 2)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: loginButton(context, () => _submit(context)),
                ),
                SizedBox(height: AppConfig.calHeight(context, 4)),
                helpButton(context),
                SizedBox(height: AppConfig.calHeight(context, 4)),
                versionText(context, _version),
              ],
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
      alignment: Alignment.center,
      height: AppConfig.calHeight(context, 30),
      color: AppConfig.secondaryColor,
      child: Shimmer.fromColors(
        baseColor: Colors.white,
        highlightColor: Colors.grey,
        child: Text(
          'ورود به اپلیکیشن شاپ‌یار',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppConfig.calFontSize(context, 4.5),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

Widget loginForm(context, formKey, webServiceController, tokenController) {
  final gap = SizedBox(height: AppConfig.calHeight(context, 2));
  final labelStyle = TextStyle(
    fontSize: AppConfig.calFontSize(context, 4),
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  return Form(
    key: formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('آدرس وب‌سرویس', style: labelStyle),
        gap,
        LogInTextFormWidget(webServiceController),
        SizedBox(height: AppConfig.calHeight(context, 2)),
        Text('توکن', style: labelStyle),
        gap,
        LogInTextFormWidget(tokenController),
      ],
    ),
  );
}

Widget loginButton(context, onPressed) {
  final buttonWidth = AppConfig.calWidth(context, 40);
  final buttonHeight = AppConfig.calHeight(context, 8);

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
                    size: 2,
                  ), // رنگش اگر خواستی بده: ProgressBar(color: Colors.white)
                )
              :  Text(
                  'ورود',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppConfig.calFontSize(context, 4),
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
              color: AppConfig.progressBarColor,
              fontSize: AppConfig.calWidth(context, 3.2),
            ),
          ),
          SizedBox(width: AppConfig.calWidth(context, 2)),
          Icon(
            Icons.help,
            color: AppConfig.progressBarColor,
            size: AppConfig.calWidth(context, 4.3),
          ),
        ],
      ),
    ),
  );
}

Widget versionText(context, version) {
  return SizedBox(
    width: AppConfig.calWidth(context, 25),
    height: AppConfig.calHeight(context, 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'ورژن ${version.toString().stringToPersianDigits()}',
          style: TextStyle(
            color: AppConfig.progressBarColor,
            fontSize: AppConfig.calWidth(context, 3.2),
          ),
        ),
        SizedBox(width: AppConfig.calWidth(context, 2)),
      ],
    ),
  );
}

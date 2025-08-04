import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shapyar_bloc/features/feature_home/presentation/screens/home-screen.dart';
import 'package:shapyar_bloc/features/feature_log_in/domain/entities/login_entity.dart';
import 'package:shapyar_bloc/features/feature_log_in/presentation/bloc/log_in_bloc.dart';
import '../../../../core/params/whole_user_data_params.dart';
import '../../../../core/widgets/main_wrapper.dart';
import '../../../../core/widgets/progress-bar.dart';
import '../../../../core/widgets/snackBar.dart';
import '../bloc/log_in_status.dart';
import '../widgets/cusrom_clippath_login.dart';
import 'package:shimmer/shimmer.dart';

import '../widgets/log_in_text_form_widget.dart';

class LogInScreen extends StatelessWidget {
  static const routeName = '/login_widget';

  LogInScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController webServiceController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();
  String buttonText = 'ورود';

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// red container
              ClipPath(
                  clipper: CustomClipPathSignUp(),
                  child: Container(
                    alignment: Alignment.center,
                    width: width,
                    height: height * 0.3,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.topRight,
                        colors: [
                          Color(int.parse('0xFF03045E')),
                          // Purple from hex code
                          Color(int.parse('0xFF4472CA')),
                          // White
                        ],
                      )
                    ),
                    child: Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: Colors.grey,
                        child: Text(
                          'ورود به مدیریت فروشگاه',
                          style: TextStyle(
                              fontSize: width * 0.07,
                              fontWeight: FontWeight.bold),
                        )),
                  )),

              SizedBox(
                height: height * 0.1,
              ),

              /// login btn -- form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'آدرس وب سرویس',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: height * 0.005,
                      ),
                      LogInTextFormWidget(webServiceController),
                      const Text(
                        'توکن',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: height * 0.005,
                      ),
                      LogInTextFormWidget(passWordController),
                      SizedBox(
                        height: height * 0.01,
                      ),

                      /// submit button
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),

              /// register btn
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                    width: width,
                    height: 58,
                    child: BlocConsumer<LogInBloc, LogInState>(
                      listener: (BuildContext context, LogInState state) {
                        if(state.logInStatus is LoginErrorState){
                          showSnack(context, "خطا: آدرس وب سرویس و یا توکن نادرست وارد شده است!",Colors.black54);
                        }

                        if(state.logInStatus is EmptyTextFieldsStatus){
                          showSnack(context, "خطا: لطفا فیلدهای خالی را تکمیل فرمایید!",Colors.black54);                        }
                        if(state.logInStatus is SharedPErrorState){
                          showSnack(context, "خطا!",Colors.black54);                        }
                        if(state.logInStatus is UserDataLoadedStatus){
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => MainWrapper())
                          );
                        }
                      },
                      builder: (context, state) {

                        if(state.logInStatus is LoadingLogInStatus){
                          return  ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                        width: 1, color: Colors.grey[300]!))),
                            onPressed: () {
                            },
                            child:SizedBox(width: width*0.05,height: height*0.02,child: ProgressBar(),)
                          );                        }
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                      width: 1, color: Colors.grey[300]!))),
                          onPressed: () {
                              context.read<LogInBloc>().add(DataLoginEvent(
                                  WholeUserDataParams(webServiceController.text,
                                      passWordController.text)));
                          },
                          child:Text(
                            'ورود',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

}


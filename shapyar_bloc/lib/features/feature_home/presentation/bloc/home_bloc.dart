import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shapyar_bloc/features/feature_home/presentation/bloc/home_status.dart';
import '../../../../core/params/home_user_data_params.dart';
import '../../../../core/utils/static_values.dart';
import '../../domain/use_cases/get_user_data_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetMainDataUseCase getMainDataUseCase;

  //final GetOrdersUseCase getOrdersUseCase;

  HomeBloc(
    this.getMainDataUseCase,
  ) : super(HomeState(homeStatus: HomeLoading())) {
    on<HomeEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<LoadData>((event, emit) async {
      print('Statime');
      print(StaticValues.webService);
      print(StaticValues.passWord);
      print(StaticValues.shopName);
      print(StaticValues.userName);
      print(StaticValues.shippingMethods);
      print(StaticValues.paymentMethods);
      print(StaticValues.status);


      if (StaticValues.webService.isEmpty ||
          StaticValues.passWord.isEmpty ||
          StaticValues.shopName.isEmpty ||
          StaticValues.userName.isEmpty ||
          StaticValues.shippingMethods.isEmpty ||
          StaticValues.paymentMethods.isEmpty ||
          StaticValues.status.isEmpty) {
        print('1');
        final UserDataParams homeUserDataParams = await getMainDataUseCase();
        final prefs = await SharedPreferences.getInstance();
        final webService = prefs.getString("webService");
        final passWord = prefs.getString("passWord");
        StaticValues.webService = webService.toString();
        StaticValues.passWord = passWord.toString();
        print('StaticValues.userName');
        print(webService);
        print(passWord);
        emit(state.copyWith(newHomeStatus: HomeLoading()));

        StaticValues.shopName = homeUserDataParams.response['name'] ?? '';
        StaticValues.userName = homeUserDataParams.response['user'] ?? '';
        StaticValues.shippingMethods =
            homeUserDataParams.response['shipping_methods'] ?? [];
        StaticValues.paymentMethods =
            homeUserDataParams.response['payment_methods'] ?? [];
        StaticValues.status = homeUserDataParams.response['status'] ?? {};
        print('StaticValues.userName');
        print(StaticValues.shopName);
        if (StaticValues.webService != '' &&
            StaticValues.passWord != '' &&
            StaticValues.shopName.isNotEmpty &&
            StaticValues.userName.isNotEmpty &&
            StaticValues.shippingMethods.isNotEmpty &&
            StaticValues.paymentMethods.isNotEmpty &&
            StaticValues.status.isNotEmpty) {

          emit(state.copyWith(
              newHomeStatus: HomeLoadedStatus()));
        } else {
          print('در صفحه هوم اطلاعات اصلی بارگیری نشد');
          emit(state.copyWith(newHomeStatus: HomeErrorStatus()));
        }
      } else {
        print('2');
        emit(state.copyWith(
            newHomeStatus: HomeLoadedStatus()));
      }
    });
      on<LogOut>((event, emit) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('webService');
        await prefs.remove('consumerKey');
      });
  }
}

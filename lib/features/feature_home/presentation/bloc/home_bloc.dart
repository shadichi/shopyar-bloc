import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shopyar/core/resources/data_state.dart';
import 'package:shopyar/features/feature_home/domain/entities/home_data_entity.dart';
import 'package:shopyar/features/feature_home/presentation/bloc/home_status.dart';
import '../../../../core/params/home_user_data_params.dart';
import '../../../../core/params/whole_user_data_params.dart';
import '../../../../core/utils/static_values.dart';
import '../../domain/use_cases/get_home-data_use_case.dart';
import '../../domain/use_cases/get_user_data_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_data_status.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetMainDataUseCase getMainDataUseCase;
  final GetHomeDataUseCase getHomeDataUseCase;


  HomeBloc(this.getMainDataUseCase, this.getHomeDataUseCase)
      : super(HomeState(
            homeStatus: HomeLoading(), homeDataStatus: HomeDataLoading())) {

    on<LoadDataEvent>((event, emit) async {

      if (StaticValues.webService.isEmpty ||
          StaticValues.passWord.isEmpty ||
          StaticValues.shopName.isEmpty ||
          StaticValues.userName.isEmpty ||
          StaticValues.shippingMethods.isEmpty ||
          StaticValues.paymentMethods.isEmpty ||
          StaticValues.status.isEmpty ||
          StaticValues.staticHomeDataEntity == null) {

        final DataState dataState = await getHomeDataUseCase();

        print('dataState.data');
        print(dataState.data);

        if (dataState is DataSuccess) {

          StaticValues.staticHomeDataEntity = dataState.data;

          print('StaticValues.staticHomeDataEntity');
          print(StaticValues.staticHomeDataEntity);

        }

          final UserDataParams homeUserDataParams = await getMainDataUseCase();

          final prefs = await SharedPreferences.getInstance();

          final webService = prefs.getString("webService");
          final passWord = prefs.getString("passWord");

          StaticValues.webService = webService.toString();
          StaticValues.passWord = passWord.toString();

          emit(state.copyWith(newHomeStatus: HomeLoading()));

          StaticValues.shopName = homeUserDataParams.response['name'] ?? '';
          StaticValues.userName = homeUserDataParams.response['user'] ?? '';
          StaticValues.shippingMethods =
              homeUserDataParams.response['shipping_methods'] ?? [];
          StaticValues.paymentMethods =
              homeUserDataParams.response['payment_methods'] ?? [];
          StaticValues.status = homeUserDataParams.response['status'] ?? {};
          StaticValues.versionNo = homeUserDataParams.response['version'] ?? "";


          if (StaticValues.webService != '' &&
              StaticValues.passWord != '' &&
              StaticValues.shopName.isNotEmpty &&
              StaticValues.userName.isNotEmpty &&
              StaticValues.shippingMethods.isNotEmpty &&
              StaticValues.paymentMethods.isNotEmpty &&
              StaticValues.status.isNotEmpty &&
              StaticValues.staticHomeDataEntity != null) {
            emit(state.copyWith(newHomeStatus: HomeLoadedStatus()));
          } else {
            print('در صفحه هوم اطلاعات اصلی بارگیری نشد');
            emit(state.copyWith(newHomeStatus: HomeErrorStatus()));
          }
        } else {
          emit(state.copyWith(newHomeStatus: HomeLoadedStatus()));
        }
      }
    );

    on<LogOutEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('webService');
      await prefs.remove('consumerKey');
    });

    on<AccountExit>((event, emit) async {
      emit(state.copyWith(newHomeStatus:HomeLoading()));
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();
      emit(state.copyWith(newHomeStatus:HomeAccountExitStatus()));
    });

    // Add this to your HomeBloc, after the other event handlers
    on<RefreshHomeData>((event, emit) async {
      // Show loading state during refresh
      emit(state.copyWith(newHomeStatus: HomeLoading()));

      try {
        // Refresh the home data
        final DataState dataState = await getHomeDataUseCase();

        if (dataState is DataSuccess) {
          StaticValues.staticHomeDataEntity = dataState.data;

          // Refresh user data if needed
          final UserDataParams homeUserDataParams = await getMainDataUseCase();
          final prefs = await SharedPreferences.getInstance();

          StaticValues.webService = prefs.getString("webService") ?? '';
          StaticValues.passWord = prefs.getString("passWord") ?? '';
          StaticValues.shopName = homeUserDataParams.response['name'] ?? '';
          StaticValues.userName = homeUserDataParams.response['user'] ?? '';
          StaticValues.shippingMethods = homeUserDataParams.response['shipping_methods'] ?? [];
          StaticValues.paymentMethods = homeUserDataParams.response['payment_methods'] ?? [];
          StaticValues.status = homeUserDataParams.response['status'] ?? {};
          StaticValues.versionNo = homeUserDataParams.response['version'] ?? "";

          emit(state.copyWith(newHomeStatus: HomeLoadedStatus()));
        } else {
          emit(state.copyWith(newHomeStatus: HomeErrorStatus()));
        }
      } catch (e) {
        emit(state.copyWith(newHomeStatus: HomeErrorStatus()));
      } finally {
        // Complete the completer if provided
        event.completer?.complete();
      }
    });

  }





}

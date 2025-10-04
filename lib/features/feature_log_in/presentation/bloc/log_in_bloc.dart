import 'dart:async';
import 'package:equatable/equatable.dart';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shopyar/features/feature_log_in/domain/use_cases/set_string_usecase.dart';
import 'package:shopyar/features/feature_log_in/presentation/bloc/log_in_status.dart';

import '../../../../core/params/whole_user_data_params.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/utils/static_values.dart';
import '../../domain/use_cases/get_login_data.dart';

part 'log_in_event.dart';

part 'log_in_state.dart';

class LogInBloc extends Bloc<LogInEvent, LogInState> {
  final GetLoginDataUseCase getLoginDataUseCase;
  final SetStringUseCase setStringUseCase;

  LogInBloc(this.getLoginDataUseCase, this.setStringUseCase)
      : super(LogInState(logInStatus: UserDataInitialStatus())) {
    //initial state
    on<LogInEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<DataLoginEvent>((event, emit) async {
      if (event.userDataParams.webService.isEmpty ||
          event.userDataParams.key.isEmpty) {
        emit(state.copyWith(newlogInStatus: EmptyTextFieldsStatus()));
      } else {
        emit(state.copyWith(newlogInStatus: LoadingLogInStatus()));
        try {
          Map<String, dynamic> response = await getLoginDataUseCase(
              WholeUserDataParams(event.userDataParams.webService.toString(),
                  event.userDataParams.key));

          if (response.isNotEmpty) {
            StaticValues.shopName = await response['name'];
            StaticValues.shippingMethods = await response['shipping_methods'];
            StaticValues.paymentMethods = await response['payment_methods'];
            StaticValues.status = await response['status'];
            StaticValues.webService =
                event.userDataParams.webService.toString();
            StaticValues.passWord = event.userDataParams.key.toString();

            if (StaticValues.shopName != '' &&
                StaticValues.status.isNotEmpty &&
                StaticValues.shopName.isNotEmpty &&
                StaticValues.shippingMethods.isNotEmpty &&
                StaticValues.paymentMethods.isNotEmpty) {
              try {
                await setStringUseCase(event.userDataParams.key.toString(),
                    event.userDataParams.webService);
                emit(state.copyWith(newlogInStatus: UserDataLoadedStatus()));
              } catch (error) {
                emit(
                    state.copyWith(newlogInStatus: SharedPErrorState('error')));
              }
            }
          } else {
            emit(state.copyWith(
                newlogInStatus:
                    LoginErrorState('Invalid username or password')));
          }
        } catch (error) {
          emit(state.copyWith(
              newlogInStatus: LoginErrorState('Invalid username or password')));
        }
      }
    });
  }
}

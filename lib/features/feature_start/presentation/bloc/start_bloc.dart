import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shapyar_bloc/features/feature_start/domain/use_cases/get_string_use_case.dart';

import 'package:shapyar_bloc/features/feature_start/presentation/bloc/start_status.dart';

import '../../../../core/params/whole_user_data_params.dart';
import '../../domain/use_cases/check-connectivity-use-case.dart';

part 'start_event.dart';

part 'start_state.dart';

class StartBloc extends Bloc<StartEvent, StartState> {
  final GetStringUseCase getStringUseCase;
  final CheckConnectivityUseCase checkConnectivityUseCase;

  StartBloc(
      this.getStringUseCase, this.checkConnectivityUseCase)
      : super(StartState(logInStatus: UserDataLoadingStatus())) {
    //initial state
    on<StartEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<LoadUserDataEvent>((event, emit) async {

      emit(state.copyWith(newlogInStatus: UserDataLoadingStatus()));
      final WholeUserDataParams userDataParams = await getStringUseCase();

      if (userDataParams.webService != '' && userDataParams.key != '') {
        emit(state.copyWith(newlogInStatus: UserDataLoadedStatus()));
      } else {
        //  emit(UserDataErrorState());
        emit(state.copyWith(newlogInStatus: UserDataErrorStatus()));
      }
    });

    on<CheckConnectionEvent>((event, emit) async {
      final bool isConnect = await checkConnectivityUseCase.call();
      if (isConnect == true) {
        emit(state.copyWith(newlogInStatus: ConnectionAvailableStatus()));
      }
      if (isConnect == false) {
        emit(state.copyWith(newlogInStatus: ConnectionUnavailableState()));
      }
    });

  }
}

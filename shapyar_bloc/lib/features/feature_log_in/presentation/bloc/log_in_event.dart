part of 'log_in_bloc.dart';

@immutable
abstract class LogInEvent {}


class DataLoginEvent extends LogInEvent {
  final WholeUserDataParams userDataParams;

  DataLoginEvent(this.userDataParams);
}







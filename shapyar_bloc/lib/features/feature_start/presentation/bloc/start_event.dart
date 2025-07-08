part of 'start_bloc.dart';

@immutable
abstract class StartEvent {}

class LoadUserDataEvent extends StartEvent {

  /*final LoginEntity loginEntity;

  LoadUserDataEvent( this.loginEntity);*/
}

class DataLoginEvent extends StartEvent {
  final WholeUserDataParams userDataParams;

  DataLoginEvent(this.userDataParams);
}

/*class SaveUserDataEvent extends LogInEvent {
  final UserDataParams userDataParams;

  SaveUserDataEvent(this.userDataParams);
}*/

class CheckConnectionEvent extends StartEvent{}





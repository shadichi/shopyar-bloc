part of 'log_in_bloc.dart';

class LogInState extends Equatable{
  final LogInStatus logInStatus;
 // final LogInStatus logInStdatus;
  const LogInState({required this.logInStatus});

  LogInState copyWith({
  LogInStatus? newlogInStatus
}){
    return LogInState(logInStatus: newlogInStatus ?? logInStatus);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    logInStatus
  ];
}



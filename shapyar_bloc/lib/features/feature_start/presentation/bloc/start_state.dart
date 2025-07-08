part of 'start_bloc.dart';

class StartState extends Equatable{
  final StartStatus logInStatus;
 // final LogInStatus logInStdatus;
  const StartState({required this.logInStatus});

  StartState copyWith({
    StartStatus? newlogInStatus
}){
    return StartState(logInStatus: newlogInStatus ?? logInStatus);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    logInStatus
  ];
}



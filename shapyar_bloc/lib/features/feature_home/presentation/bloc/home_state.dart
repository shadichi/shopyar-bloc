part of 'home_bloc.dart';

class HomeState extends Equatable{
  final HomeStatus homeStatus;
  const HomeState({required this.homeStatus});

  HomeState copyWith({
  HomeStatus? newHomeStatus
}){
    return HomeState(homeStatus: newHomeStatus?? homeStatus);
  }

  @override
  // TODO: implement props
  List<Object?> get props =>[ homeStatus];
}

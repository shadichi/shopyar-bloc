part of 'home_bloc.dart';

class HomeState extends Equatable{
  final HomeStatus homeStatus;
  final HomeDataStatus homeDataStatus;
  const HomeState({required this.homeStatus, required this.homeDataStatus});

  HomeState copyWith({
  HomeStatus? newHomeStatus,
  HomeDataStatus? newHomeDataStatus
}){
    return HomeState(homeStatus: newHomeStatus?? homeStatus, homeDataStatus: newHomeDataStatus?? homeDataStatus);
  }

  @override
  // TODO: implement props
  List<Object?> get props =>[ homeStatus, homeDataStatus];
}

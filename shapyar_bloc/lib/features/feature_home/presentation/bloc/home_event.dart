part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class LoadData extends HomeEvent{}

class LogOut extends HomeEvent{
  LogOut();
}

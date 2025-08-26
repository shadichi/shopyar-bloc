part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class LoadDataEvent extends HomeEvent{
}

class LogOutEvent extends HomeEvent{}

class LoadHomeDataEvent extends HomeEvent{}

class AccountExit extends HomeEvent{}

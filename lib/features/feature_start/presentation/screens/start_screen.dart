import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shapyar_bloc/core/widgets/main_wrapper.dart';
import 'package:shapyar_bloc/features/feature_home/presentation/screens/home-screen.dart';
import 'package:shapyar_bloc/features/feature_log_in/presentation/screens/log_in_screen.dart';
import '../../../../core/params/whole_user_data_params.dart';
import '../../../../core/widgets/progress-bar.dart';
import '../../data/repository/start_repositoryImpl.dart';
import '../bloc/start_bloc.dart';
import '../bloc/start_status.dart';
import '../widgets/no_connection_screen.dart';

class StartScreen extends StatefulWidget {
  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<StartBloc>(context).add(CheckConnectionEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartBloc, StartState>(builder: (context, state) {
      if (state.logInStatus is UserDataLoadingStatus) {

        return Center(child: ProgressBar());
      } else if (state.logInStatus is UserDataErrorStatus) {

        return LogInScreen();
      } else if (state.logInStatus is UserDataLoadedStatus) {

        return MainWrapper();
      } else if (state.logInStatus is ConnectionAvailableStatus) {
        context.read<StartBloc>().add(LoadUserDataEvent());
        return Center(child: ProgressBar());
      } else if (state.logInStatus is ConnectionUnavailableState) {
        return NoConnectionScreen();
      }
      return Container();
    });
  }
}

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rofqaa_elganna/cubits/add_donation_cubit/add_donation_cubit.dart';
import 'package:rofqaa_elganna/cubits/add_volunteer_cubit/add_volunteer_cubit.dart';
import 'package:rofqaa_elganna/cubits/create_team_cubit/create_team_cubit.dart';
import 'package:rofqaa_elganna/cubits/donations_cubit/team_donations_cubit.dart';
import 'package:rofqaa_elganna/cubits/home_cubit/home_cubit.dart';
import 'package:rofqaa_elganna/cubits/my_donations_cubit/my_donations_cubit.dart';
import 'package:rofqaa_elganna/cubits/phone_auth_cubit/phone_auth_cubit.dart';
import 'package:rofqaa_elganna/cubits/team_members_cubit/team_members_cubit.dart';
import 'package:rofqaa_elganna/cubits/teams_donations_for_manager_cubit/teams_donations_for_manager_cubit.dart';
import 'package:rofqaa_elganna/helper/utility.dart';
import 'package:rofqaa_elganna/view/screens/authentication_screen.dart';
import 'package:rofqaa_elganna/view/screens/home_layout.dart';

import 'helper/constants.dart';
import 'helper/my_bloc_observer.dart';

/// CREATE TEAM FROM TEAM MANAGER
/// TEAM SCREEN
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final Directory appDocumentDir = await getApplicationDocumentsDirectory();
  Hive..init(appDocumentDir.path);
  await Hive.openBox(Constants.HIVE_BOX);
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    //UserModel? userModel = UserModel.fromMap();
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(
          create: (BuildContext context) => HomeCubit(),
        ),
        BlocProvider<PhoneAuthCubit>(
          create: (BuildContext context) => PhoneAuthCubit(),
        ),

        BlocProvider<AddDonationCubit>(
          create: (BuildContext context) => AddDonationCubit(),
        ),
        BlocProvider<MyDonationsCubit>(
          create: (BuildContext context) => MyDonationsCubit(),
        ),
        BlocProvider<TeamDonationsCubit>(
          create: (BuildContext context) => TeamDonationsCubit(),
        ),
        BlocProvider<AddVolunteerCubit>(
          create: (BuildContext context) => AddVolunteerCubit(),
        ),
        BlocProvider<CreateTeamCubit>(
          create: (BuildContext context) => CreateTeamCubit(),
        ),
        BlocProvider<TeamMembersCubit>(
          create: (BuildContext context) => TeamMembersCubit(),
        ),
        BlocProvider<TeamsDonationsForManagerCubit>(
          create: (BuildContext context) => TeamsDonationsForManagerCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Utility.box.get(Constants.USER) != null ? HomeLayout() : AuthenticationScreen(),
        builder: EasyLoading.init(),
      ),
    );
  }
}

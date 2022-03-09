import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:rofqaa_elganna/helper/utility.dart';
import 'package:rofqaa_elganna/presentation/screens/authentication_screen.dart';
import 'package:rofqaa_elganna/presentation/screens/home_layout.dart';

import 'helper/constants.dart';
import 'helper/my_bloc_observer.dart';
import 'logic/cubits/add_donation_cubit/add_donation_cubit.dart';
import 'logic/cubits/add_volunteer_cubit/add_volunteer_cubit.dart';
import 'logic/cubits/create_team_cubit/create_team_cubit.dart';
import 'logic/cubits/donations_cubit/team_donations_cubit.dart';
import 'logic/cubits/home_cubit/home_cubit.dart';
import 'logic/cubits/my_donations_cubit/my_donations_cubit.dart';
import 'logic/cubits/phone_auth_cubit/phone_auth_cubit.dart';
import 'logic/cubits/team_members_cubit/team_members_cubit.dart';
import 'logic/cubits/teams_donations_for_manager_cubit/teams_donations_for_manager_cubit.dart';

// localize the types of donations
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  final Directory appDocumentDir = await getApplicationDocumentsDirectory();
  Hive..init(appDocumentDir.path);
  await Hive.openBox(Constants.HIVE_BOX);
  Bloc.observer = MyBlocObserver();
  runApp(EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'lang',
      fallbackLocale: const Locale('en', 'US'),
      child: MyApp()));
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
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        debugShowCheckedModeBanner: false,
        locale: context.locale,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        builder: (context, widget) {
          widget = ResponsiveWrapper.builder(
            BouncingScrollWrapper.builder(context, widget!),
            breakpoints: const [
              ResponsiveBreakpoint.resize(350, name: MOBILE),
              ResponsiveBreakpoint.autoScale(600, name: TABLET),
              ResponsiveBreakpoint.resize(800, name: DESKTOP),
              ResponsiveBreakpoint.autoScale(1700, name: 'XL'),
            ],
          );
          widget = EasyLoading.init()(context, widget);
          return widget;
        },
        home: Utility.box.get(Constants.USER) != null ? HomeLayout() : AuthenticationScreen(),
      ),
    );
  }
}

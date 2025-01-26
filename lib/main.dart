import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solitaire/cubit/auth/auth_cubit.dart';
import 'package:solitaire/cubit/customer_profile/profile_cubit.dart';
import 'package:solitaire/cubit/picker/picker_cubit.dart';
import 'package:solitaire/cubit/picker_request/picker_request_cubit.dart';
import 'package:solitaire/cubit/topup/topup_cubit.dart';
import 'package:solitaire/utils/app_preferences.dart';
import 'screens/auth/start_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferences.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => ProfileCubit()),
        BlocProvider(create: (context) => TopupCubit()),
        BlocProvider(create: (context) => PickerCubit()),
        BlocProvider(create: (context) => PickerRequestCubit()),
      ],
      child: MaterialApp(
        title: 'Solitaire',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const StartScreen(),
      ),
    );
  }
}

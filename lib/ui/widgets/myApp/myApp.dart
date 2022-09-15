import 'package:flutter/material.dart';
import 'package:graphics/Theme/app_colors.dart';
import 'package:graphics/ui/navigation/main_navigation.dart';

class MyApp extends StatelessWidget {
  static final navigation = MainNavigation();
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.main,
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: navigation.initialRoute,
      routes: navigation.routes,
    );
  }
}


import 'package:graphics/Library/Widgets/Inherited/provider.dart';
import 'package:graphics/ui/widgets/labs/lab1/lab1_model.dart';
import 'package:graphics/ui/widgets/labs/lab1/lab1_widget.dart';
import 'package:graphics/ui/widgets/labs/lab2/lab2_model.dart';
import 'package:graphics/ui/widgets/labs/lab2/lab2_widget.dart';
import 'package:graphics/ui/widgets/labs/lab3/lab3_model.dart';
import 'package:graphics/ui/widgets/labs/lab3/lab3_widget.dart';
import 'package:graphics/ui/widgets/mainScreen/mainScreen.dart';

class MainNavigationNameRoute {
  static const main = '/';
  static const lab1 = '/lab1';
  static const lab2 = '/lab2';
  static const lab3 = '/lab3';
}

class MainNavigation {
  final routes = {
    MainNavigationNameRoute.main: (context) => const MainScreen(),
    MainNavigationNameRoute.lab1: (context) => NotifierProvider(
      create: () => Lab1Model(),
      child: const Lab1Widget(),
    ),
    MainNavigationNameRoute.lab2: (context) => NotifierProvider(
      create: () => Lab2Model(),
      child: const Lab2Widget(),
    ),
    MainNavigationNameRoute.lab3: (context) => NotifierProvider(
      create: () => Lab3Model(),
      child: const Lab3Widget(),
    ),
  };
  final initialRoute = MainNavigationNameRoute.main;
}
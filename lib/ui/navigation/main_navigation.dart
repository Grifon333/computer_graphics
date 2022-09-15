import 'package:graphics/Library/Widgets/Inherited/provider.dart';
import 'package:graphics/ui/widgets/labs/lab1/lab1_model.dart';
import 'package:graphics/ui/widgets/labs/lab1/lab1_widget.dart';
import 'package:graphics/ui/widgets/mainScreen/mainScreen.dart';

class MainNavigationNameRoute {
  static const main = '/';
  static const lab1 = '/lab1';
}

class MainNavigation {
  final routes = {
    MainNavigationNameRoute.main: (context) => const MainScreen(),
    MainNavigationNameRoute.lab1: (context) => NotifierProvider(
      create: () => Lab1Model(),
      child: const Lab1Widget(),
    ),
  };
  final initialRoute = MainNavigationNameRoute.main;
}
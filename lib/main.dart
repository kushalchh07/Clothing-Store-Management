import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:nepstyle_management_system/Logic/Bloc/InventoryBloc/inventory_bloc.dart';
import 'package:nepstyle_management_system/Logic/Bloc/LoginBloc/login_bloc.dart';
import 'package:nepstyle_management_system/Logic/Bloc/categoryBloc/category_bloc.dart';
import 'package:nepstyle_management_system/Logic/Bloc/customersBloc/customer_bloc.dart';
import 'package:nepstyle_management_system/Logic/Bloc/orderBloc/order_bloc.dart';
import 'package:nepstyle_management_system/Logic/Bloc/purchaseBloc/purchase_bloc.dart';
import 'package:nepstyle_management_system/Logic/Bloc/salesBloc/sales_bloc.dart';
import 'package:nepstyle_management_system/Logic/Bloc/supplierBloc/supplier_bloc.dart';
import 'package:nepstyle_management_system/firebase_options.dart';

import 'package:nepstyle_management_system/pages/SplashScreen/splashScreen.dart';

import 'Logic/Bloc/reportBloc/report_bloc.dart';

/// Initializes the Flutter application and runs it.
///
/// This function ensures that the Flutter framework is initialized,
/// initializes Firebase, and runs the [MyApp] widget.
///
/// This function is typically called in the `main` function of the Dart
/// entrypoint file.
void main() async {
  // Ensure that the Flutter framework is initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase.
  // This function must be called before using any Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Run the MyApp widget as the root of the Flutter application.
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(),
        ),
        BlocProvider(
          create: (context) => CustomerBloc(),
        ),
        BlocProvider(
          create: (context) => InventoryBloc(),
        ),
        BlocProvider(
          create: (context) => SupplierBloc(),
        ),
        BlocProvider(
          create: (context) => PurchaseBloc(),
        ),
        BlocProvider(
          create: (context) => SalesBloc(),
        ),
        BlocProvider(
          create: (context) => OrderBloc(),
        ),
        BlocProvider(
          create: (context) => CategoryBloc(),
        ),
        BlocProvider(
          create: (context) => ReportBloc(),
        ),
      ],
      child: GetMaterialApp(
        title: 'Clothing Store Management System',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

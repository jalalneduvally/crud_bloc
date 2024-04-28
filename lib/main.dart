import 'package:crud_bloc/features/products/bloc/product_bloc.dart';
import 'package:crud_bloc/features/products/repository/product_repository.dart';
import 'package:crud_bloc/features/widget%20bloc/image_bloc.dart';
import 'package:crud_bloc/features/widget%20bloc/widget_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/utils/image_picker_utils.dart';
import 'features/category/bloc/category_bloc.dart';
import 'features/category/repository/category_repository.dart';
import 'features/screens/home_screen.dart';
import 'features/widget bloc/search_bloc.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductBloc(ProductRepository()),
        ),
        BlocProvider(
          create: (context) => CategoryBloc(CategoryRepository()),
        ),
        BlocProvider(
          create: (context) => ImagePickerBloc(ImagePickerUtils()),
        ),
        BlocProvider(
          create: (context) => RadioBloc(),
        ),
        BlocProvider(
          create: (context) => DropDownBloc(),
        ),
        BlocProvider(
          create: (context) => SearchBloc(),
        ),
      ],
      child: const MaterialApp(
        title: 'Flutter Bloc CRUD',
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:kpms/controllers/loader_controller.dart';
import 'package:kpms/screens/landing_screen.dart';
import 'package:kpms/utils/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kpms/widgets/loader.dart';
import 'package:provider/provider.dart';

LoaderController loader = LoaderController();
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
       ChangeNotifierProvider(
          create: (context) => LoaderController(),
        ),
    ],builder: (context, child) => 
    CustomLoader(
          isLoading: Provider.of<LoaderController>(context).getLoader(),
          child: 
     MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  SplashScreen(),
    )));
  }
}

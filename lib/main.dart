import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:saathi/Authentication/SignIn.dart';
import 'package:saathi/PersonalChecklist.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:saathi/Authentication/LogIn.dart';
import 'package:saathi/PersonalChecklist.dart';
import 'package:saathi/SharedChecklist.dart';
import 'package:saathi/firebase_options.dart';
import 'package:provider/provider.dart';
import 'services/AuthService.dart';
import 'package:saathi/HomePage.dart';
import 'services/Dataservice.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final directory = await  getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider.value(value: Authservice().user, initialData: null),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Inter',

          useMaterial3: true,
        ),
        home: const Wrapper(),
      ),
    );
  }
}

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {




  @override
  Widget build(BuildContext context) {
    final user = Provider.of<String?>(context);

    return (user==null) ? Login() : PersonalChecklist() ;
  }
}

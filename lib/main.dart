import 'package:dun_diary_app/core/constant/hive_constants.dart';
import 'package:dun_diary_app/feature/home/data/model/user.dart';
import 'package:dun_diary_app/feature/main/presentation/main_screen.dart';
import 'package:dun_diary_app/register_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  await initService();  
  await initHive();
  await initFirebase();
  runApp(MultiProvider(providers: appProviders, child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', debugShowCheckedModeBanner: false, home: const MainScreen());
  }
}


// init service
initService() async {
  WidgetsFlutterBinding.ensureInitialized();
}

// init hive 
initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>(HiveBoxName.userBox);
  await Hive.openBox(HiveBoxName.settingsBox);
}

// init firebase
initFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}


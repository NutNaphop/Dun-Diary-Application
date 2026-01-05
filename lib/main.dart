import 'package:dun_diary_app/core/constant/app_routes.dart';
import 'package:dun_diary_app/core/constant/hive_constants.dart';
import 'package:dun_diary_app/core/router/app_router.dart';
import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/core/services/snackbar_service.dart';
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
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
    return MaterialApp(
      title: 'Dun Diary',
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.instance.navigatorKey,
      scaffoldMessengerKey: SnackBarService.instance.scaffoldMessengerKey,
      initialRoute: AppRoutes.main,
      onGenerateRoute: AppRouter.generate,
    );
  }
}

// init service
initService() async {
  WidgetsFlutterBinding.ensureInitialized();
}

// init hive
initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(BPRecordAdapter());
  await Hive.openBox<BPRecord>(HiveBoxName.bpRecord);
  await Hive.openBox(HiveBoxName.settingsBox);
}

// init firebase
initFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

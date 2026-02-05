import 'package:dun_diary_app/core/constant/app_routes.dart';
import 'package:dun_diary_app/core/constant/hive_constants.dart';
import 'package:dun_diary_app/core/router/app_router.dart';
import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/core/services/snackbar_service.dart';
import 'package:dun_diary_app/data/analyze_record/model/analyze_cache_model.dart';
import 'package:dun_diary_app/data/analyze_record/model/analyze_result_model.dart';
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:dun_diary_app/register_provider.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
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
      title: AppStrings.common.appName,
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.instance.navigatorKey,
      scaffoldMessengerKey: SnackBarService.instance.scaffoldMessengerKey,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.generate,
    );
  }
}

// init service
initService() async {
  WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
}

// init hive
initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(BPRecordAdapter());
  Hive.registerAdapter(AnalysisCacheAdapter());
  Hive.registerAdapter(AnalyzeResultModelAdapter());
  await Hive.openBox<BPRecord>(HiveBoxName.bpRecord);
  await Hive.openBox(HiveBoxName.settingsBox);
  await Hive.openBox<String>(HiveBoxName.QueueBox);
  await Hive.openBox(HiveBoxName.metaBox);
  await Hive.openBox<AnalysisCache>(HiveBoxName.analysisCacheBox);
  await Hive.openBox<List<String>>(HiveBoxName.indexBox);
}

// init firebase
initFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

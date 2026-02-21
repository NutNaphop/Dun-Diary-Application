import 'dart:io';

import 'package:dun_diary_app/core/constant/app_routes.dart';
import 'package:dun_diary_app/core/router/base_feature_router.dart';
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:dun_diary_app/feature/record/presentation/record_screen.dart';
import 'package:dun_diary_app/feature/record/presentation/resultScreen/result_screen.dart';
import 'package:flutter/material.dart';

class RecordRouter extends BaseFeatureRouter {
  @override
  Map<String, Widget Function(dynamic args)> get routes => {
    AppRoutes.record: (args) {
      if (args is BPRecord) {
        return RecordScreen.createWithRecord(args);
      }
      return RecordScreen.create();
    },
    AppRoutes.result: (args) {
      if (args is File) {
        return ResultScreen.createWithArg(args);
      }
      // If args invalid, BaseFeatureRouter will build this widget,
      // but maybe we want to throw error or return error widget?
      // For now returning a placeholder error for invalid args in result screen
      return Scaffold(body: Center(child: Text("Error: No image provided")));
    },
  };
}

import 'dart:async';
import 'dart:io';
import 'package:dun_diary_app/core/services/app_logger.dart';

import 'package:flutter/services.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:ultralytics_yolo/widgets/yolo_controller.dart';

class ModelService {
  YOLO? _yolo;
  Completer<void>? _loadingCompleter;
  late YOLOViewController controller;

  ModelService._();
  static final ModelService instance = ModelService._();

  Future<void> loadYOLO() async {
    if (_loadingCompleter != null) return _loadingCompleter!.future;
    _loadingCompleter = Completer<void>();

    try {
      String targetModelPath = "";

      if (Platform.isIOS) {
        targetModelPath = "yoloV8F_640_float16.mlmodel";
      } else {
        final modelName = "yoloV8F_640_float16.tflite";
        final tempDir = Directory.systemTemp;
        final modelFile = File('${tempDir.path}/$modelName');
        if (!await modelFile.exists()) {
          final modelData = await rootBundle.load('assets/models/$modelName');
          await modelFile.writeAsBytes(modelData.buffer.asUint8List());
        }
        targetModelPath = modelFile.path;
      }

      _yolo = YOLO(
        modelPath: targetModelPath,
        task: YOLOTask.detect,
        useGpu: false,
      );

      await _yolo!.loadModel();
      AppLogger.info("Loaded Model: $targetModelPath");
      _loadingCompleter!.complete();
    } catch (e) {
      AppLogger.error("Error loading model", e);
      _loadingCompleter!.completeError(e);
      _loadingCompleter = null; // Allow retry on next call
      rethrow;
    }
  }

  Future<List<dynamic>> predict(Uint8List image) async {
    await loadYOLO();
    final results = await _yolo!.predict(
      image,
      confidenceThreshold: 0.5,
      iouThreshold: 0.5,
    );
    return results['boxes'];
  }

  // dispose
  void dispose() {
    _yolo?.dispose();
    _loadingCompleter = null;
  }
}

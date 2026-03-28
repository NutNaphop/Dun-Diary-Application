class YoloV8Response {
  final String classId;
  final String label;
  final double score;
  final List<double> box;

  YoloV8Response({
    required this.classId,
    required this.label,
    required this.score,
    required this.box,
  });

  factory YoloV8Response.fromJson(Map<String, dynamic> json) {
    return YoloV8Response(
      classId: json['class_id'],
      label: json['label'],
      score: json['score'],
      box: List<double>.from(json['box']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class_id': classId,
      'label': label,
      'score': score,
      'box': box,
    };
  }
}

class BPFormat {
  BPType bpType;
  BPItem item;

  BPFormat({required this.bpType, required this.item});
}

class BPItem {
  double posX;
  double posY;
  String value;

  BPItem({required this.posX, required this.posY, required this.value});
}

enum BPType{
    SYS,
    DIA,
    PUL,
}
import 'package:dun_diary_app/data/analyze_record/datasource/analyze_local_source.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get dataStatProviders {
  return [
    // Local
    Provider<AnalyzeLocalDataSource>(create: (_) => AnalyzeLocalDataSource()),
  ];
}

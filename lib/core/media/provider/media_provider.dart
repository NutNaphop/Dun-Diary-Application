import 'package:dun_diary_app/core/services/media_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get mediaProviders {
  return [Provider<MediaService>(create: (_) => MediaService())];
}

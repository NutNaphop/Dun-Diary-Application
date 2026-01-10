// Make me a mock page
import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/custom_scaffold.dart';
import 'package:flutter/material.dart';

class MockPage extends StatelessWidget {
  const MockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: Text("data"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            NavigationService.instance.goBack();
          },
        ),
      ),
      body: Text("Record"),
    );
  }
}

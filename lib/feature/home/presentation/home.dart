import 'package:dun_diary_app/core/network/api_state.dart';
import 'package:dun_diary_app/core/network/network_info.dart';
import 'package:dun_diary_app/feature/home/data/repository/user_repository.dart';
import 'package:dun_diary_app/feature/home/presentation/home_viewModel.dart';
import 'package:dun_diary_app/core/auth/auth_service.dart';
import 'package:dun_diary_app/feature/record/data/repository/record_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) => HomeViewmodel(
        repo: context.read<UserRepository>(),
        recordRepo: context.read<RecordRepository>(),
        networkInfo: context.read<NetworkInfo>(),
        authService: context.read<AuthService>(),
      ),
      child: const Home(),
    );
  }

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<HomeViewmodel>().fetchUser());
  }

  @override
  Widget build(BuildContext context) {
    final uiState = context.select((HomeViewmodel vm) => vm.state);
    final viewModel = context.read<HomeViewmodel>(); // เอาไว้กดปุ่ม

    return Scaffold(
      appBar: AppBar(
        title: const Text("Offline First App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_upload),
            onPressed: () =>
                viewModel.connectOnline()
          ),
        ],
      ),
      body: switch (uiState) {
        Initial() ||
        Loading() => const Center(child: CircularProgressIndicator()),

        Success(data: final users) => ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              title: Text(user.id.toString()),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Title: ${user.title}'),
                  Text('Owner ID: ${user.ownerId}'),
                  Text('Image: ${user.image}'),
                  Text('Profile: ${user.profile}'),
                  Text('Is Synced: ${user.isSynced}'),
                ],
              ),
            );
          },
        ),

        Error(message: final msg) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.red, size: 50),
              Text(msg),
            ],
          ),
        ),
      },
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          viewModel.addNewUser("BP Record ${DateTime.now().second}");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

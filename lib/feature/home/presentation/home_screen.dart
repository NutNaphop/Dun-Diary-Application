import 'package:dun_diary_app/core/network/api_state.dart';
import 'package:dun_diary_app/feature/home/data/repository/user_repository.dart';
import 'package:dun_diary_app/feature/home/presentation/home_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) => HomeViewmodel(
        repository: context.read<UserRepository>(),
      ),
      child: const HomeScreen(),
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<HomeViewmodel>().fetchUser());
    Future.microtask(() => context.read<HomeViewmodel>().syncPendingData());
  }

  @override
  Widget build(BuildContext context) {
    final uiState = context.select((HomeViewmodel vm) => vm.state);
    final viewModel = context.read<HomeViewmodel>(); // เอาไว้กดปุ่ม

    return Scaffold(
      appBar: AppBar(title: const Text("User List")),
      body: switch (uiState) {
        Initial() ||
        Loading() => const Center(child: CircularProgressIndicator()),

        Success(data: final users) => ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              title: Text(user.id.toString()),
              subtitle: Text(user.title),
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
          viewModel.addNewUser("New User", "image_url");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

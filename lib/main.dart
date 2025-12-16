import 'package:dun_diary_app/core/network/api_state.dart';
import 'package:dun_diary_app/feature/home/presentation/home_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(MultiProvider(providers: [ChangeNotifierProvider(create: (_) => HomeViewmodel())], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: ChangeNotifierProvider(
        create: (_) => HomeViewmodel(),
        child: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  @override
  void initState() {
    super.initState();
    Future.microtask(() => 
      context.read<HomeViewmodel>().fetchUser()
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewmodel>();
    final uiState = viewModel.state; 


    return Scaffold(
      appBar: AppBar(title: const Text("User List")),
      body: switch (uiState) {
            
            Initial() || Loading() => const Center(
              child: CircularProgressIndicator()
            ),

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
                  ElevatedButton(
                    onPressed: () => viewModel.fetchUser(), 
                    child: const Text("ลองใหม่"),
                  )
                ],
              ),
            ),
          } 
      );
  }
}


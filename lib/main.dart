import 'package:cepper/app/views/cep_view.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
          appBar: AppBar(
            title: const Text("CEPPER"),
          ),
          body: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CepView(),
          )),
    );
  }
}

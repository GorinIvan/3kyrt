import 'package:flutter/material.dart';
import 'locator.dart';
import 'ui/zoo_shop_page.dart'; // <--- ОБРАТИ ВНИМАНИЕ НА ЭТУ СТРОКУ

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zoo Shop',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
      home: const ZooShopPage(),
    );
  }
}
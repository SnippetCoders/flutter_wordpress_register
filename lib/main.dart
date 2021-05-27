import 'package:flutter/material.dart';
import 'package:flutter_wordpress_register/register_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wordpress Register',
      debugShowCheckedModeBanner: false,
      home: UserRegister(),
    );
  }
}

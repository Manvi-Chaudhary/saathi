import 'package:flutter/material.dart';
import 'package:saathi/services/AuthService.dart';
import 'package:saathi/services/Dataservice.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: TextButton(
          onPressed: (){
            Authservice().signout();
          },
          child: Text("sign out"),
        ),
      ),
    );
  }
}

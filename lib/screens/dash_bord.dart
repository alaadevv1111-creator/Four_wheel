import 'package:flutter/material.dart';
import 'package:four_wheels/screens/login_screen.dart';
import 'package:four_wheels/screens/splash_screen.dart';
import 'package:four_wheels/services/AuthService.dart';

class DashbordScreen extends StatefulWidget {
  DashbordScreen({super.key});

  @override
  State<DashbordScreen> createState() => _DashbordScreenState();

}

  class _DashbordScreenState extends State<DashbordScreen>{
  int current=0;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("data"),
        actions: [
          IconButton(onPressed: ()async{
            final reslut = await AuthService.logout();
            if(reslut['success']==true){
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(),
                  ),
                  (route)=> false,
              );
            }else{
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(reslut['message'])),
              );
            }
          }, icon: const Icon(Icons.logout)),

        ],
      ),

    );
  }
}
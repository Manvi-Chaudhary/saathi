import 'package:flutter/material.dart';
import 'package:saathi/Authentication/LogIn.dart';
import 'package:saathi/PersonalChecklist.dart';
import 'package:saathi/SharedChecklist.dart';
import 'package:saathi/services/AuthService.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {

  String? email;
  String? username;
  String? password;

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(225,225,225,1),
      body: (isLoading) ? Center(child: CircularProgressIndicator()):Container(
        width: w,
        height: h,
        padding: EdgeInsets.symmetric(horizontal: 50,vertical: 20),
        child: Column(
          children: [
            SizedBox(height: 80,),
            Icon(Icons.lock_open_rounded,size: 100,color: Color.fromRGBO(159,159,159,1),),
            SizedBox(height: 40,),
            Text("Let's Create an account for you",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15, color: Color.fromRGBO(159,159,159,1)),),
            SizedBox(height: 20,),
            SizedBox(
              width: w*0.7,
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Color.fromRGBO(239,239,239,1),
                    contentPadding: EdgeInsets.only(left: 10),
                    hintText: "Email",
                    hintStyle: TextStyle(color: Color.fromRGBO(198,198,198,1))
                ),
                onChanged: (value){
                  email=value;
                },
              ),
            ),
            SizedBox(height: 10,),
            SizedBox(
              width: w*0.7,
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Color.fromRGBO(239,239,239,1),
                    contentPadding: EdgeInsets.only(left: 10),
                    hintText: "Username",
                    hintStyle: TextStyle(color: Color.fromRGBO(198,198,198,1))
                ),
                onChanged: (value){
                  username=value;
                },
              ),
            ),
            SizedBox(height: 10,),
            SizedBox(
              width: w*0.7,
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Color.fromRGBO(239,239,239,1),
                    contentPadding: EdgeInsets.only(left: 10),
                    hintText: "Password",
                    hintStyle: TextStyle(color: Color.fromRGBO(198,198,198,1))
                ),
                onChanged: (value){
                  password=value;
                },
              ),
            ),
            SizedBox(height: 30,),
            Container(
                width: w*0.7,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromRGBO(239,239,239,1),
                ),
                child: TextButton(
                  child: Text("Sign Up",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Color.fromRGBO(90,90,90,1)),),
                  onPressed: () async {
                    if(username!=null && email!=null){
                      if(username!.length>0 && email!.length>0){
                        if(password!=null){
                          if(password!.length>=6){
                            setState(() {
                              isLoading=true;
                            });
                            dynamic res=await Authservice().signup(email, username, password);
                            if(res==null){
                              setState(() {
                                isLoading=false;
                              });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Enter valid credentials",style: TextStyle(color: Colors.white),),backgroundColor: Colors.redAccent,));

                            }else{
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> PersonalChecklist()));

                            }
                          }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password length should be 6 characters long",style: TextStyle(color: Colors.white),),backgroundColor: Colors.redAccent,));
                          }
                        }
                      }
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Enter valid credentials",style: TextStyle(color: Colors.white),),backgroundColor: Colors.redAccent,));
                    }

                  },
                )
            ),

            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already a member ? ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10, color: Color.fromRGBO(159,159,159,1))),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                }, child: Text("Login Now ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10, color: Color.fromRGBO(90,90,90,1)))),
              ],
            )

          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saathi/SharedChecklist.dart';
import 'package:saathi/model/CheckModel.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:saathi/services/Dataservice.dart';
import 'services/AuthService.dart';

class PersonalChecklist extends StatefulWidget {
  const PersonalChecklist({super.key});

  @override
  State<PersonalChecklist> createState() => _PersonalChecklistState();
}

class _PersonalChecklistState extends State<PersonalChecklist> {
  bool isCheck = false ;

  Box? checklist;
  String title="";

  void initState(){
    super.initState();
    Hive.openBox("Checklist").then((value) {
      setState(() {
        print(value.keys);
        checklist=value;
      });
    });
  }

   int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var h= MediaQuery.of(context).size.height;
    var w= MediaQuery.of(context).size.width;
    final user = Provider.of<String?>(context);
    //var data=[CheckModel(task: "Do laundary", isComplete: false),CheckModel(task: "Do Homework", isComplete: false)];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:Color.fromRGBO(225,225,225,1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(225,225,225,1),
        actions: [
          IconButton(onPressed: (){
            Authservice().signout();
          }, icon: Icon(Icons.logout,color: Color.fromRGBO(121,122,122,1),)),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> SharedChecklist()));
          }, icon: Icon(Icons.share,color: Color.fromRGBO(121,122,122,1),))
        ],
      ),

      body:  (checklist==null) ? Container() : ValueListenableBuilder(
    valueListenable: checklist!.listenable(),
    builder: (context,box,widget){
    var data=box.keys.toList();
    return Container(
    height: h,
    width: w,
    padding: EdgeInsets.symmetric(horizontal: 30),
    child: Column(

    children: [
      
    Text("My Checklist",textAlign: TextAlign.left,style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,fontStyle : FontStyle.italic,color: Color.fromRGBO(68,69,69,1)),),
    SizedBox(height: 20,),
    SizedBox(
    height: h*0.8,
    child: ListView.separated(itemBuilder: (context,index){
    Map curr = checklist!.get(data[index]);

    return ListTile(
    tileColor: Color.fromRGBO(239,239,239,1),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10)
    ),
    title: Text(curr['task'],style: TextStyle(color: Color.fromRGBO(133,133,133,1),fontSize: 18,fontWeight: FontWeight.w500)),
    trailing: Checkbox(
    value: curr['isDone'],
    activeColor: Color.fromRGBO(68,69,69,1),
    onChanged: (value) async {
    curr['isDone'] =value;
    await checklist!.put(data[index], curr);
    },
    ),

    contentPadding: EdgeInsets.only(left: 15),
    );
    },

    separatorBuilder: (context,index){
    return SizedBox(height: 10,);
    },
    itemCount: data.length),
    ),])
    );
    },
    ),

    floatingActionButton: FloatingActionButton(
    backgroundColor: Color.fromRGBO(239,239,239,1),
    shape: CircleBorder(),
    child: Icon(Icons.add,color: Color.fromRGBO(121,122,122,1),),
    onPressed: (){
    showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
    backgroundColor: Color.fromRGBO(225,225,225,1),

    title: const Text('Add a task',style: TextStyle(color: Color.fromRGBO(68,69,69,1),fontSize: 18,fontWeight: FontWeight.w500)),
    content: TextField(onChanged: (value){
    setState(() {
    title=value;
    });
    },),
    actions: <Widget>[
    TextButton(
    onPressed: () => Navigator.pop(context, 'Cancel'),
    child: const Text('Cancel',style: TextStyle(color: Color.fromRGBO(68,69,69,1),fontSize: 18,fontWeight: FontWeight.w500)),
    ),
    TextButton(
    onPressed: () {
    if(title!=""){
    try{
    checklist!.add({
    'task': title.toString(),
    'isDone': false,
    'time': DateTime.now().toIso8601String()
    });
    print("gg");
    }catch(e){
    print("error"+e.toString());
    }

    }
    print("hii");
    //print(checklist!.length);
    Navigator.pop(context, 'OK');
    },
    child: const Text('OK',style: TextStyle(color: Color.fromRGBO(68,69,69,1),fontSize: 18,fontWeight: FontWeight.w500)),
    ),
    ],
    ),
    );
    }

      ),
    );
  }
}




import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saathi/PersonalChecklist.dart';
import 'package:saathi/model/CheckModel.dart';
import 'package:saathi/services/Dataservice.dart';
import 'services/AuthService.dart';
class SharedChecklist extends StatefulWidget {




  SharedChecklist({super.key});

  @override
  State<SharedChecklist> createState() => _SharedChecklistState();
}

class _SharedChecklistState extends State<SharedChecklist> {

  bool isCheck = false ;

  String title="";
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
              Navigator.push(context, MaterialPageRoute(builder: (context)=> PersonalChecklist()));
            }, icon: Icon(Icons.person_pin,color: Color.fromRGBO(121,122,122,1),))]
      ),
      body: StreamBuilder<List<CheckModel>>(
        stream : Dataservice(uid: user!).getChecklist(),
        builder: (context,snapshot){
          var data= snapshot.data;

          return (data==null) ? Container() : Container(
              height: h,
              width: w,
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(

                  children: [
                    Text("Shared Checklist",textAlign: TextAlign.left,style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,fontStyle : FontStyle.italic,color: Color.fromRGBO(68,69,69,1)),),
                    SizedBox(height: 20,),
                    SizedBox(
                      height: h*0.8,
                      child: ListView.separated(itemBuilder: (context,index){
                        CheckModel curr = data![index];

                        return ListTile(
                          tileColor: Color.fromRGBO(239,239,239,1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          title: Text(curr.task,style: TextStyle(color: Color.fromRGBO(133,133,133,1),fontSize: 18,fontWeight: FontWeight.w500)),
                          trailing: Checkbox(
                            value: curr.isComplete,
                            activeColor: Color.fromRGBO(68,69,69,1),
                            onChanged: (value) async {
                              curr.isComplete = value!;
                              await Dataservice(uid: user!).update(curr, curr.did!);
                            },
                          ),

                          contentPadding: EdgeInsets.only(left: 15,right: 10),
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
                  onPressed: ()  async {
                    if(title!=""){
                      try{
                        CheckModel task=CheckModel(task: title, isComplete: false);
                        await Dataservice(uid: user!).add(task);
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
        },
      ),
    );
  }
}

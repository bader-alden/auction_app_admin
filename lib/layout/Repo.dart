import 'package:auction_app_admin/utils/dio.dart';
import 'package:flutter/material.dart';
List repo_list=[];
class Repo extends StatefulWidget {
  const Repo({Key? key}) : super(key: key);

  @override
  State<Repo> createState() => _RepoState();
}

class _RepoState extends State<Repo> {
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dio.post_data(url:"/dash/select",quary: {
      "table":"complains",
      "sql":" * "
    }).then((value) {
      repo_list=[];
      print(value?.data);
      repo_list = value?.data;
      setState(() {});
      // value?.data.forEach((element){
      //   repo_list.add(auction_model.fromjson(element));
      //   if(repo_list.length == value.data.length ){
      //     print(repo_list[0].name);
      //     print(repo_list[1].name);
      //     setState(() {});
      //   }
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
   if(repo_list.isNotEmpty){
     return Column(
       children: [
         Center(child: Text("الشكاوي"),),
         SizedBox(height: 50,),
         Expanded(child: ListView.separated(itemBuilder: (context,index){
           return Row(
             children: [
               Text(repo_list[index]["title"]),
               SizedBox(width: 50,),
               ElevatedButton(onPressed: (){
                 showDialog<void>(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return AlertDialog(
                                    title: Text('تفاصيل'),
                                    content: Column(
                                      children: [
                                        Text("الرقم"),
                                        Text(repo_list[index]["number"]),
                                        SizedBox(height: 30,),
                                        Text("العنوان"),
                                        Text(repo_list[index]["title"]),
                                        SizedBox(height:30,),
                                        Text("التفاصيل"),
                                        Text(repo_list[index]["text"]),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('موافق'),
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }, child: Text("التفاصيل")),
               SizedBox(width: 30,),
               ElevatedButton(onPressed: (){
                 showDialog<void>(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return AlertDialog(
                                    title: Text('هل أنت متأكد'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('لا'),
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                                        },
                                      ),
                                      TextButton(
                                        child: Text('تعم'),
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop();
                                          dio.post_data(url:"/dash/delet_id",quary: {
                                            "table":"complains",
                                            "id":repo_list[index]["id"].toString(),
                                          }).then((value) {
                                            print(value?.data);
                                            dio.post_data(url:"/dash/select",quary: {
                                              "table":"complains",
                                              "sql":" * "
                                            }).then((value) {
                                              repo_list=[];
                                              print(value?.data);
                                              repo_list = value?.data;
                                              setState(() {});
                                              // value?.data.forEach((element){
                                              //   repo_list.add(auction_model.fromjson(element));
                                              //   if(repo_list.length == value.data.length ){
                                              //     print(repo_list[0].name);
                                              //     print(repo_list[1].name);
                                              //     setState(() {});
                                              //   }
                                              // });
                                            });
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }, child: Text("حذف"))
             ],
           );
         }, separatorBuilder: (context,index){
           return Column(
             children: [
               SizedBox(height: 20,),
               Container(color: Colors.grey,height: 2,),
               SizedBox(height: 20,),
             ],
           );
         }, itemCount: repo_list.length))
       ],
     );
   }else {
     return Container(
      color: Colors.white,
      child: const Center(
        child: Text(
          'Repo',
          style: TextStyle(fontSize: 35),
        ),
      ),
    );
   }
  }
}

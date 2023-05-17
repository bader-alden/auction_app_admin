import 'package:auction_app_admin/utils/dio.dart';
import 'package:flutter/material.dart';

import '../model/auction_model.dart';
import 'auction_details_screen.dart';
List<auction_model> auction_list_type=[];
bool auc_details_delete_loading=false;
class Auction_type_details extends StatefulWidget {
  const Auction_type_details({Key? key, this.type, this.names}) : super(key: key);
final type;
final names;
  @override
  State<Auction_type_details> createState() => _Auction_type_detailsState(type,names);
}

class _Auction_type_detailsState extends State<Auction_type_details> {
  final type;
  final names;

  _Auction_type_detailsState(this.type, this.names);
  @override
  void initState() {
    // TODO: implement initState
    dio.post_data(url: "/dash/select",quary: {
      "table":type,
      "sql":" * "
    }).then((value) {
      print(value?.data);
      value?.data.forEach((element) {
        auction_list_type.add(auction_model.fromjson(element));
        if(auction_list_type.length==value.data.length){
          setState(() {});
        }
      });
    });
  }
  @override
  void dispose() {
    super.dispose();
    auction_list_type.clear();
    auc_details_delete_loading=false;
  }
  @override
  Widget build(BuildContext context) {
    if(auction_list_type.isNotEmpty){
      return auction_list_widget(context,names,setState,type);
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
          auc_details_delete_loading=false;
          auction_list_type.clear();
        },icon: Icon(Icons.arrow_back_ios_new,color: Colors.black,)),
        backgroundColor: Colors.white,
        title: Text("تفاصيل",style: TextStyle(color: Colors.black),),
      ),
      body: Container(
        color: Colors.white,
        child:  Center(
          child: Text(
            type,
            style: TextStyle(fontSize: 35),
          ),
        ),
      ),
    );
  }
}
Widget auction_list_widget (context,names,setstate,type){
  return Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
          auc_details_delete_loading=false;
          auction_list_type.clear();
        },icon: Icon(Icons.arrow_back_ios_new,color: Colors.black,)),
        backgroundColor: Colors.white,
        title: Text("تفاصيل",style: TextStyle(color: Colors.black),),
      ),
      body: Column(
        children: [
          Expanded(child:
          ListView.builder(
              itemCount: auction_list_type.length,
              itemBuilder: (context,index){
                return auction_list_element(context,auction_list_type[index],names,setstate,type);
              }))
        ],
      ),
    ),
  );
}

Widget auction_list_element(context, auction_model model,names,setstate,type) {
  return Column(
    children: [
      SizedBox(
        height: 75,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            SizedBox(width:200,child: Image.network(model.photo!,height: 150,)),
            SizedBox(width: 20,),
            Center(child: Text("الاسم:",style: TextStyle(fontSize: 20))),
            SizedBox(width: 5,),
            Center(child: Text(model.name!,style: TextStyle(fontSize: 20))),
            SizedBox(width: 20,),
            Center(child: Text("الرقم التسلسلي:",style: TextStyle(fontSize: 20))),
            SizedBox(width: 5,),
            Center(child: Text(model.id!,style: TextStyle(fontSize: 20))),
            SizedBox(width: 20,),
            Center(child: Text("الرقم التسلسلي لصاحب المزاد:",style: TextStyle(fontSize: 20))),
            SizedBox(width: 6,),
            Center(child: Text(model.user_id!,style: TextStyle(fontSize: 20))),
            SizedBox(width: 20,),
            Center(child: Text("وقث الانتهاء:",style: TextStyle(fontSize: 20))),
            SizedBox(width: 5,),
            Center(child: Text(model.time!,style: TextStyle(fontSize: 20))),
            //Spacer(),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>auction_details_screen(model:model,type: names,)));
            }, child: Text("تفاصيل المزاد")),
            SizedBox(width: 30,),
            ElevatedButton(onPressed: (){
                setstate((){
                  auc_details_delete_loading=true;
                });
                dio.post_data(url:"/dash/delet_id",quary:{
                  "table":type,
                  "id":model.id
                } ).then((value) {
                  print(value?.data);
                  dio.post_data(url: "/dash/select",quary: {
                    "table":type,
                    "sql":" * "
                  }).then((value) {
                    print(value?.data);
                    auction_list_type.clear();
                    value?.data.forEach((element) {
                      auction_list_type.add(auction_model.fromjson(element));
                      if(auction_list_type.length==value.data.length){
                        setstate(() {
                          auc_details_delete_loading=false;
                        });
                      }
                    });
                  });
                });
            }, child: auc_details_delete_loading?CircularProgressIndicator(color: Colors.white,):Text("حذف المزاد")),
            SizedBox(width: 60,),
          ],
        ),
      ),
      SizedBox(height: 10,)
    ],
  );
}

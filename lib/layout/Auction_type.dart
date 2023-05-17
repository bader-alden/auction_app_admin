import 'package:auction_app_admin/model/auction_type_model.dart';
import 'package:auction_app_admin/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:auction_app_admin/utils/dio.dart';

import 'auction_typr_details.dart';
List<auction_type_model> auction_type_list=[];
class Auction_type extends StatefulWidget {
  const Auction_type({Key? key}) : super(key: key);

  @override
  State<Auction_type> createState() => _Auction_typeState();
}

class _Auction_typeState extends State<Auction_type> {
  @override
  void initState() {
    // TODO: implement initState
      super.initState();
      auction_type_list.clear();
      dio.post_data(url:"/dash/select",quary: {
        "table":"mains",
        "sql":" * "
      }).then((value) {
        value?.data.forEach((element){
          auction_type_list?.add(auction_type_model.fromjson(element));
          if(auction_type_list?.length == value.data.length ){
            setState(() {});
          }
        });
      });
  }
  @override
  Widget build(BuildContext context) {
    if(auction_type_list!.isNotEmpty){
      return Scaffold(
        body: Column(
          children: [
            SizedBox(height: 20,),
            Row(
              children: [
                SizedBox(width: 20,),
                Center(child: Text("انواع المزادات",style: TextStyle(fontSize: 30)),),
              ],
            ),
            SizedBox(height: 20,),
            auction_type_widget_arrch(context, setState),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context,index){
                    return  auction_type_widget(context,auction_type_list[index],setState);
                  }, itemCount: auction_type_list.length),
            )
          ],
        ),
      );
    }else {
      return Container(
      color: Colors.white,
      child: const Center(
        child: Text(
          'Auction_type',
          style: TextStyle(fontSize: 35),
        ),
      ),
    );
    }
  }
}
Widget auction_type_widget(BuildContext context,auction_type_model model,setstate){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Auction_type_details(type: model.type,names:model.ar_name)));
      },
      child: Container(
        child: Row(
            children:
            [
              Container(
                  height: 100,
                  width: 50,
                  child: Image.network(base_url+"/file/${model.type!}.png",height: 50,width: 100,)),
              SizedBox(width: 20,),
              Container(
                  width: 200,
                  child: Center(child: Text(model.ar_name!,style: TextStyle(fontSize: 25),))),
              Icon(Icons.arrow_back_ios_new),
        ]
        ),
      ),
    ),
  );
}
Widget auction_type_widget_arrch(BuildContext context,setstate){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Auction_type_details(type: "archive",names:"الأرشيف")));
      },
      child: Container(
        child: Row(
            children:
            [
              Icon(Icons.archive_outlined,size: 50),
              SizedBox(width: 20,),
              Container(
                  width: 200,
                  child: Center(child: Text("الأرشيف",style: TextStyle(fontSize: 25),))),
              Icon(Icons.arrow_back_ios_new),
            ]
        ),
      ),
    ),
  );
}


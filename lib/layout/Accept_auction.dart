import 'package:auction_app_admin/model/auction_model.dart';
import 'package:auction_app_admin/utils/const.dart';
import 'package:auction_app_admin/utils/map.dart';
import 'package:flutter/material.dart';
import 'package:auction_app_admin/utils/dio.dart';
import 'package:auction_app_admin/model/user_model.dart';

import 'Users.dart';
List<auction_model> wait_auc_list =[];
bool is_wait_in_details=false;
auction_model? wait_detail;

String? accpet_auc_loading;
class Accept_auction extends StatefulWidget {
  const Accept_auction({Key? key}) : super(key: key);

  @override
  State<Accept_auction> createState() => _Accept_auctionState();
}

class _Accept_auctionState extends State<Accept_auction> {
  @override
  void initState() {
    super.initState();
    dio.post_data(url:"/dash/select",quary: {
      "table":"wait",
      "sql":" * "
    }).then((value) {
      wait_auc_list=[];
      print(value);
      value?.data.forEach((element){
        if(element['status']==0)wait_auc_list.add(auction_model.fromjson(element));
          setState(() {});
      });
    });
  }
  @override
  void dispose() {
    super.dispose();
    wait_auc_list.clear();
    is_wait_in_details=false;
    wait_detail=null;
  }
  @override
  Widget build(BuildContext context) {
    if(is_wait_in_details&& wait_detail!=null ){
      return wait_element_widget(context, wait_detail!,setState);
    }else
    if(wait_auc_list.isNotEmpty) {
      return Scaffold(
        body: Column(
          children: [
            SizedBox(height: 20,),
            Row(
              children: [
                SizedBox(width: 20,),
                Center(child: Text("قبول المزادات",style: TextStyle(fontSize: 30)),),
              ],
            ),
            SizedBox(height: 20,),
            Expanded(
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context,index){
                    return  auction_main_widget(context,wait_auc_list[index],setState);
                  }, separatorBuilder: (context,index){
                return Container(height: 2,width: double.infinity,color: Colors.grey.shade300,);
              }, itemCount: wait_auc_list.length),
            )
          ],
        ),
      );
    }else{
      return Container(
        color: Colors.white,
        child: const Center(
          child: Text(
            'Accpet auction',
            style: TextStyle(fontSize: 35),
          ),
        ),
      );
    }
  }
}

Widget auction_main_widget(BuildContext context,auction_model model,setstate){
  var con = ScrollController();
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: double.infinity,
      height: 52,
      child: Scrollbar(
        controller:con ,
        child: ListView(
            scrollDirection: Axis.horizontal,
            controller:con ,
            shrinkWrap: true,
            children:
            [
              Container(
                  height: 100,
                  width: 50,
                  child: Image.network(base_url+"/file/${model.type!}.png",height: 50,width: 100,)),
              SizedBox(width: 20,),
              Container(
                  width: 200,
                  child: Center(child: Text(model.name!,style: TextStyle(fontSize: 25),))),
              SizedBox(width: MediaQuery.of(context).size.width/3,),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue.shade600)),
                        onPressed: (){
                          setstate((){
                            is_wait_in_details=true;
                            wait_detail=model;
                          });
                        }, child: Text("تفاصيل")),
                    SizedBox(width: 20,),
                    ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.green.shade600)),
                        onPressed: (){
                          setstate((){
                            accpet_auc_loading="2|${model.id!}";
                          });
                          dio.post_data(url: "/post_auction/accept",quary: {
                            "type":model.type,
                            "id":model.id,
                            "user_id":model.user_id,
                          }).then((value) {
                            setstate((){
                              accpet_auc_loading=null;
                              wait_auc_list.clear();
                            });
                            dio.post_data(url:"/dash/select",quary: {
                              "table":"wait",
                              "sql":" * "
                            }).then((value) {
                              print(value);
                              value?.data.forEach((element){
                                if(element['status']==0)wait_auc_list.add(auction_model.fromjson(element));
                                setstate(() {});
                              });
                            });
                          });
                          // dio.post_data(url: "/post_auction/confirm",quary: {
                          //   "type":model.type,
                          //   "id":model.id
                          // }).then((value) {
                          //   setstate((){
                          //     accpet_auc_loading=null;
                          //     wait_auc_list.clear();
                          //   });
                          //   dio.post_data(url:"/dash/select",quary: {
                          //     "table":"wait",
                          //     "sql":" * "
                          //   }).then((value) {
                          //     print(value);
                          //     value?.data.forEach((element){
                          //       wait_auc_list.add(auction_model.fromjson(element));
                          //       if(wait_auc_list.length == value.data.length ){
                          //         setstate(() {});
                          //       }
                          //     });
                          //   });
                          // });
                    }, child: "2" == accpet_auc_loading?.split("|")[0]&&model.id! ==accpet_auc_loading?.split("|")[1] ?Container(width: 20,height: 20,child: CircularProgressIndicator(color: Colors.white,)):Text("قبول")),
                    SizedBox(width: 20,),
                    ElevatedButton(
                        onPressed: (){
                          setstate((){
                            accpet_auc_loading="3|${model.id!}";
                          });
                          dio.post_data(url: "/post_auction/reject_dash",quary: {
                            "type":model.type,
                            "id":model.id,
                            "user_id":model.user_id,
                          }).then((value) {
                            setstate((){
                              accpet_auc_loading=null;
                              wait_auc_list.clear();
                            });
                            dio.post_data(url:"/dash/select",quary: {
                              "table":"wait",
                              "sql":" * "
                            }).then((value) {
                              print(value);
                              value?.data.forEach((element){
                                if(element['status']==0)wait_auc_list.add(auction_model.fromjson(element));
                                setstate(() {});
                              });
                            });
                          });
                        },
                         child: "3" == accpet_auc_loading?.split("|")[0]&&model.id! ==accpet_auc_loading?.split("|")[1] ?Container(width: 20,height: 20,child: CircularProgressIndicator(color: Colors.white,)):Text("رفض")),
                  ],
                ),
              ),
            ]
        ),
      ),
    ),
  );
}


Widget wait_element_widget(BuildContext context,auction_model model,setstate){
  return Scaffold(
    body: ListView(
      shrinkWrap: true,
      children: [
        SizedBox(height: 22,),
        Row(children: [
          IconButton(onPressed: (){
            setstate(() {
              is_wait_in_details=false;
              wait_detail=null;
            });
          }, icon: Icon(Icons.arrow_back_ios_new)),
          Spacer(),
          Text("تفاصيل المزاد",style: TextStyle(fontSize: 24),),
          Spacer(),
        ],),
        SizedBox(height: 22,),
        Container(width: double.infinity,height: 20),
        Container(
          height: 520,
        // color: Colors.grey.shade200,
          child: GridView(
            gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: MediaQuery.of(context).size.width<700 ?1:2,childAspectRatio: 8),
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Center(child: Text("الاسم: ${model?.name??"غيرمتوفر"}",style: TextStyle(fontSize: 24),)),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Center(child: Text("الرقم التسلسلي: ${model?.id??"غيرمتوفر"}",style: TextStyle(fontSize: 24),)),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Center(child: Text("السعر المبدئي: ${model?.price??"غيرمتوفر"}",style: TextStyle(fontSize: 24),)),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Center(child: Text("أقل مزايدة: ${ model.num_price??"غيرمتوفر"}",style: TextStyle(fontSize: 24),)),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Center(child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("رقم التسلسلي لصاحب المزاد: ${model?.user_id??"غيرمتوفر"}",style: TextStyle(fontSize: 24),),
                    SizedBox(width: 10,),
                    ElevatedButton(onPressed: (){
                      dio.post_data(url:"/dash/select_id",quary:{
                        "table":"users",
                        "sql": " * ",
                        "id":model?.user_id
                      } ).then((value) {
                        var user = user_models.fromjson(value?.data[0]);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Material(child: Directionality(textDirection: TextDirection.rtl,child: user_detail_widget(context, user, setstate)))));
                        print(value?.data);
                      });
                    }, child: Text("عرض"))
                  ],
                )),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Center(child: Text("المدينة المتواجدة بها: ${model?.city??"غيرمتوفر"}",style: TextStyle(fontSize: 24),)),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Center(child: Text("النوع: ${model?.type??"غيرمتوفر"}",style: TextStyle(fontSize: 24),)),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Center(child: Text("قسم: ${model?.kind??"غيرمتوفر"}",style: TextStyle(fontSize: 24),)),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Center(child: Text("عدد الأيام: ${model?.end_in??"غيرمتوفر"}",style: TextStyle(fontSize: 24),)),
              ),
              // Text("الاسم ${model?.id??"غيرمتوفر"}"),
              // Text("الاسم ${model?.email??"غيرمتوفر"}"),
              // Text("الاسم ${model?.email??"غيرمتوفر"}"),
            ],),
        ),
        Container(height: 2,width: double.infinity,color: Colors.grey.shade300,),
        SizedBox(height: 10,),
        Text("الوصف: "+"\n"+(model.des??"غير متوفر"),style: TextStyle(fontSize: 24),),
        SizedBox(height: 10,),
        Container(height: 2,width: double.infinity,color: Colors.grey.shade300,),
        if(model.text_1!=null)
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("${model.text_1?.name} : \n ${model?.text_1?.details??"غيرمتوفر"}",style: TextStyle(fontSize: 24),),
        ),
        if(model.text_1!=null)
        Container(height: 2,width: double.infinity,color: Colors.grey.shade300,),
        if(model.text_2!=null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("${model.text_2?.name} : \n ${model?.text_2?.details??"غيرمتوفر"}",style: TextStyle(fontSize: 24),),
          ),
        if(model.text_2!=null)
          Container(height: 2,width: double.infinity,color: Colors.grey.shade300,),
        if(model.text_3!=null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("${model.text_3?.name} : \n ${model?.text_3?.details??"غيرمتوفر"}",style: TextStyle(fontSize: 24),),
          ),
        if(model.text_3!=null)
          Container(height: 2,width: double.infinity,color: Colors.grey.shade300,),
        SizedBox(height: 20,),
        if(model!.main_data!.isNotEmpty)
          Text("التفاصيل الاساسية",style: TextStyle(fontSize: 24),),
        if(model!.main_data!.isNotEmpty)
          ...model!.main_data!.map((e) => Text(e.split("**")[0] + "  " +e.split("**")[1] ,style: TextStyle(fontSize: 24),)),
        SizedBox(height: 20,),
        if(model.location !=null )
          Text("الموقع:",style: TextStyle(fontSize: 24)),
        SizedBox(height: 20,),
        if(model.location !=null )
          Container(
            color: Colors.grey.shade200,
            height: 300,
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Map_screen(title: model.name,lat: model.location?[0],lan: model.location?[1],)));
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image(width: double.infinity,image: NetworkImage("https://media.istockphoto.com/id/1306807452/vector/map-city-vector-illustration.jpg?b=1&s=612x612&w=0&k=20&c=RBfRJ1UZ4D-2F1HVkeZ0SHVmPWqj3eS9batfcKiQzW4="),),
                  Icon(Icons.location_on_outlined,size: 50,color: Colors.black,)
                ],
              ),
            ),
          ),
        if(model.photo!=null)
          Container(height: 2,width: double.infinity,color: Colors.grey.shade300,),
        if(model.photo!=null)
          Image.network(model.photo!),
        if(model.photos!=null)
          Container(height: 2,width: double.infinity,color: Colors.grey.shade300,),
        if(model.photos![0]!="")
          Container(
            height: 250,
            child: PageView.builder(itemBuilder: (context,index){
              return Image.network(model.photos![index]);
            }),
          ),

        SizedBox(height: 100,),
      ],
    ),
  );
}

import 'package:auction_app_admin/model/auction_model.dart';
import 'package:auction_app_admin/utils/dio.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import '../utils/map.dart';
import '../model/user_model.dart';
import 'Users.dart';

auction_model? model;
class auction_details_screen extends StatefulWidget {
  const auction_details_screen({Key? key, this.model, this.type, this.is_redy, this.id}) : super(key: key);
final auction_model? model;
final type;
final id;
final is_redy;
  @override
  _auction_details_screenState createState() => _auction_details_screenState(model,type,is_redy,id);
}

class _auction_details_screenState extends State<auction_details_screen> {
  late  auction_model? model;
  final type;
  final is_ready;
  final id;

  _auction_details_screenState(this.model, this.type, this.is_ready, this.id);
@override
  void initState() {
    super.initState();
    if(is_ready!=null&&!is_ready){
      print(type);
      print(id);
      dio.post_data(url: "/dash/select_id",quary: {"table":type,"sql":" * ","id":id.toString()}).then((value) {
        print(value?.data);
        model=auction_model.fromjson(value?.data[0]);
        setState(() {

        });
      });
    }
  }
  @override
  Widget build(BuildContext context) {
  if(model!=null){
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Scaffold(
          body: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(height: 22,),
              Row(children: [
                IconButton(onPressed: (){
                    Navigator.pop(context);
                }, icon: Icon(Icons.arrow_back_ios_new)),
                Spacer(),
                Text("تفاصيل المزاد",style: TextStyle(fontSize: 24),),
                Spacer(),
              ],),
              SizedBox(height: 22,),
              Container(width: double.infinity,height: 20),
              Container(
                height: 600,
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
                      child: Center(child: Text("أقل مزايدة: ${ model?.num_price??"غيرمتوفر"}",style: TextStyle(fontSize: 24),)),
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
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> Material(child: Directionality(textDirection: TextDirection.rtl,child: user_detail_widget(context, user, setState)))));
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
                      child: Center(child: Text("النوع: ${type??"غيرمتوفر"}",style: TextStyle(fontSize: 24),)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Center(child: Text("قسم: ${model?.kind??"غيرمتوفر"}",style: TextStyle(fontSize: 24),)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Center(child: Text("عدد الأيام: ${model?.end_in??"غيرمتوفر"}",style: TextStyle(fontSize: 24),)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Center(child: Text("حالة السعر: ${(model?.is_hide??false)?"مخفي":"غير مخفي"}",style: TextStyle(fontSize: 24),)),
                    ),
                    // Text("الاسم ${model?.id??"غيرمتوفر"}"),
                    // Text("الاسم ${model?.email??"غيرمتوفر"}"),
                    // Text("الاسم ${model?.email??"غيرمتوفر"}"),
                  ],),
              ),
              Container(height: 2,width: double.infinity,color: Colors.grey.shade300,),
              SizedBox(height: 10,),
              Text("الوصف: "+"\n"+(model?.des??"غير متوفر"),style: TextStyle(fontSize: 24),),
              SizedBox(height: 10,),
              Container(height: 2,width: double.infinity,color: Colors.grey.shade300,),
              SizedBox(height: 20,),
              if(model!.main_data!.isNotEmpty)
                Text("التفاصيل الاساسية",style: TextStyle(fontSize: 24),),
              if(model!.main_data!.isNotEmpty)
                ...model!.main_data!.map((e) => Text(e.split("**")[0] + "  " +e.split("**")[1] ,style: TextStyle(fontSize: 24),)),
              SizedBox(height: 10,),
              Container(height: 2,width: double.infinity,color: Colors.grey.shade300,),
              SizedBox(height: 20,),
              Text("المعلومات الإضافية"),
              if(model?.text_1!=null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("${model?.text_1?.name} : \n ${model?.text_1?.details??"غيرمتوفر"}",style: TextStyle(fontSize: 24),),
                ),
              if(model?.text_1!=null)
                Container(height: 2,width: double.infinity,color: Colors.grey.shade300,),
              if(model?.text_2!=null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("${model?.text_2?.name} : \n ${model?.text_2?.details??"غيرمتوفر"}",style: TextStyle(fontSize: 24),),
                ),
              if(model?.text_2!=null)
                Container(height: 2,width: double.infinity,color: Colors.grey.shade300,),
              if(model?.text_3!=null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("${model?.text_3?.name} : \n ${model?.text_3?.details??"غيرمتوفر"}",style: TextStyle(fontSize: 24),),
                ),
              if(model?.text_1 ==null&&model?.text_2 ==null&&model?.text_3 ==null)Text("لايوجد معلومات"),
             SizedBox(height: 10,),
              Container(height: 2,width: double.infinity,color: Colors.grey.shade300,),
              SizedBox(height: 20,),
              Text("الملفات الإضافية"),
              if(model?.file_1 !=null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(model!.file_1!.name!,style: TextStyle(fontSize: 22)),
                      SizedBox(width: 50,),
                      ElevatedButton(onPressed: (){
                        html.window.open(model!.file_1!.link!,"_blank");
                      }, child: Text("عرض")),
                    ],
                  ),
                ),
              if(model?.file_2 !=null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(model!.file_2!.name!,style: TextStyle(fontSize: 22)),
                      SizedBox(width: 50,),
                      ElevatedButton(onPressed: (){
                        html.window.open(model!.file_2!.link!,"_blank");
                      }, child: Text("عرض")),
                    ],
                  ),
                ),
              if(model?.file_3 !=null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(model!.file_3!.name!,style: TextStyle(fontSize: 22)),
                      SizedBox(width: 50,),
                      ElevatedButton(onPressed: (){
                        html.window.open(model!.file_3!.link!,"_blank");
                      }, child: Text("عرض")),
                    ],
                  ),
                ),
              if(model?.file_1 ==null&&model?.file_2 ==null&&model?.file_3 ==null)Text("لايوجد ملفات"),
              SizedBox(height: 10,),
              Container(height: 2,width: double.infinity,color: Colors.grey.shade300,),
              SizedBox(height: 20,),
              if(model!.sub!.isNotEmpty)
                Text("المزايدون بالترتيب",style: TextStyle(fontSize: 24),),
              if(model!.sub!.isNotEmpty&&model!.sub!=[])
                for (var a in model!.sub??[])
                  if(a!=""&&a!=null&&a!=" ")
                  SizedBox(
                    height: 30,
                    child: Row(
                      children: [
                        Text("الترتيب"),
                        SizedBox(width: 10,),
                        Text((model!.sub!.indexOf(a)+1).toString()),
                        SizedBox(width: 20,),
                        Text("المستخدم"),
                        SizedBox(width: 10,),
                        Text(a.toString().split("-")[1].split("|")[0]),
                        SizedBox(width: 20,),
                        Text("دفع"),
                        SizedBox(width: 20,),
                        Text(a.toString().split("-")[1].split("|")[1]),
                        SizedBox(width: 20,),
                        ElevatedButton(onPressed: (){
                          dio.post_data(url:"/dash/select_id",quary:{
                            "table":"users",
                            "sql": " * ",
                            "id":a.toString().split("-")[1].split("|")[0]
                          } ).then((value) {
                            var user = user_models.fromjson(value?.data[0]);
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> Material(child: Directionality(textDirection: TextDirection.rtl,child: user_detail_widget(context, user, setState)))));
                            print(value?.data);
                          });
                        }, child: Text("عرض الصفحة الشخصية")),
                      ],
                    ),
                  ),
              if(model?.sub?[0]==" ") Text("لم يشارك أحد بعد"),
              SizedBox(height: 10,),
              Container(height: 2,width: double.infinity,color: Colors.grey.shade300,),
              SizedBox(height: 20,),
              if(model!.log!.isNotEmpty)
                Text("سجل المزايدة",style: TextStyle(fontSize: 24),),
              if(model!.log!.isNotEmpty&&model!.log!=[])
                for (var a in model!.log??[])
                  if(a!=""&&a!=null&&a!=" ")
                    SizedBox(
                      height: 30,
                      child: Row(
                        children: [
                          SizedBox(width: 20,),
                          Text("المستخدم"),
                          SizedBox(width: 10,),
                          Text(a.split("|")[0]),
                          SizedBox(width: 20,),
                          Text("دفع"),
                          SizedBox(width: 20,),
                          Text(a.split("|")[1]),
                        ],
                      ),
                    ),
              if(model?.log?[0]==" ") Text("لم يشارك أحد بعد"),
              SizedBox(height: 10,),
              Container(height: 2,width: double.infinity,color: Colors.grey.shade300,),
              SizedBox(height: 20,),
              if(model?.location !=null )
                Column(
                  children: [
                    Text("الموقع:",style: TextStyle(fontSize: 24)),
                    SizedBox(height: 20,),
                    Container(
                    //  color: Colors.grey.shade200,
                      height: 300,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Map_screen(title: model?.name,lat: model?.location?[0],lan: model?.location?[1],)));
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
                    SizedBox(height: 20,),
                  ],
                ),
              if(model?.photo!=null)
                Column(
                  children: [
                    Container(height: 2,width: double.infinity,color: Colors.grey.shade300,),
                    SizedBox(height: 20,),
                    Image.network(model!.photo!,height: 350,),
                    SizedBox(height: 20,)
                  ],
                ),
              if(model?.photos!=null)
                Container(height: 2,width: double.infinity,color: Colors.grey.shade300,),
              if(model?.photos![0]!="")
                Container(
                  height: 250,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                      itemCount: model!.photos?.length,
                      itemBuilder: (context,index){
                    return Image.network(model!.photos![index],);
                  }),
                ),

              SizedBox(height: 5,),
            ],
          ),
        ),
      ),
    );
  }else{
  return Scaffold(
    body:Center(child: CircularProgressIndicator(),),
  );
  }
}}

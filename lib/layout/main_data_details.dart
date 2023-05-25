import 'dart:convert';
import 'dart:html'as html;
import 'dart:html';
import 'package:universal_io/io.dart';
import 'package:auction_app_admin/model/serach_tag_model.dart';
import 'package:auction_app_admin/utils/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Uint8List, rootBundle;
import 'package:csv/csv.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:cross_file/cross_file.dart';

import '../model/auction_type_model.dart';

List<serach_tag_model> serach_tag_list = [];
class main_data_details extends StatefulWidget {
  const main_data_details({Key? key, required this.list, this.main, this.id, required this.index}) : super(key: key);
  final List list ;
  final List<all_kind_model>? main ;
  final String? id ;
  final int index ;
  @override
  State<main_data_details> createState() => _main_data_detailsState(list,main,id,index);
}

class _main_data_detailsState extends State<main_data_details> {
  final List list ;
  final List<all_kind_model>? main ;
  final String? id ;
  final int main_index ;
  _main_data_detailsState(this.list, this.main, this.id, this.main_index);

  @override
  void initState() {
    super.initState();
    //rprint(main_id.)
    serach_tag_list.clear();
    try {
      list.forEach((element) async {
        await dio.get_data(url: "/account/serach_tag", quary: {"id": element}).then((value) {
          print(value?.data[0]);
          try {
            serach_tag_list.add(serach_tag_model.fromjson(value?.data[0]));
          } catch (e) {
            print(e);
            serach_tag_list.add(serach_tag_model.fromjson(value?.data));
          } finally {
            if (serach_tag_list.length == list.length) {
              setState(() {
                print(serach_tag_list);
              });
            }
          }
        });
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        print(serach_tag_list);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: serach_tag_list.isEmpty
        ?Center(child: CircularProgressIndicator(),)
        :Column(
        children: [
        Row(
          children: [
            SizedBox(width: 25,),
            ElevatedButton(onPressed: (){
              var name_con = TextEditingController();
              showDialog(context: context, builder: (context)=>AlertDialog(
                title: Column(children: [
                  Text("إضافة"),
                  TextFormField(controller: name_con,)
                ],),
                actions: [
                  TextButton(onPressed: (){
                    dio.post_data(url: "/dash/insert_tag", quary: {
                      "table": " serach ",
                      "sql_key": " name  ",
                      "sql_value": "'${name_con.text}'"
                    }).then((value) {
                      var new_id = value?.data[0]["id"].toString();
                      print(main![main_index].main_date!);
                      var ad = main![main_index].main_date?.split("^");
                      ad?.add(new_id!);
                      var a = "${main![main_index].kind!}|${main![main_index].img!}|${main![main_index].time!}|${ad?.join("^")}";
                      main?.removeAt(main_index);
                      main?.insert(main_index, all_kind_model.fromjson(a));
                      var s =[];
                      main?.forEach((element) {
                        s.add("${element.kind!}|${element.img!}|${element.time!}|${element.main_date!}");
                      });
                      print(s.join("*"));
                      serach_tag_list.add(serach_tag_model.fromjson({"id":new_id,"name":name_con.text,"tag":""}));
                      setState(() {});
                      dio.post_data(
                          url: "/dash/update_id",
                          quary: {
                            "table": " mains ",
                            "sql_key":
                            " all_kind = '${s.join("*")}' ",
                            "id": id
                          });
                    });
                    Navigator.pop(context);}, child: Text("موافق")),
                  TextButton(onPressed: (){Navigator.pop(context);}, child: Text("لا"))
                ],
              ));
            }, child: Text("إضافة")),
            Spacer(),
            Text("المعلومات الاساسية "),
            Spacer(),
            IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back)),
            SizedBox(width: 25,),
          ],
        ),
        Expanded(
          child: ListView.separated(
              itemCount: serach_tag_list.length,
              itemBuilder: (context,index){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Spacer(),
                      ElevatedButton(onPressed: (){
                        print(main![main_index].main_date!);
                        var ad = main![main_index].main_date?.split("^");
                        ad?.removeWhere((element) => element == serach_tag_list[index].id);
                        var a = "${main![main_index].kind!}|${main![main_index].img!}|${main![main_index].time!}|${ad?.join("^")}";
                        main?.removeAt(main_index);
                        main?.insert(main_index, all_kind_model.fromjson(a));
                        var s =[];
                        main?.forEach((element) {
                          s.add("${element.kind!}|${element.img!}|${element.time!}|${element.main_date!}");
                        });
                        print(s.join("*"));
                        serach_tag_list.removeAt(index);
                        setState(() {

                        });
                        dio.post_data(
                            url: "/dash/update_id",
                            quary: {
                              "table": " mains ",
                              "sql_key":
                              " all_kind = '${s.join("*")}' ",
                              "id": id
                            }).then((value) {
                          dio.post_data(url: "/dash/delet_id", quary: {
                            "table": " city ",
                            "id": serach_tag_list[index].id,
                          });
                        });
                      }, child: Text("حذف")),
                      SizedBox(width: 25,),
                      ElevatedButton(onPressed: (){
                        var con = TextEditingController(text: serach_tag_list[index].name);
                        showDialog(context: context, builder: (context)=>AlertDialog(
                          title: Column(
                            children: [
                              Text("تعديل"),
                              TextFormField(
                                controller: con,
                              )
                            ],
                          ),
                          actions: [
                            TextButton(onPressed: (){
                              serach_tag_list[index].name = con.text;
                              dio.post_data(
                                  url: "/dash/update_id",
                                  quary: {
                                    "table": " serach ",
                                    "sql_key":
                                    " name = '${con.text}' ",
                                    "id": serach_tag_list[index].id
                                  });
                              setState(() {

                              });
                              Navigator.pop(context);}, child: Text("نعم")),
                            TextButton(onPressed: (){Navigator.pop(context);}, child: Text("إلغاء")),
                          ],
                        ));
                      }, child: Text("تعديل الاسم")),
                      SizedBox(width: 25,),
                      ElevatedButton(onPressed: (){
                        var con = TextEditingController();
                        showDialog(context: context, builder: (context)=>AlertDialog(
                          title: Column(
                            children: [
                              Text("إضافة"),
                              TextFormField(
                                controller: con,
                              )
                            ],
                          ),
                          actions: [
                            TextButton(onPressed: (){
                              if(serach_tag_list[index].tag.isNotEmpty &&serach_tag_list[index].tag[0]!=null &&serach_tag_list[index].tag[0]!="") {
                                serach_tag_list[index].tag.add(con.text.toString());
                              }else{
                                serach_tag_list[index].tag=[con.text.toString()];
                              }
                              print(serach_tag_list[index].tag);
                              print(serach_tag_list[index].tag.length);
                              var _ =  serach_tag_list[index].tag.join("*|*");
                              dio.post_data(
                                  url: "/dash/update_id",
                                  quary: {
                                    "table": " serach ",
                                    "sql_key":
                                    " tag = '$_' ",
                                    "id": serach_tag_list[index].id
                                  });
                              setState(() {

                              });
                              Navigator.pop(context);}, child: Text("نعم")),
                            TextButton(onPressed: (){Navigator.pop(context);}, child: Text("إلغاء")),
                          ],
                        ));
                      }, child: Text("إضافة")),
                      SizedBox(width: 25,),
                      ElevatedButton(onPressed: () async {
                          final result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['csv'],);
                            var file = XFile.fromData(result!.files.first.bytes!);
                            List<List<dynamic>> csvTable = CsvToListConverter().convert(await file.readAsString());
                            List csvTableMapped = csvTable.map((e) => e.first).toList();
                            print(csvTableMapped);
                          csvTableMapped.forEach((element) =>serach_tag_list[index].tag.add(element.toString()));
                        var _ =  serach_tag_list[index].tag.join("*|*");
                          dio.post_data(
                              url: "/dash/update_id",
                              quary: {
                                "table": " serach ",
                                "sql_key":
                                " tag = '$_' ",
                                "id": serach_tag_list[index].id
                              });
                          setState(() {

                          });
                      }, child: Text("cvs إضافة")),
                      Spacer(),
                      Text(serach_tag_list[index].name??"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                    ],
                  ),
                  ...serach_tag_list[index].tag.map((e) => InkWell(
                    onLongPress: (){
                      var con = TextEditingController(text: e);
                      showDialog(context: context, builder: (context)=>AlertDialog(
                        title: Column(
                          children: [
                            Text("تعديل"),
                            TextFormField(
                              controller: con,
                            )
                          ],
                        ),
                        actions: [
                          TextButton(onPressed: (){
                            var ind = serach_tag_list[index].tag.indexOf(e);
                            serach_tag_list[index].tag.removeAt(ind);
                            var _ = serach_tag_list[index].tag.join("*|*");
                            dio.post_data(
                                url: "/dash/update_id",
                                quary: {
                                  "table": " serach ",
                                  "sql_key":
                                  " tag = '$_' ",
                                  "id": serach_tag_list[index].id
                                });
                            setState(() {});
                            Navigator.pop(context);}, child: Text("حذف")),
                          SizedBox(width: 30,),
                          TextButton(onPressed: (){
                          var ind = serach_tag_list[index].tag.indexOf(e);
                          serach_tag_list[index].tag.removeAt(ind);
                          serach_tag_list[index].tag.insert(ind,con.text);
                          var _ = serach_tag_list[index].tag.join("*|*");
                            dio.post_data(
                                url: "/dash/update_id",
                                quary: {
                                  "table": " serach ",
                                  "sql_key":
                                  " tag = '$_' ",
                                  "id": serach_tag_list[index].id
                                });
                            setState(() {

                            });
                            Navigator.pop(context);}, child: Text("نعم")),
                          TextButton(onPressed: (){Navigator.pop(context);}, child: Text("إلغاء")),
                        ],
                      ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(e,style: TextStyle(fontSize: 18),),
                    ),
                  )),

                ],
              ),
            );
          },separatorBuilder: (context,index)=>Container(height: 2,color: Colors.grey.shade300,),),
        ),
          SizedBox(height: 20,),
        ],
      ),
    );
  }
}

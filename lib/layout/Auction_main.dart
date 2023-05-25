import 'dart:html';
import 'dart:typed_data';
import 'package:auction_app_admin/utils/const.dart';
import 'package:auction_app_admin/utils/dio.dart';
import 'package:auction_app_admin/model/auction_type_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'dart:async';

import 'main_data_details.dart';

List<auction_type_model> auction_main_list = [];
bool is_update_init = false;
int auction_main_screen_type = 0;
String terms = "";
var is_check_update;
var is_soon;
var name_ar_con = TextEditingController();
var name_en_con = TextEditingController();
var text_slot_con = TextEditingController();
var file_slot_con = TextEditingController();
var type_con = TextEditingController();
var price_con = TextEditingController();
List<String> auction_main_type_auction = [];
List<String> auction_main_type_auction_img = [];
List<String> auction_main_type_auction_time = [];
List<String> auction_main_type_auction_main_data = [];
List<String> auction_main_text_slot = [];
List<String> auction_main_file_slot = [];
bool auction_main_update_is_loading = false;
auction_type_model? auction_main_type_model;

class Auction_main extends StatefulWidget {
  const Auction_main({Key? key}) : super(key: key);

  @override
  State<Auction_main> createState() => _Auction_mainState();
}

class _Auction_mainState extends State<Auction_main> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auction_main_list.clear();
    dio.post_data(url: "/dash/select", quary: {"table": "mains", "sql": " * "}).then((value) {
      value?.data.forEach((element) {
        auction_main_list.add(auction_type_model.fromjson(element));
        if (auction_main_list.length == value.data.length) {
          setState(() {});
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    auction_main_list.clear();
    auction_main_screen_type = 0;
    auction_main_type_model = null;
    is_update_init = false;
    auction_main_type_auction.clear();
    auction_main_type_auction_img.clear();
    auction_main_type_auction_time.clear();
    auction_main_type_auction_main_data.clear();
    auction_main_text_slot.clear();
    auction_main_file_slot.clear();
    type_con.clear();
    price_con.clear();
    auction_main_update_is_loading = false;
  }

  @override
  Widget build(BuildContext context) {
    if (auction_main_screen_type == 1 && auction_main_type_model != null) {
      return auction_main_show_screen(context, auction_main_type_model!, setState);
    }
    if (auction_main_screen_type == 2 && auction_main_type_model != null) {
      return auction_main_update_screen(
        context,
        auction_main_type_model!,
        setState,
      );
    }
    if (auction_main_screen_type == 3) {
      return auction_main_update_screen(
        context,
        auction_main_type_model,
        setState,
      );
    }
    if (auction_main_list.isNotEmpty) {
      return Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Center(
                  child: Text("انواع المزادات", style: TextStyle(fontSize: 30)),
                ),
                Spacer(),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        auction_main_screen_type = 3;
                      });
                    },
                    child: Text("إضافة نوع")),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return auction_main_widget(context, auction_main_list[index], setState);
                  },
                  separatorBuilder: (context, index) {
                    return Container(
                      height: 2,
                      width: double.infinity,
                      color: Colors.green,
                    );
                  },
                  itemCount: auction_main_list.length),
            )
          ],
        ),
      );
    } else {
      return Container(
        color: Colors.white,
        child: const Center(
          child: Text(
            'Auction main',
            style: TextStyle(fontSize: 35),
          ),
        ),
      );
    }
  }
}

Widget auction_main_widget(BuildContext context, auction_type_model model, setstate) {
  var con = ScrollController();
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: double.infinity,
      height: 52,
      child: Scrollbar(
        controller: con,
        child: ListView(scrollDirection: Axis.horizontal, controller: con, shrinkWrap: true, children: [
          Container(
              height: 100,
              width: 50,
              child: Image.network(
                base_url+"/file/${model.type!}.png",
                height: 50,
                width: 100,
              )),
          SizedBox(
            width: 20,
          ),
          Container(
              width: 200,
              child: Center(
                  child: Text(
                model.ar_name!,
                style: TextStyle(fontSize: 25),
              ))),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      setstate(() {
                        auction_main_screen_type = 1;
                        auction_main_type_model = model;
                      });
                    },
                    child: Text("عرض")),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      setstate(() {
                        auction_main_screen_type = 2;
                        auction_main_type_model = model;
                      });
                    },
                    child: Text("تعديل")),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: Text('حذف نوع'),
                            content: Text('تحذير \n ستخسر جميع المزادات التي بداخل النوع'),
                            actions: <Widget>[
                              ElevatedButton(
                                child: Text('تراجع'),
                                onPressed: () {
                                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                                },
                              ),
                              ElevatedButton(
                                child: Text('حذف'),
                                onPressed: () {
                                  dio.post_data(url: "dash/drop_tb", quary: {
                                    "table": model.type,
                                    "id": model.id,
                                  }).then((value) {
                                    print(value?.data);
                                    dio.post_data(url: "/dash/select", quary: {"table": "mains", "sql": " * "}).then((value) {
                                      auction_main_list.clear();
                                      value?.data.forEach((element) {
                                        auction_main_list.add(auction_type_model.fromjson(element));
                                        if (auction_main_list.length == value.data.length) {
                                          setstate(() {});
                                          Navigator.of(dialogContext).pop();
                                        }
                                      });
                                    });
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text("حذف")),
              ],
            ),
          ),
        ]),
      ),
    ),
  );
}

Widget auction_main_show_screen(BuildContext context, auction_type_model model, setstate) {
  return Scaffold(
    body: ListView(
      shrinkWrap: true,
// crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () {
                  setstate(() {
                    auction_main_screen_type = 0;
                    auction_main_type_model = null;
                  });
                },
                icon: Icon(Icons.arrow_back_ios_new)),
            Spacer(),
            Text(
              "معلومات",
              style: TextStyle(fontSize: 24),
            ),
            Spacer(),
          ],
        ),
        Container(
          height: 240,
          // color: Colors.grey.shade200,
          child: GridView(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: MediaQuery.of(context).size.width < 700 ? 1 : 2, childAspectRatio: 8),
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Center(
                    child: Text(
                  "الاسم بالعربي ${model.ar_name ?? "غيرمتوفر"}",
                  style: TextStyle(fontSize: 24),
                )),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Center(
                    child: Text(
                  "الاسم بالانكليزي ${model.eng_name ?? "غيرمتوفر"}",
                  style: TextStyle(fontSize: 24),
                )),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Center(
                    child: Text(
                  "الرقم التسلسلي ${model.id ?? "غيرمتوفر"}",
                  style: TextStyle(fontSize: 24),
                )),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Center(
                    child: Text(
                  "اسم قاعدة البيانات ${model.type ?? "غيرمتوفر"}",
                  style: TextStyle(fontSize: 24),
                )),
              ),
            ],
          ),
        ),
        Container(
          height: 2,
          color: Colors.grey.shade300,
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "الأنواع: ",
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(
          height: 30,
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: model.all_kind?.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                        backgroundColor: Colors.orange.shade200,
                        radius: 30,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.network(
                            model.all_kind![index].img!,
                          ),
                        )),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      model.all_kind![index].kind!,
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text("المدة بالأيام:"),
                    Text(
                      model.all_kind![index].time!,
                      style: TextStyle(fontSize: 18),
                    ),
                    // Text("المعلومات الأساسية:"),
                    // SizedBox(
                    //   width: 20,
                    // ),
                    // Container(
                    //     width: 200,
                    //     child: Text(
                    //      //auction_main_type_auction_main_data.toString(),
                    //       model.all_kind![index].main_date!.replaceAll("^", " , "),
                    //       overflow: TextOverflow.ellipsis,
                    //       style: TextStyle(fontSize: 18),
                    //     )),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          List a = model.all_kind![index].main_date!.toString().split("^");
                          // showDialog<void>(
                          //   context: context,
                          //   barrierDismissible: false,
                          //   builder: (BuildContext dialogContext) {
                          //     return AlertDialog(
                          //       content: SizedBox(
                          //         height: 500,
                          //         width: 500,
                          //         child: StatefulBuilder(builder: (context, setstae) {
                          //           return Column(
                          //             children: [
                          //               Expanded(
                          //                 child: ListView.builder(
                          //                     itemCount: a.length,
                          //                     itemBuilder: (context, indexx) {
                          //                       return Column(
                          //                         children: [
                          //                           Row(
                          //                             children: [
                          //                               Spacer(),
                          //                               Text(a[indexx]),
                          //                               SizedBox(
                          //                                 width: 10,
                          //                               ),
                          //                             ],
                          //                           ),
                          //                           SizedBox(
                          //                             height: 10,
                          //                           ),
                          //                         ],
                          //                       );
                          //                     }),
                          //               ),
                          //             ],
                          //           );
                          //         }),
                          //       ),
                          //       actions: <Widget>[
                          //         TextButton(
                          //           child: Text('موافق'),
                          //           onPressed: () {
                          //             Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                          //           },
                          //         ),
                          //       ],
                          //     );
                          //   },
                          // );
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>main_data_details(list:a,main:model.all_kind!,id:model.id,index: index,)));
                        },
                        child: Text("عرض المعلومات الاساسية")),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            );
          },
        ),
        Container(
          height: 2,
          color: Colors.grey.shade300,
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "خيارات المعلومات الإضافية:",
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(
          height: 10,
        ),
        if (model.text_slot?[0] != ""||model.text_slot!.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            itemCount: model.text_slot?.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.text_slot![index],
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              );
            },
          )
        else
          Text(
            "لا يوجد",
            style: TextStyle(fontSize: 20),
          ),
        Container(
          height: 2,
          color: Colors.grey.shade300,
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "خيارات الملفات الإضافية:",
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(
          height: 10,
        ),
        if (model.file_slot![0] != "")
          ListView.builder(
            shrinkWrap: true,
            itemCount: model.file_slot?.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.file_slot![index],
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              );
            },
          )
        else
          Text(
            "لا يوجد",
            style: TextStyle(fontSize: 20),
          ),
        Container(
          height: 2,
          color: Colors.grey.shade300,
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          children: [
            Text(
              "يحتاج لأضافة موقع:",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              width: 10,
            ),
            if (model.with_location!)
              Text(
                "نعم",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
              )
            else
              Text(
                "لا",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
              ),

          ],
        ),
        SizedBox(height: 20,),
        Container(
          height: 2,
          color: Colors.grey.shade300,
        ),
        SizedBox(height: 20,),
        Row(
          children: [
            Text("السعر:",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(width: 20,),
            Text(model.price!,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        SizedBox(
          height: 70,
        ),
      ],
    ),
  );
}

Widget auction_main_update_screen(BuildContext context, auction_type_model? model, setstate) {
  var new_kind_con = TextEditingController();
  var new_kind_time_con = TextEditingController();
  if (!is_update_init) {
    is_update_init = true;
    is_check_update = model?.with_location ?? false;
    is_soon = model?.is_soon ?? true;
    name_ar_con = TextEditingController(text: model?.ar_name);
    name_en_con = TextEditingController(text: model?.eng_name);
    price_con=TextEditingController(text: model?.price);
    if (model != null) {
      model.all_kind?.forEach((element) {
        print(element.img);
        auction_main_type_auction.add(element.kind!);
        auction_main_type_auction_img.add(element.img!);
        auction_main_type_auction_time.add(element.time!);
        auction_main_type_auction_main_data.add(element.main_date!);
      });
    }if(model?.text_slot![0]!=" "&&model?.text_slot![0]!="") {
      auction_main_text_slot = model?.text_slot ?? [];
    }
    if(model?.file_slot![0]!=" " &&model?.file_slot![0]!="") {
      auction_main_file_slot = model?.file_slot ?? [];
    }

  }
  return Scaffold(
    body: ListView(
      shrinkWrap: true,
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () {
                  setstate(() {
                    auction_main_screen_type = 0;
                    auction_main_type_model = null;
                    is_update_init = false;
                    auction_main_type_auction.clear();
                    auction_main_type_auction_img.clear();
                    auction_main_type_auction_time.clear();
                    auction_main_type_auction_main_data.clear();
                    auction_main_text_slot.clear();
                    auction_main_file_slot.clear();
                    type_con.clear();
                    auction_main_update_is_loading = false;
                  });
                },
                icon: Icon(Icons.arrow_back_ios_new)),
            Spacer(),
            Text(
              "تعديل",
              style: TextStyle(fontSize: 24),
            ),
            Spacer(),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "الاسم بالعربي:",
          style: TextStyle(fontSize: 24),
        ),
        Container(width: 500, child: TextFormField(controller: name_ar_con)),
        SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          ":الاسم بالانكليزي",
          style: TextStyle(fontSize: 24),
        ),
        Container(
            width: 500,
            child: TextFormField(
              controller: name_en_con,
            )),
        SizedBox(
          height: 15,
        ),
        Text(
          "سعر إضافة إعلان",
          style: TextStyle(fontSize: 24),
        ),
        Container(
            width: 500,
            child: TextFormField(
              controller: price_con,
            )),
        SizedBox(
          height: 15,
        ),
        if (model == null)
          SizedBox(
            height: 15,
          ),
        if (model == null)
          Text(
            ":اسم قاعدة البيانات (يحب أن يكون بالانكليزية و مميز و بدون فراغات)",
            style: TextStyle(fontSize: 24),
          ),
        if (model == null)
          Container(
              width: 500,
              child: TextFormField(
                controller: type_con,
              )),
        SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Text(
              "الأنواع: ",
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: auction_main_type_auction.length,
          itemBuilder: (context, index) {
            return SizedBox(
              height: 75,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                          backgroundColor: Colors.orange.shade200,
                          radius: 30,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.network(auction_main_type_auction_img[index]),
                            // child: Image.network(model.all_kind![index].img!,),
                          )),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        auction_main_type_auction[index],
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text("عدد أيام عرض المزاد:"),
                      Text(
                        auction_main_type_auction_time[index],
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text("المعلومات الأساسية:"),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                          width: 200,
                          child: Text(
                            auction_main_type_auction_main_data[index],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 18),
                          )),
                      SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            List a = auction_main_type_auction_main_data[index].toString().split("^");
                            var con = TextEditingController();
                            showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext dialogContext) {
                                return AlertDialog(
                                  title: Text('تعديل'),
                                  content: SizedBox(
                                    height: 500,
                                    width: 500,
                                    child: StatefulBuilder(builder: (context, setstae) {
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    setstae(() {
                                                      a.add(con.text);
                                                    });
                                                    con.clear();
                                                  },
                                                  child: Text("إضافة")),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  child: TextFormField(
                                                controller: con,
                                                textDirection: TextDirection.rtl,
                                              )),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                                itemCount: a.length,
                                                itemBuilder: (context, indexx) {
                                                  return Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          ElevatedButton(
                                                              onPressed: () {
                                                                setstae(() {
                                                                  a.removeAt(indexx);
                                                                });
                                                              },
                                                              child: Text("حذف")),
                                                          Spacer(),
                                                          Text(a[indexx]),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                    ],
                                                  );
                                                }),
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('موافق'),
                                      onPressed: () {
                                        setstate(() {
                                          String s = "";
                                          for (int i = 0; i < a.length; i++) {
                                            s = s + a[i];
                                            if (i + 1 != a.length) {
                                              s = s + "^";
                                            }
                                          }
                                          auction_main_type_auction_main_data[index] = s;
                                        });
                                        Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                                      },
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop();
                                        },
                                        child: Text("تراجح")),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text("تعديل المعلومات الاساسية")),
                      SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            var name_con = TextEditingController(text: auction_main_type_auction[index]);
                            var time_con = TextEditingController(text: auction_main_type_auction_time[index]);
                            var img = auction_main_type_auction_img[index];
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("تعديل نوع"),
                                    content: Container(
                                      height: 500,
                                      width: 500,
                                      child: Column(
                                        children: [
                                          Text("الاسم"),
                                          TextFormField(
                                            controller: name_con,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text("مدة المزاد"),
                                          TextFormField(
                                            controller: time_con,
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text("الصورة"),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          ElevatedButton(
                                              onPressed: () async {
                                                // final ImagePicker _picker = ImagePicker();
                                                // final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                                                // FilePickerResult? image = await FilePicker.platform
                                                //     .pickFiles(allowedExtensions: ['png'], allowMultiple: false, type: FileType.custom);
                                                Uint8List? image = await ImagePickerWeb.getImageAsBytes();
                                                if (image != null) {
                                                  // String dir = image.files[0].name.split(".").last;
                                                  FormData formData = FormData.fromMap(
                                                      {"file": await MultipartFile.fromBytes(image.toList(), filename: name_con.text)});
                                                  dio.post_data(url: "/uplode/uplode", data: formData).then((value) {
                                                    Tost_widget("تم رفع الصورة", "green");
                                                    img = value?.data["message"];
                                                    Navigator.pop(context);
                                                  });
                                                  showDialog<void>(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Container(height: 50,width: 50,child: CircularProgressIndicator()),
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                              child: Text("تغيير الصورة")),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            setstate(() {
                                              auction_main_type_auction.removeAt(index);
                                              auction_main_type_auction_time.removeAt(index);
                                              auction_main_type_auction_img.removeAt(index);
                                              auction_main_type_auction.insert(index, name_con.text);
                                              auction_main_type_auction_time.insert(index, time_con.text);
                                              auction_main_type_auction_img.insert(index, img);
                                            });
                                            name_con.clear();
                                            time_con.clear();
                                            Navigator.pop(context);
                                          },
                                          child: Text("موافق")),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            name_con.clear();
                                            time_con.clear();
                                            Navigator.pop(context);
                                          },
                                          child: Text("تراجع")),
                                    ],
                                  );
                                });
                          },
                          child: Text("تعديل")),
                      SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            setstate(() {
                              auction_main_type_auction.removeAt(index);
                              auction_main_type_auction_time.removeAt(index);
                              auction_main_type_auction_img.removeAt(index);
                              auction_main_type_auction_main_data.removeAt(index);
                            });
                          },
                          child: Text("حذف")),
                      SizedBox(
                        width: 50,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            );
          },
        ),
        Row(
          children: [
            ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        var img = "";
                        return AlertDialog(
                          title: Text("الاسم"),
                          content: Column(
                            children: [
                              Text("الاسم"),
                              TextFormField(
                                controller: new_kind_con,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text("مدة المزاد"),
                              TextFormField(
                                controller: new_kind_time_con,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text("الصورة"),
                              SizedBox(
                                width: 20,
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    // final ImagePicker _picker = ImagePicker();
                                    // final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                                    // if(image!=null){
                                    //   String dir = image.name.split(".").last;
                                    //   FormData formData = FormData.fromMap({
                                    //     "file":
                                    //     await MultipartFile.fromBytes(await image.readAsBytes(),filename: image.name)
                                    //   });

                                    // FilePickerResult? image = await FilePicker.platform.pickFiles(allowedExtensions: ['png'],allowMultiple: false,type: FileType.custom,);
                                    Uint8List? image = await ImagePickerWeb.getImageAsBytes();
                                    if (image != null) {
                                      // String dir = image.files[0].name.split(".").last;
                                      FormData formData =
                                          FormData.fromMap({"file": await MultipartFile.fromBytes(image.toList(), filename: new_kind_con.text)});
                                      dio.post_data(url: "/uplode/uplode", data: formData).then((value) {
                                        Tost_widget("تم رفع الصورة", "green");
                                        img = value?.data["message"];
                                        Navigator.pop(context);
                                      });
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Container(height: 50,width: 50,child: CircularProgressIndicator()),
                                          );
                                        },
                                      );
                                    }
                                  },
                                  child: Text("تغيير الصورة")),
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  setstate(() {
                                    auction_main_type_auction.add(new_kind_con.text);
                                    auction_main_type_auction_time.add(new_kind_time_con.text);
                                    auction_main_type_auction_img.add(img);
                                    auction_main_type_auction_main_data.add(" ");
                                  });
                                  new_kind_time_con.clear();
                                  new_kind_con.clear();
                                  Navigator.pop(context);
                                },
                                child: Text("موافق"))
                          ],
                        );
                      });
                },
                child: Icon(Icons.add)),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          height: 2,
          color: Colors.grey,
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Text(
              "المعلومات الإضافية:",
              style: TextStyle(fontSize: 24),
            ),
            Spacer(),
            SizedBox(
              width: 30,
            ),
          ],
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: auction_main_text_slot.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      auction_main_text_slot[index],
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setstate(() {
                          auction_main_text_slot.removeAt(index);
                        });
                      },
                      child: Text("حذف")),
                ],
              );
            }),
        if (auction_main_text_slot.length < 3)
          Row(
            children: [
              ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                  onPressed: () {
                    if (auction_main_text_slot.length < 3) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("new"),
                                content: TextFormField(
                                  controller: text_slot_con,
                                ),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        setstate(() {
                                          auction_main_text_slot.add(text_slot_con.text);
                                        });
                                        Navigator.pop(context);
                                        text_slot_con.clear();
                                      },
                                      child: Text("ok"))
                                ],
                              ));
                    } else {
                      Tost_widget("لايمكن إضافة أكثر من ثلاث خانات", "red");
                    }
                  },
                  child: Center(
                    child: Icon(Icons.add),
                  )),
            ],
          ),
        SizedBox(
          height: 15,
        ),
        Container(
          height: 2,
          color: Colors.grey,
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            //SizedBox(width: 20,),
            Text(
              "الملفات الإضافية:",
              style: TextStyle(fontSize: 24),
            ),
            Spacer(),

            SizedBox(
              width: 20,
            ),
            Spacer(),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: auction_main_file_slot.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      auction_main_file_slot[index],
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setstate(() {
                          auction_main_file_slot.removeAt(index);
                        });
                      },
                      child: Text("حذف")),
                ],
              );
            }),
        if (auction_main_file_slot.length < 3)
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                  onPressed: () {
                    if (auction_main_file_slot.length < 3) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("new"),
                                content: TextFormField(
                                  controller: file_slot_con,
                                ),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        setstate(() {
                                          auction_main_file_slot.add(file_slot_con.text);
                                        });
                                        Navigator.pop(context);
                                        file_slot_con.clear();
                                      },
                                      child: Text("ok"))
                                ],
                              ));
                    } else {
                      Tost_widget("لايمكن إضافة أكثر من ثلاث خانات", "red");
                    }
                  },
                  child: Container(child: Center(child: Icon(Icons.add)))),
            ],
          ),
        SizedBox(
          height: 15,
        ),
        Container(
          height: 2,
          color: Colors.grey,
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Text(
              "يحتاج الى خريطة",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              width: 20,
            ),
            Checkbox(
                value: is_check_update,
                onChanged: (value) => setstate(() {
                      is_check_update = !is_check_update!;
                    })),
          ],
        ),
        SizedBox(
          height: 25,
        ),
        Row(
          children: [
            Text(
              "قريبا ؟",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              width: 20,
            ),
            Checkbox(
                value: is_soon,
                onChanged: (value) => setstate(() {
                  print(model?.is_soon);
                  is_soon = !is_soon!;
                })),
          ],
        ),
        SizedBox(
          height: 25,
        ),
        InkWell(
          onTap: () async {
            Uint8List? image = await ImagePickerWeb.getImageAsBytes();
            if (image != null) {
              FormData formData =
              FormData.fromMap({"file": await MultipartFile.fromBytes(image.toList(), filename: (model?.type ?? type_con.text) + ".png")});
              dio.post_data(url: "/uplode/uplode", data: formData).then((value) {
                Tost_widget("تم تعديل الصورة", "green");
                print(value?.data);
                Navigator.pop(context);
              });
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Container(height: 50,width: 50,child: CircularProgressIndicator()),
                  );
                },
              );
            }
          },
          child: Row(
            children: [
              Text(
                "تغيير صورة النوع",
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                width: 30,
              ),
              Icon(Icons.arrow_back_ios_new),
            ],
          ),
        ),
        SizedBox(
          height: 50,
        ),
        InkWell(
          onTap: () {
            var con = TextEditingController(text: model?.terms ?? "");
            showDialog<void>(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  title: Text('الأحكام و الشروط'),
                  content: TextFormField(controller: con),
                  actions: <Widget>[
                    TextButton(
                      child: Text('ok'),
                      onPressed: () {
                        terms = con.text;
                        con.clear();
                        Navigator.of(dialogContext).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Row(
            children: [
              Text(
                "الأحكام و الشروط",
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                width: 30,
              ),
              Icon(Icons.arrow_back_ios_new),
            ],
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Row(
          children: [
            ElevatedButton(
                onPressed: () {
                  setstate(() {
                    auction_main_screen_type = 0;
                    auction_main_type_model = null;
                    is_update_init = false;
                    auction_main_type_auction.clear();
                    auction_main_type_auction_img.clear();
                    auction_main_type_auction_main_data.clear();
                    auction_main_type_auction_time.clear();
                    auction_main_text_slot.clear();
                    auction_main_file_slot.clear();
                    type_con.clear();
                    price_con.clear();
                    auction_main_update_is_loading = false;
                  });
                },
                child: Text("إلغاء")),
            SizedBox(
              width: 30,
            ),
            ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.green)),
                onPressed: () {
                  setstate(() {
                    auction_main_update_is_loading = true;
                  });
                  var s = "";
                  var s2 = "";
                  var s3 = "";
                  for (int i = 0; i < auction_main_type_auction.length; i++) {
                    s = s +
                        auction_main_type_auction[i] +
                        "|" +
                        auction_main_type_auction_img[i] +
                        "|" +
                        auction_main_type_auction_time[i] +
                        "|" +
                        auction_main_type_auction_main_data[i];
                    if (i + 1 != auction_main_type_auction.length) {
                      s = s + "*";
                    }
                  }
                  for (int i = 0; i < auction_main_text_slot.length; i++) {
                    s2 = s2 + auction_main_text_slot[i];
                    if (i + 1 != auction_main_text_slot.length) {
                      s2 = s2 + "|";
                    }
                  }
                  for (int i = 0; i < auction_main_file_slot.length; i++) {
                    s3 = s3 + auction_main_file_slot[i];
                    if (i + 1 != auction_main_file_slot.length) {
                      s3 = s3 + "|";
                    }
                  }
                  dio.post_data(url: "/dash/" + (model == null ? "insert" : "update_id"), quary: {
                    "table": "mains",
                    "id": model?.id ?? "",
                    "sql_key": model == null
                        ? "ar_name , eng_name , all_kind , text_slot , file_solt , with_location , type , terms , is_soon , price"
                        : " ar_name = '" +
                            name_ar_con.text +
                            "', eng_name = '" +
                            name_en_con.text +
                            "' , all_kind = '" +
                            s +
                            "' , text_slot = '" +
                            s2 +
                            "'  , file_solt = '" +
                            s3 +
                            "' , with_location = '" +
                            (is_check_update == true ? '1' : '0') +
                            "' , terms = '" +
                            terms +
                            "' , is_soon = '" +
                           (is_soon == true ? '1' : '0') +
                            "' , price = '" +
                            price_con.text +
                            "'",
                    "sql_value": " '" +
                        name_ar_con.text +
                        "', '" +
                        name_en_con.text +
                        "' , '" +
                        s +
                        "' ,  '" +
                        s2 +
                        "'  ,  '" +
                        s3 +
                        "' , '" +
                        (is_check_update == true ? '1' : '0') +
                        "' ,  '" +
                        type_con.text +
                        "'  ,'" +
                        terms +
                        "'  ,'" +
                        (is_soon == true ? '1' : '0') +
                        "'  ,'" +
                        price_con.text +
                        "' ",
                  }).then((value) {
                    print(value?.data);
                    dio.post_data(url: "/dash/select", quary: {"table": "mains", "sql": " * "}).then((value) async {
                      if (model == null) {
                        await dio.post_data(url: "/dash/create_table", quary: {"table": type_con.text});
                      }
                      auction_main_list.clear();
                      value?.data.forEach((element) {
                        auction_main_list.add(auction_type_model.fromjson(element));
                        if (auction_main_list.length == value.data.length) {
                          setstate(() {
                            auction_main_screen_type = 0;
                            auction_main_type_model = null;
                            is_update_init = false;
                            auction_main_type_auction.clear();
                            auction_main_type_auction_img.clear();
                            auction_main_type_auction_time.clear();
                            auction_main_type_auction_main_data.clear();
                            auction_main_text_slot.clear();
                            auction_main_file_slot.clear();
                            type_con.clear();
                            price_con.clear();
                            auction_main_update_is_loading = false;
                          });
                          Tost_widget("تمت العملية بنجاح", "green");
                        }
                      });
                    });
                  });
                },
                child: auction_main_update_is_loading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text("موافق")),
          ],
        ),
        SizedBox(
          height: 75,
        ),
      ],
    ),
  );
}

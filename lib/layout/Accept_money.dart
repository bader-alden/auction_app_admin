import 'package:flutter/material.dart';
import 'package:auction_app_admin/utils/dio.dart';
import 'package:flutter/material.dart';
import 'package:auction_app_admin/model/user_model.dart';
import 'Users.dart';

List mouney_list = [];
List mouney_type = ["pay","add","pay2"];
List mouney_name_type = ["دفعات إنشاء المزادات","دفعات تغذية الحسابات","دفعات مشتريات المزادات"];
int mouney_list_type = 0;

class Accept_money extends StatefulWidget {
  const Accept_money({Key? key}) : super(key: key);

  @override
  State<Accept_money> createState() => _Accept_moneyState();
}

class _Accept_moneyState extends State<Accept_money> {
  @override
  void initState() {
    super.initState();
    dio.post_data(url: "/dash/select", quary: {"table": "apporoval", "sql": " * "}).then((value) {
      mouney_list = [];
      print(value?.data);
      mouney_list = value?.data;
      setState(() {});
      // value?.data.forEach((element){
      //   mouney_list.add(auction_model.fromjson(element));
      //   if(mouney_list.length == value.data.length ){
      //     print(mouney_list[0].name);
      //     print(mouney_list[1].name);
      //     setState(() {});
      //   }
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
     if (mouney_list_type==4) {
      return money_list_archive(setState);
    }else if (mouney_list_type!=0) {
      return money_list(setState);
    }else {
       return Column(
         children: [
           Center(
             child: Text("قبول الدفعات"),
           ),
           SizedBox(
             height: 50,
           ),
           Padding(
             padding: const EdgeInsets.all(15.0),
             child: InkWell(
               onTap: () {
                 setState(() {
                   mouney_list_type = 1;
                 });
               },
               child: Row(
                   children:
                   [
                     Icon(Icons.circle, size: 20),
                     SizedBox(width: 20,),
                     Text("دفعات إنشاء المزادات", style: TextStyle(fontSize: 25),),
                     SizedBox(width: 20,),
                     Icon(Icons.arrow_back_ios_new),
                   ]
               ),
             ),
           ),
           Padding(
             padding: const EdgeInsets.all(15.0),
             child: InkWell(
               onTap: () {
                 setState(() {
                   mouney_list_type = 2;
                 });
               },
               child: Row(
                   children:
                   [
                     Icon(Icons.circle, size: 20),
                     SizedBox(width: 20,),
                     Text("دفعات تغذية الحسابات", style: TextStyle(fontSize: 25),),
                     SizedBox(width: 20,),
                     Icon(Icons.arrow_back_ios_new),
                   ]
               ),
             ),
           ),
           Padding(
             padding: const EdgeInsets.all(15.0),
             child: InkWell(
               onTap: () {
                 setState(() {
                   mouney_list_type = 3;
                 });
               },
               child: Row(
                   children:
                   [
                     Icon(Icons.circle, size: 20),
                     SizedBox(width: 20,),
                     Text("دفعات مشتريات المزادات", style: TextStyle(fontSize: 25),),
                     SizedBox(width: 20,),
                     Icon(Icons.arrow_back_ios_new),
                   ]
               ),
             ),
           ),
           Padding(
             padding: const EdgeInsets.all(15.0),
             child: InkWell(
               onTap: () {
                 setState(() {
                   mouney_list_type = 4;
                 });
               },
               child: Row(
                   children:
                   [
                     Icon(Icons.circle, size: 20),
                     SizedBox(width: 20,),
                     Text("أرشيف الدفعات", style: TextStyle(fontSize: 25),),
                     SizedBox(width: 20,),
                     Icon(Icons.arrow_back_ios_new),
                   ]
               ),
             ),
           ),
         ],
       );
     }
  }
}

Widget money_list(setState){
  return Column(
    children: [
      Row(
        children: [
          IconButton(onPressed: (){
            setState(() {
              mouney_list_type=0;
            });
          }, icon: Icon(Icons.arrow_back_ios_new)),
          Spacer(),
          Text(mouney_name_type[mouney_list_type-1],style: TextStyle(fontSize: 25),),
          Spacer(),
        ],
      ),
      SizedBox(
        height: 50,
      ),
      Expanded(
          child: ListView.separated(
              itemCount: mouney_list.where((element) => element['pay_type'] == mouney_type[mouney_list_type-1] &&element['status_of_transform'] == '0' ).length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Text(double.parse(mouney_list.where((element) => element['pay_type'] == mouney_type[mouney_list_type-1] &&element['status_of_transform'] == '0').toList()[index]["amount"]).round().toString()),
                    SizedBox(
                      width: 50,
                    ),
                    // ElevatedButton(
                    //     onPressed: () {
                    //       showDialog<void>(
                    //         context: context,
                    //         builder: (BuildContext dialogContext) {
                    //           return AlertDialog(
                    //             title: Text('تفاصيل'),
                    //             content: Column(
                    //               children: [
                    //                 Text("القيمة"),
                    //                 Text(double.parse(mouney_list[index]["amount"]).round().toString()),
                    //                 SizedBox(
                    //                   height: 30,
                    //                 ),
                    //                 Text("العنوان"),
                    //                 //    Text(mouney_list[index]["title"]),
                    //                 SizedBox(
                    //                   height: 30,
                    //                 ),
                    //                 Text("التفاصيل"),
                    //                 //  Text(mouney_list[index]["text"]),
                    //               ],
                    //             ),
                    //             actions: <Widget>[
                    //               TextButton(
                    //                 child: Text('موافق'),
                    //                 onPressed: () {
                    //                   Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                    //                 },
                    //               ),
                    //             ],
                    //           );
                    //         },
                    //       );
                    //     },
                    //     child: Text("التفاصيل")),
                    SizedBox(
                      width: 30,
                    ),
                    ElevatedButton(onPressed: (){
                      dio.post_data(url:"/pay/check_pay_dash",quary: {"tran_ref":mouney_list.where((element) => element['pay_type'] == mouney_type[mouney_list_type-1] &&element['status_of_transform'] == '0' ).toList()[index]['id_of_transforms']}).then((value) {
                        print(value?.data);
                        showDialog<void>(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: Text('تفاصيل'),
                            content: Column(
                              children: [
                                Text("الاسم"+"  "+value!.data["customer_details"]["name"],textDirection: TextDirection.rtl,),
                                Text("الرقم"+"  "+value!.data["customer_details"]["phone"],textDirection: TextDirection.rtl,),
                                Text("الحالة"+"  "+(value!.data["payment_result"]["response_status"] =="A"? "  تم الدفع":"لم يتم الدفع"),textDirection: TextDirection.rtl,),
                                Text("العملة"+"  "+value!.data["cart_currency"],textDirection: TextDirection.rtl,),
                                Text("المدفوع"+"  "+double.parse(value!.data["cart_amount"]).toString(),textDirection: TextDirection.ltr,),
                                Text("الاجمالي"+"  "+double.parse(value!.data["tran_total"]).toString(),textDirection: TextDirection.rtl,),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('رجوع'),
                                onPressed: () {
                                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }).catchError((e){print(e);});
                    }, child: Text("تحقق من الملعومات")),
                    SizedBox(
                      width: 30,
                    ),
                    ElevatedButton(onPressed: (){
                      var a =mouney_list.where((element) => element['pay_type'] == mouney_type[mouney_list_type-1] &&element['status_of_transform'] == '0' ).toList();
                      dio.post_data(url:"/dash/select_id",quary:{
                      "table":"users",
                      "sql": " * ",
                      "id":a[index]['user_id']
                      } ).then((value) {
                        var user = user_models.fromjson(value?.data[0]);
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) =>
                            Material(child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: user_detail_widget(
                                    context, user, setState)))));
                        print(value?.data);
                      });
                    }, child: Text("عرض معلومات المستخدم")),
                    SizedBox(
                      width: 30,
                    ),
                    ElevatedButton(
                        onPressed: () {
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
                                      var a =mouney_list.where((element) => element['pay_type'] == mouney_type[mouney_list_type-1] &&element['status_of_transform'] == '0' ).toList();
                                      if(mouney_type[mouney_list_type-1] =="pay") {
                                        dio.post_data(url: "/post_auction/confirm", quary: {"type": a[index]['auction_type'], "id": a[index]['auction_id'],"transform_id":a[index]['id']}).then((value) {
                                        print(value?.data);
                                        dio.post_data(url: "/dash/select", quary: {"table": "apporoval", "sql": " * "}).then((value) {
                                          mouney_list = [];
                                          print(value?.data);
                                          mouney_list = value?.data;
                                          setState(() {});
                                        });
                                      });
                                      }else if(mouney_type[mouney_list_type-1] == "add"){
                                        dio.post_data(url: "/pay/add_wallet", quary: {"amount": a[index]['amount'], "user_id": a[index]['user_id'],"tran_id":a[index]['id']}).then((value) {
                                          print(value?.data);
                                          dio.post_data(url: "/dash/select", quary: {"table": "apporoval", "sql": " * "}).then((value) {
                                            mouney_list = [];
                                            print(value?.data);
                                            mouney_list = value?.data;
                                            setState(() {});
                                          });
                                        });
                                      }else if(mouney_type[mouney_list_type-1] =="pay2"){
                                        dio.post_data(url: "/pay/accept_pay2", quary: {"type": a[index]['auction_type'], "id": a[index]['auction_id'],"tran_id":a[index]['id'],"user_id":a[index]['user_id'] ,"amount":a[index]['amount']}).then((value) {
                                          print(value?.data);
                                          dio.post_data(url: "/dash/select", quary: {"table": "apporoval", "sql": " * "}).then((value) {
                                            mouney_list = [];
                                            print(value?.data);
                                            mouney_list = value?.data;
                                            setState(() {});
                                          });
                                        });
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text("موافقة")),
                    SizedBox(
                      width: 30,
                    ),
                    ElevatedButton(
                        onPressed: () {
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
                                      var a =mouney_list.where((element) => element['pay_type'] == mouney_type[mouney_list_type-1] &&element['status_of_transform'] == '0' ).toList();
                                      if(mouney_type[mouney_list_type-1] =="pay") {
                                        // dio.post_data(url: "/post_auction/confirm", quary: {"type": a[index]['auction_type'], "id": a[index]['auction_id'],"transform_id":a[index]['id']}).then((value) {
                                        //   print(value?.data);
                                        //   dio.post_data(url: "/dash/select", quary: {"table": "apporoval", "sql": " * "}).then((value) {
                                        //     mouney_list = [];
                                        //     print(value?.data);
                                        //     mouney_list = value?.data;
                                        //     setState(() {});
                                        //   });
                                        // });
                                      }else if(mouney_type[mouney_list_type-1] == "add"){
                                        // dio.post_data(url: "/pay/add_wallet", quary: {"amount": a[index]['amount'], "user_id": a[index]['user_id'],"tran_id":a[index]['id']}).then((value) {
                                        //   print(value?.data);
                                        //   dio.post_data(url: "/dash/select", quary: {"table": "apporoval", "sql": " * "}).then((value) {
                                        //     mouney_list = [];
                                        //     print(value?.data);
                                        //     mouney_list = value?.data;
                                        //     setState(() {});
                                        //   });
                                        // });
                                      }else if(mouney_type[mouney_list_type-1] =="pay2"){
                                        dio.post_data(url: "/dash/update_id", quary: {
                                          "table": a[index]['auction_type'],
                                          "id": a[index]['auction_id'],
                                          "sql_key": "status = '3' "
                                        });
                                        // dio.post_data(url: "/pay/accept_pay2", quary: {"type": a[index]['auction_type'], "id": a[index]['auction_id'],"tran_id":a[index]['id'],"user_id":a[index]['user_id']}).then((value) {
                                        //   print(value?.data);
                                        //   dio.post_data(url: "/dash/select", quary: {"table": "apporoval", "sql": " * "}).then((value) {
                                        //     mouney_list = [];
                                        //     print(value?.data);
                                        //     mouney_list = value?.data;
                                        //     setState(() {});
                                        //   });
                                        // });
                                      }
                                      print(a);
                                      print(a[index]);
                                      dio.post_data(url: "/dash/update_id", quary: {
                                        "table": "apporoval",
                                        "id": a[index]["id"].toString(),
                                        "sql_key": "status_of_transform = '3' "
                                      }).then((value) {
                                        print(value?.data);
                                        dio.post_data(url: "/dash/select", quary: {"table": "apporoval", "sql": " * "}).then((value) {
                                          mouney_list = [];
                                          print(value?.data);
                                          mouney_list = value?.data;
                                          setState(() {});
                                          // value?.data.forEach((element){
                                          //   mouney_list.add(auction_model.fromjson(element));
                                          //   if(mouney_list.length == value.data.length ){
                                          //     print(mouney_list[0].name);
                                          //     print(mouney_list[1].name);
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
                        },
                        child: Text("رفض")),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: Colors.grey,
                      height: 2,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                );
              },
              ))
    ],
  );
}

Widget money_list_archive(setState){
  return Column(
    children: [
      Row(
        children: [
          IconButton(onPressed: (){
            setState(() {
              mouney_list_type=0;
            });
          }, icon: Icon(Icons.arrow_back_ios_new)),
          Spacer(),
          Text("أرشيف الدفعات",style: TextStyle(fontSize: 25),),
          Spacer(),
        ],
      ),
      SizedBox(
        height: 50,
      ),
      Expanded(
          child: ListView.separated(
            itemCount: mouney_list.where((element) => element['status_of_transform'] != '0' ).length,
            itemBuilder: (context, index) {
              return SizedBox(
                height: 25,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Text("الرمز التسلسلي للدفعة:"),
                    SizedBox(
                      width: 10,
                    ),
                    Text(mouney_list.where((element) => element['status_of_transform'] != '0' ).toList()[index]["id_of_transforms"]),
                    SizedBox(
                      width: 50,
                    ),
                    Text("القيمة:"),
                    SizedBox(
                      width: 10,
                    ),
                    Text(double.parse(mouney_list.where((element) => element['status_of_transform'] != '0' ).toList()[index]["amount"]).round().toString()),
                    SizedBox(
                      width: 50,
                    ),
                    Text("النوع:"),
                    SizedBox(
                      width: 10,
                    ),
                    Text(mouney_name_type[mouney_type.indexOf(mouney_list.where((element) => element['status_of_transform'] != '0' ).toList()[index]["pay_type"])]),
                    SizedBox(
                      width: 30,
                    ),
                    Text("الحالة:"),
                    SizedBox(
                      width: 10,
                    ),
                    if(mouney_list.where((element) => element['status_of_transform'] != '0' ).toList()[index]["status_of_transform"]=="2")
                    Text("مقبول",style: TextStyle(color: Colors.green),)
                    else
                      Text("مرفوض",style: TextStyle(color: Colors.red),),
                    SizedBox(
                      width: 30,
                    ),
                    ElevatedButton(onPressed: (){
                      dio.post_data(url:"/pay/check_pay_dash",quary: {"tran_ref":mouney_list.where((element) => element['status_of_transform'] != '0' ).toList()[index]["id_of_transforms"]}).then((value) {
                        print(value?.data);
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: Text('تفاصيل'),
                              content: Column(
                                children: [
                                  Text("الاسم"+"  "+value!.data["customer_details"]["name"],textDirection: TextDirection.rtl,),
                                  Text("الرقم"+"  "+value!.data["customer_details"]["phone"],textDirection: TextDirection.rtl,),
                                  Text("الحالة"+"  "+(value!.data["payment_result"]["response_status"] =="A"? "  تم الدفع":"لم يتم الدفع"),textDirection: TextDirection.rtl,),
                                  Text("العملة"+"  "+value!.data["cart_currency"],textDirection: TextDirection.rtl,),
                                  Text("المدفوع"+"  "+double.parse(value!.data["cart_amount"]).toString(),textDirection: TextDirection.ltr,),
                                  Text("الاجمالي"+"  "+double.parse(value!.data["tran_total"]).toString(),textDirection: TextDirection.rtl,),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('رجوع'),
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }).catchError((e){print(e);});
                    }, child: Text("تحقق من الملعومات")),
                    SizedBox(
                      width: 30,
                    ),
                    ElevatedButton(onPressed: (){
                      var a =mouney_list.where((element) => element['status_of_transform'] != '0' ).toList();
                      dio.post_data(url:"/dash/select_id",quary:{
                        "table":"users",
                        "sql": " * ",
                        "id":a[index]['user_id']
                      } ).then((value) {
                        var user = user_models.fromjson(value?.data[0]);
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) =>
                            Material(child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: user_detail_widget(
                                    context, user, setState)))));
                        print(value?.data);
                      });
                    }, child: Text("عرض معلومات المستخدم")),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Colors.grey,
                    height: 2,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              );
            },
          ))
    ],
  );
}


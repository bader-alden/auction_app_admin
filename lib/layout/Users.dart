import 'dart:html';

import 'package:auction_app_admin/utils/const.dart';
import 'package:auction_app_admin/utils/dio.dart';
import 'package:flutter/material.dart';

import '../model/user_model.dart';
import 'auction_details_screen.dart';

List<user_models> user_list = [];
ScrollController user_list_con = ScrollController();
ScrollController user_elment_con = ScrollController();
int user_type_page = 0;
bool is_loading_update_user = false;
user_models? user_model_type;

class Users extends StatefulWidget {
  Users({Key? key}) : super(key: key);

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  void initState() {
    dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " users "}).then((value) {
      user_list.clear();
      value?.data.forEach((element) {
        print(element);
        user_list.add(user_models.fromjson(element));
        if (user_list.length == value.data.length) {
          setState(() {});
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    user_list.clear();
    user_type_page = 0;
    user_model_type = null;
  }

  @override
  Widget build(BuildContext context) {
    if (user_type_page == 1 && user_model_type != null) {
      return user_detail_widget(context, user_model_type, setState);
    } else if (user_type_page == 2 && user_model_type != null) {
      return user_update_widget(context, user_model_type, setState);
    } else if (user_type_page == 4) {
      return user_update_widget(context, null, setState);
    } else {
      if (user_list.isNotEmpty) {
        return Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text("قائمة بالمستخدمين", style: TextStyle(fontSize: 30)),
                Spacer(),
                ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                    onPressed: () {
                      setState(() {
                        user_type_page = 4;
                      });
                    },
                    child: Text("إضافة مستخدم")),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Scrollbar(
                controller: user_list_con,
                child: ListView.separated(
                    shrinkWrap: true,
                    controller: user_list_con,
                    itemBuilder: (context, index) {
                      return ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 200), child: user_list_element(context, user_list[index], setState));
                    },
                    separatorBuilder: (context, index) {
                      return Container(
                        width: double.infinity,
                        height: 2,
                        color: Colors.grey.shade300,
                      );
                    },
                    itemCount: user_list.length),
              ),
            ),
          ],
        );
      } else {
        return Container(
          color: Colors.white,
          child: const Center(
            child: Text(
              'Users',
              style: TextStyle(fontSize: 35),
            ),
          ),
        );
      }
    }
  }
}

Widget user_list_element(BuildContext context, user_models model, setstate) {
  var con = ScrollController();
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.grey.shade100,
            width: 550,
            height: 50,
            child: Scrollbar(
              controller: con,
              scrollbarOrientation: ScrollbarOrientation.bottom,
              child: ListView(
                controller: con,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.account_circle, size: 40),
                  SizedBox(
                    width: 10,
                  ),
                  Center(child: Text("الرمز التسلسلي: ${model.id!}")),
                  SizedBox(
                    width: 30,
                  ),
                  //   Text( MediaQuery.of(context).size.width.toString()),
                  Center(child: Text("الاسم: ${model.name!}")),
                  if (MediaQuery.of(context).size.width > 500)
                    SizedBox(
                      width: MediaQuery.of(context).size.width.toDouble() / 3,
                    ),
                  // Text(model.name!),
                  //Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          setstate(() {
                            user_model_type = model;
                            user_type_page = 1;
                          });
                        },
                        child: Text("عرض جميع المعلومات")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          setstate(() {
                            user_model_type = model;
                            user_type_page = 2;
                          });
                        },
                        child: Text("تعديل المستخدم")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              var con = TextEditingController();
                              return AlertDialog(
                                title: Text('إرسال إشعار الى ' + model.name!),
                                content: TextFormField(
                                  controller: con,
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('إلغاء'),
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                                    },
                                  ),
                                  TextButton(
                                    child: Text('إرسال'),
                                    onPressed: () {
                                      dio.get_data(url: "/fcm", quary: {"id": model.id, "body": con.text}).then((value) {
                                        print(value?.data);
                                        print(value?.data);
                                        Tost_widget("تم الارسال بنجاج", "green");
                                        Navigator.of(dialogContext).pop();
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text("إرسال إشعار")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          dio.post_data(url:"/dash/delet_id",quary: {
                            "table":" users ",
                            "id":model.id,
                          }).then((value) {
                            print(value?.data);
                            dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " users "}).then((value) {
                              value?.data.forEach((element) {
                                print(element);
                                user_list.add(user_models.fromjson(element));
                                if (user_list.length == value.data.length) {
                                  setstate(() {});
                                }
                              });
                            });
                          });
                        },
                        child: Text("حذف المستخدم")),
                  ),
                ],
              ),
            ),
          ),
        ),
        //  Spacer(),
      ],
    ),
  );
}

Widget user_detail_widget(BuildContext context, user_models? model, setstate) {
  print(MediaQuery.of(context).size.width);
  return ListView(
    shrinkWrap: true,
    children: [
      SizedBox(
        height: 30,
      ),
      Row(
        children: [
          IconButton(
              onPressed: () {
                setstate(() {
                  user_type_page = 0;
                  user_model_type = null;
                });
                if(Navigator.canPop(context)){
                  Navigator.pop(context);
                }
              },
              icon: Icon(Icons.arrow_back_ios)),
          Spacer(),
          Text(
            "عرض بيانات المستخدم",
            style: TextStyle(fontSize: 30),
          ),
          Spacer(),
        ],
      ),
      SizedBox(
        height: 30,
      ),
      Container(
        height: 30,
        width: double.infinity,
      //  color: Colors.grey.shade200,
      ),
      Container(
        height: 350,
       // color: Colors.grey.shade200,
        child: GridView(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: MediaQuery.of(context).size.width < 700 ? 1 : 2, childAspectRatio: 8),
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Center(
                  child: Text(
                "الاسم ${model?.name ?? "غيرمتوفر"}",
                style: TextStyle(fontSize: 24),
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Center(
                  child: Text(
                "الرقم التسلسلي ${model?.id ?? "غيرمتوفر"}",
                style: TextStyle(fontSize: 24),
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Center(
                  child: Text(
                "الايميل ${model?.email ?? "غيرمتوفر"}",
                style: TextStyle(fontSize: 24),
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Center(
                  child: Text(
                    "رقم الجوال ${model?.mobile_id ?? "غيرمتوفر"}",
                    style: TextStyle(fontSize: 24),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Center(
                  child: Text(
                "العنوان ${model?.address ?? "غيرمتوفر"}",
                style: TextStyle(fontSize: 24),
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Center(
                  child: Text(
                "رقم الهوية ${model?.id_number ?? "غيرمتوفر"}",
                style: TextStyle(fontSize: 24),
              )),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(4.0),
            //   child: Center(
            //       child: Text(
            //     "المفضلة ${model?.fav ?? "غيرمتوفر"}",
            //     style: TextStyle(fontSize: 24),
            //   )),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(4.0),
            //   child: Center(child: Text("المزادات المشارك بها ${model?.auctions??"غيرمتوفر"}",style: TextStyle(fontSize: 24),)),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(4.0),
            //   child: Center(child: Text("المزادات التي أنشأها ${ model?.my_auction??"غيرمتوفر"}",style: TextStyle(fontSize: 24),)),
            // ),
          ],
        ),
      ),
      SizedBox(
        height: 15,
      ),
      Container(
        height: 3,
        color: Colors.grey,
      ),
      SizedBox(
        height: 15,
      ),
      Text(
        "المفضلة",
        style: TextStyle(fontSize: 24),
      ),
      SizedBox(
        height: 10,
      ),
      if((model?.fav?.length ??0)>1)
      ListView.builder(
          itemCount: model?.fav?.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (model!.fav![index] != "") {
              return Row(
                children: [
                  Text(model.fav![index]),
                  ElevatedButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>auction_details_screen(is_redy: false,type: model.fav![index].split("|")[1],id:model!.fav![index].split("|")[0] ,)));
                   // Navigator.push(context, MaterialPageRoute(builder: (context)=>auction_details_screen(model:model,type: names,)));
                    }, child: Text("عرض")),
                ],
              );
            } else {
              return Container();
            }
          }),
      SizedBox(
        height: 15,
      ),
      Container(
        height: 3,
        color: Colors.grey,
      ),
      SizedBox(
        height: 15,
      ),
      Text(
        "المزادات المشارك بها ",
        style: TextStyle(fontSize: 24),
      ),
      SizedBox(
        height: 10,
      ),
      if((model?.auctions?.length ??0)>1)
      ListView.builder(
          itemCount: model?.auctions?.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (model!.auctions![index] != "") {
              return Row(
                children: [
                  Text(model!.auctions![index]),
                  ElevatedButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>auction_details_screen(is_redy: false,type: model!.auctions![index].split("|")[1],id:model!.auctions![index].split("|")[0] ,)));
                  }, child: Text("عرض")),
                ],
              );
            } else {
              return Container();
            }
          }),
      SizedBox(
        height: 15,
      ),
      Container(
        height: 3,
        color: Colors.grey,
      ),
      SizedBox(
        height: 15,
      ),
      Text(
        "المزادات التي أنشأها",
        style: TextStyle(fontSize: 24),
      ),
      SizedBox(
        height: 10,
      ),
      if((model?.my_auction?.length ??0)>1)
      ListView.builder(
          itemCount: model?.my_auction?.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (model!.my_auction![index] != "") {
              return Row(
                children: [
                  Text(model!.my_auction![index]),
                  ElevatedButton(onPressed: () {
                    var auc_type = model!.my_auction![index].split("|")[2];
                    var auc_id = model!.my_auction![index].split("|")[1];
                    var auc_status = model!.my_auction![index].split("|")[0];
                 if(auc_status=="0" ||auc_status=="2"||auc_status=="3"){
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>auction_details_screen(is_redy: false,type: "wait",id:auc_id ,)));
                 }else{
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>auction_details_screen(is_redy: false,type: auc_type,id:auc_id ,)));
                 }

                  }, child: Text("عرض")),
                ],
              );
            } else {
              return Container();
            }
          }),
      SizedBox(
        height: 75,
      ),
    ],
  );
}

Widget user_update_widget(BuildContext context, user_models? model, setstate) {
  var name_con = TextEditingController(text: model?.name);
  var email_con = TextEditingController(text: model?.email);
  var mobile_num_con = TextEditingController(text: model?.mobile_id);
  var address_con = TextEditingController(text: model?.address);
  var id_num_con = TextEditingController(text: model?.id_number);
  return Column(
    children: [
      SizedBox(
        height: 30,
      ),
      Row(
        children: [
          IconButton(
              onPressed: () {
                setstate(() {
                  user_type_page = 0;
                  user_model_type = null;
                });
              },
              icon: Icon(Icons.arrow_back_ios)),
          Spacer(),
          Text(
            "تعديل بيانات المستخدم",
            style: TextStyle(fontSize: 30),
          ),
          Spacer(),
        ],
      ),
      SizedBox(
        height: 30,
      ),
      Container(
        height: 30,
        width: double.infinity,
        color: Colors.grey.shade200,
      ),
      Expanded(
        child: Container(
          padding: EdgeInsets.all(8),
          color: Colors.grey.shade200,
          child: ListView(
            // gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: MediaQuery.of(context).size.width<500 ?1:2,childAspectRatio: 10),
            children: [
              Text(
                "الاسم: ",
                style: TextStyle(fontSize: 24),
              ),
              Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 3),
                  child: TextFormField(
                    controller: name_con,
                  )),
              SizedBox(
                height: 40,
              ),
              Text(
                "الايميل: ",
                style: TextStyle(fontSize: 24),
              ),
              Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 3),
                  child: TextFormField(
                    controller: email_con,
                  )),
              SizedBox(
                height: 40,
              ),
              Text(
                "العنوان: ",
                style: TextStyle(fontSize: 24),
              ),
              Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 3),
                  child: TextFormField(
                    controller: address_con,
                  )),
              SizedBox(
                height: 40,
              ),
              Text(
                "رقم الجوال: ",
                style: TextStyle(fontSize: 24),
              ),
              Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 3),
                  child: TextFormField(
                    controller: mobile_num_con,
                  )),
              SizedBox(
                height: 40,
              ),
              Text(
                "رقم الهوية: ",
                style: TextStyle(fontSize: 24),
              ),
              Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 3),
                  child: TextFormField(
                    controller: id_num_con,
                  )),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        setstate(() {
                          user_model_type = null;
                          user_type_page = 0;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("إلغاء"),
                      )),
                  SizedBox(
                    width: 100,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setstate(() {
                          is_loading_update_user = true;
                        });

                        dio.post_data(url: "/dash/" + (model == null ? "insert" : "update_id"), quary: {
                          "table": "users",
                          "id": model == null ? "" : model?.id,
                          "sql_key": model != null
                              ? " email = '" +
                                  email_con.text +
                                  "', address = '" +
                                  address_con.text +
                                  "' , name = '" +
                                  name_con.text +
                                  "' , mobile_id = '" +
                                  mobile_num_con.text +
                                  "' , id_number = '" +
                                  id_num_con.text +
                                  "'"
                              : " email , address  , name , mobile_id  , id_number  ,gsm_token ,gsm_token2 , auctions , fav , my_auction",
                          "sql_value": " '" +
                              email_con.text +
                              "', '" +
                              address_con.text +
                              "' , '" +
                              name_con.text +
                              "' , '" +
                              mobile_num_con.text +
                              "' , '" +
                              id_num_con.text +
                              "' , ' ' , ' ' , ' ' , ' ' , ' ' ",
                        }).then((value) {
                          print(value);
                          setstate(() {
                            user_model_type = null;
                            user_type_page = 0;
                            is_loading_update_user = false;
                            user_list.clear();
                            dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " users "}).then((value) {
                              value?.data.forEach((element) {
                                print(element);
                                user_list.add(user_models.fromjson(element));
                                if (user_list.length == value.data.length) {
                                  setstate(() {});
                                }
                              });
                            });
                          });
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: is_loading_update_user
                            ? Center(
                                child: CircularProgressIndicator(color: Colors.white),
                              )
                            : Text("موافق"),
                      ),
                      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.grey.shade400))),
                ],
              )
            ],
          ),
        ),
      )
    ],
  );
}

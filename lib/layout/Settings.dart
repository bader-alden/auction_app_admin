import 'dart:convert';
import 'dart:typed_data';

import 'package:auction_app_admin/utils/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';

import '../utils/const.dart';

int setting_operation = 0;
String? terms;
List faq = [];
List link_list = [];

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dio.post_data(url: "/dash/select", quary: {"table": "term", "sql": " * "}).then((value) => setState(() {
          terms = value?.data[0]['terms'].toString();
        }));
    dio.post_data(url: "/dash/select", quary: {"table": "faq", "sql": " * "}).then((value) => setState(() {
          faq = value?.data;
          print(value?.data[0]['Question']);
        }));
    dio.post_data(url: "/dash/select", quary: {"table": "social", "sql": " * "}).then((value) => setState(() {
          link_list = value?.data;
          print(value?.data);
        }));
  }

  @override
  Widget build(BuildContext context) {
    if (setting_operation == 1) {
      if (terms != null) {
        var con = TextEditingController(text: terms);
        return Scaffold(
          body: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          setting_operation = 0;
                        });
                      },
                      icon: Icon(Icons.arrow_back_ios_new)),
                  Spacer(),
                  Text(
                    "سياسة الخصوصية",
                    style: TextStyle(fontSize: 25),
                  ),
                  Spacer()
                ],
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    color: Colors.grey.shade200,
                    child: TextFormField(
                      maxLines: null,
                      controller: con,
                      decoration: InputDecoration(border: InputBorder.none),
                    )),
              )),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          setting_operation = 0;
                        });
                      },
                      child: Text("إلغاء")),
                  SizedBox(
                    width: 50,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        dio.post_data(url: "/dash/update_id", quary: {"table": "term", "sql_key": "terms = '" + con.text + "'", "id": "1"}).then(
                            (value) {
                          dio.post_data(url: "/dash/select", quary: {"table": "term", "sql": " * "}).then((value) => setState(() {
                                terms = value?.data[0]['terms'].toString();
                                setting_operation = 0;
                              }));
                        });
                      },
                      child: Text("حفظ")),
                ],
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        );
      } else {
        return Scaffold(
          body: Text("Terms"),
        );
      }
    }
    if (setting_operation == 2) {
      return Scaffold(
        body: Column(children: [
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      setting_operation = 0;
                    });
                  },
                  icon: Icon(Icons.arrow_back_ios_new)),
              Spacer(),
              Text(
                "الاسئلة المتكررة",
                style: TextStyle(fontSize: 25),
              ),
              Spacer(),
              ElevatedButton(
                  onPressed: () {
                    var q_con = TextEditingController();
                    var a_con = TextEditingController();
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: Text('التفاصيل', textDirection: TextDirection.rtl),
                          content: Container(
                            height: 500,
                            width: 500,
                            child: ListView(
                              children: [
                                Text("السؤال:", textDirection: TextDirection.rtl),
                                TextFormField(
                                  controller: q_con,
                                  textDirection: TextDirection.rtl,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text("الجواب:", textDirection: TextDirection.rtl),
                                TextFormField(
                                  controller: a_con,
                                  textDirection: TextDirection.rtl,
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('إلغاء'),
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            TextButton(
                              child: Text('موافق'),
                              onPressed: () {
                                dio.post_data(url: "/dash/insert", quary: {
                                  "table": "faq",
                                  "sql_key": " Question , Answer ",
                                  "sql_value": "'${q_con.text}' , '${a_con.text}'"
                                }).then((value) {
                                  print(value?.data);
                                  dio.post_data(url: "/dash/select", quary: {"table": "faq", "sql": " * "}).then((value) => setState(() {
                                        faq = value?.data;
                                        Navigator.of(dialogContext).pop();
                                      }));
                                });
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text("إنشاء")),
              SizedBox(
                width: 60,
              ),
            ],
          ),
          Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: faq.length,
                  itemBuilder: (contex, index) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Text(faq[index]['Question']),
                            //Spacer(),
                            SizedBox(
                              width: 50,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  showDialog<void>(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: Text('التفاصيل', textDirection: TextDirection.rtl),
                                        content: Container(
                                          height: 500,
                                          width: 500,
                                          child: ListView(
                                            children: [
                                              Text("السؤال:", textDirection: TextDirection.rtl),
                                              Text(faq[index]['Question'], textDirection: TextDirection.rtl),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text("الجواب:", textDirection: TextDirection.rtl),
                                              Text(faq[index]['Answer'], textDirection: TextDirection.rtl),
                                            ],
                                          ),
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
                                },
                                child: Text("عرض")),
                            SizedBox(
                              width: 30,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  var q_con = TextEditingController(text: faq[index]['Question']);
                                  var a_con = TextEditingController(text: faq[index]['Answer']);
                                  showDialog<void>(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: Text('التفاصيل', textDirection: TextDirection.rtl),
                                        content: Container(
                                          height: 500,
                                          width: 500,
                                          child: ListView(
                                            children: [
                                              Text("السؤال:", textDirection: TextDirection.rtl),
                                              TextFormField(
                                                controller: q_con,
                                                textDirection: TextDirection.rtl,
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text("الجواب:", textDirection: TextDirection.rtl),
                                              TextFormField(
                                                controller: a_con,
                                                textDirection: TextDirection.rtl,
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('إلغاء'),
                                            onPressed: () {
                                              Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                                            },
                                          ),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          TextButton(
                                            child: Text('موافق'),
                                            onPressed: () {
                                              dio.post_data(url: "/dash/update_id", quary: {
                                                "table": "faq",
                                                "sql_key": " Question = '${q_con.text}' , Answer = '${a_con.text}'",
                                                "id": faq[index]['id']
                                              }).then((value) {
                                                print(value?.data);
                                                dio.post_data(url: "/dash/select", quary: {"table": "faq", "sql": " * "}).then(
                                                    (value) => setState(() {
                                                          faq = value?.data;
                                                          Navigator.of(dialogContext).pop();
                                                        }));
                                              });
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text("تعديل")),
                            SizedBox(
                              width: 30,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  dio.post_data(url: "/dash/delet_id", quary: {"table": "faq", "id": faq[index]['id']}).then((value) {
                                    dio.post_data(url: "/dash/select", quary: {"table": "faq", "sql": " * "}).then((value) => setState(() {
                                          faq = value?.data;
                                          print(value?.data[0]['Question']);
                                        }));
                                  });
                                },
                                child: Text("حذف")),
                            SizedBox(
                              width: 60,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    );
                  }))
        ]),
      );
    }
    if (setting_operation == 3) {
      return Scaffold(
        body: Column(children: [
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      setting_operation = 0;
                    });
                  },
                  icon: Icon(Icons.arrow_back_ios_new)),
              Spacer(),
              Text(
                "التواصل الاجتماعي",
                style: TextStyle(fontSize: 25),
              ),
              Spacer(),
              ElevatedButton(
                  onPressed: () {
                    var name_con = TextEditingController();
                    var link_con = TextEditingController();
                    var s ;
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: Text('التفاصيل', textDirection: TextDirection.rtl),
                          content: Container(
                            height: 500,
                            width: 500,
                            child: ListView(
                              children: [
                                Text("الاسم:", textDirection: TextDirection.rtl),
                                TextFormField(
                                  controller: name_con,
                                  textDirection: TextDirection.rtl,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text("الرابط:", textDirection: TextDirection.rtl),
                                TextFormField(
                                  controller: link_con,
                                  textDirection: TextDirection.rtl,
                                ),
                                SizedBox(
                                  height: 20,
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
                                        FormData formData =
                                            FormData.fromMap({"file": await MultipartFile.fromBytes(image.toList(), filename: name_con.text)});
                                        dio.post_data(url: "/uplode/uplode", data: formData).then((value) {
                                          Tost_widget("تم رفع الصورة", "green");
                                          s = value?.data["message"];
                                          Navigator.pop(context);
                                        });
                                        showDialog<void>(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Container(height: 50, width: 50, child: CircularProgressIndicator()),
                                            );
                                          },
                                        );
                                      }
                                    },
                                    child: Text("تغيير الصورة")),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('إلغاء'),
                              onPressed: () {
                                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                              },
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            TextButton(
                                child: Text('موافق'),
                                onPressed: () {
                                  dio.post_data(url: "/dash/insert", quary: {
                                    "table": "social",
                                    "sql_key": " name , link , photo ",
                                    "sql_value": "'${name_con.text}' , '${link_con.text}' , '${s}' "
                                  }).then((value) {
                                    print(value?.data);
                                    dio.post_data(url: "/dash/select", quary: {"table": "social", "sql": " * "}).then((value) => setState(() {
                                      link_list = value?.data;
                                      Navigator.of(dialogContext).pop();
                                    }));
                                  });
                                })
                          ],
                        );
                      },
                    );
                  },
                  child: Text("إنشاء")),
              SizedBox(
                width: 60,
              ),
            ],
          ),
          Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: link_list.length,
                  itemBuilder: (contex, index) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Text(link_list[index]['name']),
                            //Spacer(),
                            SizedBox(
                              width: 50,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  showDialog<void>(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: Text('التفاصيل', textDirection: TextDirection.rtl),
                                        content: Container(
                                          height: 500,
                                          width: 500,
                                          child: ListView(
                                            children: [
                                              Text("الاسم:", textDirection: TextDirection.rtl),
                                              Text(link_list[index]['name'], textDirection: TextDirection.rtl),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text("الرايط:", textDirection: TextDirection.rtl),
                                              Text(link_list[index]['link'], textDirection: TextDirection.rtl),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text("الصورة:", textDirection: TextDirection.rtl),
                                              Image.network(link_list[index]['photo'], height: 50),
                                            ],
                                          ),
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
                                },
                                child: Text("عرض")),
                            SizedBox(
                              width: 30,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  var name_con = TextEditingController(text: link_list[index]['name']);
                                  var link_con = TextEditingController(text: link_list[index]['link']);
                                  var s = link_list[index]['photo'];
                                  showDialog<void>(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: Text('التفاصيل', textDirection: TextDirection.rtl),
                                        content: Container(
                                          height: 500,
                                          width: 500,
                                          child: ListView(
                                            children: [
                                              Text("الاسم:", textDirection: TextDirection.rtl),
                                              TextFormField(
                                                controller: name_con,
                                                textDirection: TextDirection.rtl,
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text("الرابط:", textDirection: TextDirection.rtl),
                                              TextFormField(
                                                controller: name_con,
                                                textDirection: TextDirection.rtl,
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Image.network(s, height: 50),
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
                                                        s = value?.data["message"];
                                                        Navigator.pop(context);
                                                      });
                                                      showDialog<void>(
                                                        context: context,
                                                        barrierDismissible: false,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: Container(height: 50, width: 50, child: CircularProgressIndicator()),
                                                          );
                                                        },
                                                      );
                                                    }
                                                  },
                                                  child: Text("تغيير الصورة")),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('إلغاء'),
                                            onPressed: () {
                                              Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                                            },
                                          ),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          TextButton(
                                            child: Text('موافق'),
                                            onPressed: () {
                                              dio.post_data(url: "/dash/update_id", quary: {
                                                "table": "social",
                                                "sql_key": " name = '${name_con.text}' , link = '${link_con.text}' , photo = '${s}'",
                                                "id": link_list[index]['id']
                                              }).then((value) {
                                                print(value?.data);
                                                dio.post_data(url: "/dash/select", quary: {"table": "social", "sql": " * "}).then(
                                                    (value) => setState(() {
                                                          link_list = value?.data;
                                                          Navigator.of(dialogContext).pop();
                                                        }));
                                              });
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text("تعديل")),
                            SizedBox(
                              width: 30,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  dio.post_data(url: "/dash/delet_id", quary: {"table": "social", "id": link_list[index]['id']}).then((value) {
                                    dio.post_data(url: "/dash/select", quary: {"table": "social", "sql": " * "}).then((value) => setState(() {
                                          link_list = value?.data;
                                        }));
                                  });
                                },
                                child: Text("حذف")),
                            SizedBox(
                              width: 60,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    );
                  }))
        ]),
      );
    } else {
      return Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "الاعدادت العامة",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        setting_operation = 1;
                      });
                    },
                    child: Row(children: [
                      Icon(Icons.circle, size: 20),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "سياسة الخصوصية",
                        style: TextStyle(fontSize: 25),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(Icons.arrow_back_ios_new),
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        setting_operation = 2;
                      });
                    },
                    child: Row(children: [
                      Icon(Icons.circle, size: 20),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "الاسئلة المتكررة",
                        style: TextStyle(fontSize: 25),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(Icons.arrow_back_ios_new),
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        setting_operation = 3;
                      });
                    },
                    child: Row(children: [
                      Icon(Icons.circle, size: 20),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "التواصل الاجتماعي",
                        style: TextStyle(fontSize: 25),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(Icons.arrow_back_ios_new),
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: InkWell(
                    onTap: () {
                      // setState((){
                      //   //setting_operation=5;
                      //
                      // });
                      dio.post_data(url: "/dash/select", quary: {"table": "version", "sql": " * "}).then((value) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              var text_con = TextEditingController(text: value?.data[0]['version']);
                              return AlertDialog(
                                title: Text("تحذير : تغيير الإصدار بؤدي لطلب تحديث من مستخدمين التطبيق"),
                                content: TextFormField(controller: text_con),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        dio.post_data(url: "/dash/update_id", quary: {
                                          "table": "version",
                                          "sql_key": " version = '${text_con.text}' ",
                                          "id": 1
                                        }).then((value) => Navigator.pop(context));
                                      },
                                      child: Text("موافق"),
                                      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.green))),
                                  ElevatedButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("إلغاء"),
                                      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red))),
                                ],
                              );
                            });
                      });
                    },
                    child: Row(children: [
                      Icon(Icons.circle, size: 20),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "الإصدار",
                        style: TextStyle(fontSize: 25),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(Icons.arrow_back_ios_new),
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: InkWell(
                    onTap: () {
                      // setState((){
                      //   //setting_operation=5;
                      //
                      // });
                      dio.post_data(url: "/dash/select", quary: {"table": "term", "sql": " * "}).then((value) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              var text_con = TextEditingController(text: value?.data[0]['the_support']);
                              return AlertDialog(
                                title: Text("تحديث رابط الدعم الفني"),
                                content: TextFormField(controller: text_con),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        dio.post_data(url: "/dash/update_id", quary: {
                                          "table": "term",
                                          "sql_key": " the_support = '${text_con.text}' ",
                                          "id": 1
                                        }).then((value) => Navigator.pop(context));
                                      },
                                      child: Text("موافق"),
                                      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.green))),
                                  ElevatedButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("إلغاء"),
                                      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red))),
                                ],
                              );
                            });
                      });
                    },
                    child: Row(children: [
                      Icon(Icons.circle, size: 20),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "الدعم الفني",
                        style: TextStyle(fontSize: 25),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(Icons.arrow_back_ios_new),
                    ]),
                  ),
                ),
              ],
            ))
          ],
        ),
      );
    }
  }
}

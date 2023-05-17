import 'package:auction_app_admin/utils/dio.dart';
import 'package:flutter/material.dart';

List account = [];
List add_rule = [];
bool rule_init = false;
bool check_1 = false;
bool check_2 = false;
bool check_3 = false;
bool check_4 = false;
bool check_5 = false;
bool check_6 = false;
bool check_7 = false;
bool check_8 = false;
bool check_9 = false;
bool check_10 = false;

class ChangeRule extends StatefulWidget {
  const ChangeRule({Key? key}) : super(key: key);

  @override
  _ChangeRuleState createState() => _ChangeRuleState();
}

class _ChangeRuleState extends State<ChangeRule> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dio.post_data(url: "/dash/select", quary: {"table": "dashboard", "sql": "*"}).then((value) {
      setState(() {
        account = value?.data;
      });
    });
  }
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    add_rule.clear();
    rule_init=false;
    check_1 = false;
    check_2 = false;
    check_3 = false;
    check_4 = false;
    check_5 = false;
    check_6 = false;
    check_7 = false;
    check_8 = false;
    check_9 = false;
    check_10 = false;
  }
  @override
  Widget build(BuildContext context) {
    if (account.isNotEmpty) {
      return Scaffold(
        body: Column(children: [
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Spacer(),
              Text(
                "تغيير الصلاحيات ",
                style: TextStyle(fontSize: 25),
              ),
              Spacer(),
              ElevatedButton(
                  onPressed: () {
                    var user_con = TextEditingController();
                    var pass_con = TextEditingController();
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: Text('التفاصيل', textDirection: TextDirection.rtl),
                          content: Container(
                            height: 700,
                            width: 500,
                            child: StatefulBuilder(builder: (context, setstate) {
                              return ListView(
                                children: [
                                  Text("الاسم:", textDirection: TextDirection.rtl),
                                  TextFormField(
                                    controller: user_con,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text("كلمة السر:", textDirection: TextDirection.rtl),
                                  TextFormField(
                                    controller: pass_con,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  Text("المستخدمين", textDirection: TextDirection.rtl),
                                  Checkbox(
                                      value: check_1,
                                      onChanged: (value) => setstate(() {
                                            check_1 = !check_1;
                                          value!? add_rule.add("users"):add_rule.remove("users");
                                          })),
                                  Text("الفئات", textDirection: TextDirection.rtl),
                                  Checkbox(
                                      value: check_2,
                                      onChanged: (value) => setstate(() {
                                            check_2 = !check_2;
                                            value! ? add_rule.add("type"): add_rule.remove("type");
                                          })),
                                  Text("تفاصيل الفئات", textDirection: TextDirection.rtl),
                                  Checkbox(
                                      value: check_3,
                                      onChanged: (value) => setstate(() {
                                            check_3 = !check_3;
                                            value! ?  add_rule.add("type_details"): add_rule.remove("type_details");
                                          })),
                                  Text("قبول المزادات", textDirection: TextDirection.rtl),
                                  Checkbox(
                                      value: check_4,
                                      onChanged: (value) => setstate(() {
                                            check_4 = !check_4;
                                            value! ? add_rule.add("accept_auction"):add_rule.remove("accept_auction");
                                          })),
                                  Text("قبول الدفعات", textDirection: TextDirection.rtl),
                                  Checkbox(
                                      value: check_5,
                                      onChanged: (value) => setstate(() {
                                            check_5 = !check_5;
                                            value! ?  add_rule.add("accept_money"):add_rule.remove("accept_money");
                                          })),
                                  Text("الشكاوي", textDirection: TextDirection.rtl),
                                  Checkbox(
                                      value: check_6,
                                      onChanged: (value) => setstate(() {
                                            check_6 = !check_6;
                                            value! ?  add_rule.add("repo"):add_rule.remove("repo");
                                          })),
                                  Text("الإعدادت العامة", textDirection: TextDirection.rtl),
                                  Checkbox(
                                      value: check_7,
                                      onChanged: (value) => setstate(() {
                                            check_7 = !check_7;
                                            value! ?    add_rule.add("setting"):add_rule.remove("setting");
                                          })),
                                  Text("تغيير الصلاحيات", textDirection: TextDirection.rtl),
                                  Checkbox(
                                      value: check_8,
                                      onChanged: (value) => setstate(() {
                                            check_8 = !check_8;
                                            value! ?    add_rule.add("rule"):add_rule.remove("rule");
                                          })),
                                  Text("نسخ احتياطي للمعلومات", textDirection: TextDirection.rtl),
                                  Checkbox(
                                      value: check_9,
                                      onChanged: (value) => setstate(() {
                                        check_9 = !check_9;
                                        value! ?    add_rule.add("backup"):add_rule.remove("backup");
                                      })), Text("تغيير المدن", textDirection: TextDirection.rtl),
                                  Checkbox(
                                      value: check_10,
                                      onChanged: (value) => setstate(() {
                                        check_10 = !check_10;
                                        value! ?    add_rule.add("city"):add_rule.remove("city");
                                      })),
                                ],
                              );
                            }),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('إلغاء'),
                              onPressed: () {
                                add_rule.clear();
                                rule_init=false;
                                check_1 = false;
                                check_2 = false;
                                check_3 = false;
                                check_4 = false;
                                check_5 = false;
                                check_6 = false;
                                check_7 = false;
                                check_8 = false;
                                check_9 = false;
                                check_10 = false;
                                Navigator.of(dialogContext).pop();
                              },
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            TextButton(
                              child: Text('موافق'),
                              onPressed: () {
                                String s = "";
                                for (int i = 0; i < add_rule.length; i++) {
                                  s = s + add_rule[i];
                                  if (i + 1 != add_rule.length) {
                                    s = s + "|";
                                  }
                                  print(s);
                                }
                                dio.post_data(url: "/dash/insert", quary: {
                                  "table": "dashboard",
                                  "sql_key": " pass , user , rule ",
                                  "sql_value": "'${pass_con.text}' , '${user_con.text}', '${s}'"
                                }).then((value) {
                                  print(value?.data);
                                  dio.post_data(url: "/dash/select", quary: {"table": "dashboard", "sql": " * "}).then((value) => setState(() {
                                        account = value?.data;
                                        rule_init=false;
                                        check_1 = false;
                                        check_2 = false;
                                        check_3 = false;
                                        check_4 = false;
                                        check_5 = false;
                                        check_6 = false;
                                        check_7 = false;
                                        check_8 = false;
                                        check_9 = false;
                                        check_10 = false;
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
          SizedBox(
            height: 30,
          ),
          Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: account.length,
                  itemBuilder: (contex, index) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Text(account[index]['user']),
                            //Spacer(),
                            SizedBox(
                              width: 50,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  var user_con = TextEditingController(text: account[index]['user']);
                                  var pass_con = TextEditingController(text: account[index]['pass']);
                                  if (!rule_init) {
                                    rule_init = true;
                                    add_rule = account[index]['rule'].runtimeType ==String?account[index]['rule'].toString().split("|"):account[index]['rule'];
                                    if (account[index]['rule'].contains("users")) {
                                      check_1 = true;
                                    }
                                    if (account[index]['rule'].contains("type")) {
                                      check_2 = true;
                                    }
                                    if (account[index]['rule'].contains("type_details")) {
                                      check_3 = true;
                                    }
                                    if (account[index]['rule'].contains("accept_auction")) {
                                      check_4 = true;
                                    }
                                    if (account[index]['rule'].contains("accept_money")) {
                                      check_5 = true;
                                    }
                                    if (account[index]['rule'].contains("repo")) {
                                      check_6 = true;
                                    }
                                    if (account[index]['rule'].contains("setting")) {
                                      check_7 = true;
                                    }
                                    if (account[index]['rule'].contains("rule")) {
                                      check_8 = true;
                                    }
                                    if (account[index]['rule'].contains("backup")) {
                                      check_9 = true;
                                    }
                                    if (account[index]['rule'].contains("city")) {
                                      check_10 = true;
                                    }
                                  }
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: Text('التفاصيل', textDirection: TextDirection.rtl),
                                        content: Container(
                                          height: 700,
                                          width: 500,
                                          child: StatefulBuilder(builder: (context, setstate) {
                                            return ListView(
                                              children: [
                                                Text("الاسم:", textDirection: TextDirection.rtl),
                                                TextFormField(
                                                  controller: user_con,
                                                  textDirection: TextDirection.rtl,
                                                  readOnly: true,
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Text("كلمة السر:", textDirection: TextDirection.rtl),
                                                TextFormField(
                                                  controller: pass_con,
                                                  textDirection: TextDirection.rtl,
                                                  readOnly: true,
                                                ),
                                                Text("المستخدمين", textDirection: TextDirection.rtl),
                                                Checkbox(
                                                    value: check_1,
                                                    onChanged: (value) {}),
                                                Text("الفئات", textDirection: TextDirection.rtl),
                                                Checkbox(
                                                    value: check_2,
                                                    onChanged: (value) {}),
                                                Text("تفاصيل الفئات", textDirection: TextDirection.rtl),
                                                Checkbox(
                                                    value: check_3,
                                                    onChanged: (value) {}),
                                                Text("قبول المزادات", textDirection: TextDirection.rtl),
                                                Checkbox(
                                                    value: check_4,
                                                    onChanged: (value) {}),
                                                Text("قبول الدفعات", textDirection: TextDirection.rtl),
                                                Checkbox(
                                                    value: check_5,
                                                    onChanged: (value) {}),
                                                Text("الشكاوي", textDirection: TextDirection.rtl),
                                                Checkbox(
                                                    value: check_6,
                                                    onChanged: (value) {}),
                                                Text("الإعدادت العامة", textDirection: TextDirection.rtl),
                                                Checkbox(
                                                    value: check_7,
                                                    onChanged: (value) {}),
                                                Text("تغيير الصلاحيات", textDirection: TextDirection.rtl),
                                                Checkbox(
                                                    value: check_8,
                                                    onChanged: (value) {}),
                                                Text("النسخ الاحتياطي للمعلومات ", textDirection: TextDirection.rtl),
                                                Checkbox(
                                                    value: check_9,
                                                    onChanged: (value) {}),
                                                Text("تغيير المدن", textDirection: TextDirection.rtl),
                                                Checkbox(
                                                    value: check_10,
                                                    onChanged: (value) {}),
                                              ],
                                            );
                                          }),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('إلغاء'),
                                            onPressed: () {
                                              add_rule.clear();
                                              rule_init=false;
                                              check_1 = false;
                                              check_2 = false;
                                              check_3 = false;
                                              check_4 = false;
                                              check_5 = false;
                                              check_6 = false;
                                              check_7 = false;
                                              check_8 = false;
                                              check_9 = false;
                                              check_10 = false;
                                              Navigator.of(dialogContext).pop();
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
                                  var user_con = TextEditingController(text: account[index]['user']);
                                  var pass_con = TextEditingController(text: account[index]['pass']);
                                  if (!rule_init) {
                                    rule_init = true;
                                    add_rule = account[index]['rule'].runtimeType ==String?account[index]['rule'].toString().split("|"):account[index]['rule'];
                                    if (account[index]['rule'].contains("users")) {
                                      check_1 = true;
                                    }
                                    if (account[index]['rule'].contains("type")) {
                                      check_2 = true;
                                    }
                                    if (account[index]['rule'].contains("type_details")) {
                                      check_3 = true;
                                    }
                                    if (account[index]['rule'].contains("accept_auction")) {
                                      check_4 = true;
                                    }
                                    if (account[index]['rule'].contains("accept_money")) {
                                      check_5 = true;
                                    }
                                    if (account[index]['rule'].contains("repo")) {
                                      check_6 = true;
                                    }
                                    if (account[index]['rule'].contains("setting")) {
                                      check_7 = true;
                                    }
                                    if (account[index]['rule'].contains("rule")) {
                                      check_8 = true;
                                    }
                                    if (account[index]['rule'].contains("backup")) {
                                      check_9 = true;
                                    }
                                    if (account[index]['rule'].contains("city")) {
                                      check_10 = true;
                                    }
                                  }
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: Text('التفاصيل', textDirection: TextDirection.rtl),
                                        content: Container(
                                          height: 700,
                                          width: 500,
                                          child: StatefulBuilder(builder: (context, setstate) {
                                            return ListView(
                                              children: [
                                                Text("الاسم:", textDirection: TextDirection.rtl),
                                                TextFormField(
                                                  controller: user_con,
                                                  textDirection: TextDirection.rtl,
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Text("كلمة السر:", textDirection: TextDirection.rtl),
                                                TextFormField(
                                                  controller: pass_con,
                                                  textDirection: TextDirection.rtl,
                                                ),
                                                Text("المستخدمين", textDirection: TextDirection.rtl),
                                                Checkbox(
                                                    value: check_1,
                                                    onChanged: (value) => setstate(() {
                                                      check_1 = !check_1;
                                                      value!? add_rule.add("users"):add_rule.remove("users");
                                                    })),
                                                Text("الفئات", textDirection: TextDirection.rtl),
                                                Checkbox(
                                                    value: check_2,
                                                    onChanged: (value) => setstate(() {
                                                      check_2 = !check_2;
                                                      value! ? add_rule.add("type"): add_rule.remove("type");
                                                    })),
                                                Text("تفاصيل الفئات", textDirection: TextDirection.rtl),
                                                Checkbox(
                                                    value: check_3,
                                                    onChanged: (value) => setstate(() {
                                                      check_3 = !check_3;
                                                      value! ?  add_rule.add("type_details"): add_rule.remove("type_details");
                                                    })),
                                                Text("قبول المزادات", textDirection: TextDirection.rtl),
                                                Checkbox(
                                                    value: check_4,
                                                    onChanged: (value) => setstate(() {
                                                      check_4 = !check_4;
                                                      value! ? add_rule.add("accept_auction"):add_rule.remove("accept_auction");
                                                    })),
                                                Text("قبول الدفعات", textDirection: TextDirection.rtl),
                                                Checkbox(
                                                    value: check_5,
                                                    onChanged: (value) => setstate(() {
                                                      check_5 = !check_5;
                                                      value! ?  add_rule.add("accept_money"):add_rule.remove("accept_money");
                                                    })),
                                                Text("الشكاوي", textDirection: TextDirection.rtl),
                                                Checkbox(
                                                    value: check_6,
                                                    onChanged: (value) => setstate(() {
                                                      check_6 = !check_6;
                                                      value! ?  add_rule.add("repo"):add_rule.remove("repo");
                                                    })),
                                                Text("الإعدادت العامة", textDirection: TextDirection.rtl),
                                                Checkbox(
                                                    value: check_7,
                                                    onChanged: (value) => setstate(() {
                                                      check_7 = !check_7;
                                                      value! ?    add_rule.add("setting"):add_rule.remove("setting");
                                                    })),
                                                Text("تغيير الصلاحيات", textDirection: TextDirection.rtl),
                                                Checkbox(
                                                    value: check_8,
                                                    onChanged: (value) => setstate(() {
                                                      check_8 = !check_8;
                                                      value! ?    add_rule.add("rule"):add_rule.remove("rule");
                                                    })),
                                                Text("نسخ احتياطي للمعلومات", textDirection: TextDirection.rtl),
                                                Checkbox(
                                                    value: check_9,
                                                    onChanged: (value) => setstate(() {
                                                      check_9 = !check_9;
                                                      value! ?    add_rule.add("backup"):add_rule.remove("backup");
                                                    })), Text("تغيير المدن", textDirection: TextDirection.rtl),
                                                Checkbox(
                                                    value: check_10,
                                                    onChanged: (value) => setstate(() {
                                                      check_10 = !check_10;
                                                      value! ?    add_rule.add("city"):add_rule.remove("city");
                                                    })),
                                              ],
                                            );
                                          }),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('إلغاء'),
                                            onPressed: () {
                                              add_rule.clear();
                                              rule_init=false;
                                               check_1 = false;
                                               check_2 = false;
                                               check_3 = false;
                                               check_4 = false;
                                               check_5 = false;
                                               check_6 = false;
                                               check_7 = false;
                                               check_8 = false;
                                              check_9 = false;
                                              check_10 = false;
                                              Navigator.of(dialogContext).pop();
                                            },
                                          ),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          TextButton(
                                            child: Text('موافق'),
                                            onPressed: () {
                                              String s = "";
                                              for (int i = 0; i < add_rule.length; i++) {
                                                s = s + add_rule[i];
                                                if (i + 1 != add_rule.length) {
                                                  s = s + "|";
                                                }
                                                print(s);
                                              }
                                              dio.post_data(url: "/dash/update_id", quary: {
                                                "table": "dashboard",
                                                "sql_key": " pass = '${pass_con.text}' , user =  '${user_con.text}' , rule = '${s}' ",
                                                "id":account[index]['id']
                                              }).then((value) {
                                                print(value?.data);
                                                dio.post_data(url: "/dash/select", quary: {"table": "dashboard", "sql": " * "}).then(
                                                    (value) => setState(() {
                                                          account = value?.data;
                                                          add_rule.clear();
                                                          rule_init=false;
                                                          check_1 = false;
                                                          check_2 = false;
                                                          check_3 = false;
                                                          check_4 = false;
                                                          check_5 = false;
                                                          check_6 = false;
                                                          check_7 = false;
                                                          check_8 = false;
                                                          check_9 = false;
                                                          check_10 = false;
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
                                  dio.post_data(url: "/dash/delet_id",quary: {"table":"dashboard","id":account[index]['id']}).then((value) {
                                    dio.post_data(url:"/dash/select",quary: {"table":"dashboard","sql":" * "}).then((value) => setState((){account=value?.data;}));
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
      return Scaffold();
    }
  }
}

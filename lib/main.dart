import 'dart:html';
import 'dart:html' as html;
import 'package:auction_app_admin/layout/change_pass.dart';
import 'package:auction_app_admin/layout/change_rule.dart';
import 'package:auction_app_admin/layout/cities.dart';
import 'package:auction_app_admin/utils/dio.dart';
import 'package:auction_app_admin/utils/hive.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'layout/Accept_auction.dart';
import 'layout/Accept_money.dart';
import 'layout/Auction_main.dart';
import 'layout/Auction_type.dart';
import 'layout/Login.dart';
import 'layout/Repo.dart';
import 'layout/Settings.dart';
import 'layout/Users.dart';
import 'layout/bauckup.dart';
import 'layout/dashboard.dart';
String getOSInsideWeb() {
  final userAgent = window.navigator.userAgent.toString().toLowerCase();
  if( userAgent.contains("iphone"))  return "ios";
  if( userAgent.contains("ipad")) return "ios";
  if( userAgent.contains("android"))  return "Android";
  return "Web";
}
 main() async {
   String platform = "";
   if (kIsWeb) {
     platform = getOSInsideWeb();
   }
   if(platform == "Android" ||platform =="ios" ){
     is_open = false;
   }else{
     is_open = true;
   }
  WidgetsFlutterBinding.ensureInitialized();
  dio.init();
  await hive.init();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'أوكشن السعودية',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home:  Login(),
      // home: const MyHomePage(title: 'easy_sidemenu Demo'),
      debugShowCheckedModeBanner: false,
    );
  }
}

SideMenuController page = SideMenuController();
var page_con = PageController();
bool is_open = true;
class MyHomePage extends StatefulWidget {
   MyHomePage({Key? key, required this.rule}) : super(key: key);
  final String rule;

  @override
  _MyHomePageState createState() => _MyHomePageState(rule);
}

class _MyHomePageState extends State<MyHomePage> {
  String? rule;
  _MyHomePageState(this.rule);

  @override
  Widget build(BuildContext context) {
    List<String> list_rule = rule!.split("|");
    //print(list_rule);
    return Directionality(
    textDirection: TextDirection.rtl,
      child: Scaffold(
          body: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SideMenu(
                controller: page,
                style: SideMenuStyle(
                  showTooltip: false,
                  displayMode: is_open?SideMenuDisplayMode.open:SideMenuDisplayMode.compact,
                  hoverColor: Colors.blue[100],
                  selectedColor: Colors.lightBlue,
                  selectedTitleTextStyle: const TextStyle(color: Colors.white),
                  selectedIconColor: Colors.white,
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.all(Radius.circular(10)),
                  // ),
                  // backgroundColor: Colors.blueGrey[700]
                ),
                title: Column(
                  children: [
                    SizedBox(height: 10,),
                    ElevatedButton(onPressed: (){
                      setState(() {
                        is_open=!is_open;
                      });
                    }, child: Container(width: double.infinity,child: Icon(Icons.menu_open))),
                    SizedBox(height: 20,),
                    ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 200,
                          maxWidth: 200,
                        ),
                        child: Image.asset("assets/logo.png")
                    ),
                    SizedBox(height: 20,),
                    const Divider(
                      indent: 8.0,
                      endIndent: 8.0,
                    ),
                  ],
                ),
                items: [
                  SideMenuItem(
                    priority: 0,
                    title: 'الصفحة الرئيسية',
                    onTap: (index,con) {
                      page.changePage(0);
                      page_con.jumpToPage(index);
                    },
                    icon: const Icon(Icons.home),
                  ),
                  if(list_rule.contains("users"))
                  SideMenuItem(
                    priority: 1,
                    title: 'المستخدمين',
                    onTap: (index,con) {
                      page.changePage(1);
                      page_con.jumpToPage(index);
                    },
                    icon: const Icon(Icons.supervisor_account),
                  ),
                    if(list_rule.contains("type"))
                  SideMenuItem(
                    priority: 2,
                    title: 'الفئات',
                    onTap: (index,con) {
                      page.changePage(2);
                      page_con.jumpToPage(index);
                    },
                    icon: const Icon(Icons.file_copy),
                    trailing: Container(
                        decoration: const BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 3),
                          child: Text(
                            'جديد',
                            style: TextStyle(fontSize: 11, color: Colors.grey[800]),
                          ),
                        )),
                  ),
                     if(list_rule.contains("type_details"))
                  SideMenuItem(
                    priority: 3,
                    title: 'تفاصيل الفئات',
                    onTap: (index,con) {
                      page.changePage(3);
                      page_con.jumpToPage(index);
                    },
                    icon: const Icon(Icons.auto_awesome_mosaic),
                  ),
                      if(list_rule.contains("accept_auction"))
                  SideMenuItem(
                    priority: 4,
                    title: 'قبول المزادات',
                    onTap: (index,con) {
                      page.changePage(4);
                      page_con.jumpToPage(index);
                    },
                    icon: const Icon(Icons.add_task),
                  ),
                  if(list_rule.contains("accept_money"))
                    SideMenuItem(
                      priority: 5,
                      title: 'قبول الدفعات',
                      onTap: (index,con) {
                        page.changePage(5);
                        page_con.jumpToPage(index);
                      },
                      icon: const Icon(Icons.monetization_on),
                    ),
                     if(list_rule.contains("repo"))
                  SideMenuItem(
                    priority: 6,
                    title: 'الشكاوي',
                    onTap: (index,con) {
                      page.changePage(6);
                      page_con.jumpToPage(index);
                    },
                    icon: const Icon(Icons.list_alt_sharp),
                  ),
                  if(list_rule.contains("city"))
                    SideMenuItem(
                      priority: 7,
                      title: "مدن المملكة",
                      onTap: (index,con) {
                        page.changePage(7);
                        page_con.jumpToPage(index);
                      },
                      icon: const Icon(Icons.location_city),
                    ),
                       if(list_rule.contains("setting"))
                  SideMenuItem(
                    priority: 8,
                    title: 'الإعدادات العامة',
                    onTap: (index,con) {
                      page.changePage(8);
                      page_con.jumpToPage(index);
                    },
                    icon: const Icon(Icons.settings),
                  ),
                  if(list_rule.contains("backup"))
                  SideMenuItem(
                    priority: 9,
                    title: 'النسخ الاحتياطي',
                    onTap: (index,con) {
                      page.changePage(9);
                      page_con.jumpToPage(index);
                    },
                    icon: const Icon(Icons.settings),
                  ),
                  SideMenuItem(
                    priority: 10,
                    title: 'تغيير كلمة المرور',
                    onTap: (index,con) {
                      page.changePage(10);
                      page_con.jumpToPage(index);
                    },
                    icon: const Icon(Icons.password),
                  ),
                  if(list_rule.contains("rule"))
                  SideMenuItem(
                    priority: 11,
                    title: 'تغيير الصلاحيات',
                    onTap: (index,con) {
                      page.changePage(11);
                      page_con.jumpToPage(index);
                    },
                    icon: const Icon(Icons.password),
                  ),
                  SideMenuItem(
                    priority: 12,
                    title: 'تسجيل الخروج',
                    icon: Icon(Icons.exit_to_app),
                    onTap: (index,con){
                      hive.hive_delet("id");
                      html.window.location.reload();
                      //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Login()), (route) => false);
                    },
                  ),
                ],
              ),
              Expanded(
                child: PageView(
                controller: page_con,
                physics: NeverScrollableScrollPhysics(),
                  children:  [
                    Dashboard(),
                    Users(),
                    Auction_main(),
                    Auction_type(),
                    Accept_auction(),
                    Accept_money(),
                    Repo(),
                    Cities(),
                    Settings(),
                    Bauckup(),
                    ChangePass(),
                    ChangeRule()
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }
}
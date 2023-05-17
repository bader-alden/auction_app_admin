import 'package:auction_app_admin/utils/dio.dart';
import 'package:flutter/material.dart';
var count_of_waitting;
class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dio.get_data(url: "/dash/allCount").then((value) => setState((){count_of_waitting=value?.data;}));
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child:  Center(
        child: Text(
          count_of_waitting!=null?  ('  عدد المزادات بإنتظار الموافقة:$count_of_waitting'):"",
          style: TextStyle(fontSize: 35),
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }
}

import 'package:auction_app_admin/utils/const.dart';
import 'package:auction_app_admin/utils/dio.dart';
import 'package:auction_app_admin/utils/hive.dart';
import 'package:flutter/material.dart';
var change_pass_old_con=TextEditingController();
var change_pass_new_con=TextEditingController();
var change_pass_re_con=TextEditingController();
class ChangePass extends StatefulWidget {
  const ChangePass({Key? key}) : super(key: key);

  @override
  _ChangePassState createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        children: [
          SizedBox(height: 20,),
          Center(child: Text("تغيير كلمة السر",style: TextStyle(fontSize: 24),),),
          SizedBox(height: 40,),
          Text("كلمة المرور القديمة:"),
          Container(width: 400,child: TextFormField(controller: change_pass_old_con,)),
          SizedBox(height: 30,),
          Text("كلمة المرور الجديدة:"),
          Container(width: 400,child: TextFormField(controller: change_pass_new_con,)),
          SizedBox(height: 30,),
          Text("إعادة كلمة السر:"),
          Container(width:400,child: TextFormField(controller: change_pass_re_con,)),
          SizedBox(height: 30,),
          ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.green)),
              onPressed: (){
            if(change_pass_new_con.text==change_pass_re_con.text){
                dio.post_data(url: "/dash/change_pass",quary: {
                  "id":hive.hive_get("id"),
                  "pass":change_pass_old_con.text,
                  'new_pass':change_pass_new_con.text
                }).then((value) {
                  if(value?.data =="yes"){
                    setState(() {
                      change_pass_old_con.clear();
                      change_pass_new_con.clear();
                      change_pass_re_con.clear();
                    });
                    Tost_widget("تمت العملية بنجاح", "green");
                  }else{
                    Tost_widget("كلمة المرور القديمة خاطئة", "red");
                  }
                });
            }else{
              Tost_widget("غير متطابق", "red");
            }
          }, child: Text("موافق"))
        ],
      ),
    );
  }
}

import 'package:auction_app_admin/utils/dio.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
bool is_buckup_loading= false;
class Bauckup extends StatefulWidget {
  const Bauckup({ Key? key}) : super(key: key);

  @override
  _BauckupState createState() => _BauckupState();
}

class _BauckupState extends State<Bauckup> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("النسخ الاحتياطي"),
        SizedBox(height: 50,),
        ElevatedButton(onPressed: (){
          setState(() {
            is_buckup_loading=true;
          });
          dio.get_data(url:"/dataxlsx").then((value) {
            print(value?.data);
            if(value?.data!=null){
           print(value?.data);
                html.AnchorElement anchorElement =  new html.AnchorElement(href: value?.data);
                anchorElement.download = value?.data;
                anchorElement.click();
            setState(() {
              is_buckup_loading=false;
            });
            }
          });
        }, child: Container(
          height: 75,
          width: 100,
          child: Center(child: is_buckup_loading?CircularProgressIndicator(color: Colors.white,):Text("إنشاء نسخة احتياطية")),
        ))
      ],
    );
  }
}
// class SwitchNativeWeb {
//   static void downloadFile({required String url,
//     required String fileName ,required String dataType}){
//     switch_value.downloadFile(dataType: dataType,fileName: fileName,url: url);}
// }
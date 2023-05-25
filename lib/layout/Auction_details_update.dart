import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'package:auction_app_admin/model/auction_model.dart';
import 'package:auction_app_admin/utils/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:reorderables/reorderables.dart';
import 'dart:html' as html;
import '../utils/const.dart';
import '../utils/map.dart';
import '../model/user_model.dart';
import 'Users.dart';
import 'package:http/http.dart' as http;

auction_model? model;

class Auction_details_update extends StatefulWidget {
  const Auction_details_update({Key? key, this.model, this.type, this.is_redy, this.id}) : super(key: key);
  final auction_model? model;
  final type;
  final id;
  final is_redy;
  @override
  _Auction_details_updateState createState() => _Auction_details_updateState(model, type, is_redy, id);
}

class _Auction_details_updateState extends State<Auction_details_update> {
  late auction_model? model;
  final type;
  final is_ready;
  final id;
  List<int>? _rows;

  _Auction_details_updateState(this.model, this.type, this.is_ready, this.id);
  @override
  void initState() {
    super.initState();
    _rows = List<int>.generate(50, (int index) => index);

    if (is_ready != null && !is_ready) {
      print(type);
      print(type);
      print(type);
      print(id);
      print(id);
      print(id);
      dio.post_data(url: "/dash/select_id", quary: {"table": type, "sql": " * ", "id": id.toString()}).then((value) {
        //print(value?.data);
        model = auction_model.fromjson(value?.data[0]);
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void _onReorder(int oldIndex, int newIndex) {
      setState(() {
        int? row = _rows?.removeAt(oldIndex);
        _rows?.insert(newIndex, row!);
      });
    }

    // Make sure there is a scroll controller attached to the scroll view that contains ReorderableSliverList.
    // Otherwise an error will be thrown.
    ScrollController _scrollController = PrimaryScrollController.of(context) ?? ScrollController();
    if (model != null) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Scaffold(
            body: ListView(
              // shrinkWrap: true,
              children: [
                if (model?.photo != null)
                  Column(
                    children: [
                      Container(
                        height: 2,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FutureBuilder<http.Response>(
                          future: http.get(Uri.parse(model!.photo!)),
                          builder: (context, data) {
                            if (data.connectionState == ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return InkWell(
                                onLongPress: () {
                                  showDialog<void>(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: Column(
                                          children: [
                                            TextButton(
                                                onPressed: () async {
                                                  // and encode them to base64
                                                  final base64data = base64Encode(data.data!.bodyBytes);
                                                  var download = document.createElement('a') as AnchorElement;
                                                  download.href = 'data:image/png;base64,' + base64data;
                                                  download.download = Uri.parse(model!.photo!).pathSegments.last;
                                                  download.click();
                                                  download.remove();
                                                },
                                                child: Text("تنزيل")),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            TextButton(
                                                onPressed: () async {
                                                  Uint8List? image = await ImagePickerWeb.getImageAsBytes();
                                                  if (image != null) {
                                                    FormData formData = FormData.fromMap({"file": await MultipartFile.fromBytes(image.toList(), filename: Uri.parse(model!.photo!).pathSegments.last)});
                                                    dio.post_data(url: "/uplode/uplode", data: formData).then((value) {
                                                      Tost_widget("تم تعديل الصورة", "green");
                                                      print(value?.data);
                                                      Navigator.pop(context);
                                                      Navigator.pop(dialogContext);
                                                      setState(() {});
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
                                                child: Text("إستبدال")),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Image.memory(
                                  data.data!.bodyBytes,
                                  height: 350,
                                ));
                            //Image.network(model!.photo!,height: 350,));
                          }),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                if (model?.photos != null)
                  Container(
                    height: 2,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                  ),
                SizedBox(
                  height: 250,
                  child: ReorderableListView(
                    scrollController:_scrollController ,
                    scrollDirection: Axis.horizontal,
                  children: [
                    if (model?.photos![0] != "")
                      for (int index = 0; index < model!.photos!.length; index++)
                        FutureBuilder<http.Response>(
                          key: ValueKey(index),
                            future: http.get(Uri.parse(model!.photos![index])),
                            builder: (context, data) {
                              if (data.connectionState == ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return Stack(
                                children: [
                                  InkWell(
                                      onLongPress: () {
                                        showDialog<void>(
                                          context: context,
                                          builder: (BuildContext dialogContext) {
                                            return AlertDialog(
                                              title: Column(
                                                children: [
                                                  TextButton(
                                                      onPressed: () async {
                                                        // and encode them to base64
                                                        final base64data = base64Encode(data.data!.bodyBytes);
                                                        var download = document.createElement('a') as AnchorElement;
                                                        download.href = 'data:image/png;base64,' + base64data;
                                                        download.download = Uri.parse(model!.photos![index]).pathSegments.last;
                                                        download.click();
                                                        download.remove();
                                                      },
                                                      child: Text("تنزيل")),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  TextButton(
                                                      onPressed: () async {
                                                        Uint8List? image = await ImagePickerWeb.getImageAsBytes();
                                                        if (image != null) {
                                                          FormData formData = FormData.fromMap({"file": await MultipartFile.fromBytes(image.toList(), filename: Uri.parse(model!.photos![index]).pathSegments.last)});
                                                          dio.post_data(url: "/uplode/uplode", data: formData).then((value) {
                                                            Tost_widget("تم تعديل الصورة", "green");
                                                            print(value?.data);
                                                            Navigator.pop(context);
                                                            Navigator.pop(dialogContext);
                                                            setState(() {});
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
                                                      child: Text("إستبدال")),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Image.memory(
                                        data.data!.bodyBytes,
                                        height: MediaQuery.of(context).size.height/3,
                                        width:MediaQuery.of(context).size.width/3,
                                      )),
                                  ReorderableDragStartListener(index: index, child: const Icon(Icons.drag_indicator_outlined)),
                                ],
                              );
                              //Image.network(model!.photo!,height: 350,));
                            }),
                  ],
                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final String item = model!.photos!.removeAt(oldIndex);
                        model!.photos!.insert(newIndex, item);
                        dio.post_data(
                            url: "/dash/update_id",
                            quary: {
                              "table": "wait",
                              "sql_key":
                              " photos = '${model!.photos!.join("|")}' ",
                              "id": id
                            }).then((value) => print(value?.data));
                      });
                    },
                  ),
                ),
                // Container(
                //   height: 250,
                //   child: ListView.builder(
                //       scrollDirection: Axis.horizontal,
                //       itemCount: model!.photos?.length,
                //       itemBuilder: (context,index){
                //         if(model!.photos![index]!=model?.photo) {
                //           return
                //         }
                //       }),
                // ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}

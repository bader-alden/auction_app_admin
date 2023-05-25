import 'package:auction_app_admin/utils/dio.dart';
import 'package:flutter/material.dart';

List allCities = [];

class Cities extends StatefulWidget {
  const Cities({Key? key}) : super(key: key);

  @override
  State<Cities> createState() => _CitiesState();
}

class _CitiesState extends State<Cities> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dio.get_data(url: "/dash/city").then((value) {
      print(value?.data);
      setState(() {
        allCities = value?.data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (allCities.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Spacer(),
                Text("مدن المملكة" , style: TextStyle(fontSize: 25),),
                Spacer(),
                ElevatedButton(onPressed: () {
                  var con = TextEditingController();
                  showDialog<void>(
                        context: context,
                        // false = user must tap button, true = tap outside dialog
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: Column(
                              children: [
                                Text("إنشاء"),
                                TextFormField(
                                  controller: con,
                                )
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('إلغاء'),
                                onPressed: () {
                                  Navigator.of(dialogContext)
                                      .pop(); // Dismiss alert dialog
                                },
                              ),
                              TextButton(
                                child: Text('موافق'),
                                onPressed: () {
                          dio.post_data(url: "/dash/insert", quary: {
                          "table": " city ",
                          "sql_key": " namecity  ",
                          "sql_value": "'${con.text}'"
                          }).then((value) {

                            dio
                                .get_data(url: "/dash/city")
                                .then((value) {
                              print(value?.data);
                              allCities.clear();
                              setState(() {
                                allCities = value?.data;
                              });
                            });
                          Navigator.of(dialogContext)
                              .pop(); // Dismiss alert dialog
                          },
                          );
                          })],
                          );
                        },
                      );
                    }, child: Text("إضافة")),
                SizedBox(
                  width: 25,
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: allCities.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(allCities[index]["namecity"].toString()),
                          SizedBox(
                            width: 50,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                var con = TextEditingController(
                                    text:
                                        allCities[index]["namecity"].toString());
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Column(
                                          children: [
                                            Text("تعديل"),
                                            TextFormField(
                                              controller: con,
                                            )
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () {
                                                dio.post_data(
                                                    url: "/dash/update_id",
                                                    quary: {
                                                      "table": "city",
                                                      "sql_key":
                                                          " namecity = '${con.text}' ",
                                                      "id": allCities[index]['id']
                                                    }).then((value) {
                                                  print(value?.data);
                                                  dio
                                                      .get_data(url: "/dash/city")
                                                      .then((value) {
                                                    print(value?.data);
                                                    allCities.clear();
                                                    setState(() {
                                                      allCities = value?.data;
                                                    });
                                                  });
                                                });

                                                Navigator.pop(context);
                                              },
                                              child: Text("موافق")),
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("ٍإلغاء")),
                                        ],
                                      );
                                    });
                              },
                              child: Text("تعديل")),
                          SizedBox(
                            width: 40,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                dio.post_data(url: "/dash/delet_id", quary: {
                                  "table": " city ",
                                  "id": allCities[index]["id"],
                                }).then((value) {
                                  print(value?.data);
                                  dio.get_data(url: "/dash/city").then((value) {
                                    print(value?.data);
                                    allCities.clear();
                                    setState(() {
                                      allCities = value?.data;
                                    });
                                  });
                                });
                              },
                              child: Text("حذف")),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      );
    }
    return Center(child: Text("cities"),);
  }
}

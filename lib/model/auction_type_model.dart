class auction_type_model{
  String? type;
  String? id;
  String? eng_name;
  String? ar_name;
  String? detail;
  String? text;
  String? terms;
  String? price;
  bool? with_location;
  bool? is_soon;
  List<all_kind_model>? all_kind=[];
  List<String>? text_slot=[];
  List<String>? file_slot=[];
  auction_type_model.fromjson(Map<String,dynamic> json){
    type=json['type'];
    id=json['id'].toString();
    terms=json['terms'].toString();
    price=json['price'].toString();
    text=json['text'];
    json['all_kind'].toString().split("*").forEach((element) {
      all_kind?.add(all_kind_model.fromjson(element));
    });
    eng_name=json['eng_name'];
    ar_name=json['ar_name'];
    is_soon=json['is_soon'].toString()=="1";
    detail=json['detail'];
    with_location=json['with_location'] == 1 ? true : false;
    text_slot =json["text_slot"]==null ?null : json["text_slot"].toString().split("|");
    file_slot = json["file_solt"]==null ?null :json["file_solt"].toString().split("|");
  
  }
}
class all_kind_model{
  String? kind;
  String? img;
  String? time;
  String? main_date;
  all_kind_model.fromjson(json){
    kind=json.toString().split("|")[0];
    img=json.toString().split("|")[1];
    time=json.toString().split("|")[2];
    main_date=json.toString().split("|")[3];
  }
}
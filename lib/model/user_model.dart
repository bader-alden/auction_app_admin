class user_models{
  String? name;
  String? email;
  String? id;
  String? id_number ;
  String? mobile_id;
  String? address;
  String? gsm_token;
  List<String>? fav;
  List<String>? my_auction;
  List<String>? auctions;
  user_models.fromjson(json){
    print(json);
    // email = emaila.toString();
    //  pass = passs.toString();
    name = json["name"].toString();
    id = json["id"].toString();
    email = json["email"].toString();
    id_number  = json["id_number"].toString();
    mobile_id = json["mobile_id"].toString();
    address = json["address"].toString();
    gsm_token = json["gsm_token"].toString();
    fav = json["fav"].toString().split(",");
    my_auction = json["my_auction"].toString().split(",");
    auctions = json["auctions"].toString().split(",");
  }
}
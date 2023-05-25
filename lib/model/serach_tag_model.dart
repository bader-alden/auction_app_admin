class serach_tag_model{
  String? id;
  String? name;
  List tag=[];
  serach_tag_model.fromjson(json){
    id= json["id"].toString();
    name= json["name"];
    tag= json["tag"] ==null ?[]: json["tag"].toString().split("*|*") ;
  }
}
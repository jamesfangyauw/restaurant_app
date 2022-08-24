import 'dart:convert';
class RestOfFavorite {
  late int? id;
  late String? idFavorite;
  late String? name;
  late String? desc;
  late String? urlImage;
  late String? city;
  late String? rating;
  late String? address;
  late String? isFav;

  RestOfFavorite(
      {this.id,
        required this.idFavorite,
        required this.name,
        required this.desc,
        required this.urlImage,
        required this.city,
        required this.rating,
        required this.address,
        required this.isFav});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idfavorit': idFavorite,
      'name': name,
      'desc': desc,
      'urlimage': urlImage,
      'city': city,
      'rating': rating,
      'address': address,
      'isFav': isFav
    };
  }

  RestOfFavorite.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    idFavorite = map['idfavorite'];
    name = map['name'];
    desc = map['desc'];
    urlImage = map['urlimage'];
    city = map['city'];
    rating = map['rating'];
    address = map['address'];
    isFav = map['isFav'];
  }
}

import 'package:flutter/material.dart';
import '/model/favorite_model.dart';
import '/database/db_helper.dart';
import '/widget/navigation_bar_bottom.dart';

class RestaurantDetailFav extends StatefulWidget {
  static const routeName = '/detail_favorite';
  final RestOfFavorite restOfFavorite;
  const RestaurantDetailFav({Key? key, required this.restOfFavorite});

  @override
  _favoriteFavState createState() => _favoriteFavState();
}

class _favoriteFavState extends State<RestaurantDetailFav> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.restOfFavorite.name!}'s Detail"),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.remove,
                color: Colors.white,
              ),
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Notification'),
                    content: const Text('Do you sure to delete this restaurant from your favorite list ? Answer "Yes" or "No" '),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Tidak'),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          databaseHelper.delete(widget.restOfFavorite.id!);
                          Navigator.of(context).pushNamedAndRemoveUntil(BottomNavbar.routeName, (Route<dynamic> route) => false);
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );
                // dbHelper.delete(widget.favorite.id!);
              },
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                      'https://restaurant-api.dicoding.dev/images/medium/' +
                          widget.restOfFavorite.urlImage!),
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: <Widget>[
                              Text(widget.restOfFavorite.name!,
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Row(
                                  children: <Widget>[
                                    const Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 20,
                                    ),
                                    Text(
                                      widget.restOfFavorite.rating.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.location_on,
                                color: Colors.grey,
                                size: 20,
                              ),
                              Text(
                                "${widget.restOfFavorite.address}, ${widget.restOfFavorite.city}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: const Divider(
                            color: Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text('Deskripsi: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            widget.restOfFavorite.desc!,
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
        )
    );
  }
}

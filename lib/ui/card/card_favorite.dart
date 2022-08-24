import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '/database/db_helper.dart';
import '/model/favorite_model.dart';
import '/ui/restaurant_detail_fav.dart';

class CardFavorite extends StatefulWidget {
  static const String favoriteTitle = 'All List of My Favorite';
  static const routeName = '/resto_fav';

  @override
  _FavoriteCardState createState() => _FavoriteCardState();
}

class _FavoriteCardState extends State<CardFavorite> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  late List<RestOfFavorite> itemList;
  int count = 0; //always start from 0

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => updateListView()); //! will have no effect because the receiver can't be null
    return Scaffold(
        appBar: AppBar(
            title: Text("My List of Favorite Restaurant"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView.builder(
              itemCount: count,
              itemBuilder: (BuildContext context, int index) {
                final restOfFavorite = itemList[index];
                return Material(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Ink(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueGrey, width: 2.0),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          leading: Hero(
                            tag: restOfFavorite.urlImage!,
                            child: Image.network(
                              'https://restaurant-api.dicoding.dev/images/small/' +
                                  restOfFavorite.urlImage!,
                              width: 100,
                            ),
                          ),
                          subtitle: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      restOfFavorite.name!,
                                      style: TextStyle(
                                          fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Row(
                                  children: [
                                    Text(restOfFavorite.city!),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Row(
                                  children: [
                                    Text(restOfFavorite.rating.toString()),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onTap: () => Navigator.pushNamed(
                            context,
                            RestaurantDetailFav.routeName,
                            arguments: restOfFavorite,
                          ),
                        ),
                      ),
                    ));
              }),
        ));
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initDb();
    dbFuture.then((database) {
      Future<List<RestOfFavorite>> itemListFuture = databaseHelper.getFavoriteList();
      itemListFuture.then((itemList) {
        setState(() {
          this.itemList = itemList;
          this.count = itemList.length;
        });
      });
    });
  }
}

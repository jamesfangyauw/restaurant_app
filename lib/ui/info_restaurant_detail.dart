import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/dataAPI/api.dart';
import '/model/restaurant_list_model.dart';
import '/provider/restaurant_detail_provider.dart';
import '/widget/navigation_bar_bottom.dart';
import 'package:sqflite/sqflite.dart';
import '/model/favorite_model.dart';
import '/database/db_helper.dart';

class RestDetail extends StatelessWidget {
  static const routeName = '/resto_detail';

  final Restaurant restaurant;
  RestDetail({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<RestDetailProvider>(
        create: (_) => RestDetailProvider(
            apiRestDetail: ApiRestDetail(IDnum_detail: restaurant.id)),
        child: DetailMenu(),
      ),
    );
  }
}

class DetailMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.news),
            label: "All Information Restaurant",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.tray_fill),
            label: 'ALL Foods',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.drop_fill),
            label: 'All Drinks',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.pencil_circle_fill),
            label: 'Trust Review',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return DetailInformationRes();
          case 1:
            return AllFoodsList();
          case 2:
            return AllDrinkList();
          case 3:
            return AllListReview();
          default:
            return const Center(
              child: Text('Page not found!'),
            );
        }
      },
    );
  }
}

class AllFoodsList extends StatefulWidget {
  @override
  _AllFoodsListState createState() => _AllFoodsListState();
}

class _AllFoodsListState extends State<AllFoodsList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RestDetailProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.Loading) {
          return Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.HasData) {
          var restaurantDetail = state.result.restaurant;

          return Scaffold(
              appBar: AppBar(
                title: Text("Daftar Makanan"),
              ),
              body: SingleChildScrollView(
                  child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      restaurantDetail.menus.foods.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                        child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Ink(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black12,
                                                width: 2.0),
                                            color: Colors.white30,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(restaurantDetail
                                                .menus.foods[index].name),
                                          )),
                                    ));
                                  }),
                            ),
                          ]),
                    ),
                  ],
                ),
              )));
        } else if (state.state == ResultState.NoData) {
          return Center(child: Text(state.message));
        } else if (state.state == ResultState.Error) {
          return Center(child: Text(state.message));
        } else {
          return Center(child: Text(''));
        }
      },
    );
  }
}

class AllDrinkList extends StatefulWidget {
  @override
  _AllDrinkListState createState() => _AllDrinkListState();
}

class _AllDrinkListState extends State<AllDrinkList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RestDetailProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.Loading) {
          return Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.HasData) {
          var restaurantDetail = state.result.restaurant;

          return Scaffold(
              appBar: AppBar(
                title: Text("Daftar Minuman"),
              ),
              body: SingleChildScrollView(
                  child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      restaurantDetail.menus.drinks.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                        child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Ink(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black12,
                                                width: 2.0),
                                            color: Colors.white30,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(restaurantDetail
                                                .menus.drinks[index].name),
                                          )),
                                    ));
                                  }),
                            ),
                          ]),
                    ),
                  ],
                ),
              )));
        } else if (state.state == ResultState.NoData) {
          return Center(child: Text(state.message));
        } else if (state.state == ResultState.Error) {
          return Center(child: Text(state.message));
        } else {
          return Center(child: Text(''));
        }
      },
    );
  }
}

class DetailInformationRes extends StatefulWidget {
  @override
  _DetailInformationResState createState() => _DetailInformationResState();
}

class _DetailInformationResState extends State<DetailInformationRes> {
  int count = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();
  late List<RestOfFavorite> itemList;
  late final RestOfFavorite restOfFavorite;

  @override
  Widget build(BuildContext context) {
    return Consumer<RestDetailProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.Loading) {
          return Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.HasData) {
          var restDetail = state.result.restaurant;

          return Scaffold(
              appBar: AppBar(
                title: Text(restDetail.name),
                actions: <Widget>[ //add the love restaurant
                  IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text('Notification!!!'),
                                content: const Text('If you sure to add this restaurant to your favorite list ? choose "Yes" or "No"'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, 'Tidak'),
                                    child: const Text('No, maybe later'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      restOfFavorite = RestOfFavorite(
                                          idFavorite: restDetail.id,
                                          name: restDetail.name,
                                          desc: restDetail.description,
                                          urlImage: restDetail.pictureId,
                                          city: restDetail.city,
                                          rating: restDetail.rating.toString(),
                                          address: restDetail.address,
                                          isFav: '1'
                                      );
                                      int result = await databaseHelper.insert(restOfFavorite);
                                      if (result > 0) {
                                        updateListView();
                                      }
                                      Navigator.of(context).pushNamedAndRemoveUntil(BottomNavbar.routeName, (Route<dynamic> route) => false);
                                    },
                                    child: const Text('Yes, sure'),
                                  ),
                                ],
                              ),
                        );
                      }
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
                                restDetail.pictureId),
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
                                    Text(restDetail.name,
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
                                            restDetail.rating.toString(),
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
                                      "${restDetail.address}, ${restDetail
                                          .city}",
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
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  restDetail.description,
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )));
        } else if (state.state == ResultState.NoData) {
          return Center(child: Text(state.message));
        } else if (state.state == ResultState.Error) {
          return Center(child: Text(state.message));
        } else {
          return Center(child: Text(''));
        }
      },
    );
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

class AllListReview extends StatefulWidget {
  @override
  _AllListReviewState createState() => _AllListReviewState();
}

class _AllListReviewState extends State<AllListReview> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RestDetailProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.Loading) {
          return Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.HasData) {
          var restaurantDetail = state.result.restaurant;

          return Scaffold(
              appBar: AppBar(
                title: Text("Review Tempat"),
              ),
              body: SingleChildScrollView(
                  child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemCount:
                                      restaurantDetail.customerReviews.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Card(
                                          child: Ink(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black12,
                                                  width: 1.0
                                              ),
                                              color: Colors.white30,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                      'Name: ${restaurantDetail.customerReviews[index].name}'
                                                  ),
                                                  Text(
                                                      'Date: ${restaurantDetail.customerReviews[index].date}'
                                                  ),
                                                  Text(
                                                      'Review: ${restaurantDetail.customerReviews[index].review}'
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                          ]),
                    ),
                  ],
                ),
              )));
        } else if (state.state == ResultState.NoData) {
          return Center(child: Text(state.message));
        } else if (state.state == ResultState.Error) {
          return Center(child: Text(state.message));
        } else {
          return Center(child: Text(''));
        }
      },
    );
  }
}

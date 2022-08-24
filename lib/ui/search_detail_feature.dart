import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/dataAPI/api.dart';
import '/database/db_helper.dart';
import '/model/favorite_model.dart';
import '/model/search_model.dart';
import '/provider/search_detail_provider.dart';
import '/widget/navigation_bar_bottom.dart';
import 'package:sqflite/sqflite.dart';

class RestDetailFromSearching extends StatelessWidget {
  static const routeName = '/search_resto_detail';

  final RestSearch restaurant;
  const RestDetailFromSearching({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<RestSearchDetailProv>(
        create: (_) => RestSearchDetailProv(
            apiRestSearchDetail:
            ApiRestSearchDetail(IDnum_detail: restaurant.id)),
        child: AllMenuRest(),
      ),
    );
  }
}

class AllMenuRest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.news),
            label: "All Information of Restaurant",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.tray_fill),
            label: 'Foods',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.drop_fill),
            label: 'Drinks',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.pencil_circle_fill),
            label: 'Review',
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
              child: Text('Error 404! Page Not Found!!! Please Check Again'),
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
    return Consumer<RestSearchDetailProv>(
      builder: (context, state, _) {
        if (state.state == ResultState.Loading) {
          return Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.HasData) {
          var restaurantDetail = state.result.restaurant;

          return Scaffold(
              appBar: AppBar(
                title: Text("List Of Foods in this Restaurant"),
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
                                                        color: Colors.blueGrey,
                                                        width: 2.0),
                                                    color: Colors.white10,
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
          return Center(child: Text('Error, please try again later'));
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
    return Consumer<RestSearchDetailProv>(
      builder: (context, state, _) {
        if (state.state == ResultState.Loading) {
          return Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.HasData) {
          var restaurantDetail = state.result.restaurant;

          return Scaffold(
              appBar: AppBar(
                title: Text("List of ALl Drinks in this restaurant"),
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
                                                        color: Colors.blueGrey,
                                                        width: 2.0),
                                                    color: Colors.white10,
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
          return Center(child: Text('Error, please try again later'));
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
    return Consumer<RestSearchDetailProv>(
      builder: (context, state, _) {
        if (state.state == ResultState.Loading) {
          return Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.HasData) {
          var restDetail = state.result.restaurant;

          return Scaffold(
              appBar: AppBar(
                title: Text(restDetail.name),
                actions: <Widget>[
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
                            content: const Text('Do you sure to add this restaurant to your favorite list ? Answer "Yes" or "No'),
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
                                child: const Text('Yes'),
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
                                            color: Colors.orange,
                                            size: 20,
                                          ),
                                          Text(
                                            restDetail.rating.toString(),
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.black87,
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
                                      color: Colors.white12,
                                      size: 20,
                                    ),
                                    Text(
                                      "${restDetail.address}, ${restDetail.city}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: const Divider(
                                  color: Colors.white12,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text('Description of this Restaurant: ',
                                    style: TextStyle(fontWeight: FontWeight.bold)),
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
    return Consumer<RestSearchDetailProv>(
      builder: (context, state, _) {
        if (state.state == ResultState.Loading) {
          return Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.HasData) {
          var restaurantDetail = state.result.restaurant;

          return Scaffold(
              appBar: AppBar(
                title: Text("Trust Review of This Restaurant"),
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
                                                      color: Colors.white12,
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
                                                          'Full Name: ${restaurantDetail.customerReviews[index].name}'
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

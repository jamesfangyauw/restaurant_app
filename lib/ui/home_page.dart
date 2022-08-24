import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/dataAPI/api.dart';
import '/provider/restaurant_list_provider.dart';
import '/ui/search_feature.dart';
import '/ui/card/card_restaurant.dart';
import '/widget/multi_system_operation.dart';

class Home extends StatefulWidget {
  static const routeName = '/home_page';

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<RestListProvider>(
        create: (_) => RestListProvider(apiRestList: ApiRestList()),
        child: InformationRestaurant(),
      ),
    );
  }
}

class InformationRestaurant extends StatefulWidget {
  @override
  State<InformationRestaurant> createState() => _InformationRestaurantState();
}

class _InformationRestaurantState extends State<InformationRestaurant> {
  TextEditingController searchController = new TextEditingController();
  String nameofRest = 'Name of Restaurant';

  Widget _buildList() {
    return Consumer<RestListProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.Loading) {
          return Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.HasData) {
          return Scaffold (
              appBar: AppBar(
                title: Text("List The Best Restaurant in Indonesia"),
              ),
              body: Container(
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextField(
                                  textInputAction: TextInputAction.search,
                                  onSubmitted: (value) {
                                    nameofRest = searchController.text;
                                    Navigator.pushNamed(
                                      context,
                                      RestSearchFeature.routeName,
                                      arguments: nameofRest,
                                    );
                                  },
                                  controller: searchController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    labelText: 'Find your favorite restaurant!!!',
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.search),
                                      onPressed: () {
                                        nameofRest = searchController.text;
                                        Navigator.pushNamed(
                                          context,
                                          RestSearchFeature.routeName,
                                          arguments: nameofRest,
                                        );
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(top: 10),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 100,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: state.result.restaurant.length,
                                    itemBuilder: (context, index) {
                                      var restaurant = state.result.restaurant[index];
                                      return CardRestaurant(restaurant : restaurant);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ]
                  )
              ),
          );
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

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: _buildList(),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('List The Best Restaurant in Indonesia'),
        transitionBetweenRoutes: false,
      ),
      child: _buildList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiSystemOperation(
      so_Android: _buildAndroid,
      so_Ios: _buildIos,
    );
  }
}

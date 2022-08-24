import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/dataAPI/api.dart';
import '/provider/search_provider.dart';
import '/ui/card/card_search.dart';
import '/widget/multi_system_operation.dart';

class RestSearchFeature extends StatelessWidget {
  static const routeName = '/resto_search';

  final String nameOfRest;
  const RestSearchFeature({required this.nameOfRest});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<RestSearchProv>(
        create: (_) => RestSearchProv(
            apiRestSearch: ApiRestSearch(feature: nameOfRest)),
        child: RestListOfSearching(),
      ),
    );
  }
}

class RestListOfSearching extends StatelessWidget {
  TextEditingController searchController = new TextEditingController();
  String nameRest = 'find your favorite restaurant';
  Widget _buildList() {
    TextEditingController searchController = TextEditingController();
    return Consumer<RestSearchProv>(
      builder: (context, state, _) {
        if (state.state == ResultState.Loading) {
          return Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.HasData) {
          return Container(
              child: Column(children: [
                Container(
                  padding: EdgeInsets.only(top: 19, left: 19, right: 19),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                          controller: searchController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Find your favorite restaurant in this country',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                nameRest = searchController.text;
                                Navigator.pushNamed(
                                  context,
                                  RestSearchFeature.routeName,
                                  arguments: nameRest,
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
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: SizedBox(
                                width: 1,
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: SizedBox(
                                width: 1,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 100,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.result.restaurants.length,
                              itemBuilder: (context, index) {
                                var restaurant = state.result.restaurants[index];
                                return CardSearch(restaurant: restaurant);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ]));
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
      appBar: AppBar(
        title: Text('List Restaurant Application'),
      ),
      body: _buildList(),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('List Restaurant Application'),
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

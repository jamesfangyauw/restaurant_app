import 'package:flutter/material.dart';
import '/model/search_model.dart';
import '/ui/search_detail_feature.dart';

class CardSearch extends StatelessWidget {
  final RestSearch restaurant; //class from model file

  const CardSearch({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Ink(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12, width: 2.0),
              color: Colors.white70,
            ),
            child: ListTile(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              leading: Hero(
                tag: restaurant.pictureId,
                child: Image.network(
                  'https://restaurant-api.dicoding.dev/images/small/' + restaurant.pictureId,
                ),
              ),
              subtitle: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      children: [
                        Text(
                          restaurant.name,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row (
                      children: <Widget>[
                        const Icon(
                          Icons.location_on,
                          color: Colors.black,
                          size: 20,
                        ),
                        Text(
                          restaurant.city,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child: Row(
                      children: <Widget>[
                        const Icon(
                          Icons.star,
                          color: Colors.orangeAccent,
                          size: 20,
                        ),
                        Text(
                          restaurant.rating.toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.yellow,
                          ),
                        ),
                      ],
                      // children: [
                      //   Text(widget.restaurant.rating.toString()),
                      // ],
                    ),
                  ),
                ],
              ),
              onTap: () => Navigator.pushNamed(
                context,
                RestDetailFromSearching.routeName,
                arguments: restaurant,
              ),
            ),
          ),
        )
    );
  }
}

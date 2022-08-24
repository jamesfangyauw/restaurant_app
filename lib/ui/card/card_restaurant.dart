import 'package:flutter/material.dart';
import '/model/restaurant_list_model.dart';
import '/ui/info_restaurant_detail.dart';

class CardRestaurant extends StatefulWidget {
  final Restaurant restaurant; //class from model file

  const CardRestaurant({required this.restaurant});

  @override
  _CardRestaurantState createState() => _CardRestaurantState();
}

class _CardRestaurantState extends State<CardRestaurant> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Ink(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12, width: 2.0),
              color: Colors.white30,
            ),
            child: ListTile(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              leading: Hero(
                tag: widget.restaurant.pictureId,
                child: Image.network(
                  'https://restaurant-api.dicoding.dev/images/small/' + widget.restaurant.pictureId,
                ),
              ),
              subtitle: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      children: [
                        Text(
                          widget.restaurant.name,
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
                          color: Colors.red,
                          size: 20,
                        ),
                        Text(
                          widget.restaurant.city,
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
                          widget.restaurant.rating.toString(),
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
                RestDetail.routeName,
                arguments: widget.restaurant,
              ),
            ),
          ),
        )
    );
  }
}

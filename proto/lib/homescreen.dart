import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:proto/routes.dart';

List routes = [
  {'id': 0, 'name': 'Jeep ni Arn', 'price': 0.0},
  {'id': 1, 'name': 'Jeep ni Jb', 'price': 230.0},
  {'id': 2, 'name': 'Jeep ni Arbe', 'price': 300.0},
  {'id': 3, 'name': 'Bus ni John', 'price': 500.0},
  {'id': 4, 'name': 'pls kill me - kent', 'price': 140.0},
];

String deds = 'bing bang';
int currentindex = 0;

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  late MapZoomPanBehavior _panBehavior;
  late Random random;
  late List<MapLatLng> polyline;
  late MapZoomPanBehavior _mapZoomPanBehavior;
  late List<PolylineModel> polylines;

  int selectedRotId = 1;

  @override
  void initState() {
    polyline = const <MapLatLng>[
      MapLatLng(8.475474, 124.648183),
      MapLatLng(8.475649, 124.649513),
      MapLatLng(8.477628, 124.648445),
      MapLatLng(8.477368, 124.649668),
    ];

    polylines = <PolylineModel>[
      PolylineModel(polyline),
    ];
    _mapZoomPanBehavior = MapZoomPanBehavior(
      zoomLevel: 15,
      focalLatLng: const MapLatLng(8.475649, 124.649513),
      enableDoubleTapZooming: true,
      maxZoomLevel: 17,
    );

    random = Random();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextStyle textStyle = themeData.textTheme.bodySmall!
        .copyWith(color: themeData.colorScheme.surface);
    return Scaffold(
      body: Stack(children: [
        SfMaps(
          layers: [
            MapTileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              zoomPanBehavior: _mapZoomPanBehavior,
              sublayers: [
                MapPolylineLayer(
                  polylines: List<MapPolyline>.generate(
                    polylines.length,
                    (int index) {
                      return MapPolyline(
                        points: polylines[index].points,
                      );
                    },
                  ).toSet(),
                  color: Colors.green,
                  width: 5,
                  tooltipBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.only(left: 15, top: 10),
                      width: 170,
                      height: 50,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('Jeep Name  :  ', style: textStyle),
                              Text('Jeep ni Arn', style: textStyle),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Travel time    :  ', style: textStyle),
                              Text('${random.nextInt(30)} mins',
                                  style: textStyle),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          ],
        ),
        DraggableScrollableSheet(
            initialChildSize: 0.3,
            maxChildSize: 1,
            snapSizes: [0.5, 1],
            snap: true,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                color: Colors.white,
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: ClampingScrollPhysics(),
                    controller: scrollController,
                    itemCount: routes.length,
                    itemBuilder: (BuildContext context, int index) {
                      final route = routes[index];
                      if (index == 0) {
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: const [
                              SizedBox(
                                width: 50,
                                child: Divider(
                                  thickness: 5,
                                ),
                              ),
                              Text('Choose a trip or swipe up for more')
                            ],
                          ),
                        );
                      }
                      return Card(
                        margin: EdgeInsets.zero,
                        elevation: 0,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(10),
                          onTap: () {
                            setState(() {
                              selectedRotId = route['id'];
                            });
                          },
                          leading: Icon(Icons.car_rental),
                          title: Text(route['name']),
                          trailing: Text(
                            route['price'].toString(),
                          ),
                          selected: selectedRotId == route['id'],
                          selectedTileColor: Colors.grey[200],
                        ),
                      );
                    }),
              );
            })
      ]),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(Icons.settings),
          ),
        ],
        currentIndex: currentindex,
        onTap: (int index) {
          setState(() {
            currentindex = index;
          });
        },
      ),
    );
  }
}

class PolylineModel {
  PolylineModel(this.points);
  final List<MapLatLng> points;
}

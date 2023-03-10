import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

void main() {
  runApp(const Myapp());
}

String deds = 'bing bang';
int currentindex = 0;

class Myapp extends StatefulWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  late MapZoomPanBehavior _panBehavior;
  late Random random;
  late List<MapLatLng> polyline;
  late MapZoomPanBehavior _mapZoomPanBehavior;
  late List<PolylineModel> polylines;

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
        enableDoubleTapZooming: true);

    random = Random();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextStyle textStyle = themeData.textTheme.caption!
        .copyWith(color: themeData.colorScheme.surface);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SfMaps(
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
                      padding: EdgeInsets.only(left: 15, top: 10),
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
                              Text(random.nextInt(30).toString() + ' mins',
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
            BottomNavigationBarItem(
              label: 'Routes',
              icon: Icon(Icons.add_location_alt_rounded),
            ),
          ],
          currentIndex: currentindex,
          onTap: (int index) {
            setState(() {
              currentindex = index;
            });
          },
        ),
      ),
    );
  }
}

class PolylineModel {
  PolylineModel(this.points);
  final List<MapLatLng> points;
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';
import 'package:connectivity/connectivity.dart';

class MapPage extends StatefulWidget {
  static final String route = "/mappage";
  @override
  _MapPageState createState() => new _MapPageState();
}

enum UniLinksType { string, uri }

class _MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  // user location variables
  final locator = Geolocator();

  Position position = new Position(
      latitude: 0, longitude: 0
  );

  // UniLinks variables
  Uri _latestUri;
  StreamSubscription _sub;
  UniLinksType _type = UniLinksType.string;
  MapController mapController;
  bool zoomedOnUser;

  @override
  initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        Firestore.instance.settings(persistenceEnabled: true);
      }
    });
    zoomedOnUser = false;
    mapController = new MapController();
    initPlatformState();
  }

  @override
  dispose() {
    if (_sub != null) _sub.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    if (_type == UniLinksType.string) {
      await initPlatformStateForStringUniLinks();
    } else {
      await initPlatformStateForUriUniLinks();
    }
  }

  /// An implementation using a [String] link
  initPlatformStateForStringUniLinks() async {
    // Attach a listener to the links stream
    _sub = getLinksStream().listen((String link) {
      if (!mounted) return;
      setState(() {
        _latestUri = null;
        try {
          if (link != null) _latestUri = Uri.parse(link);
        } on FormatException {}
      });
    }, onError: (err) {
      if (!mounted) return;
      setState(() {
        _latestUri = null;
      });
    });

    // Attach a second listener to the stream
    getLinksStream().listen((String link) {
      print('got link: $link');
    }, onError: (err) {
      print('got err: $err');
    });

    // Get the latest link
    String initialLink;
    Uri initialUri;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialLink = await getInitialLink();
      print('initial link: $initialLink');
      if (initialLink != null) initialUri = Uri.parse(initialLink);
    } on PlatformException {
      initialLink = 'Failed to get initial link.';
      initialUri = null;
    } on FormatException {
      initialLink = 'Failed to parse the initial link as Uri.';
      initialUri = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _latestUri = initialUri;
    });
  }

  /// An implementation using the [Uri] convenience helpers
  initPlatformStateForUriUniLinks() async {
    // Attach a listener to the Uri links stream
    _sub = getUriLinksStream().listen((Uri uri) {
      if (!mounted) return;
      setState(() {
        _latestUri = uri;
      });
    }, onError: (err) {
      if (!mounted) return;
      setState(() {
        _latestUri = null;
      });
    });

    // Attach a second listener to the stream
    getUriLinksStream().listen((Uri uri) {
      print('got uri: ${uri?.path} ${uri?.queryParametersAll}');
    }, onError: (err) {
      print('got err: $err');
    });

    // Get the latest Uri
    Uri initialUri;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialUri = await getInitialUri();
      print('initial uri: ${initialUri?.path}'
          ' ${initialUri?.queryParametersAll}');
    } on PlatformException {
      initialUri = null;
    } on FormatException {
      initialUri = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _latestUri = initialUri;
    });
  }
  var markers = List<Marker>();

  @override
  Widget build(BuildContext context) {
    final params = _latestUri?.queryParameters != null ? _latestUri
        ?.queryParameters : new Map<String, String>();
    final lonParam = params.containsKey("lon") ? params['lon'] : "";
    final latParam = params.containsKey("lat") ? params['lat'] : "";
    final radiusParam = params.containsKey("radius") ? params['radius'] : "";
    double longitude = 0;
    double latitude = 0;
    double radius = 2000;
    if (lonParam != null && latParam != null) {
      try {
        longitude = double.parse(lonParam);
        latitude = double.parse(latParam);
        if (radiusParam != null) {
          radius = double.parse(radiusParam);
        }
      } catch (e) {}
    }

    var circleMarkers = <CircleMarker>[CircleMarker(
        point: LatLng(latitude, longitude),
        color: Colors.blue.withOpacity(0.7),
        borderStrokeWidth: 2,
        useRadiusInMeter: true,
        radius: radius // 2000 meters | 2 km
    ),
    ];
    var userMarker = Marker(
      point: LatLng(position?.latitude, position?.longitude),
      builder: (ctx) => Container(
        child: Icon(Icons.person_pin, size: 35,),
      ),
    );
    markers.add(userMarker);
    locator.getPositionStream(LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 10))
        .listen((pos) async => await _updateMarkerPosition(userMarker, pos));

    return new MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: Text('Home')),
            body: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Flexible(
                    child: FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        center: LatLng(51.5, -0.09),
                        zoom: 11.0,
                      ),
                      layers: [
                        TileLayerOptions(
                            urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            subdomains: ['a', 'b', 'c']),
                        new GroupLayerOptions(group: [
                          new CircleLayerOptions(circles: circleMarkers),
                          new MarkerLayerOptions(markers: markers),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _getLocation().then((value) {
                  setState(() {
                    _sendDataToFireStore();
                  });
                });
              },
              child: Icon(Icons.location_on),
              backgroundColor: Colors.redAccent,
            )
        )
    );
  }

  // Asynchronous callbacks

  void _sendDataToFireStore() {
    try {
      Connectivity();
      DocumentReference doc = Firestore.instance.collection("Mission").document();
      doc.setData({
        'Location': GeoPoint(position.latitude, position.longitude),
        'Timestamp': Timestamp.now(),
        'Uploaded': true,
      });
      Firestore.instance.collection("Mission").snapshots()
          .forEach((qs) => qs.documents
            .forEach((document) => _addDocumentAsMarker(document)));
    }catch(e) {
      print(e);
    }
  }

  Future<Position> _getLocation() async {
    return await locator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> _updateMarkerPosition(Marker marker, Position pos) {
    if (!zoomedOnUser) {
      mapController.move(new LatLng(pos.latitude, pos.longitude), 15);
      zoomedOnUser = true;
    }

    marker.point.latitude = pos.latitude;
    marker.point.longitude = pos.longitude;
    position = pos;
    return null;
  }

  void _addDocumentAsMarker(DocumentSnapshot document) {
    markers.insert(0, new Marker(
        point: LatLng(position?.latitude, position?.longitude),
        builder: (ctx) => Container(
          child: Icon(Icons.location_on, color: document["Uploaded"] ? Colors.green : Colors.red, size: 40,),
    )));
    print(document);
  }

}
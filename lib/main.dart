import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_googlemaps_temp/store.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoogleMaps Sample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TopPage(),
    );
  }
}

class TopPage extends StatefulWidget {
  TopPage({Key? key}) : super(key: key);

  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> with WidgetsBindingObserver {
  static final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(35.665751, 139.728687),
    zoom: 16,
  );
  bool _isPermissionGranted = false;
  Completer<GoogleMapController> _mapController = Completer();
  List<Store> _stores = [];
  Set<Marker> _markers = {};
  late BitmapDescriptor _fmIcon;
  late BitmapDescriptor _lsIcon;

  @override
  void initState() {
    super.initState();
    _getPermission();
    _loadStores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GoogleMaps Sample'),
      ),
      body: Stack(
        children: [
          _buildMaps(),
          _buildList(context),
        ],
      ),
    );
  }

  Widget _buildMaps() {
    return _isPermissionGranted
        ? GoogleMap(
            initialCameraPosition: _initialPosition,
            markers: _markers,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
            },
          )
        : Text('位置情報を許可してください');
  }

  Widget _buildList(BuildContext context) {
    return _isPermissionGranted
        ? DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.2,
            maxChildSize: 0.4,
            builder: (BuildContext context, ScrollController scrollController) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: _stores.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            _stores[index].name,
                          ),
                          onTap: () => {
                            _animateCamera(_stores[index]),
                          },
                        );
                      },
                    ),
                  ),
                ),
              );
            })
        : Container();
  }

  Future<void> _animateCamera(Store store) async {
    final mapController = await _mapController.future;
    await mapController.showMarkerInfoWindow(MarkerId(store.id.toString()));
    await mapController.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(store.latitude, store.longitude),
      ),
    );
  }

  Future<void> _loadStores() async {
    final jsonString = await rootBundle.loadString('assets/stores.json');
    final jsonArray = json.decode(jsonString);
    _stores =
        List<Store>.from(jsonArray.map((i) => Store.fromJson(i)).toList());
    await _loadIcons();
    setState(() {
      _markers = _stores
          .map((store) => Marker(
              markerId: MarkerId(store.id.toString()),
              position: LatLng(store.latitude, store.longitude),
              infoWindow: InfoWindow(
                title: store.name,
                onTap: () => _showStoreInfo(store),
              ),
              icon: _markerIcon(store),
              onTap: () => _showStoreInfo(store)))
          .toSet();
    });
  }

  BitmapDescriptor _markerIcon(Store store) {
    var icon;
    switch (store.type) {
      case 'ファミリーマート':
        icon = _fmIcon;
        break;
      case 'ローソン':
        icon = _lsIcon;
        break;
      default:
        icon = BitmapDescriptor.defaultMarker;
    }
    return icon;
  }

  Future<void> _loadIcons() async {
    final fmBytes = await getUint8ListFromAsset('assets/fm.png', 140, 140);
    if (fmBytes != null) {
      _fmIcon = BitmapDescriptor.fromBytes(fmBytes);
    } else {
      _fmIcon = BitmapDescriptor.defaultMarker;
    }
    final lsBytes = await getUint8ListFromAsset('assets/ls.png', 140, 140);
    if (lsBytes != null) {
      _lsIcon = BitmapDescriptor.fromBytes(lsBytes);
    } else {
      _lsIcon = BitmapDescriptor.defaultMarker;
    }
  }

  Future<void> _showStoreInfo(Store store) async {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(store.name),
          content: Text(store.address),
          actions: <Widget>[
            ElevatedButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Future<void> _getPermission() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      setState(() {
        _isPermissionGranted = true;
      });
    }
  }

  Future<Uint8List?> getUint8ListFromAsset(
      String path, int width, int height) async {
    final ByteData byteData = await rootBundle.load(path);
    final ui.Codec codec = await ui.instantiateImageCodec(
      byteData.buffer.asUint8List(),
      targetWidth: width,
      targetHeight: height,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        ?.buffer
        .asUint8List();
  }
}

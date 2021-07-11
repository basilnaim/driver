// // import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'dart:async';
// // import 'package:flutter/material.dart';
// //
// // // const double CAMERA_ZOOM = 13;
// // // const double CAMERA_TILT = 0;
// // // const double CAMERA_BEARING = 30;
// // // const LatLng SOURCE_LOCATION = LatLng(42.7477863, -71.1699932);
// // // const LatLng DEST_LOCATION = LatLng(42.6871386, -71.2143403);
// //
// // // Starting point latitude
// // double _originLatitude = 6.5212402;
// // // Starting point longitude
// // double _originLongitude = 3.3679965;
// // // Destination latitude
// // double _destLatitude = 6.849660;
// // // Destination Longitude
// // double _destLongitude = 3.648190;
// // // Markers to show points on the map
// // Map<MarkerId, Marker> markers = {};
// //
// // class MapPage extends StatefulWidget {
// //   @override
// //   State<StatefulWidget> createState() => MapPageState();
// // }
// //
// // class MapPageState extends State<MapPage> {
// //   // Completer<GoogleMapController> _controller = Completer();
// //   // // this set will hold my markers
// //   // Set<Marker> _markers = {};
// //   // // this will hold the generated polylines
// //   // Set<Polyline> _polylines = {};
// //   // // this will hold each polyline coordinate as Lat and Lng pairs
// //   // List<LatLng> polylineCoordinates = [];
// //   // // this is the key object - the PolylinePoints
// //   // // which generates every polyline between start and finish
// //   // PolylinePoints polylinePoints = PolylinePoints();
// //   // String googleAPIKey = "<YOUR_API_KEY>";
// //   // // for my custom icons
// //   // BitmapDescriptor sourceIcon;
// //   // BitmapDescriptor destinationIcon;
// //
// //   // Google Maps controller
// //   Completer<GoogleMapController> _controller = Completer();
// //   // Configure map position and zoom
// //   static final CameraPosition _kGooglePlex = CameraPosition(
// //     target: LatLng(_originLatitude, _originLongitude),
// //     zoom: 9.4746,
// //   );
// //
// //   // @override
// //   // void initState() {
// //   //   super.initState();
// //   //   setSourceAndDestinationIcons();
// //   // }
// //
// //   @override
// //   void initState() {
// //     /// add origin marker origin marker
// //     _addMarker(
// //       LatLng(_originLatitude, _originLongitude),
// //       "origin",
// //       BitmapDescriptor.defaultMarker,
// //     );
// //
// //     // Add destination marker
// //     _addMarker(
// //       LatLng(_originLatitude, _originLongitude),
// //       "destination",
// //       BitmapDescriptor.defaultMarkerWithHue(90),
// //     );
// //     super.initState();
// //   }
// //
// //   // void setSourceAndDestinationIcons() async {
// //   //   sourceIcon = await BitmapDescriptor.fromAssetImage(
// //   //       ImageConfiguration(devicePixelRatio: 2.5), 'assets/driving_pin.png');
// //   //   destinationIcon = await BitmapDescriptor.fromAssetImage(
// //   //       ImageConfiguration(devicePixelRatio: 2.5),
// //   //       'assets/destination_map_marker.png');
// //   // }
// //
// //   // This method will add markers to the map based on the LatLng position
// //   _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
// //     MarkerId markerId = MarkerId(id);
// //     Marker marker =
// //         Marker(markerId: markerId, icon: descriptor, position: position);
// //     markers[markerId] = marker;
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     // CameraPosition initialLocation = CameraPosition(
// //     //     zoom: CAMERA_ZOOM,
// //     //     bearing: CAMERA_BEARING,
// //     //     tilt: CAMERA_TILT,
// //     //     target: SOURCE_LOCATION);
// //     // return GoogleMap(
// //     //     myLocationEnabled: true,
// //     //     compassEnabled: true,
// //     //     tiltGesturesEnabled: false,
// //     //     markers: _markers,
// //     //     polylines: _polylines,
// //     //     mapType: MapType.normal,
// //     //     initialCameraPosition: initialLocation,
// //     //     onMapCreated: onMapCreated);
// //     return GoogleMap(
// //       mapType: MapType.normal,
// //       initialCameraPosition: _kGooglePlex,
// //       myLocationEnabled: true,
// //       tiltGesturesEnabled: true,
// //       compassEnabled: true,
// //       scrollGesturesEnabled: true,
// //       zoomGesturesEnabled: true,
// //       markers: Set<Marker>.of(markers.values),
// //       onMapCreated: (GoogleMapController controller) {
// //         _controller.complete(controller);
// //       },
// //     );
// //   }
// //
// //   // void onMapCreated(GoogleMapController controller) {
// //   //   controller.setMapStyle(Utils.mapStyles);
// //   //   _controller.complete(controller);
// //   //   setMapPins();
// //   //   setPolylines();
// //   // }
// //
// //   // void setMapPins() {
// //   //   setState(() {
// //   //     // source pin
// //   //     _markers.add(Marker(
// //   //         markerId: MarkerId('sourcePin'),
// //   //         position: SOURCE_LOCATION,
// //   //         icon: sourceIcon));
// //   //     // destination pin
// //   //     _markers.add(Marker(
// //   //         markerId: MarkerId('destPin'),
// //   //         position: DEST_LOCATION,
// //   //         icon: destinationIcon));
// //   //   });
// //   // }
// //
// //   //PointLatLng(22.296360, 70.803358),
// //   //         PointLatLng(22.280065, 70.802197)
// //   // setPolylines() async {
// //   //   List<PointLatLng> result = await polylinePoints?.getRouteBetweenCoordinates(
// //   //       googleAPIKey, 22.296360, 70.803358, 22.280065, 70.802197);
// //   //   if (result.isNotEmpty) {
// //   //     // loop through all PointLatLng points and convert them
// //   //     // to a list of LatLng, required by the Polyline
// //   //     result.forEach((PointLatLng point) {
// //   //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
// //   //     });
// //   //   }
// //   //
// //   //   setState(() {
// //   //     // create a Polyline instance
// //   //     // with an id, an RGB color and the list of LatLng pairs
// //   //     Polyline polyline = Polyline(
// //   //         polylineId: PolylineId("poly"),
// //   //         color: Color.fromARGB(255, 40, 122, 198),
// //   //         points: polylineCoordinates);
// //   //
// //   //     // add the constructed polyline as a set of points
// //   //     // to the polyline set, which will eventually
// //   //     // end up showing up on the map
// //   //     _polylines.add(polyline);
// //   //   });
// //   // }
// // }
// //
// // class Utils {
// //   static String mapStyles = '''[
// //   {
// //     "elementType": "geometry",
// //     "stylers": [
// //       {
// //         "color": "#f5f5f5"
// //       }
// //     ]
// //   },
// //   {
// //     "elementType": "labels.icon",
// //     "stylers": [
// //       {
// //         "visibility": "off"
// //       }
// //     ]
// //   },
// //   {
// //     "elementType": "labels.text.fill",
// //     "stylers": [
// //       {
// //         "color": "#616161"
// //       }
// //     ]
// //   },
// //   {
// //     "elementType": "labels.text.stroke",
// //     "stylers": [
// //       {
// //         "color": "#f5f5f5"
// //       }
// //     ]
// //   },
// //   {
// //     "featureType": "administrative.land_parcel",
// //     "elementType": "labels.text.fill",
// //     "stylers": [
// //       {
// //         "color": "#bdbdbd"
// //       }
// //     ]
// //   },
// //   {
// //     "featureType": "poi",
// //     "elementType": "geometry",
// //     "stylers": [
// //       {
// //         "color": "#eeeeee"
// //       }
// //     ]
// //   },
// //   {
// //     "featureType": "poi",
// //     "elementType": "labels.text.fill",
// //     "stylers": [
// //       {
// //         "color": "#757575"
// //       }
// //     ]
// //   },
// //   {
// //     "featureType": "poi.park",
// //     "elementType": "geometry",
// //     "stylers": [
// //       {
// //         "color": "#e5e5e5"
// //       }
// //     ]
// //   },
// //   {
// //     "featureType": "poi.park",
// //     "elementType": "labels.text.fill",
// //     "stylers": [
// //       {
// //         "color": "#9e9e9e"
// //       }
// //     ]
// //   },
// //   {
// //     "featureType": "road",
// //     "elementType": "geometry",
// //     "stylers": [
// //       {
// //         "color": "#ffffff"
// //       }
// //     ]
// //   },
// //   {
// //     "featureType": "road.arterial",
// //     "elementType": "labels.text.fill",
// //     "stylers": [
// //       {
// //         "color": "#757575"
// //       }
// //     ]
// //   },
// //   {
// //     "featureType": "road.highway",
// //     "elementType": "geometry",
// //     "stylers": [
// //       {
// //         "color": "#dadada"
// //       }
// //     ]
// //   },
// //   {
// //     "featureType": "road.highway",
// //     "elementType": "labels.text.fill",
// //     "stylers": [
// //       {
// //         "color": "#616161"
// //       }
// //     ]
// //   },
// //   {
// //     "featureType": "road.local",
// //     "elementType": "labels.text.fill",
// //     "stylers": [
// //       {
// //         "color": "#9e9e9e"
// //       }
// //     ]
// //   },
// //   {
// //     "featureType": "transit.line",
// //     "elementType": "geometry",
// //     "stylers": [
// //       {
// //         "color": "#e5e5e5"
// //       }
// //     ]
// //   },
// //   {
// //     "featureType": "transit.station",
// //     "elementType": "geometry",
// //     "stylers": [
// //       {
// //         "color": "#eeeeee"
// //       }
// //     ]
// //   },
// //   {
// //     "featureType": "water",
// //     "elementType": "geometry",
// //     "stylers": [
// //       {
// //         "color": "#c9c9c9"
// //       }
// //     ]
// //   },
// //   {
// //     "featureType": "water",
// //     "elementType": "labels.text.fill",
// //     "stylers": [
// //       {
// //         "color": "#9e9e9e"
// //       }
// //     ]
// //   }
// // ]''';
// // }
//
// import 'dart:async';
//
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter/material.dart';
//
// import '../all_constant.dart';
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// // Starting point latitude
// double _originLatitude;
//
// // Starting point longitude
// double _originLongitude;
// // Destination latitude
// double _destLatitude = 23.017381;
// // Destination Longitude
// double _destLongitude = 72.601417;
// // Markers to show points on the map
// Map<MarkerId, Marker> markers = {};
//
// PolylinePoints polylinePoints = PolylinePoints();
// Map<PolylineId, Polyline> polylines = {};
//
// class _MyAppState extends State<MyApp> {
//   // Google Maps controller
//   Completer<GoogleMapController> _controller = Completer();
//   // Configure map position and zoom
//   static final CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(_originLatitude, _originLongitude),
//     zoom: 9.4746,
//   );
//
//   @override
//   void initState() {
//     /// add origin marker origin marker
//     _originLatitude = Prefs.getDouble(Const.latitude);
//     _originLongitude = Prefs.getDouble(Const.longitude);
//     _addMarker(
//       LatLng(_originLatitude, _originLongitude),
//       "origin",
//       BitmapDescriptor.defaultMarker,
//     );
//
//     // Add destination marker
//     _addMarker(
//       LatLng(_destLatitude, _destLongitude),
//       "destination",
//       BitmapDescriptor.defaultMarkerWithHue(90),
//     );
//
//     _getPolyline();
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Welcome to Flutter'),
//       ),
//       body: GoogleMap(
//         mapType: MapType.normal,
//         initialCameraPosition: _kGooglePlex,
//         myLocationEnabled: true,
//         tiltGesturesEnabled: true,
//         compassEnabled: true,
//         scrollGesturesEnabled: true,
//         zoomGesturesEnabled: true,
//         polylines: Set<Polyline>.of(polylines.values),
//         markers: Set<Marker>.of(markers.values),
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//       ),
//     );
//   }
//
//   // This method will add markers to the map based on the LatLng position
//   _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
//     MarkerId markerId = MarkerId(id);
//     Marker marker =
//         Marker(markerId: markerId, icon: descriptor, position: position);
//     markers[markerId] = marker;
//   }
//
//   _addPolyLine(List<LatLng> polylineCoordinates) {
//     PolylineId id = PolylineId("poly");
//     Polyline polyline = Polyline(
//       polylineId: id,
//       points: polylineCoordinates,
//       width: 4,
//       color: Const.primaryColor,
//     );
//     polylines[id] = polyline;
//     setState(() {});
//   }
//
//   void _getPolyline() async {
//     List<LatLng> polylineCoordinates = [];
//
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       "AIzaSyDHvNc2AIRogHxsQvdd8jDC0T2kwLmGDZA",
//       PointLatLng(_originLatitude, _originLongitude),
//       PointLatLng(_destLatitude, _destLongitude),
//       travelMode: TravelMode.driving,
//     );
//     if (result.points.isNotEmpty) {
//       result.points.forEach((PointLatLng point) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//     } else {
//       print(result.errorMessage);
//     }
//     _addPolyLine(polylineCoordinates);
//   }
// }

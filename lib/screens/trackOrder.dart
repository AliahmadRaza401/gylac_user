import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:gyalcuser_project/screens/profile/loading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/App_Menu.dart';
import '../widgets/customer_draggable.dart';

class TrackOrder extends StatefulWidget {
  TrackOrder({Key? key}) : super(key: key);

  @override
  _TrackOrderState createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  var scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _deviceToken();
  }

  _deviceToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // UserProvider _user = Provider.of<UserProvider>(context, listen: false);
    //
    // if (_user.userModel?.token != preferences.getString('token')) {
    //   Provider.of<UserProvider>(context, listen: false).saveDeviceToken();
    // }
  }

  @override
  Widget build(BuildContext context) {
  //  UserProvider userProvider = Provider.of<UserProvider>(context);

    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.day, now.month, now.year);
    return SafeArea(
      child: Scaffold(
        key: scaffoldState,
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.white,
          title:Center(
          child: Text("Track Order",style: TextStyle(color:Colors.black,fontSize: 16,))),
          leading: Builder(
                  builder:(context)=>IconButton(
                icon: Icon(Icons.menu_rounded,color: Colors.black,),
                onPressed: () => Scaffold.of(context).openDrawer(),
          ), 
                    
                   
              ),
        ),
        drawer: AppMenu(),
        body: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child:Stack(children: [
            MapScreen(scaffoldState),
          ],)
          
          )
        
        
        )
        
        
        );
          
}
}class MapScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldState;

  MapScreen(this.scaffoldState);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapsPlaces? googlePlaces;
  TextEditingController destinationController = TextEditingController();
  Color darkBlue = Colors.black;
  Color grey = Colors.grey;
  GlobalKey<ScaffoldState> scaffoldSate = GlobalKey<ScaffoldState>();
  String position = "postion";

  @override
  void initState() {
    super.initState();
    scaffoldSate = widget.scaffoldState;
  }

  @override
  Widget build(BuildContext context) {
  // AppStateProvider appState = Provider.of<AppStateProvider>(context);
    return /*appState.center == null
        ? Loading()
        : Stack(
            children: <Widget>[
              GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: appState.center, zoom: 15),
                onMapCreated: appState.onCreate,
                myLocationEnabled: true,
                mapType: MapType.normal,
                tiltGesturesEnabled: true,
                compassEnabled: false,
                markers: appState.markers,
                onCameraMove: appState.onCameraMove,
                polylines: appState.poly,
              ),
              Positioned(
                top: 10,
                left: 15,
                child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ), 
              ),
              Positioned(
                
                
               
              child:Container(
                alignment: Alignment.bottomCenter,
                child: RiderWidget())
              )
            ],
          );*/
    Container();
  }
}







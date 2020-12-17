import 'package:flutter/material.dart';
import '../services/location.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future getLocation() async {
    print('requesting location...');
    final service = Location();
    final position = await service.getLocation();
    if (position == null) {
      print('could not acquire location.');
    } else {
      print(position);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () async {
            //Get the current location
            await getLocation();
          },
          child: Text('Get Location'),
        ),
      ),
    );
  }
}

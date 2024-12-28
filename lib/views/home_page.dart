import 'package:flutter/material.dart';
import 'package:flutter_assignment/views/user_card.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class HomePage extends StatelessWidget {
  final userController = Get.put(UserController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: _buildAppBar(size),
      body: Column(
        children: [
          _buildLocationDisplay(size),
          Expanded(child: _buildBody(size)),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(Size size) {
    return PreferredSize(
      preferredSize: Size.fromHeight(size.height * 0.1),
      child: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'User Management App',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white70),
        ),
        centerTitle: true,
      ),
    );
  }

  Widget _buildBody(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Obx(
        () => ListView.builder(
          padding: EdgeInsets.only(top: size.height * 0.02),
          itemCount: userController.users.length,
          itemBuilder: (context, index) {
            final user = userController.users[index];
            return UserCard(user: user);
          },
        ),
      ),
    );
  }

  Widget _buildLocationDisplay(Size size) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getCurrentLocation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.all(size.height * 0.02),
            child: const CircularProgressIndicator(),
          );
        } else if (snapshot.hasError || !snapshot.hasData) {
          return Padding(
            padding: EdgeInsets.all(size.height * 0.02),
            child: const Text('Failed to get location'),
          );
        } else {
          final data = snapshot.data!;
          final latitude = data['latitude'];
          final longitude = data['longitude'];
          final address = data['address'];

          return Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
            child: Column(
              children: [
                Text(
                  'Latitude: $latitude, Longitude: $longitude',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Address: $address',
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Future<Map<String, dynamic>> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return Future.error('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location permissions are permanently denied.');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      final placemark = placemarks.first;

      String address =
          '${placemark.street}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}';

      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'address': address,
      };
    } catch (e) {
      return Future.error('Error getting location: $e');
    }
  }
}

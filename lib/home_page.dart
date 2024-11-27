import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'location_service.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Position? _currentPosition;
  String _locationMessage = "Mencari Lat dan Long...";
  bool _loading = false;

  // Mendapatkan lokasi terkini
  Future<void> _getCurrentLocation() async {
    setState(() {
      _loading = true;
    });
    try {
      final position = await LocationService.getCurrentPosition();
      setState(() {
        _currentPosition = position;
        _locationMessage =
        "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _locationMessage = 'Gagal mendapatkan lokasi: $e';
      });
    }
  }

  // Membuka Google Maps jika posisi tersedia
  void _openGoogleMaps() {
    if (_currentPosition != null) {
      LocationService.openGoogleMaps(_currentPosition!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _getCurrentLocation,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Titik Koordinat',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(_locationMessage),
            const SizedBox(height: 20),
            _loading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: _getCurrentLocation,
              child: const Text('Cari Lokasi'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openGoogleMaps,
              child: const Text('Buka Google Maps'),
            ),
          ],
        ),
      ),
    );
  }
}

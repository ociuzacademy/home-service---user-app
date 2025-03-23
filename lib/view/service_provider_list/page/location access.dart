import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:home_ease/constants/ursls.dart';
import 'package:home_ease/view/service_provider_list/model/provider_list_model.dart';
import 'package:home_ease/view/service_provider_list/service/provider_list_service.dart';
import 'package:home_ease/view/slot_selection/page/book_slot.dart';

class GeolocatorRepairPage extends StatefulWidget {
  final String service_id;
  const GeolocatorRepairPage({super.key, required this.service_id});

  @override
  _GeolocatorRepairPageState createState() => _GeolocatorRepairPageState();
}

class _GeolocatorRepairPageState extends State<GeolocatorRepairPage> {
  String _locationMessage =
      "Location not fetched. Please enable location services to get the nearest repair centers for quick and convenient access";
  bool _showRepairs = false;
  Position? _currentPosition;
  Future<ServiceProviderList>? _serviceProviderFuture;

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationMessage = "Location permission denied";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationMessage = "Location permissions are permanently denied";
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
      _locationMessage =
          "📍 Latitude: ${position.latitude}, Longitude: ${position.longitude}";
      _showRepairs = true;

      // Ensure _serviceProviderFuture is initialized properly
      _serviceProviderFuture = providerService(
        latitude: position.latitude.toString(),
        longitude: position.longitude.toString(),
        service_id: widget.service_id,
      );
    });
  }

  // double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  //   return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  // }

  @override
  void initState() {
    super.initState();
    _serviceProviderFuture =
        Future.value(ServiceProviderList(status: null, serviceProviders: []));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("🔧 Repair Locator"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _locationMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _getCurrentLocation,
              icon: Icon(Icons.location_on),
              label: Text("Access Location"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 164, 219, 235),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            _showRepairs && _currentPosition != null
                ? Expanded(
                    child: FutureBuilder<ServiceProviderList>(
                      future: _serviceProviderFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/bad request.jpg'),
                                Text("Error: ${snapshot.error}",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          );
                        }

                        if (!snapshot.hasData ||
                            snapshot.data!.serviceProviders == null ||
                            snapshot.data!.serviceProviders!.isEmpty) {
                          return const Center(
                              child: Text("No service providers found"));
                        }

                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                MediaQuery.of(context).size.width > 600 ? 3 : 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio:
                                MediaQuery.of(context).size.width > 600
                                    ? 0.9
                                    : 0.8,
                          ),
                          itemCount: snapshot.data!.serviceProviders!.length,
                          itemBuilder: (context, index) {
                            var provider =
                                snapshot.data!.serviceProviders![index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SlotBookingPage(
                                      provider: snapshot
                                              .data!.serviceProviders![
                                          index], // Pass the specific provider
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                '${UserUrl.baseUrl}/${provider.image}' ??
                                                    ''),
                                            radius: constraints.maxWidth * 0.3,
                                          ),
                                          SizedBox(
                                              height:
                                                  constraints.maxHeight * 0.05),
                                          Text(
                                            provider.username ?? 'Unknown',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    constraints.maxWidth * 0.1),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                              height:
                                                  constraints.maxHeight * 0.01),
                                          //_buildInfoRow("📞 ", provider.phone ?? 'No phone', constraints),
                                          _buildInfoRow(
                                              "",
                                              "${provider.distanceKm?.toString() ?? 'N/A'} km away",
                                              constraints),
                                          _buildInfoRow(
                                              "Slot price:",
                                              "₹${provider.price?.toString() ?? 'N/A'}",
                                              constraints),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, BoxConstraints constraints) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: constraints.maxHeight * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
                color: Colors.blueGrey,
                fontSize: constraints.maxWidth * 0.07,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(width: constraints.maxWidth * 0.02),
          Text(
            value,
            style: TextStyle(
                color: Colors.black87, fontSize: constraints.maxWidth * 0.08),
          ),
        ],
      ),
    );
  }
}

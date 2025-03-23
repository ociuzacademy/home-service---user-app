import 'package:flutter/material.dart';
import 'package:home_ease/view/payment_details_view/page/details_view.dart';
import 'package:home_ease/view/view_bookings/model/booked_model.dart';
import 'package:home_ease/view/view_bookings/service/booked_service.dart';
import 'package:home_ease/view/view_bookings/service/completed_service.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  Color getStatusColor(String status) {
    switch (status) {
      case 'ongoing':
        return Colors.orange;
      case 'booked':
        return Colors.blue;
      default:
        return Colors.black;
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleNotArrived(BuildContext context, int bookingId) async {
    try {
      final responseMessage = await completedService(
        booking_id: bookingId.toString(),
      );

      if (responseMessage.status == 'success') {
        _showSnackBar(context, 'Process has been stopped');
      } else {
        _showSnackBar(context, responseMessage.message ?? "Unknown error");
      }
    } catch (e) {
      _showSnackBar(context, 'Failed to stop: $e');
    }
  }

  Future<void> _handleCompleted(BuildContext context, int bookingId) async {
    try {
      final responseMessage = await completedService(
        booking_id: bookingId.toString(),
      );

      if (responseMessage.status == 'success') {
        _showSnackBar(
            context, 'Process completed and moved to payment process');
      } else {
        _showSnackBar(context, responseMessage.message ?? "Unknown error");
      }
    } catch (e) {
      _showSnackBar(context, 'Failed to complete: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Status'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<BookedServiceModel>>(
        future: bookedlistService(), // Replace with your actual service call
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                children: [
                  Image.asset('assets/images/noResponse.jpg'),
                  Text(
                    "Error: ${snapshot.error}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No services found"));
          }

          final bookings = snapshot.data!;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];

              return GestureDetector(
                onTap: () {},
                child: Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date: ${booking.bookingDate?.toLocal().toString().split(' ')[0]}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Price: ${booking.serviceDetails?.price}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Service: ${booking.serviceDetails?.serviceName}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Date: ${booking.bookingDate != null ? DateFormat('yyyy-MM-dd').format(booking.bookingDate!) : 'N/A'}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Start Time: ${booking.slotStartTime}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'End Time: ${booking.slotEndTime}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              decoration: BoxDecoration(
                                color: getStatusColor(booking.status ?? ''),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                booking.status ?? '',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (booking.status?.toLowerCase() == 'ongoing')
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green),
                                onPressed: () =>
                                    _handleCompleted(context, booking.id!),
                                child: const Text(
                                  'Completed',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            if (booking.status?.toLowerCase() == 'booked')
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                onPressed: () =>
                                    _handleNotArrived(context, booking.id!),
                                child: const Text(
                                  'Not Arrived',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            if (booking.status?.toLowerCase() == 'completed')
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PaymentDetails(booking_id: booking.id!.toString(), 
                                      service_name: booking.serviceDetails!.serviceName!, 
                                      visiting_date: booking.bookingDate!.toString(), 
                                      price: booking.serviceDetails!.price!.toString(),),
                                    ),
                                  );
                                }, // Fixed this parenthesis and comma here!

                                child: const Text(
                                  'Make Payment',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

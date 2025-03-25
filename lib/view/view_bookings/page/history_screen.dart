import 'package:flutter/material.dart';
import 'package:home_ease/view/payment_details_view/page/details_view.dart';
import 'package:home_ease/view/view_bookings/model/booked_model.dart';
import 'package:home_ease/view/view_bookings/service/booked_service.dart';
import 'package:home_ease/view/view_bookings/service/completed_service.dart';
import 'package:home_ease/view/view_bookings/service/not_arrived_service.dart';
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
      final responseMessage = await notArrivedService(
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Booking Status',
          style: TextStyle(
            fontSize: screenWidth * 0.05, // Responsive font size
            fontWeight: FontWeight.bold,
          ),
        ),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/noResponse.jpg',
                    width: screenWidth * 0.5, // Responsive image width
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    "Error: ${snapshot.error}",
                    style: TextStyle(
                      fontSize: screenWidth * 0.04, // Responsive font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No services found",
                style: TextStyle(
                  fontSize: screenWidth * 0.04, // Responsive font size
                ),
              ),
            );
          }

          final bookings = snapshot.data!;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];

              return GestureDetector(
                onTap: () {},
                child: Card(
                  margin: EdgeInsets.all(screenWidth * 0.03), // Responsive margin
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date: ${booking.bookingDate?.toLocal().toString().split(' ')[0]}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04, // Responsive font size
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          'Price: ${booking.serviceDetails?.price}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04, // Responsive font size
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          'Service: ${booking.serviceDetails?.serviceName}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04, // Responsive font size
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          'Date: ${booking.bookingDate != null ? DateFormat('yyyy-MM-dd').format(booking.bookingDate!) : 'N/A'}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04, // Responsive font size
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          'Start Time: ${booking.slotStartTime}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04, // Responsive font size
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          'End Time: ${booking.slotEndTime}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04, // Responsive font size
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01,
                                horizontal: screenWidth * 0.03,
                              ),
                              decoration: BoxDecoration(
                                color: getStatusColor(booking.status ?? ''),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                booking.status ?? '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.035, // Responsive font size
                                ),
                              ),
                            ),
                            if (booking.status?.toLowerCase() == 'ongoing')
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.04,
                                    vertical: screenHeight * 0.01,
                                  ),
                                ),
                                onPressed: () =>
                                    _handleCompleted(context, booking.id!),
                                child: Text(
                                  'Completed',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.035, // Responsive font size
                                  ),
                                ),
                              ),
                            if (booking.status?.toLowerCase() == 'booked')
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.04,
                                    vertical: screenHeight * 0.01,
                                  ),
                                ),
                                onPressed: () =>
                                    _handleNotArrived(context, booking.id!),
                                child: Text(
                                  'Not Arrived',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.035, // Responsive font size
                                  ),
                                ),
                              ),
                            if (booking.status?.toLowerCase() == 'completed')
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.04,
                                    vertical: screenHeight * 0.01,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PaymentDetails(
                                        booking_id: booking.id!.toString(),
                                        service_name: booking.serviceDetails!.serviceName!,
                                        visiting_date: booking.bookingDate!.toString(),
                                        price: booking.serviceDetails!.price!.toString(),
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Make Payment',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.035, // Responsive font size
                                  ),
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
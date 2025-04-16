import 'package:flutter/material.dart';
import 'package:home_ease/view/all_history/model/service_history_model.dart';
import 'package:home_ease/view/all_history/service/history_service.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking History',
        style: TextStyle(color: Colors.black,fontSize: 19,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<ServiceHistoryModel>>(
        future: historyService(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/bad_request.jpg',
                    width: 300,
                  ),
                  Text(
                    "Error: ${snapshot.error}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Book your service for viewing history",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            );
          }

          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final booking = items[index];
              final serviceDetails = booking.serviceDetails;
              return Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        serviceDetails.serviceName,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.calendar_today,
                          'Date: ${_formatDate(booking.bookingDate)}'),
                      const SizedBox(height: 4),
                      _buildInfoRow(
                          Icons.access_time,
                          'Time: ${booking.slotStartTime} - ${booking.slotEndTime}'),
                      const SizedBox(height: 4),
                      _buildInfoRow(
                        Icons.info,
                        'Status: ${booking.status}',
                        color: booking.status.toLowerCase() == 'paid'
                            ? Colors.green
                            : Colors.orange,
                      ),
                      const SizedBox(height: 4),
                      _buildInfoRow(Icons.attach_money,
                          'Price: ${serviceDetails.price.toStringAsFixed(2)}'),
                      const SizedBox(height: 4),
                      _buildInfoRow(Icons.money,
                          'Platform Fee: ${booking.platformFee}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {Color color = Colors.black}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(fontSize: 14, color: color),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
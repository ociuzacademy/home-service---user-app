import 'package:flutter/material.dart';
import 'package:home_ease/view/all_history/model/service_history_model.dart';
import 'package:home_ease/view/all_history/service/history_service.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking History'),
      ),
      body: FutureBuilder<List<ServiceHistoryModel>>(
        future:historyService(),
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
                    'assets/images/bad request.jpg',
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
              child: Text("No service found"),
            );
          }

          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final booking = items[index];
              final serviceDetails = booking.serviceDetails;
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    serviceDetails?.serviceName ?? 'No Service Name',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text(
                        'Date: ${booking.bookingDate?.toIso8601String().split('T')[0]}',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Time: ${booking.slotStartTime} - ${booking.slotEndTime}',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Status: ${booking.status}',
                        style: TextStyle(
                          fontSize: 14,
                          color: booking.status == 'paid'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Price: \$${serviceDetails?.price!.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Platform Fee: \$${booking.platformFee}',
                        style: TextStyle(fontSize: 14),
                      ),
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
}
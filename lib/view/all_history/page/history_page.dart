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
         backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<ServiceHistoryModel>>(
        future: historyService(), // Ensure this function returns Future<List<ServiceHistoryModel>>
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
                    'assets/images/bad request.jpg', // Ensure the image path is correct
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
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    serviceDetails?.serviceName?.toString() ?? 'No Service Name',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text(
                        'Date: ${booking.bookingDate?.toIso8601String().split('T')[0] ?? 'No Date'}',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Time: ${booking.slotStartTime ?? 'No Start Time'} - ${booking.slotEndTime ?? 'No End Time'}',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Status: ${booking.status?.toString() ?? 'No Status'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: booking.status == Status.PAID
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Price: ${serviceDetails?.price?.toStringAsFixed(2) ?? '0.00'}',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Platform Fee: ${booking.platformFee ?? '0.00'}',
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
import 'package:flutter/material.dart';
import 'package:home_ease/view/payment/page/payment_page.dart';
import 'package:intl/intl.dart';

class PaymentDetails extends StatelessWidget {
  final String booking_id;
  final String service_name;
  final String visiting_date;
  final String price;

  const PaymentDetails({
    super.key,
    required this.booking_id,
    required this.service_name,
    required this.visiting_date,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate platform fee (10% of the price)
    double platformFee = double.parse(price) * 0.10;
    double totalAmount = double.parse(price) + platformFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                _buildDetailRow('Service Name:', service_name),
                _buildDetailRow('Visiting Date:',
                    DateFormat('dd/MM/yyyy').format(DateTime.parse(visiting_date))),
                _buildDetailRow('Price:', price),
                _buildDetailRow('Platform Fee (10%):', platformFee.toStringAsFixed(2)),
                const Divider(thickness: 1, height: 20),
                _buildDetailRow('Total Amount:', totalAmount.toStringAsFixed(2),
                    isBold: true),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      // Navigate to the payment screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserPayment( total_price: price, booking_id: booking_id,),
                        ),
                      );
                    },
                    child: const Text('Proceed to Payment', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 33, 32, 32),fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? Colors.blueAccent : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:home_ease/view/slot_selection/service/book_slot_service.dart';
import 'package:home_ease/view/slot_selection/service/confirm_book_service.dart';
import 'package:intl/intl.dart';
import 'package:home_ease/constants/ursls.dart';
import 'package:home_ease/view/service_provider_list/model/provider_list_model.dart';
import 'package:home_ease/view/slot_selection/model/available_slot_model.dart';

class SlotBookingPage extends StatefulWidget {
  final ServiceProvider provider;
  const SlotBookingPage({super.key, required this.provider});

  @override
  State<SlotBookingPage> createState() => _SlotBookingPageState();
}

class _SlotBookingPageState extends State<SlotBookingPage> {
  DateTime? _selectedDate;
  int? _selectedSlotIndex;
  List<AvailableSlot> _availableSlots = [];
  bool _isLoading = false;

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 7)),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _selectedSlotIndex = null; // Reset selected slot when date changes
      });
      _fetchAvailableSlots(); // Fetch slots after selecting a date
    }
  }

  void _toggleSlot(int index) {
    setState(() {
      _selectedSlotIndex = (_selectedSlotIndex == index) ? null : index;
    });
  }

  Future<void> _fetchAvailableSlots() async {
    if (_selectedDate == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Format the date as yyyy-MM-dd
      String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);

      var response = await confirmSlotService(
        date: formattedDate, // Pass the formatted date to the API
        provider_id: widget.provider.id.toString(),
      );

      setState(() {
        _availableSlots = response.availableSlots ?? [];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch slots: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _confirmBooking() async {
    if (_selectedSlotIndex == null) return;

    var selectedSlot = _availableSlots[_selectedSlotIndex!];

    try {
      final responseMessage = await confirmCheckoutScreenService(
        slot_id: selectedSlot.slot!.id.toString(),
        provider_id: widget.provider.id.toString(),
        date: DateFormat('yyyy-MM-dd').format(_selectedDate!),
      );

      if (responseMessage.status == 'success') {
        if (mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Proceed to Payment"),
                content: const Text(
                    "Do you want to continue to the payment page?\nIf there is any cancellation, please contact the shop."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("No"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigate to the payment page
                    },
                    child: const Text("Yes"),
                  ),
                ],
              );
            },
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseMessage.message ?? "Unknown error")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Slot'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Provider Details Card
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage('${UserUrl.baseUrl}/${widget.provider.image}' ?? ''),
                      radius: 50,
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.provider.username ?? 'Unknown',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(height: 4),
                    Text("📍 ${widget.provider.distanceKm?.toString() ?? 'N/A'} km away", style: TextStyle(fontSize: 16)),
                    SizedBox(height: 4),
                    Text("📞 ${widget.provider.phone ?? 'No phone'}", style: TextStyle(fontSize: 16)),
                    SizedBox(height: 4),
                    Text(widget.provider.email?.toString() ?? 'N/A', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 4),
                    Text("Slot price: ${widget.provider.price?.toString() ?? 'N/A'}", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Date Selection Button
            ElevatedButton.icon(
              onPressed: _pickDate,
              icon: Icon(Icons.calendar_today),
              label: Text(
                _selectedDate == null
                    ? 'Select Date'
                    : 'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}', // Format the date for display
              ),
            ),
            SizedBox(height: 20),

            // Loading Indicator
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else if (_selectedDate == null)
              Text('Please select a date to see available slots')
            else if (_availableSlots.isEmpty)
              Center(child: Text("No slots available for the selected date"))
            else
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1.5,
                ),
                itemCount: _availableSlots.length,
                itemBuilder: (context, index) {
                  var slot = _availableSlots[index];
                  bool isSelected = _selectedSlotIndex == index;
                  return GestureDetector(
                    onTap: () => _toggleSlot(index),
                    child: Card(
                      color: isSelected ? Colors.blueAccent : Colors.white.withOpacity(0.7),
                      elevation: isSelected ? 6 : 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Text(
                          "${slot.slot?.slotStart ?? 'N/A'} - ${slot.slot?.slotEnd ?? 'N/A'}",
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            SizedBox(height: 20),

            // Confirm Booking Button
            if (_selectedSlotIndex != null)
              ElevatedButton(
                onPressed: _confirmBooking,
                child: Text('Confirm Booking'),
              ),
          ],
        ),
      ),
    );
  }
}
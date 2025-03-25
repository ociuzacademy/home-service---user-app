import 'package:flutter/material.dart';
import 'package:home_ease/view/service_provider_list/page/location%20access.dart';
import 'package:home_ease/view/subservice_view/model/subcategory_model.dart';
import 'package:home_ease/view/subservice_view/service/subcategory_service.dart';

class ServicesListPage extends StatelessWidget {
  final String category_id;

  const ServicesListPage({
    super.key,
    required this.category_id,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double padding = screenSize.width * 0.04;
    final double containerHeight = screenSize.height * 0.15;
    final double fontSize = screenSize.width * 0.05;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Services List'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<SubCategoryModel>>(
        future: subServiceList(category_id: category_id),
        builder: (context, snapshot) {
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle error state
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: TextStyle(fontSize: fontSize * 0.8, color: Colors.black54),
              ),
            );
          }

          // Handle empty data state
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No items found",
                style: TextStyle(fontSize: fontSize * 0.8, color: Colors.black54),
              ),
            );
          }

          // Data is available, build the list
          List<SubCategoryModel> items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GeolocatorRepairPage(
                          service_id: item.id.toString()),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(padding * 0.3),
                  padding: EdgeInsets.all(padding * 0.5),
                  height: containerHeight,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.blueAccent,
                        Color.fromARGB(255, 93, 181, 226)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      item.serviceName ?? "No Name",
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        shadows: const [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                        letterSpacing: 1.2,
                      ),
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
import 'package:flutter/material.dart';
import 'hospital_data.dart';

class HospitalResultsModal extends StatelessWidget {
  final List<Hospital> filteredHospitals;

  const HospitalResultsModal({
    super.key,
    required this.filteredHospitals,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Results',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: filteredHospitals.length,
                itemBuilder: (context, index) {
                  final hospital = filteredHospitals[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: ListTile(
                      leading:
                          const Icon(Icons.local_hospital, color: Colors.red),
                      title: Text(hospital.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(hospital.type),
                          const SizedBox(height: 4),
                          Text(
                            'Open 24 hours',
                            style: TextStyle(color: Colors.green[700]),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.phone, color: Colors.red),
                            onPressed: () {
                              // Optional: launch phone dialer
                            },
                          ),
                          IconButton(
                            icon:
                                const Icon(Icons.directions, color: Colors.red),
                            onPressed: () {
                              // Optional: launch Google Maps
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

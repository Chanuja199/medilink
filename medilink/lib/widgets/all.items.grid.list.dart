import 'package:flutter/material.dart';
import 'package:medilink/models/medicine.model.dart';
import 'package:medilink/pages/single.pharmacy.item.view.dart';
import 'package:medilink/services/medicine.service.dart';

class AllItemsGridList extends StatefulWidget {
  const AllItemsGridList({super.key});

  @override
  State<AllItemsGridList> createState() => _AllItemsGridListState();
}

class _AllItemsGridListState extends State<AllItemsGridList> {
  List<Medicine> _medicines = [];
  bool _isLoading = true; // Track loading state
  String _errorMessage = ''; // Store error messages

  @override
  void initState() {
    super.initState();
    _fetchMedicines(); // Fetch medicines when the widget is initialized
  }

  // Fetch medicines
  Future<void> _fetchMedicines() async {
    try {
      final medicines = await MedicineService.getMedicines();
      setState(() {
        _medicines = medicines;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch medicines: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _errorMessage.isNotEmpty
            ? Center(child: Text(_errorMessage))
            : _medicines.isEmpty
                ? const Center(child: Text('No medicines found'))
                : Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 items per row
                        crossAxisSpacing: 8, // Spacing between columns
                        mainAxisSpacing: 8, // Spacing between rows
                        childAspectRatio: 0.75, // Adjust the aspect ratio
                      ),
                      itemCount: _medicines.length,
                      itemBuilder: (context, index) {
                        final medicine = _medicines[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SingleItemView(itemId: medicine.id!)));
                          },
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Medicine Image (Placeholder)
                                  Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        medicine.name[0].toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // Medicine Name
                                  Text(
                                    medicine.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  // Medicine Description (Optional)
                                  if (medicine.description != null)
                                    Text(
                                      medicine.description!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  const SizedBox(height: 5),
                                  // Medicine Price
                                  Text(
                                    '\$${medicine.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  // Medicine Stock
                                  Text(
                                    'Stock: ${medicine.stock}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
  }
}

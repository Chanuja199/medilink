import 'package:flutter/material.dart';
import 'package:medilink/models/medicine.model.dart';
import 'package:medilink/services/medicine.service.dart';

class InsidePharmacyView extends StatefulWidget {
  final int pharmacyId;
  const InsidePharmacyView({super.key, required this.pharmacyId});

  @override
  _InsidePharmacyViewState createState() => _InsidePharmacyViewState();
}

class _InsidePharmacyViewState extends State<InsidePharmacyView>
    with SingleTickerProviderStateMixin {
  List<Medicine> _medicines = [];
  bool _isLoading = true; // Track loading state
  String _errorMessage = ''; // Store error messages

  // Animation controller
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _fetchMedicines(); // Fetch medicines when the widget is initialized

    // Initialize animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose animation controller
    super.dispose();
  }

  // Fetch medicines for the pharmacy
  Future<void> _fetchMedicines() async {
    try {
      List<Medicine> medicines =
          await MedicineService.getMedicinesByPharmacy(widget.pharmacyId);
      medicines = medicines
          .where((medcine) => medcine.pharmacyId == widget.pharmacyId)
          .toList();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pharmacy Medicines"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _medicines.isEmpty
                  ? const Center(child: Text('No medicines found'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _medicines.length,
                      itemBuilder: (context, index) {
                        final medicine = _medicines[index];
                        return FadeTransition(
                          opacity: _animation,
                          child: ScaleTransition(
                            scale: _animation,
                            child: Card(
                              margin: const EdgeInsets.all(8),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Medicine Image (Placeholder)
                                    Container(
                                      height: 150,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade100,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          medicine.name[0].toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 48,
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
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    // Medicine Description (Optional)
                                    if (medicine.description != null)
                                      Text(
                                        medicine.description!,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    const SizedBox(height: 10),
                                    // Medicine Price
                                    Text(
                                      'Price: \$${medicine.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    // Medicine Stock
                                    Text(
                                      'Stock: ${medicine.stock}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}

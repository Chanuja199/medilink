import 'package:flutter/material.dart';
import 'package:medilink/models/pharmacy.model.dart';
import 'package:medilink/pages/inside.pharmacy.view.dart';
import 'package:medilink/services/pharmacy.service.dart';

class PharmaciesHorizontalList extends StatefulWidget {
  const PharmaciesHorizontalList({super.key});

  @override
  _PharmaciesHorizontalListState createState() =>
      _PharmaciesHorizontalListState();
}

class _PharmaciesHorizontalListState extends State<PharmaciesHorizontalList>
    with SingleTickerProviderStateMixin {
  List<Pharmacy> _pharmacies = [];
  bool _isLoading = true; // Track loading state
  String _errorMessage = ''; // Store error messages

  // Animation controller
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _fetchPharmacies(); // Fetch pharmacies when the widget is initialized

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

  // Fetch pharmacies
  Future<void> _fetchPharmacies() async {
    try {
      final pharmacies = await PharmacyService().getPharmacies();
      setState(() {
        _pharmacies = pharmacies;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch pharmacies: $e';
        _isLoading = false;
      });
    }
  }

  // Get initials from pharmacy name
  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 250,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _pharmacies.isEmpty
                  ? const Center(child: Text('No pharmacies found'))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _pharmacies.length,
                      itemBuilder: (context, index) {
                        final pharmacy = _pharmacies[index];
                        return FadeTransition(
                          opacity: _animation,
                          child: ScaleTransition(
                            scale: _animation,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            InsidePharmacyView(
                                                pharmacyId: pharmacy.id!)));
                              },
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // CircleAvatar with initials
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.blue.shade100,
                                      child: Text(
                                        _getInitials(pharmacy.name),
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // Pharmacy name
                                    Text(
                                      pharmacy.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 5),
                                    // Pharmacy location (city)
                                    if (pharmacy.location != null)
                                      Text(
                                        pharmacy.location!['city'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                        textAlign: TextAlign.center,
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

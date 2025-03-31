import 'package:flutter/material.dart';
import 'package:medilink/pages/inventory.page.dart';
import 'package:medilink/pages/order.page.dart';
import 'package:medilink/pages/profile.page.dart';
import 'package:medilink/pages/shop.page.dart';

class PharmacyHomePage extends StatefulWidget {
  const PharmacyHomePage({super.key});

  @override
  _PharmacyHomePageState createState() => _PharmacyHomePageState();
}

class _PharmacyHomePageState extends State<PharmacyHomePage> {
  int _selectedIndex = 0;

  // List of widgets to display for each tab
  final List<Widget> _pages = [
    const InventoryPage(),
    const OrderPage(),
    const ShopPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome Back'),
      ),
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

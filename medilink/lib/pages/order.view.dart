import 'package:flutter/material.dart';

class OrderView extends StatefulWidget {
  final int prescriptioonId;
  const OrderView({super.key, required this.prescriptioonId});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}

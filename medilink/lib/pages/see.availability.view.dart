import 'package:flutter/material.dart';
import 'package:medilink/models/medicine.model.dart';
import 'package:medilink/models/prescription.analasys.model.dart';
import 'package:medilink/services/medicine.service.dart';
import 'package:medilink/services/openai.client.dart';
import 'package:medilink/services/prescriptions.analasys.service.dart';
import 'package:medilink/widgets/availability.view.dart';

class SeeAvailabilityView extends StatefulWidget {
  final String prescription;
  final int prescriptionId;
  const SeeAvailabilityView({
    super.key,
    required this.prescription,
    required this.prescriptionId,
  });

  @override
  State<SeeAvailabilityView> createState() => _SeeAvailabilityViewState();
}

class _SeeAvailabilityViewState extends State<SeeAvailabilityView> {
  List<Medicine> allMedicines = [];
  Map<String, dynamic>? analysisResult;
  bool isLoading = true;
  String? errorMessage;

  Future<void> getAllMedicines() async {
    try {
      final result = await MedicineService.getMedicines();
      setState(() {
        allMedicines = result;
      });
      // After getting medicines, analyze the prescription
      await analyzePrescription();
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load medicines: $e";
        isLoading = false;
      });
      print(e);
    }
  }

  Future<void> analyzePrescription() async {
    try {
      final apiClient = HttpApiClient();
      final analysisService = PrescriptionAnalysisService(apiClient: apiClient);

      final response = await analysisService.analyzePrescription(
        widget.prescription,
        allMedicines,
      );

      setState(() {
        if (response.success) {
          analysisResult = response.data;

          try {
            final analysis = PrescriptionAnalysis.fromJson(analysisResult!);
            print(
                "Successfully parsed with ${analysis.prescribedMedicines.length} medicines");
          } catch (parseError) {
            print("Error parsing with model: $parseError");
          }
        } else {
          errorMessage = response.message;
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to analyze prescription: $e";
        isLoading = false;
      });
      print(e);
    }
  }

  @override
  void initState() {
    getAllMedicines();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medicine Availability"),
      ),
      body: isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Analyzing prescription..."),
                ],
              ),
            )
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                            errorMessage = null;
                          });
                          getAllMedicines();
                        },
                        child: const Text("Try Again"),
                      ),
                    ],
                  ),
                )
              : AvailabilityResultView(
                  analysisResult: analysisResult!,
                  prescriptionId: widget.prescriptionId,
                ),
    );
  }
}

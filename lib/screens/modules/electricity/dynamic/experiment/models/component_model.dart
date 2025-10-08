// lib/screens/modules/electricity/dynamic/experiment/models/component_model.dart

enum ComponentType { lamp, battery, switchComponent }

class CircuitComponent {
  final String id;
  final ComponentType type;
  bool isConnected; // Status apakah komponen terpasang/tidak dicabut
  bool isWorking;   // Status apakah komponen (lampu) menyala/berfungsi
  
  final double x;
  final double y;

  CircuitComponent({
    required this.id,
    required this.type,
    this.isConnected = true,
    this.isWorking = true,
    required this.x,
    required this.y,
  });
}
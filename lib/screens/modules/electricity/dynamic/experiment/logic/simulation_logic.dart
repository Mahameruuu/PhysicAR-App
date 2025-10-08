import '../models/component_model.dart';

class SimulationLogic {
  // Logika rangkaian SERI (tetap)
  static bool calculateSeriesLightStatus(
      bool isSwitchOn, List<CircuitComponent> lamps) {
    if (!isSwitchOn) return false;

    for (var lamp in lamps) {
      if (!lamp.isConnected) return false;
    }
    return true;
  }

  // Logika rangkaian PARALEL (asli)
  static void calculateParallelLightStatus(
      bool isSwitchOn, List<CircuitComponent> lamps) {
    if (!isSwitchOn) {
      // Saklar mati → semua lampu mati
      for (var lamp in lamps) {
        lamp.isWorking = false;
      }
      return;
    }

    // Setiap lampu menyala jika dia tersambung
    for (var lamp in lamps) {
      lamp.isWorking = lamp.isConnected;
    }

    // Jika semua lampu terputus → arus berhenti total (opsional)
    final allDisconnected = lamps.every((lamp) => !lamp.isConnected);
    if (allDisconnected) {
      for (var lamp in lamps) {
        lamp.isWorking = false;
      }
    }
  }
}

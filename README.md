
---

## 📱 **README – Frontend Mobile (Flutter)**

```markdown
# 📱 Mobile App - Flutter

## 📘 Deskripsi
Aplikasi ini dibangun menggunakan **Flutter**, dan terhubung langsung dengan **Laravel API Backend**.  
Aplikasi menampilkan data secara real-time melalui endpoint API serta menyediakan UI interaktif untuk pengguna.

---

## ⚙️ Fitur Utama
- Integrasi API Laravel
- Desain UI responsif
- Navigasi multi-halaman
- Manajemen state (Provider / Bloc)
- Validasi form dan autentikasi pengguna

```

---

## 🧰 Setup Lingkungan

### 1️⃣ Clone Repository
```bash
git clone <repo-flutter-url>
cd <repo-folder>
```

2️⃣ Install Dependencies
```bash
flutter pub get
```

3️⃣ Konfigurasi API Endpoint
Ubah base URL API Laravel di file konfigurasi (misalnya lib/config/api.dart):
const String baseUrl = "http://localhost:8000/api";

4️⃣ Jalankan Aplikasi
```bash
flutter run
```

🧪 Pengujian Aplikasi

1. Pastikan backend Laravel aktif.
2. Jalankan aplikasi di emulator / device.
3. Coba login / CRUD data.
4. Jika gagal, cek log error di console Flutter.

🚀 Deployment
Android
```bash
flutter build apk
```
Output file: build/app/outputs/flutter-apk/app-release.apk

iOS
```bash
flutter build ios
```
Pastikan Xcode sudah terinstal.

📁 Struktur Folder Penting
```text
lib/
 ├── main.dart
 ├── screens/
 ├── models/
 ├── services/
 └── config/
assets/
pubspec.yaml
```

🤝 Integrasi dengan Backend
Pastikan endpoint Laravel sudah aktif dan dapat diakses dari perangkat.
Contoh konfigurasi:
```bash
final response = await http.get(Uri.parse('$baseUrl/users'));
```

👨‍💻 Kontributor
Frontend Developer: [M. Mahameru. A]

Framework: Flutter

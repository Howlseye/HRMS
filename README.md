# HRMS Mobile

Dokumentasi teknis aplikasi mobile Human Resource Management System (HRMS) berbasis Flutter yang terintegrasi dengan backend ERPNext/Frappe HRMS.

---

## Tech Stack

### Core & Framework
- **Language**: Dart (SDK `^3.12.2`)
- **Framework**: Flutter
- **Platform Support**: Android, iOS

### Libraries & Dependencies
- **State Management**: `flutter_riverpod` (^3.4.3)
- **Routing & Navigation**: `go_router` (^18.0.1)
- **Networking**: `dio` (^5.11.1)
- **Session & Cookies**: `cookie_jar` (^4.0.9), `dio_cookie_manager` (^3.5.0)
- **Environment Config**: `flutter_dotenv` (^6.0.1)
- **Hardware & Device**:
  - Location/GPS: `geolocator` (^14.0.1)
  - Camera & File: `image_picker` (^1.2.3), `file_picker` (^13.1.0), `gal` (^2.3.3)
- **Local Storage**: `shared_preferences` (^2.5.5), `path_provider` (^2.1.6)
- **UI & Media**:
  - `flutter_svg` (^2.3.0)
  - `lottie` (^3.5.1)
  - `cached_network_image` (^4.0.0)
  - `intl` (^0.20.2)

---

## Arsitektur Proyek

Aplikasi menerapkan **Feature-First Architecture** yang dikombinasikan dengan pembagian layer berbasis **Riverpod**:

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_assets.dart         # Path aset statis (icons, images, lottie)
│   │   ├── app_colors.dart         # Palet warna aplikasi
│   │   └── app_strings.dart        # Seluruh string UI tersentralisasi
│   ├── network/
│   │   ├── api_endpoints.dart      # Daftar endpoint API backend Frappe
│   │   └── dio_client.dart         # Konfigurasi instance Dio & CookieManager
│   ├── router/
│   │   └── app_router.dart         # Deklarasi GoRoute dan navigasi aplikasi
│   ├── services/                   # Abstraksi hardware API (kamera, file)
│   ├── theme/
│   │   ├── app_text_styles.dart    # Konfigurasi tipografi (Inter & Nunito)
│   │   └── app_theme.dart          # ThemeData aplikasi
│   ├── utils/                      # Fungsi utilitas murni (geofencing, formatter)
│   └── widgets/                    # Komponen UI global yang digunakan lintas fitur
│
└── features/
    ├── account/                    # Manajemen profil & logout
    ├── announcement/               # Daftar dan detail pengumuman
    ├── attendance/                 # Logika check-in/out & validasi GPS radius
    ├── auth/                       # Otentikasi sesi & lupa password
    ├── employee/                   # Direktori karyawan & filter
    ├── home/                       # Dashboard utama
    ├── leave/                      # Pengajuan cuti & alokasi saldo
    ├── log_book/                   # Daily log, timesheet matrix & approval
    ├── main/                       # Shell bottom navigation bar
    ├── notifications/              # Sistem notifikasi
    ├── reimbursement/              # Pengajuan klaim biaya & lampiran nota
    └── splash/                     # Inisialisasi aplikasi & pengecekan sesi
```

### Struktur Tiap Fitur (`lib/features/<nama_fitur>/`)
1. **`models/`**: Representasi data, model entitas, dan serialisasi JSON (`fromJson`/`toJson`).
2. **`repositories/`**: Abstraksi data layer untuk komunikasi HTTP via Dio ke backend.
3. **`providers/`**: State management Riverpod (`Provider`, `FutureProvider`, `StateNotifierProvider`), menangani logika bisnis dan pemanggilan repository.
4. **`screens/`**: Komponen tampilan halaman utama (StatefulWidget / ConsumerWidget).
5. **`widgets/`**: Komponen UI modular spesifik yang hanya digunakan pada fitur tersebut.

---

## Konfigurasi & Environment

### 1. Environment Variables (`.env`)
Aplikasi memerlukan berkas `.env` pada root direktori:

```env
BASE_URL=https://your-hrms-erpnext-domain.com
```

### 2. Assets & Fonts
Seluruh aset lokal dideklarasikan di `pubspec.yaml`:
- **Images**: `assets/images/`
- **Icons**: `assets/icons/`
- **Lottie**: `assets/lottie/`
- **Fonts**:
  - `Inter`: Regular (400), Medium (500)
  - `Nunito`: SemiBold (600), ExtraBold (800)

---

## Network & Session Handling

### 1. Dio Client & Cookie Persistence
- Backend Frappe menggunakan otentikasi berbasis session cookie (`sid`).
- Instance `dioProvider` dikonfigurasi dengan:
  - Base URL dinamis dari `dotenv.env['BASE_URL']`.
  - `PersistCookieJar` via `path_provider` (dokumen aplikasi) untuk mempertahankan sesi login saat aplikasi dibuka kembali.
  - `DioCookieManager` untuk otomatis menyertakan cookie pada setiap HTTP request.

---

## Menjalankan Proyek

### Instalasi Dependensi
```bash
flutter pub get
```

### Menjalankan Aplikasi
```bash
flutter run
```

### Static Analysis
```bash
flutter analyze
```

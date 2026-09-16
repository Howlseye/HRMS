class AppStrings {
  AppStrings._();

  // Common
  static const String appName = 'HRMS 79';
  static const String appSubtitle = 'Human Resource\nManagement System';
  
  // Login Screen
  static const String welcome = 'Selamat Datang';
  static const String emailLabel = 'Email';
  static const String emailHint = 'Masukkan email';
  static const String passwordLabel = 'Password';
  static const String passwordHint = 'Masukkan password';
  static const String rememberMe = 'Remember me';
  static const String signIn = 'Sign in';
  static const String forgotPassword = 'Lupa Password';
  static const String loginFailed = 'Login gagal. Periksa kembali email dan password Anda.';

  // Forgot Password Screen
  static const String forgotPasswordTitle = 'Lupa Password';
  static const String sendResetEmail = 'Kirim email reset password';
  static const String spamNotice =
      'Cek kotak spam jika Anda tidak menerima email untuk reset password di kotak masuk.';
  static const String backToLogin = 'Kembali ke halaman login';

  // Home Screen
  static const String goodMorning = 'Selamat pagi,';
  static const String date = 'Sel, 01 Sep 2026';
  static const String workHours = 'Jam Kerja 08:00 – 17:00';
  static const String workHoursPrefix = 'Jam Kerja ';
  static const String checkIn = 'Check In';
  static const String checkOut = 'Check Out';
  static const String notCheckedIn = 'Belum check in hari ini';
  static const String alreadyCheckedIn = 'Menunggu jam kerja selesai';
  static const String alreadyCheckedOut = 'Sudah check out hari ini';
  
  static const String menuAbsensi = 'Absensi';
  static const String menuReimburse = 'Reimburse';
  static const String menuLembur = 'Lembur';
  static const String menuCuti = 'Cuti';
  static const String menuSlipGaji = 'Slip Gaji';
  static const String menuLogBook = 'Log Book';
  static const String menuAll = 'Semua';

  // Attendance Screen
  static const String titleAttendance = 'Absensi';
  static const String historyAttendance = 'Histori Absensi';
  static const String logActivity = 'Log Activity';
  static const String statCuti = 'Cuti / Sakit';
  static const String statTerlambat = 'Terlambat';
  static const String statPulangAwal = 'Pulang Awal';
  static const String statTidakAbsen = 'Tidak Absen';
  static const String filterMonth = 'Agustus 2026';
  static const String attendanceList = 'Daftar Kehadiran';
  static String totalDays(int count) => '$count hari';
  static const String errorLoadData = 'Gagal memuat data';
  static const String noAttendanceHistory = 'Tidak ada riwayat absensi';
  static const String noReason = 'Tidak mencantumkan alasan';

  static const String todatsActivity = 'Aktivitas Hari Ini';
  static const String detailAttendanceTitle = 'Detail Attendance';
  static const String reasonLate = 'Alasan Terlambat';
  static const String reasonEarlyOut = 'Alasan Pulang Awal';
  static const String noteLateCheckInPrefix = 'Terlambat ';
  static const String noteLateCheckInSuffix = '. Isi alasan keterlambatan untuk melanjutkan check in.';
  static const String noteEarlyCheckOutPrefix = 'Pulang awal ';
  static const String noteEarlyCheckOutSuffix = '. Isi alasan untuk melanjutkan check out.';
  static const String checkInLate = 'Check In terlambat';
  static const String checkOutEarly = 'Check Out lebih awal';
  static const String noteLateCheckInHint = 'Jelaskan alasan terlambat';
  static const String noteEarlyCheckOutHint = 'Jelaskan alasan pulang awal';
  static const String sendCheckIn = 'Kirim Check In';
  static const String sendCheckOut = 'Kirim Check Out';
  static const String none = '-';
  static const String notLate = 'Tidak terlambat';
  static const String notEarlyOut = 'Tidak pulang awal';
  
  static const String todaysActivity = 'Aktivitas Hari Ini';
  static const String emptyActivity = 'Tidak ada aktivitas hari ini';
  static const String viewAll = 'Lihat Semua';
  static const String announcement = 'Pengumuman';
  static const String checkInSent = 'Check In Dikirim';
  static const String checkOutSent = 'Check Out Dikirim';
  static const String back = 'Kembali';

  // Bottom Navigation
  static const String navHome = 'Home';
  static const String navEmployee = 'Employee';
  static const String navInbox = 'Inbox';
  static const String navAccount = 'Account';
  // Account Screen
  static const String menuAccount = 'Account';
  static const String myActivity = 'Aktivitas Saya';
  static const String attendanceLog = 'Attendance Log';
  static const String logBook = 'Log Book';
  static const String submission = 'Pengajuan';
  static const String submitLeave = 'Ajukan Cuti';
  static const String submitOvertime = 'Ajukan Lembur';
  static const String submitPayslip = 'Ajukan Slip Gaji';
  static const String reimbursement = 'Rembursement';
  static const String logout = 'Logout';

  static const String menuInbox = 'Inbox';
  static const String markAllRead = 'Tandai Sudah Dibaca';
  static const String statusApproved = 'Approved';
  static const String statusRejected = 'Rejected';
  static const String statusWaiting = 'Waiting';

  static const String menuEmployee = 'Employee';
  static const String detailEmployeeTitle = 'Detail Employee';
  static const String joinDate = 'Tanggal Bergabung';
  static const String phoneNumber = 'No. Handphone';
  static const String email = 'Email';
  static const String location = 'Lokasi';
  static const String placement = 'Penempatan';
  static const String searchEmployeeHint = 'Cari nama atau jabatan';

  static const String filterLocation = 'Lokasi';
  static const String filterRole = 'Role';
  static const String resetFilter = 'Reset Filter';
  static const String applyFilter = 'Terapkan Filter';

  static const String popupMarkAllReadTitle = 'Tandai Semua Sudah Dibaca';
  static const String popupMarkAllReadDesc = 'Apakah Anda yakin ingin menandai semua inbox sebagai sudah dibaca? Tindakan ini tidak dapat dibatalkan.';
  static const String popupConfirm = 'Konfirmasi';
  static const String popupCancel = 'Batal';

  static const String errorServerSide = 'Server Side Error';
  static const String errorDataNotFound = 'Data Not Found';

  static const List<String> filterAvailableLocations = ['Bandung', 'Jakarta'];
  static const List<String> filterAvailableRoles = [
    'Accounting',
    'Software Engineer',
    'Internship',
    'HR',
    'UI/UX Designer',
    'Marketing',
    'Infrastructure'
  ];

  static const List<String> monthNames = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];
}

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

  // Forgot Password Screen
  static const String forgotPasswordTitle = 'Lupa Password';
  static const String sendResetEmail = 'Kirim email reset password';
  static const String spamNotice =
      'Cek kotak spam jika Anda tidak menerima email untuk reset password di kotak masuk.';
  static const String backToLogin = 'Kembali ke halaman login';

  // Home Screen
  static const String goodMorning = 'Selamat pagi,';
  static const String userName = 'Aldy Pratama';
  static const String date = 'Sel, 01 Sep 2026';
  static const String workHours = 'Jam Kerja 08:00 – 17:00';
  static const String checkIn = 'Check In';
  static const String checkOut = 'Check Out';
  static const String alreadyCheckedOut = 'Sudah check out hari ini';
  
  static const String menuAbsensi = 'Absensi';
  static const String menuReimburse = 'Reimburse';
  static const String menuLembur = 'Lembur';
  static const String menuCuti = 'Cuti';
  static const String menuSlipGaji = 'Slip Gaji';
  static const String menuLogBook = 'Log Book';
  static const String menuAll = 'Semua';

  static const String todaysActivity = 'Aktivitas Hari Ini';
  static const String viewAll = 'Lihat Semua';
  static const String announcement = 'Pengumuman';

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
  static const String userRole = 'UI/UX Designer';

  static const String menuInbox = 'Inbox';
  static const String markAllRead = 'Tandai Sudah Dibaca';
  static const String statusApproved = 'Approved';
  static const String statusRejected = 'Rejected';
  static const String statusWaiting = 'Waiting';

  static const String menuEmployee = 'Employee';
  static const String searchEmployeeHint = 'Cari nama atau jabatan';

  static const String filterLocation = 'Lokasi';
  static const String filterRole = 'Role';
  static const String resetFilter = 'Reset Filter';
  static const String applyFilter = 'Terapkan Filter';

  static const String popupMarkAllReadTitle = 'Tandai Semua Sudah Dibaca';
  static const String popupMarkAllReadDesc = 'Apakah Anda yakin ingin menandai semua inbox sebagai sudah dibaca? Tindakan ini tidak dapat dibatalkan.';
  static const String popupConfirm = 'Konfirmasi';
  static const String popupCancel = 'Batal';

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
}

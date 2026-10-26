class AppStrings {
  AppStrings._();

  // Common
  static const String appName = 'HRMS 79';
  static const String appSubtitle = 'Human Resource\nManagement System';
  static const String requiredAsterisk = ' *';
  
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
  static const String resetEmailSent = 'Instruksi reset password telah dikirim ke email Anda.';
  static const String resetEmailFailed = 'Gagal mengirim email reset password.';

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
  
  static const String wfhConfirmationTitle = 'Konfirmasi WFH';
  static const String wfhConfirmationMessage = 'Lokasi Anda berada di luar radius kantor. Absensi ini akan tercatat sebagai WFH. Yakin ingin melanjutkan?';
  
  static const String menuAbsensi = 'Absensi';
  static const String menuReimburse = 'Reimburse';
  static const String menuCuti = 'Cuti';
  static const String menuPengumuman = 'Pengumuman';
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
  static const String noAttendanceHistory = 'Tidak ada riwayat kehadiran';
  static const String noAttendanceHistoryDesc = 'Belum ada riwayat kehadiran yang\ntercatat untuk periode ini.';
  static const String noReason = 'Tidak mencantumkan alasan';

  // Admin Home Screen
  static const String approvalDailyLog = 'Persetujuan Daily Log';
  static const String reviewToday = 'Review Hari Ini';
  static const String participantsNeedApproval = 'peserta perlu persetujuan';
  static const String totalParticipants = 'Total Peserta';
  static const String waitingApprove = 'Waiting Approve';
  static const String notSubmit = 'Not Submit';
  
  // Log Book Tabs
  static const String tabApproval = 'Persetujuan';
  static const String tabMyLog = 'Log Saya';
  static const String todayDateAdmin = 'Hari ini, 1 Agustus 2026';
  static const String labelHariIni = 'Hari ini';
  static const String noApprovalTitle = 'Tidak Ada Persetujuan';
  static const String allTalentApprovedSubtitle = 'Semua talent sudah disetujui';
  static const String totalParticipantsValue = '171';

  // Log Book Screen (Dummy Data)
  static const String logBookTitle = 'Log Book';
  static const String dummyMonth = 'Agustus 2026';
  static const String statDaysRecorded = 'Hari Tercatat';
  static const String statDaysValue = '20/20';
  static const String statWaiting = 'Waiting';
  static const String statWaitingValue = '0';
  static const String statRejected = 'Rejected';
  static const String statRejectedValue = '0';
  static const String statMissed = 'Missed';
  static const String statusDraft = 'Draft';
  static const String todayActivityInfoMsg = 'Anda dapat memilih daily log pada bagian ini untuk mencatat task yang dikerjakan hari ini';
  static const String listDailyLog = 'List Daily Log';
  static const String btnExport = 'Export';
  static const String btnReject = 'Tolak';
  static const String btnApprove = 'Setujui';
  static const String dailyLogTitle = 'Daily Log';
  static const String detailLogBookTitle = 'Log Book Detail';
  static const String nameLabel = 'Nama';
  static const String customerLabel = 'Customer';
  static const String periodLabel = 'Periode';
  static const String fullNameLabel = 'Nama Lengkap';
  static const String dummyFullName = 'Nikola Sagala';
  static const String companyLabel = 'Perusahaan';
  static const String dummyCompany = 'Padepokan Tujuh Sembilan';
  static const String projectLabel = 'Project';
  static const String dummyProject = 'HRMS';
  static const String addOrFixTaskBannerMsg = 'Anda dapat menambah atau memperbaiki task kapan saja sebelum check out.';
  static const String taskLabel = 'Task';
  static const String taskWorkedTodaySubtitle = 'Task yang anda kerjakan hari ini';
  static const String taskWorkedPastSubtitle = 'Task yang anda kerjakan';
  static const String noTaskYet = 'Belum ada task';
  static const String addTaskBtn = 'Tambahkan Task';
  static const String statusSaved = 'Tersimpan';
  static const String totalTaskLabel = 'Total Task';
  static const String taskTypeLabel = 'Jenis Task';
  static const String taskSummaryLabel = 'Ringkasan Task';
  static const String taskSummaryHint = 'Jelaskan ringkasan task yang dikerjakan';
  static const String taskConstraintHint = 'Jelaskan kendala yang dialami saat mengerjakan task';
  static const String durationLabel = 'Durasi';
  static const String hoursLabel = 'Jam';
  static const String minutesLabel = 'Menit';
  static const String btnSave = 'Simpan';
  static const String editTaskTitle = 'Edit Task';
  static const String submitLogBookPopupTitle = 'Kirim Log Book';
  static const String submitLogBookPopupDesc = 'Setelah anda mengirim log book, anda tidak dapat mengeditnya lagi. Yakin ingin melanjutkan?';
  static const String deleteTaskPopupTitle = 'Hapus Task';
  static const String deleteTaskPopupDesc = 'Task ini akan dihapus dari daily log dan tidak dapat dipulihkan.';
  static const String submitLogBookSuccessTitle = 'Log Book Dikirim';
  static const String submitLogBookSuccessMsg = 'Log Book berhasil dikirim. Anda sudah dapat melakukan check out sekarang.';
  static const String idLogBookLabel = 'ID Log Book';
  static const String dash = '-';
  static const String dummyIdLogBook = 'LB-20260901-001';
  static const String noLogBookSentToday = 'Tidak ada Log Book yang dikirim pada hari ini.';
  static const String dummyDurationDetail = '3 Jam 25 Menit';
  static const String dummySingleTaskCount = '1';
  static const String dummyDateSeptember1 = '1 September 2026';
  static const String dummyTime0759 = '07:59';
  static const String dummyTime1715 = '17:15';
  static const String dummyConstraintLoginEmail = 'Tidak bisa login email';
  static const String dummyAdminDetailDesc = 'Mempelajari konsep dasar Clean Architecture dari Robert C. Martin beserta implementasinya pada framework Flutter menggunakan referensi dari Reso Coder. Setelah itu, mengikuti pertemuan dengan mentor untuk meninjau user story dan penyusunan log inisiasi proyek. Kegiatan ditutup dengan sesi tanya jawab bersama tim developer dan mentor guna menyepakati aturan kerja proyek, termasuk persiapan pelaksanaan rutinitas Agile yang akan dimulai pada Senin depan.';
  static const String ninePlus = '9+';
  
  // Add Log Book Screen (Check Out)
  static const String addLogBookTitle = 'Check Out';
  static const String addLogBookDatePlaceholder = '1 September 2026';
  static const String addLogBookActivityQuestion = 'Apa yang kamu kerjakan hari ini';
  static const String addLogBookActivityOptionsDevelopment = 'Development';
  static const String addLogBookActivityOptionsBugFixing = 'Bug fixing';
  static const String addLogBookActivityOptionsTesting = 'Testing';
  static const String addLogBookActivityOptionsMeeting = 'Meeting';
  static const String addLogBookActivityOptionsDocumentation = 'Documentation';
  static const String addLogBookActivityOptionsSupport = 'Support';
  static const String addLogBookActivityOptionsOther = 'Other';
  static const String addLogBookSummaryLabel = 'Ringkasan Aktivitas';
  static const String addLogBookSummaryHint = 'Jelaskan aktivitas hari ini';
  static const String addLogBookConstraintLabel = 'Ada kendala?';
  static const String addLogBookConstraintHint = 'Jelaskan kendala saat mengerjakan';
  static const String btnSubmit = 'Kirim';
  
  // Add Log Book Success Screen
  static const String addLogBookSuccessTitle = 'Check Out Dikirim';
  static const String addLogBookSuccessProgressPrefix = 'Progress Bulan Ini: ';
  static const String addLogBookSuccessActivityLabel = 'Aktivitas';
  static const String addLogBookSuccessDetailLabel = 'Detail';
  static const String addLogBookSuccessConstraintLabel = 'Kendala';
  static const String btnBack = 'Kembali';

  static const String dummyDate1 = 'Sen, 3 Agu 2026';
  static const String dummyDate2 = 'Sel, 4 Agu 2026';
  static const String dummyDate3 = 'Rab, 5 Agu 2026';
  static const String dummyDate4 = 'Kam, 6 Agu 2026';
  static const String dummyDate5 = 'Jum, 7 Agu 2026';
  static const String dummyDate6 = 'Sen, 10 Agu 2026';
  static const String dummyLogActivity1 = 'Development, Bug fixing';
  static const String dummyLogDetail1 = 'Mengimplementasikan slicing UI dan penanganan state pada modul log book.';
  static const String dummyLogConstraint1 = 'Tidak ada kendala';
  static const String dummyLogActivity2 = 'Development, Testing';
  static const String dummyLogDetail2 = 'Melakukan integrasi API dan pengujian fungsional pada modul absensi.';
  static const String dummyLogActivity3 = 'Meeting, Documentation';
  static const String dummyLogDetail3 = 'Mengikuti sprint planning dan menyusun dokumentasi teknis proyek.';
  static const String dummyLogActivity4 = 'Development, Support';
  static const String dummyLogDetail4 = 'Memperbaiki isu performa dan pendampingan penggunaan sistem.';
  static const String dummyLogConstraint4 = 'Response time server terkadang lambat saat jam sibuk.';
  static const String dummyLogActivity5 = 'Development, Bug fixing';
  static const String dummyLogDetail5 = 'Melakukan refactoring kode pada provider dan repository.';
  static const String dummyLogConstraint5 = 'Kendala keterlambatan respon dari API eksternal.';
  static const String dummyLogRejectReason5 = 'Terdapat log yang tidak sesuai dengan aktivitas sebenarnya';
  static const String dummyEmpName1 = 'Afdal Ramdan';
  static const String dummyEmpRole1 = 'UI/UX Designer';
  static const String dummyEmpName2 = 'Budi Santoso';
  static const String dummyEmpRole2 = 'HR Manager';
  static const String dummyEmpName3 = 'Citra Dewi';
  static const String dummyEmpRole3 = 'Data Analyst';
  static const String dummyEmpName4 = 'Doni Prabowo';
  static const String dummyEmpRole4 = 'Project Coordinator';
  static const String dummyEmpName5 = 'Eka Lestari';
  static const String dummyEmpRole5 = 'System Administrator';
  static const String dummyEmpName6 = 'Fajar Nugroho';
  static const String dummyEmpRole6 = 'Software Engineer';
  static const String dummyEmpName7 = 'Gita Rahmawati';
  static const String dummyEmpRole7 = 'Business Analyst';
  static const String dummyEmpName8 = 'Hendra Wijaya';
  static const String dummyEmpRole8 = 'Software Engineer';
  static const String dummyEmpName9 = 'Indah Permatasari';
  static const String dummyEmpRole9 = 'Recruitment Specialist';
  static const String statusNotStarted = 'Not Started';
  static const String detailLogTitle = 'Detail Log';
  static const String checkInOut = 'Check in & out';
  static const String activity = 'Aktivitas';
  static const String detail = 'Detail';
  static const String constraints = 'Kendala';
  static const String rejectReasonLabel = 'Alasan Reject';
  static const String exportLogBookTitle = 'Export Log Book';
  static const String exportLogBookDesc = 'Export data Log Book ke format Excel.';
  static const String exportPeriod = 'Periode';
  static const String exportFormat = 'Format';
  static const String exportFormatExcel = 'Excel (.xlsx)';
  static const String exportDataCount = 'Data yang akan diekspor';
  static const String exportDataCountValue = '20 hari';
  
  static const String errorLocationDataNotFound = 'Data lokasi kantor tidak tersedia. Hubungi admin.';
  static const String errorGpsDisabled = 'Layanan lokasi (GPS) tidak aktif.';
  static const String errorLocationPermissionDenied = 'Izin akses lokasi ditolak.';
  static const String errorLocationPermissionDeniedForever = 'Izin lokasi ditolak secara permanen. Silakan aktifkan melalui pengaturan perangkat.';
  static const String reasonWfh = 'Alasan WFH';
  static const String noteWfhHint = 'Berikan alasan melakukan WFH...';

  // Detail Attendance Screen
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
  static const String emptyActivity = 'Tidak ada riwayat absensi';
  static const String emptyActivityDesc = 'Belum ada absensi yang tercatat.';
  static const String viewAll = 'Lihat Semua';
  static const String announcement = 'Pengumuman';
  static const String detailPengumuman = 'Detail Pengumuman';
  static const String noAnnouncement = 'Belum ada pengumuman';
  static const String noAnnouncementSub = 'Tidak ada pengumuman\nyang tersedia untuk saat ini.';
  // Attendance Success Screen
  static const String checkInSent = 'Check In Dikirim';
  static const String selamatBekerja = 'Selamat Bekerja!';
  static const String checkInSuccessDesc = 'Anda bisa mulai bekerja seperti biasa. Saat ingin mencatat pekerjaan, buka aktivitas hari ini, lalu tekan tambah task. Tidak perlu mengisi semuanya sekarang.';
  static const String checkOutSent = 'Check Out Dikirim';
  static const String back = 'Kembali';

  // Log Book
  static const List<String> shortDayNames = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
  static const String workingHoursFull = 'Jam Kerja 08:00 – 17:00';

  // Bottom Navigation
  static const String navHome = 'Home';
  static const String navEmployee = 'Employee';
  static const String navNotification = 'Notifikasi';
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

  // Notification Screen
  static const String menuNotification = 'Notification';
  static const String noNotificationData = 'Belum ada notifikasi';
  static const String noNotificationDataDesc = 'Anda belum memiliki notifikasi\napapun saat ini.';
  static const String markAllRead = 'Tandai Sudah Dibaca';
  static const String statusApproved = 'Approved';
  static const String statusRejected = 'Rejected';
  static const String statusWaiting = 'Waiting';

  // Employee Screen
  static const String menuEmployee = 'Employee';
  static const String detailEmployeeTitle = 'Detail Employee';
  static const String noEmployeeData = 'Belum ada data employee';
  static const String noEmployeeDataDesc = 'Data employee masih kosong.';
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

  // Popups / Dialogs
  static const String popupMarkAllReadTitle = 'Tandai Semua Sudah Dibaca';
  static const String popupMarkAllReadDesc = 'Apakah Anda yakin ingin menandai semua notifikasi sebagai sudah dibaca? Tindakan ini tidak dapat dibatalkan.';
  static const String popupConfirm = 'Konfirmasi';
  static const String popupCancel = 'Batal';
  static const String popupCancelLeaveTitle = 'Batalkan Pengajuan?';
  static const String popupCancelLeaveDesc = 'Pengajuan cuti yang dibatalkan tidak dapat diproses lebih lanjut. Pastikan Anda ingin membatalkan pengajuan ini.';
  static const String popupCancelLeaveConfirm = 'Batalkan';

  // Error Messages
  static const String errorServerSide = 'Terjadi kesalahan pada server. Coba beberapa saat lagi.';
  static const String errorConnection = 'Koneksi Bermasalah';
  static const String errorSessionExpired = 'Sesi Anda telah habis atau akses ditolak.';
  static const String errorInternalServer = 'Server bermasalah.';
  static const String errorEmailNotFound = 'Email tidak ditemukan.';
  static const String errorSystem = 'Terjadi kesalahan pada sistem.';
  static const String cobaLagi = 'Coba Lagi';
  static const String errorDataNotFound = 'Data Not Found';
  static const String noShiftData = 'Jadwal belum tersedia';
  static const String employeeDataNotLoaded = 'Data karyawan belum dimuat. Silakan muat ulang halaman.';
  static String requiredField(String field) => '$field wajib diisi';

  // Filters
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

  // Common Data
  static const List<String> monthNames = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  // Leave Screen
  static const String leaveTitle = 'Pengajuan Cuti';
  static const String remainingYearlyLeave = 'Sisa Cuti Tahunan';
  static const String noLeaveRequest = 'Belum ada pengajuan';
  static const String noLeaveRequestSub = 'Anda dapat mengajukan melalui\ntombol di bawah ini';
  static const String noLeaveAllocationTitle = 'Belum Ada Jatah Cuti';
  static const String noLeaveAllocationDesc = 'Data alokasi cuti Anda tidak ditemukan.\nSilakan hubungi HR.';
  static const String noLeaveApproverTitle = 'Penyetuju Belum Diatur';
  static const String noLeaveApproverDesc = 'Data penyetuju cuti Anda belum diatur.\nSilakan hubungi HR.';
  static const String backToHome = 'Kembali';

  static const String leaveType = 'Jenis Cuti';
  static const String leaveDate = 'Tanggal';


  // Detail Leave Screen
  static const String detailLeaveTitle = 'Detail Pengajuan Cuti';
  static const String detailPengajuan = 'Detail pengajuan';
  static const String waitingApproval = 'Menunggu Persetujuan';
  static const String leaveApproved = 'Pengajuan Disetujui';
  static const String leaveRejected = 'Pengajuan Ditolak';
  static const String leaveId = 'ID Pengajuan';
  static const String leaveSubmissionDate = 'Tanggal Pengajuan';
  static const String leaveStartDate = 'Tanggal Mulai';
  static const String leaveReason = 'Alasan Cuti';
  static const String leaveRejectReason = 'Alasan Ditolak';
  static const String cancelLeave = 'Batalkan Pengajuan';
  static const String notesPrefix = 'Notes: ';
  static const String statusCancelled = 'Cancelled';
  static const String leaveCancelled = 'Pengajuan Dibatalkan';
  // New Leave Screen
  static const String newLeaveTitle = 'Pengajuan Cuti Baru';
  static const String leaveTypeLabel = 'Jenis Cuti';
  static const String leaveEndDate = 'Tanggal Selesai';
  static const String selectLeaveType = 'Pilih jenis cuti';
  static const String selectStartDate = 'Pilih tanggal mulai';
  static const String selectEndDate = 'Pilih tanggal selesai';
  static const String errorSelectLeaveTypeFirst = 'Pilih jenis cuti dahulu';
  static const String errorSelectStartDateFirst = 'Pilih tanggal mulai dahulu';
  static const String explainLeaveReason = 'Jelaskan alasan cuti';
  static const String submit = 'Kirim';
  static const String cancel = 'Batal';
  static const String confirmLeave = 'Konfirmasi Cuti';
  static const String ensureDataCorrect = 'Pastikan data yang dicantumkan sudah benar.';
  static const String submitNow = 'Ajukan Sekarang';
  
  // Success Leave Screen
  static const String submissionSuccess = 'Pengajuan Berhasil';
  static const String submissionSuccessDesc = 'Pengajuan cuti Anda berhasil dikirim dan sedang menunggu proses persetujuan.';
  static const String reimburseSuccessDesc = 'Pengajuan reimburse Anda berhasil dikirim dan sedang menunggu proses persetujuan.';
  static const String viewSubmission = 'Lihat Pengajuan';


  // Reimbursement
  static const String reimbursementTitle = 'Benefit Reimbursement';
  static const String noReimbursementRequest = 'Belum ada pengajuan';
  static const String noReimbursementRequestSub = 'Anda dapat mengajukan melalui\ntombol di bawah ini';
  static const String infoPengajuanTitle = 'Informasi Pengajuan';
  static const String infoPengajuanDesc = 'Ajukan paling lambat tanggal 4 setiap bulan untuk mendapatkan pencairan pada tanggal 11. Pengajuan setelah tanggal 4 akan dicairkan pada tanggal 11 bulan berikutnya.';
  static const String batal = 'Batal';
  static const String lanjutkan = 'Lanjutkan';

  // Detail Reimbursement
  static const String detailReimbursementTitle = 'Detail Pengajuan Reimburse';
  static const String idPengajuan = 'ID Pengajuan';
  static const String tanggalPengajuan = 'Tanggal Pengajuan';
  static const String jumlahDisetujui = 'Jumlah yang disetujui';
  static const String totalDisetujui = 'Total disetujui';
  static const String rincianBenefit = 'Rincian Benefit';
  static const String tanggalTransaksi = 'Tanggal Transaksi';
  static const String jumlahDiajukan = 'Jumlah yang diajukan';
  static const String deskripsi = 'Deskripsi';
  static const String lampiran = 'Lampiran';
  static const String cancelReimburseTitle = 'Batalkan Pengajuan?';
  static const String cancelReimburseDesc = 'Pengajuan reimburse yang dibatalkan tidak dapat diproses lebih lanjut. Pastikan Anda ingin membatalkan pengajuan ini.';
  static const String confirmCancel = 'Batalkan';
  static const String cancelReimburseSuccessTitle = 'Pengajuan Dibatalkan';
  static const String cancelReimburseSuccessDesc = 'Pengajuan tidak akan diproses lebih lanjut dan dapat diajukan kembali jika diperlukan.';
  static const String kembali = 'Kembali';
  
  static const String newReimburseTitle = 'Pengajuan Reimburse';
  static const String infoPengaju = 'Informasi Pengaju';
  static const String namaLengkap = 'Nama Lengkap';
  static const String perusahaan = 'Perusahaan';
  static const String departemen = 'Departemen';
  static const String addBenefitSubtitle = 'Tambahkan rincian benefit yang ingin diajukan';
  static const String emptyBenefitDetail = 'Belum ada rincian benefit';
  static const String addDetail = 'Tambahkan rincian';
  static const String send = 'Kirim';
  
  static const String addBenefitDetailTitle = 'Tambahkan Rincian';
  static const String editDetail = 'Edit Rincian';
  static const String errorLoadBenefitType = 'Gagal memuat tipe benefit.\n';
  static const String downloadText = 'Unduh';
  static const String downloadSuccess = 'Berhasil mengunduh lampiran';
  static const String downloadFailed = 'Gagal mengunduh lampiran';
  static const String benefitType = 'Benefit';
  static const String selectBenefitType = 'Pilih benefit';
  static const String transactionDate = 'Tanggal Transaksi';
  static const String selectTransactionDate = 'Pilih tanggal transaksi';
  static const String submittedAmount = 'Jumlah yang diajukan';
  static const String descPlaceholder = 'Contoh: Perjalanan dinas ke klien';
  static const String attachment = 'Lampiran';
  static const String maxFileSize = 'Ukuran file maksimal 5 MB';
  static const String dragFileHere = 'Tarik file ke sini atau ';
  static const String chooseFromDevice = 'pilih dari perangkat';
  static const String save = 'Simpan';
  
  // Bottom Sheet Filter & Attachment
  static const String filterBy = 'Filter berdasarkan';
  static const String allStatus = 'Semua status';
  static const String statusWaitingEnum = 'Menunggu';
  static const String statusApprovedEnum = 'Disetujui';
  static const String statusRejectedEnum = 'Ditolak';
  
  // Reimbursement Statuses
  static const String reimburseStatusDraft = 'Pending';
  static const String reimburseStatusSubmitted = 'Approved';
  static const String reimburseStatusCancelled = 'Cancelled';
  static const String reimburseStatusPaid = 'Paid';
  static const String reimburseStatusUnpaid = 'Unpaid';
  static const String reimburseStatusRejected = 'Rejected';
  
  static const String chooseAttachmentSource = 'Pilih Sumber Lampiran';
  static const String takePhoto = 'Ambil Foto';
  static const String useCameraDirectly = 'Gunakan kamera langsung';
  static const String chooseFromGallery = 'Pilih dari Galeri / Dokumen';
  static const String choosePhotoOrPdf = 'Pilih file foto atau PDF dari perangkat Anda';
  static const String deleteDetail = 'Hapus';
  static const String deleteDetailSuccess = 'Rincian berhasil dihapus';
  static const String deleteDetailConfirmTitle = 'Hapus Rincian?';
  static const String deleteDetailConfirmDesc = 'Rincian benefit ini akan dihapus dari pengajuan Anda. Tindakan ini tidak dapat dibatalkan.';
  static const String confirmDelete = 'Hapus';

  // Dummy Reimbursement Data (Untuk Testing UI)
  static const String dummyTransportation = 'Transportation';
  static const String dummyKacamata = 'Kacamata';
  static const String dummyMedical = 'Medical';
  static const String dummyLainnya = 'Lainnya';
  static const String zeroText = '0';
  static const String rpText = 'Rp';
}

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logbook_app_077/features/logbook/log_controller.dart'; 

void main() {
  dynamic actual, expected;

  group('Modul 3 - LogController Save to Disk (Test)', () {
    late LogController controller;

    setUp(() async {
      // (1) setup (arrange, build)
      // Inisialisasi mock storage 
      SharedPreferences.setMockInitialValues({});
      
      // Buat objek LogController dengan username dummy
      controller = LogController(username: "helga");
      
      await Future.delayed(const Duration(milliseconds: 100));
    });

    // Sesuai TC01 di Excel
    test('addLog berhasil menambahkan log valid dan menyimpannya', () {
      // (2) exercise (act, operate)
      controller.addLog("Belajar Flutter", "Membuat test case Modul 3", "Akademik");

      actual = controller.logsNotifier.value.length;
      expected = 1;

      // (3) verify (assert, check)
      expect(actual, expected, reason: 'Expected $expected but got $actual');
    });

    // Sesuai TC02 di Excel 
    test('addLog menolak menyimpan catatan jika title kosong', () {
      // (2) exercise (act, operate)
      controller.addLog("", "Deskripsi log tanpa judul", "Umum");

      actual = controller.logsNotifier.value.length;
      expected = 0;

      // (3) verify (assert, check)
      expect(actual, expected, reason: 'Expected $expected but got $actual');
    });

    // Sesuai TC03 di Excel 
    test('addLog menolak menyimpan catatan jika description kosong', () {
      // (2) exercise (act, operate)
      controller.addLog("Judul Saja", "", "Umum");

      actual = controller.logsNotifier.value.length;
      expected = 0; 

      // (3) verify (assert, check)
      expect(actual, expected, reason: 'Expected $expected but got $actual');
    });
  });
}
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_markdown/flutter_markdown.dart';
import '../config/theme.dart';

class PraktikumPage extends StatefulWidget {
  const PraktikumPage({Key? key}) : super(key: key);

  @override
  State<PraktikumPage> createState() => _PraktikumPageState();
}

class _PraktikumPageState extends State<PraktikumPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Praktikum Hukum Ohm',
          style: TextStyle(
            color: AppTheme.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.primaryPink,
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppTheme.white,
          labelColor: AppTheme.white,
          unselectedLabelColor: AppTheme.white.withOpacity(0.7),
          labelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          tabs: const [
            Tab(text: 'Alat & Bahan'),
            Tab(text: 'Langkah'),
            Tab(text: 'Code'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAlatBahanTab(),
          _buildLangkahTab(),
          _buildCodeTab(),
        ],
      ),
    );
  }

  // Tab 1: Alat dan Bahan
  Widget _buildAlatBahanTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Bifocal Modelling (Hardware + Software)'),
          const SizedBox(height: 24),

          // Hardware Section
          _buildCategorySection(
            categoryTitle: 'A. Perangkat Keras (Hardware/Dunia Riil)',
            items: [
              AlatBahanItem(
                name: 'Mikrokontroler ESP32',
                description:
                    'Sebagai unit pemroses data utama yang berfungsi membaca sinyal analog dari sensor dan mengirimkannya ke sistem.',
                icon: Icons.memory,
              ),
              AlatBahanItem(
                name: 'Potensiometer (10k Ohm)',
                description:
                    'Berfungsi sebagai hambatan variabel untuk mengatur variasi input tegangan (Voltage Divider) dalam rangkaian.',
                icon: Icons.tune,
              ),
              AlatBahanItem(
                name: 'Breadboard (Papan Percobaan)',
                description:
                    'Sebagai media untuk merangkai komponen tanpa perlu penyolderan.',
                icon: Icons.grid_on,
              ),
              AlatBahanItem(
                name: 'Kabel Jumper (Male-to-Male / Male-to-Female)',
                description: 'Sebagai penghubung arus listrik antar komponen dan ke pin ESP32.',
                icon: Icons.cable,
              ),
              AlatBahanItem(
                name: 'Kabel USB Data',
                description: 'Sebagai sumber daya ESP32 sekaligus jalur komunikasi data ke komputer.',
                icon: Icons.power,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Software Section
          _buildCategorySection(
            categoryTitle: 'B. Perangkat Lunak (Software/Dunia Virtual)',
            items: [
              AlatBahanItem(
                name: 'VS Code (Visual Studio Code)',
                description: 'Editor utama untuk menulis kode program.',
                icon: Icons.code,
              ),
              AlatBahanItem(
                name: 'Extension PlatformIO IDE',
                description:
                    'Ekstensi di dalam VS Code untuk manajemen library, kompilasi, dan upload kode ke ESP32.',
                icon: Icons.extension,
              ),
              AlatBahanItem(
                name: 'Serial Monitor (PlatformIO)',
                description: 'Untuk melihat log data tegangan dan arus secara real-time.',
                icon: Icons.terminal,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Tab 2: Langkah
  Widget _buildLangkahTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Langkah-Langkah Praktikum Hukum Ohm'),
          const SizedBox(height: 24),

          // Langkah 1
          _buildLangkahCard(
            stepNumber: 1,
            stepTitle: 'Koneksi Potensiometer',
            stepDescription: '(Sebagai Pengatur Tegangan)',
            stepContent: 'Potensiometer punya 3 kaki. Hadapkan lubang putarannya ke arahmu, lalu hubungkan:',
            subSteps: [
              SubLangkahItem(
                label: 'Kaki Kiri (Pin 1)',
                description: 'Hubungkan ke GND ESP32.',
                icon: Icons.cloud_done_outlined,
              ),
              SubLangkahItem(
                label: 'Kaki Tengah (Pin 2)',
                description: 'Hubungkan ke Pin GPIO 34 ESP32. (Ini pin yang membaca perubahan tegangan).',
                icon: Icons.sensors,
              ),
              SubLangkahItem(
                label: 'Kaki Kanan (Pin 3)',
                description: 'Hubungkan ke 3V3 ESP32.',
                icon: Icons.flash_on,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Langkah 2
          _buildLangkahCard(
            stepNumber: 2,
            stepTitle: 'Langkah Pemasangan di Breadboard',
            stepDescription: '(Urutannya)',
            stepContent: '',
            subSteps: [
              SubLangkahItem(
                label: 'Pasang ESP32',
                description:
                    'Pasang di tengah breadboard (pastikan kaki kiri dan kanan berada di blok lubang yang berbeda agar tidak short).',
                icon: Icons.important_devices,
              ),
              SubLangkahItem(
                label: 'Jalur Power',
                description:
                    'Hubungkan pin 3V3 ESP32 ke jalur merah (+/vcc) di pinggir breadboard, dan pin GND ke jalur biru (-/gnd).',
                icon: Icons.power_settings_new,
              ),
              SubLangkahItem(
                label: 'Pasang Potensio',
                description:
                    'Letakkan di area kosong breadboard. Hubungkan kaki kiri ke jalur biru dan kaki kanan ke jalur merah.',
                icon: Icons.tune,
              ),
              SubLangkahItem(
                label: 'Kabel Data (Input)',
                description: 'Tarik kabel dari kaki tengah potensio ke GPIO 34.',
                icon: Icons.cable,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Langkah 3
          _buildLangkahCard(
            stepNumber: 3,
            stepTitle: 'Menyambungkan ESP ke VSCode',
            stepDescription: '(Setup Development Environment)',
            stepContent: 'Ikuti tahapan instalasi dan konfigurasi untuk menghubungkan ESP32 dengan VSCode:',
            subSteps: [
              SubLangkahItem(
                label: 'Instalasi VS Code dan Driver',
                description:
                    'Download & Install Visual Studio Code dari situs resmi. Pastikan driver USB-to-Serial (CP210x atau CH340) sudah terpasang agar port ESP32 terdeteksi di VS Code.',
                icon: Icons.code,
              ),
              SubLangkahItem(
                label: 'Instal Ekstensi PlatformIO',
                description:
                    'Buka VS Code, tekan Ctrl+Shift+X, cari "PlatformIO IDE", dan klik Install. Tunggu sampai ikon Semut (Ant) muncul di sidebar kiri.',
                icon: Icons.extension,
              ),
              SubLangkahItem(
                label: 'Membuat Project Baru',
                description:
                    'Klik ikon PlatformIO > PIO Home > New Project. Isi nama project (Praktikum_Hukum_Ohm), pilih board "Espressif ESP32 Dev Module", framework Arduino, lalu Finish.',
                icon: Icons.folder_open,
              ),
              SubLangkahItem(
                label: 'Menulis Kode Program',
                description:
                    'Buka folder src, klik main.cpp. Pastikan menambahkan #include <Arduino.h> di baris paling atas. Tulis kode pembacaan sensor atau LED blink untuk testing.',
                icon: Icons.edit_note,
              ),
              SubLangkahItem(
                label: 'Build dan Upload',
                description:
                    'Gunakan ikon Centang (✓) untuk Build, Panah Kanan (→) untuk Upload, dan Steker untuk membuka Serial Monitor dan melihat log data.',
                icon: Icons.upload,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Langkah 4
          _buildLangkahCard(
            stepNumber: 4,
            stepTitle: 'Pengisian LKPD',
            stepDescription: '(Pengambilan dan Analisis Data)',
            stepContent: 'Ikuti prosedur pengambilan data untuk mengisi tabel pengamatan LKPD dengan akurat:',
            subSteps: [
              SubLangkahItem(
                label: 'Tampilan Web Bifocal Modelling',
                description:
                    'Saat koneksi berhasil, layar web menampilkan Grafik Perbandingan (Kurva Teori pink dan Kurva Percobaan biru) dan Data Logging (tabel real-time dengan kolom Tegangan V, Arus I, dan Waktu).',
                icon: Icons.show_chart,
              ),
              SubLangkahItem(
                label: 'Variasi Putaran Potensiometer',
                description:
                    'Putar potensiometer secara perlahan dan bertahap untuk mendapatkan 10 variasi titik data yang berbeda. Jangan langsung diputar habis.',
                icon: Icons.touch_app,
              ),
              SubLangkahItem(
                label: 'Capture dan Pemindahan Data',
                description:
                    'Setiap kali berhenti di posisi tertentu, ambil nilai Tegangan (V) dari Data Logging dan masukkan ke kolom "Tegangan (V) Pembacaan Sensor" di LKPD. Ambil nilai Arus (I) dan masukkan ke kolom "Arus (I) Sensor" (konversi mA ke Ampere jika diperlukan).',
                icon: Icons.table_rows,
              ),
              SubLangkahItem(
                label: 'Validasi Grafik dan Sinkronisasi Data',
                description:
                    'Pastikan setiap titik data membentuk garis lurus di web. Jika titiknya melenceng jauh, periksa kabel jumper. Catat Error/selisih antara data fisik (sensor) dan model matematika di kolom terakhir LKPD.',
                icon: Icons.done_all,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Tab 3: Code
  Widget _buildCodeTab() {
    return FutureBuilder<http.Response>(
      future: http.get(Uri.parse('https://raw.githubusercontent.com/azellamaa/biofocal-modeling/main/README.md')),
      builder: (context, snapshot) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Akses kode sumber dan contoh bifocal modeling di repository berikut:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.greyDark,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: () async {
                  final url = Uri.parse('https://github.com/azellamaa/biofocal-modeling');
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPink.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.primaryPink.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.link, color: AppTheme.primaryPink),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'https://github.com/azellamaa/biofocal-modeling',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.primaryPink,
                                decoration: TextDecoration.underline,
                              ),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'README.md:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.primaryPink,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (snapshot.connectionState == ConnectionState.waiting)
                const CircularProgressIndicator()
              else if (snapshot.hasError)
                Text('Gagal memuat README.md')
              else if (snapshot.hasData && snapshot.data!.statusCode == 200)
                Container(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: MarkdownBody(
                    data: snapshot.data!.body,
                    styleSheet: MarkdownStyleSheet(
                      p: Theme.of(context).textTheme.bodyMedium,
                      h1: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.primaryPink),
                      h2: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.primaryPink),
                      h3: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.primaryPink),
                    ),
                  ),
                )
              else
                Text('README.md tidak ditemukan'),
            ],
          ),
        );
      },
    );
  }

  // Helper Widgets
  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppTheme.primaryPink,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildCategorySection({
    required String categoryTitle,
    required List<AlatBahanItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          categoryTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.black,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 16),
        ...items.map((item) => _buildAlatBahanCard(item)).toList(),
      ],
    );
  }

  Widget _buildAlatBahanCard(AlatBahanItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.primaryPink.withOpacity(0.2),
          ),
          color: AppTheme.greyLight,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.primaryPink.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  item.icon,
                  color: AppTheme.primaryPink,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppTheme.black,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.greyDark,
                            height: 1.5,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLangkahCard({
    required int stepNumber,
    required String stepTitle,
    required String stepDescription,
    required String stepContent,
    required List<SubLangkahItem> subSteps,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryPink.withOpacity(0.3),
          width: 2,
        ),
        color: AppTheme.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step Header
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPink,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$stepNumber',
                      style: const TextStyle(
                        color: AppTheme.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stepTitle,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (stepDescription.isNotEmpty)
                        Text(
                          stepDescription,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.primaryPink,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Step Content
            if (stepContent.isNotEmpty) ...[
              Text(
                stepContent,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.greyDark,
                      height: 1.5,
                    ),
              ),
              const SizedBox(height: 16),
            ],

            // Sub Steps
            ...subSteps.asMap().entries.map((entry) {
              int index = entry.key;
              SubLangkahItem subStep = entry.value;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == subSteps.length - 1 ? 0 : 12,
                ),
                child: _buildSubLangkahItem(subStep),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubLangkahItem(SubLangkahItem item) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppTheme.primaryPink.withOpacity(0.05),
        border: Border.all(
          color: AppTheme.primaryPink.withOpacity(0.2),
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryPink.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              item.icon,
              color: AppTheme.primaryPink,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.black,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.greyDark,
                        height: 1.4,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Model class for Alat dan Bahan
class AlatBahanItem {
  final String name;
  final String description;
  final IconData icon;

  AlatBahanItem({
    required this.name,
    required this.description,
    required this.icon,
  });
}

// Model class for Sub Langkah
class SubLangkahItem {
  final String label;
  final String description;
  final IconData icon;

  SubLangkahItem({
    required this.label,
    required this.description,
    required this.icon,
  });
}

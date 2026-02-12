import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/theme.dart';

class LkpdPage extends StatefulWidget {
  const LkpdPage({Key? key}) : super(key: key);

  @override
  State<LkpdPage> createState() => _LkpdPageState();
}

class _LkpdPageState extends State<LkpdPage> {
  late Stream<ConnectivityResult> _connectionStatusStream;
  int _currentStep = 0;

  // Data Diri Form
  final _namaTekController = TextEditingController();
  final _instansiTekController = TextEditingController();
  String _selectedGender = '';

  // Pengamatan Table Data (10 rows)
  final _pengamatanData = List.generate(
    10,
    (i) => PengamatanRow(
      no: i + 1,
      arus: '',
      hambatan: '',
      teganganTerhitung: '',
      teganganPembacaan: '',
      selisih: '',
    ),
  );

  // Kesimpulan Fields (2 data saja)
  final _kesimpulanSensorController = TextEditingController();
  final _kesimpulanHambatanController = TextEditingController();

  // Angket Penilaian Data
  final _angketData = [
    AngketItem(1, 'Kemampuan untuk dapat dilaksanakan', 'Alat praktikum mudah digunakan dan dioperasikan'),
    AngketItem(2, 'Kemampuan untuk dapat dilaksanakan', 'Alat praktikum dapat digunakan secara berulang ulang'),
    AngketItem(3, 'Kesinambungan', 'Potensi penggunaan dimasa yang akan datang'),
    AngketItem(4, 'Kesinambungan', 'Perawatan alat mudah dilakukan'),
    AngketItem(5, 'Kesinambungan', 'Alat terbuat dari bahan-bahan yang kuat dan tidak mudah rusak'),
    AngketItem(6, 'Efisiensi', 'Kecukupan waktu untuk memahami konsep hukum ohm'),
    AngketItem(7, 'Efisiensi', 'Kemudahan memahami materi hukum ohm'),
    AngketItem(8, 'Kecocokan dengan lingkungan', 'Alat praktikum dirancang sesuai dengan kondisi lingkungan belajar'),
    AngketItem(9, 'Kecocokan dengan lingkungan', 'Alat praktikum aman digunakan dan tidak mengandung unsur yang berbahaya'),
    AngketItem(10, 'Penerimaan dan Kemenarikan Alat', 'Alat praktikum dirancang dengan bentuk yang sesuai dengan kebutuhan materi'),
    AngketItem(11, 'Penerimaan dan Kemenarikan Alat', 'Alat praktikum dapat menunjang pembelajaran yang aktif dan tidak monoton'),
  ];

  String _kritikSaran = '';

  // Pertanyaan Analisis
  final _pertanyaan1Controller = TextEditingController(); // Perbedaan V hitung vs sensor
  final _pertanyaan2Controller = TextEditingController(); // Linearitas grafik

  @override
  void initState() {
    super.initState();
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    setState(() {
      _connectionStatusStream = Connectivity().onConnectivityChanged;
    });
  }

  @override
  void dispose() {
    _namaTekController.dispose();
    _instansiTekController.dispose();
    _pertanyaan1Controller.dispose();
    _pertanyaan2Controller.dispose();
    _kesimpulanSensorController.dispose();
    _kesimpulanHambatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: _connectionStatusStream,
      builder: (context, streamSnapshot) {
        final isOnline = streamSnapshot.data != ConnectivityResult.none;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'LKPD - Angket Penilaian',
              style: TextStyle(
                color: AppTheme.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: AppTheme.primaryPink,
            elevation: 2,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Center(
                  child: Row(
                    children: [
                      Icon(
                        isOnline ? Icons.cloud_done : Icons.cloud_off,
                        color: isOnline ? Colors.lightGreen : Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isOnline ? 'Online' : 'Offline',
                        style: const TextStyle(
                          color: AppTheme.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          body: StreamBuilder<ConnectivityResult>(
            stream: _connectionStatusStream,
            builder: (context, snapshot) {
              final isOnlineBody = snapshot.data != ConnectivityResult.none;

              if (!isOnlineBody) {
                return _buildOfflineWidget();
              }

              return Stepper(
                currentStep: _currentStep,
                onStepContinue: () {
                  // Validasi sebelum lanjut ke step berikutnya
                  if (_currentStep == 0) {
                    // Validasi Data Diri
                    if (_namaTekController.text.isEmpty ||
                        _instansiTekController.text.isEmpty ||
                        _selectedGender.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('❌ Data Diri belum lengkap!\nSilakan isi Nama, Instansi, dan Jenis Kelamin.'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                        ),
                      );
                      return;
                    }
                  } else if (_currentStep == 1) {
                    // Validasi Pengamatan
                    if (!_isAllPengamatanFilled()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            '❌ Tabel Pengamatan belum lengkap!\n'
                            'Isi SEMUA 10 baris dengan lengkap (Arus, Hambatan, V Hitung, V Sensor, Selisih).',
                          ),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 4),
                        ),
                      );
                      return;
                    }
                    if (!_isAllKesimpulanFilled()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('❌ Kesimpulan belum diisi!\nIsi Tegangan Sensor dan Hambatan.'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                        ),
                      );
                      return;
                    }
                    if (_pertanyaan1Controller.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('❌ Pertanyaan 1 belum dijawab!'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                        ),
                      );
                      return;
                    }
                    if (_pertanyaan2Controller.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('❌ Pertanyaan 2 belum dijawab!'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                        ),
                      );
                      return;
                    }
                  }

                  // Jika validasi lolos, lanjut ke step berikutnya
                  if (_currentStep < 2) {
                    setState(() {
                      _currentStep++;
                    });
                  }
                },
                onStepCancel: () {
                  if (_currentStep > 0) {
                    setState(() {
                      _currentStep--;
                    });
                  }
                },
                controlsBuilder: (context, details) {
                  // Hide ALL buttons di step 2 (Angket Penilaian) karena ada button custom di content
                  if (_currentStep == 2) {
                    return const SizedBox.shrink();
                  }
                  
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: details.onStepContinue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryPink,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: const Text('Lanjut'),
                        ),
                        const SizedBox(width: 12),
                        if (_currentStep > 0)
                          OutlinedButton(
                            onPressed: details.onStepCancel,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.primaryPink,
                              side: const BorderSide(color: AppTheme.primaryPink),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: const Text('Kembali'),
                          ),
                      ],
                    ),
                  );
                },
                steps: [
                  // Step 1: Data Diri
                  Step(
                    title: const Text('Data Diri'),
                    content: _buildDataDiriStep(),
                    isActive: _currentStep >= 0,
                    state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                  ),
                  // Step 2: Pengamatan
                  Step(
                    title: const Text('Pengamatan'),
                    content: _buildPengamatanStep(),
                    isActive: _currentStep >= 1,
                    state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                  ),
                  // Step 3: Angket Penilaian
                  Step(
                    title: const Text('Angket Penilaian'),
                    content: _buildAngketPenilaianStep(),
                    isActive: _currentStep >= 2,
                    state: _currentStep > 2 ? StepState.complete : StepState.indexed,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildOfflineWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off,
            size: 80,
            color: AppTheme.primaryPink,
          ),
          const SizedBox(height: 20),
          Text(
            'Anda Sedang Offline',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.black,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Hubungkan ke WiFi atau Data untuk\nmelanjutkan pengisian angket',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.greyDark,
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _initConnectivity(),
            icon: const Icon(Icons.refresh),
            label: const Text('Cek Kembali'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPink,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataDiriStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            label: 'Nama Lengkap *',
            controller: _namaTekController,
            icon: Icons.person,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Instansi *',
            controller: _instansiTekController,
            icon: Icons.business,
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.black,
                  ),
              children: const [
                TextSpan(text: 'Jenis Kelamin '),
                TextSpan(
                  text: '*',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildGenderChip('Laki-laki'),
          _buildGenderChip('Perempuan'),
          const SizedBox(height: 12),
          Text(
            '* Wajib diisi',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.red,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderChip(String label) {
    final isSelected = _selectedGender == label;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedGender = selected ? label : '';
          });
        },
        selectedColor: AppTheme.primaryPink,
        backgroundColor: Colors.white,
        side: BorderSide(
          color: isSelected ? AppTheme.primaryPink : AppTheme.greyLight,
          width: 1.5,
        ),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppTheme.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppTheme.primaryPink),
            hintText: 'Masukkan $label',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppTheme.primaryPink,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPengamatanStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Warning container
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryPink.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppTheme.primaryPink,
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, 
                      color: AppTheme.primaryPink,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Penting: Isi SEMUA 10 baris data pengamatan',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryPink,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Ambil 10 variasi data dengan memutar potensio meter secara bertahap. '
                  'Setiap kolom di seluruh 10 baris HARUS diisi dengan lengkap.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.greyDark,
                        height: 1.4,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryPink,
                  ),
              children: const [
                TextSpan(text: 'Tabel Pengamatan '),
                TextSpan(
                  text: '*',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildPengamatanTable(),
          const SizedBox(height: 32),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryPink,
                  ),
              children: const [
                TextSpan(text: 'Tabel Kesimpulan Pengamatan '),
                TextSpan(
                  text: '*',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildKesimpulanTable(),
          const SizedBox(height: 32),
          // Pertanyaan 1
          _buildQuestionField(
            question: 'Pertanyaan 1 *: Berdasarkan tabel di atas, apakah terdapat perbedaan antara nilai Tegangan (V) hasil hitungan rumus dengan hasil pembacaan sensor IoT secara langsung? Jelaskan mengapa!',
            controller: _pertanyaan1Controller,
            minLines: 4,
          ),
          const SizedBox(height: 24),
          // Pertanyaan 2
          _buildQuestionField(
            question: 'Pertanyaan 2 *: Gambarkan titik-titik data (V, I) pada sumbu koordinat. Apakah titik-titik tersebut membentuk garis lurus (linear)? Apa artinya bagi nilai hambatan potensiometer tersebut?',
            controller: _pertanyaan2Controller,
            minLines: 4,
          ),
          const SizedBox(height: 16),
          Text(
            '* Wajib diisi',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.red,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPengamatanTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('No')),
          DataColumn(label: Text('Arus (I)\n(A)')),
          DataColumn(label: Text('Hambatan (R)\n(Ohm)')),
          DataColumn(label: Text('Tegangan (V)\nHasil Hitung')),
          DataColumn(label: Text('Tegangan (V)\nPembacaan Sensor')),
          DataColumn(label: Text('Selisih/\nError')),
        ],
        rows: _pengamatanData.map((row) {
          return DataRow(
            cells: [
              DataCell(Text('${row.no}')),
              DataCell(_buildEditableCell(row, 'arus')),
              DataCell(_buildEditableCell(row, 'hambatan')),
              DataCell(_buildEditableCell(row, 'teganganTerhitung')),
              DataCell(_buildEditableCell(row, 'teganganPembacaan')),
              DataCell(_buildEditableCell(row, 'selisih')),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildKesimpulanTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kesimpulan Sensor
        Text(
          'Tegangan Sensor (V)',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.greyDark,
              ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _kesimpulanSensorController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: 'Masukkan nilai tegangan sensor...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppTheme.primaryPink,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppTheme.primaryPink.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.all(12),
            filled: true,
            fillColor: AppTheme.primaryPink.withOpacity(0.05),
          ),
        ),
        const SizedBox(height: 20),
        // Kesimpulan Hambatan
        Text(
          'Hambatan (Ohm)',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.greyDark,
              ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _kesimpulanHambatanController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: 'Masukkan nilai hambatan...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppTheme.primaryPink,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppTheme.primaryPink.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.all(12),
            filled: true,
            fillColor: AppTheme.primaryPink.withOpacity(0.05),
          ),
        ),
      ],
    );
  }

  Widget _buildEditableCell(PengamatanRow row, String field) {
    // Get current value untuk preserve data saat rebuild
    String currentValue;
    switch (field) {
      case 'arus':
        currentValue = row.arus;
        break;
      case 'hambatan':
        currentValue = row.hambatan;
        break;
      case 'teganganTerhitung':
        currentValue = row.teganganTerhitung;
        break;
      case 'teganganPembacaan':
        currentValue = row.teganganPembacaan;
        break;
      case 'selisih':
        currentValue = row.selisih;
        break;
      default:
        currentValue = '';
    }

    return SizedBox(
      width: 80,
      child: TextFormField(
        initialValue: currentValue,
        onChanged: (value) {
          switch (field) {
            case 'arus':
              row.arus = value;
              break;
            case 'hambatan':
              row.hambatan = value;
              break;
            case 'teganganTerhitung':
              row.teganganTerhitung = value;
              break;
            case 'teganganPembacaan':
              row.teganganPembacaan = value;
              break;
            case 'selisih':
              row.selisih = value;
              break;
          }
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          contentPadding: const EdgeInsets.all(8),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }

  Widget _buildQuestionField({
    required String question,
    required TextEditingController controller,
    int minLines = 4,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.greyDark,
                height: 1.5,
              ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          minLines: minLines,
          maxLines: 8,
          decoration: InputDecoration(
            hintText: 'Tulis jawaban Anda di sini...',
            hintStyle: TextStyle(
              color: AppTheme.greyDark.withOpacity(0.5),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppTheme.primaryPink,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppTheme.primaryPink.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppTheme.primaryPink,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.all(12),
            filled: true,
            fillColor: AppTheme.primaryPink.withOpacity(0.05),
          ),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.black,
                height: 1.5,
              ),
        ),
      ],
    );
  }

  Widget _buildAngketPenilaianStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAngketHeader(),
          const SizedBox(height: 24),
          ..._angketData.map((item) => _buildAngketRow(item)).toList(),
          const SizedBox(height: 16),
          Text(
            '* Semua pertanyaan angket wajib diberi skor (1-4)',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.red,
                  fontStyle: FontStyle.italic,
                ),
          ),
          const SizedBox(height: 24),
          _buildKritikSaranSection(),
          const SizedBox(height: 32),
          // Button Row: Back dan Submit
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _currentStep--;
                    });
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Kembali'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryPink,
                    side: const BorderSide(color: AppTheme.primaryPink, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: const Icon(Icons.send),
                  label: const Text('Kirim Angket'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryPink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAngketHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryPink,
                ),
            children: const [
              TextSpan(text: 'ANGKET PENILAIAN PENGGUNA '),
              TextSpan(
                text: '*',
                style: TextStyle(color: Colors.red, fontSize: 24),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Petunjuk Pengisian:',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.black,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Angket penilaian pengguna ini dimaksudkan untuk mengetahui pendapat pengguna terhadap media pembelajaran prototipe bifocal modelling tools materi Hukum Ohm. Dimohon memberikan tanda pada kolom skor penilaian sesuai dengan pendapat Anda.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.greyDark,
                height: 1.5,
              ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryPink.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppTheme.primaryPink.withOpacity(0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Keterangan Skor:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.black,
                    ),
              ),
              const SizedBox(height: 8),
              ...[
                ('4', 'Sangat Setuju'),
                ('3', 'Setuju'),
                ('2', 'Kurang Setuju'),
                ('1', 'Tidak Setuju'),
              ].map((e) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '${e.$1} = ${e.$2}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.greyDark,
                        ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAngketRow(AngketItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.primaryPink.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(10),
        color: AppTheme.greyLight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No ${item.no} - ${item.kriteria}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryPink,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            item.aspek,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.black,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [1, 2, 3, 4].map((score) {
              final isSelected = item.score == score;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      item.score = score;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryPink : AppTheme.white,
                      border: Border.all(
                        color: AppTheme.primaryPink,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$score',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppTheme.primaryPink,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildKritikSaranSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.black,
                ),
            children: [
              const TextSpan(text: 'Kritik dan Saran '),
              TextSpan(
                text: '(Optional)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.greyDark,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          onChanged: (value) {
            _kritikSaran = value;
          },
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Tuliskan kritik dan saran Anda di sini... (Boleh dikosongkan)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppTheme.primaryPink,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  bool _isAllPengamatanFilled() {
    return _pengamatanData.every((row) =>
        row.arus.isNotEmpty &&
        row.hambatan.isNotEmpty &&
        row.teganganTerhitung.isNotEmpty &&
        row.teganganPembacaan.isNotEmpty &&
        row.selisih.isNotEmpty);
  }

  bool _isAllKesimpulanFilled() {
    return _kesimpulanSensorController.text.isNotEmpty &&
        _kesimpulanHambatanController.text.isNotEmpty;
  }

  bool _isAllAngketFilled() {
    return _angketData.every((item) => item.score > 0);
  }

  void _submitForm() async {
    if (_namaTekController.text.isEmpty ||
        _instansiTekController.text.isEmpty ||
        _selectedGender.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan isi semua data diri terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validasi Tabel Pengamatan
    if (!_isAllPengamatanFilled()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '❌ Mohon isi SEMUA 10 baris di Tabel Pengamatan!\n'
            'Pastikan setiap kolom (Arus, Hambatan, V Hitung, V Sensor, Selisih) terisi lengkap.',
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
      setState(() => _currentStep = 1); // Kembali ke step pengamatan
      return;
    }

    // Validasi Kesimpulan
    if (!_isAllKesimpulanFilled()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '❌ Mohon isi Nilai Kesimpulan!\n'
            'Pastikan Tegangan Sensor dan Hambatan terisi.',
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
      setState(() => _currentStep = 1); // Kembali ke step pengamatan
      return;
    }

    // Validasi Pertanyaan 1
    if (_pertanyaan1Controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Mohon jawab Pertanyaan 1 tentang perbedaan Tegangan!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      setState(() => _currentStep = 1); // Kembali ke step pengamatan
      return;
    }

    // Validasi Pertanyaan 2
    if (_pertanyaan2Controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Mohon jawab Pertanyaan 2 tentang linearitas grafik!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      setState(() => _currentStep = 1); // Kembali ke step pengamatan
      return;
    }

    // Validasi Angket Penilaian - SEMUA HARUS DIISI!
    if (!_isAllAngketFilled()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '❌ Mohon isi SEMUA Angket Penilaian!\n'
            'Setiap pertanyaan harus diberi skor (1-5).',
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
      setState(() => _currentStep = 2); // Pastikan di step angket
      return;
    }

    // CATATAN: komentar_saran bersifat OPTIONAL - tidak perlu validasi

    // Check internet connection
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '⚠️ Tidak Ada Internet\n'
              'Hubungkan ke WiFi atau Mobile Data untuk mengirim data.',
            ),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 4),
          ),
        );
      }
      return;
    }

    // Show loading dengan tampilan yang lebih baik
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryPink),
                strokeWidth: 3,
              ),
              const SizedBox(height: 20),
              Text(
                'Mengirim Data...',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryPink,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Mohon tunggu sebentar',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.greyDark,
                    ),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      // Persiapkan data
      final Map<String, dynamic> requestData = {
        'nama': _namaTekController.text,
        'instansi': _instansiTekController.text,
        'gender': _selectedGender,
      };

      // Add pengamatan data dengan key tp_1_*, tp_2_*, dst.
      for (int i = 0; i < _pengamatanData.length; i++) {
        final row = _pengamatanData[i];
        final prefix = 'tp_${i + 1}';
        requestData['${prefix}_arus'] = row.arus;
        requestData['${prefix}_hambatan'] = row.hambatan;
        requestData['${prefix}_tegangan_hitung'] = row.teganganTerhitung;
        requestData['${prefix}_tegangan_sensor'] = row.teganganPembacaan;
        requestData['${prefix}_selisih'] = row.selisih;
      }

      // Add kesimpulan
      requestData['kesimpulan_sensor'] = _kesimpulanSensorController.text;
      requestData['kesimpulan_hambatan'] = _kesimpulanHambatanController.text;

      // Add pertanyaan analisis
      requestData['pertanyaan_1'] = _pertanyaan1Controller.text;
      requestData['pertanyaan_2'] = _pertanyaan2Controller.text;

      // Add angket scores with specific keys
      const angketKeys = [
        'alat_mudah_digunakan',
        'alat_dapat_berulang',
        'potensi_masa_depan',
        'perawatan_alat_mudah',
        'bahan_kuat_awet',
        'kecukupan_waktu_pemahaman',
        'kemudahan_pahami_materi',
        'sesuai_kondisi_lingkungan',
        'aman_digunakan',
        'bentuk_sesuai_materi',
        'penunjang_belajar_aktif',
      ];

      for (int i = 0; i < _angketData.length; i++) {
        if (i < angketKeys.length) {
          requestData[angketKeys[i]] = _angketData[i].score;
        }
      }

      // Add komentar saran
      requestData['komentar_saran'] = _kritikSaran;

      // Kirim ke Google Apps Script menggunakan POST
      // IMPORTANT: Gunakan application/json dengan rawBody untuk doPost
      final response = await http.post(
        Uri.parse('https://script.google.com/macros/s/AKfycbycDdJYR93p2uU5sEBHoYKwKA20RAI4H9y-8-i5sXKlVwzmVMErz7pGY7O6ftYc2Mcr/exec'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      // Close loading dialog
      if (mounted) Navigator.pop(context);

        // Debug: Print response untuk troubleshooting
        print('=== LKPD Response Debug ===');
        print('Status Code: ${response.statusCode}');
        print('Response Headers: ${response.headers}');
        print('Response Body (first 500 chars): ${response.body.substring(0, response.body.length > 500 ? 500 : response.body.length)}');
        print('========================');

        // Check status code
        if (response.statusCode == 200 || response.statusCode == 302) {
          final responseBody = response.body.trim();
          
          // Check jika HTML error dari Google Apps Script
          if (responseBody.contains('<!DOCTYPE html>') && responseBody.contains('<title>Salah</title>')) {
            throw Exception(
              '❌ Google Apps Script Error!\n\n'
              'Script mengembalikan halaman error "Salah".\n\n'
              'Kemungkinan penyebab:\n'
              '• Function doGet() tidak ada di Google Apps Script\n'
              '• Ada error di kode Google Apps Script\n'
              '• Nama field tidak sesuai\n'
              '• Spreadsheet ID salah atau permission ditolak\n\n'
              'Buka Google Apps Script dan cek Execution log untuk detail error.'
            );
          }
          
          // Jika dapat redirect HTML (status 302), anggap sukses
          if (response.statusCode == 302 || 
              (responseBody.contains('Moved Temporarily') && responseBody.contains('<HTML>'))) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Terima kasih karena sudah mengisi angket penilaian'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
              
              // Redirect ke home page setelah 2 detik
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  Navigator.pop(context);
                }
              });
            }
            return; // Sukses, keluar dari function
          }

          // Jika response JSON, parse seperti biasa
          if (responseBody.startsWith('{')) {
            try {
              final responseData = jsonDecode(responseBody);
              
              if (responseData['success'] == true) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Terima kasih karena sudah mengisi angket penilaian'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  
                  // Redirect ke home page setelah 2 detik
                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  });
                }
              } else {
                throw Exception(responseData['message'] ?? 'Server mengembalikan success: false');
              }
            } on FormatException catch (e) {
              throw Exception(
                '❌ Format Response Error!\n\n'
                'Response dari server bukan JSON yang valid.\n\n'
                'Detail: ${e.message}\n\n'
                'Cek console untuk melihat response lengkap.'
              );
            }
          } else {
            // Response bukan JSON dan bukan redirect - unknown format
            throw Exception(
              '❌ Unknown Response Format!\n\n'
              'Response tidak dalam format yang dikenali.\n\n'
              'Cek console untuk detail.'
            );
          }
        } else {
          throw Exception('❌ Server Error: HTTP ${response.statusCode}');
        }
    } catch (error) {
      // Close loading dialog jika masih terbuka
      if (mounted) {
        // Check if dialog is still open
        Navigator.of(context, rootNavigator: true).popUntil((route) {
          return route is! PopupRoute;
        });
      }
      
      if (mounted) {
        String errorMessage = '❌ Gagal Mengirim Data';
        
        if (error.toString().contains('Failed host lookup')) {
          errorMessage = '❌ Tidak Ada Koneksi Internet\n\n'
              'Pastikan device Anda terhubung ke WiFi atau Mobile Data, '
              'lalu coba lagi.';
        } else if (error.toString().contains('Connection refused')) {
          errorMessage = '❌ Server Tidak Merespons\n\n'
              'Google Apps Script endpoint mungkin sedang error. '
              'Hubungi admin atau coba lagi nanti.';
        } else if (error.toString().contains('SocketException')) {
          errorMessage = '❌ Masalah Jaringan\n\n'
              'Periksa kembali koneksi internet Anda dan coba lagi.';
        } else if (error.toString().contains('FormatException') || 
                   error.toString().contains('Format Response Error')) {
          errorMessage = '❌ Google Apps Script Error!\n\n'
              'Server mengirim response yang tidak valid.\n\n'
              'Solusi:\n'
              '1. Buka Google Apps Script Anda\n'
              '2. Deploy ulang sebagai Web App\n'
              '3. Pastikan return format JSON: {"success": true}\n\n'
              'Lihat console untuk detail lengkap.';
        } else if (error.toString().contains('Google Apps Script Error')) {
          errorMessage = error.toString().replaceAll('Exception: ', '');
        } else {
          errorMessage = '❌ Error: ${error.toString()}';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }
}

// Model Classes
class PengamatanRow {
  final int no;
  String arus;
  String hambatan;
  String teganganTerhitung;
  String teganganPembacaan;
  String selisih;

  PengamatanRow({
    required this.no,
    required this.arus,
    required this.hambatan,
    required this.teganganTerhitung,
    required this.teganganPembacaan,
    required this.selisih,
  });
}

class KesimpulanRow {
  final int no;
  String arus;
  String hambatan;
  String tegangan;

  KesimpulanRow({
    required this.no,
    required this.arus,
    required this.hambatan,
    required this.tegangan,
  });
}

class AngketItem {
  final int no;
  final String kriteria;
  final String aspek;
  int score = 0;

  AngketItem(this.no, this.kriteria, this.aspek);
}

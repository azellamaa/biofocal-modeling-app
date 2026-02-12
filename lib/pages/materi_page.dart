import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../config/theme.dart';

class MateriPage extends StatefulWidget {
  const MateriPage({Key? key}) : super(key: key);

  @override
  State<MateriPage> createState() => _MateriPageState();
}

class _MateriPageState extends State<MateriPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
          'Materi Hukum Ohm',
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
            Tab(text: 'Sejarah'),
            Tab(text: 'Pengertian'),
            Tab(text: 'Rumus & Penurunan'),
            Tab(text: 'Grafik'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSejarahTab(),
          _buildPengertianTab(),
          _buildRumusTab(),
          _buildGrafikTab(),
        ],
      ),
    );
  }

  // Tab 1: Sejarah
  Widget _buildSejarahTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('HUKUM OHM - SEJARAH'),
          const SizedBox(height: 16),
          _buildBodyText(
            'Pada tahun 1820-an, konsep listrik masih sangat baru dan membingungkan. '
            'Belum ada alat ukur yang akurat untuk arus maupun tegangan. Georg Ohm mulai '
            'bereksperimen menggunakan kawat dengan berbagai panjang dan ketebalan untuk '
            'melihat bagaimana mereka memengaruhi aliran listrik.',
          ),
          const SizedBox(height: 16),
          _buildBodyText(
            'Ohm menerbitkan bukunya yang terkenal berjudul "Die galvanische Kette, '
            'mathematisch bearbeitet" (Rangkaian Galvanik yang Diolah secara Matematis). '
            'Dalam buku ini, ia menggunakan penemuan Termokopel (sebagai sumber tegangan '
            'yang stabil) dan Galvanometer untuk mengukur arus.',
          ),
          const SizedBox(height: 16),
          _buildBodyText(
            'Menariknya, saat pertama kali dipublikasikan, teori Ohm ditertawakan dan '
            'ditolak oleh para ilmuwan Jerman saat itu. Mereka menganggap pendekatan '
            'matematika Ohm terlalu kompleks dan tidak perlu untuk fenomena alam. Karena '
            'penolakan ini, Ohm sempat kehilangan pekerjaannya sebagai guru dan hidup '
            'dalam kemiskinan selama bertahun-tahun.',
          ),
          const SizedBox(height: 16),
          _buildBodyText(
            'Dunia baru menyadari kebenaran teori Ohm satu dekade kemudian. Pada tahun '
            '1841, Royal Society di London memberikan penghargaan Copley Medal kepadanya. '
            'Akhirnya, pada tahun 1893, nama "Ohm" resmi diabadikan sebagai satuan standar '
            'internasional untuk hambatan listrik (Ω).',
          ),
        ],
      ),
    );
  }

  // Tab 2: Pengertian
  Widget _buildPengertianTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('PENGERTIAN HUKUM OHM'),
          const SizedBox(height: 16),
          _buildBodyText(
            'Hukum Ohm adalah prinsip dasar dalam fisika elektronika yang menyatakan bahwa '
            'kuat arus listrik yang mengalir melalui sebuah penghantar akan berbanding lurus '
            'dengan beda potensial (tegangan) yang diberikan kepadanya, asalkan suhu lingkungan '
            'tetap stabil.',
          ),
          const SizedBox(height: 20),
          _buildSubSectionTitle('Prinsip Dasar Hukum Ohm:'),
          const SizedBox(height: 12),
          _buildBulletPoint(
            'Jika Tegangan naik, maka Arus juga akan naik (asalkan hambatan tetap).',
          ),
          _buildBulletPoint(
            'Jika Hambatan naik, maka Arus akan turun (asalkan tegangan tetap).',
          ),
          const SizedBox(height: 24),
          _buildSubSectionTitle('Rumus Hukum Ohm:'),
          const SizedBox(height: 16),
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryPink.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryPink.withOpacity(0.3),
                ),
              ),
              child: Math.tex(
                r'V = I \times R',
                textStyle: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSubSectionTitle('Keterangan:'),
          const SizedBox(height: 12),
          _buildDefinitionItem('V (Voltage)', 'Tegangan listrik yang diberikan (Satuan: Volt)'),
          _buildDefinitionItem('I (Current)', 'Arus listrik yang mengalir (Satuan: Ampere)'),
          _buildDefinitionItem('R (Resistance)', 'Hambatan listrik (Satuan: Ohm atau Ω)'),
          const SizedBox(height: 24),
          Center(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 300),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                'assets/images/ohm_triangle.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tab 3: Rumus & Penurunan
  Widget _buildRumusTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('RUMUS & PENURUNAN HUKUM OHM'),
          const SizedBox(height: 16),
          _buildBodyText('Sebelum masuk ke rumus, kita pahami dulu 3 besaran penting:'),
          const SizedBox(height: 24),
          // Arus Listrik
          _buildFormulaSection(
            title: '1. Arus Listrik (I)',
            description: 'Arus adalah aliran muatan listrik.',
            formula: r'I = \frac{Q}{t}',
            definitions: [
              ('I', 'arus (Ampere)'),
              ('Q', 'muatan (Coulomb)'),
              ('t', 'waktu (detik)'),
            ],
          ),
          const SizedBox(height: 24),
          // Tegangan
          _buildFormulaSection(
            title: '2. Tegangan (V)',
            description: 'Tegangan adalah beda potensial listrik antara dua titik.',
            formula: r'V = \frac{W}{Q}',
            definitions: [
              ('V', 'tegangan (Volt)'),
              ('W', 'energi/usaha (Joule)'),
              ('Q', 'muatan (Coulomb)'),
            ],
          ),
          const SizedBox(height: 24),
          // Hambatan
          _buildFormulaSection(
            title: '3. Hambatan (R)',
            description:
                'Hambatan adalah ukuran seberapa besar suatu bahan menghambat arus listrik. '
                'Nilai hambatan dipengaruhi oleh:',
            formula: r'R = \rho \frac{L}{A}',
            definitions: [
              (r'\rho \text{ (rho)}', 'resistivitas bahan'),
              ('L', 'panjang penghantar'),
              ('A', 'luas penampang'),
            ],
          ),
          const SizedBox(height: 32),
          _buildSubSectionTitle('Penurunan Rumus Hukum Ohm:'),
          const SizedBox(height: 24),
          // Langkah 1
          _buildDerivationStep(
            stepNumber: 1,
            title: 'Hubungan Medan Listrik dan Gaya',
            description: 'Muatan dalam kawat mengalami gaya listrik:',
            formula: r'F = qE',
            explanation: 'Dimana: q = muatan, E = medan listrik.',
          ),
          const SizedBox(height: 20),
          // Langkah 2
          _buildDerivationStep(
            stepNumber: 2,
            title: 'Hubungan Medan Listrik dan Tegangan',
            description: 'Medan listrik dalam kawat:',
            formula: r'E = \frac{V}{L}',
            explanation: 'Dimana: V = tegangan, L = panjang kawat.',
          ),
          const SizedBox(height: 20),
          // Langkah 3
          _buildDerivationStep(
            stepNumber: 3,
            title: 'Kecepatan Drift Elektron',
            description: 'Elektron dalam kawat bergerak dengan kecepatan drift:',
            formula: r'v_d = \mu E',
            explanation:
                r'Substitusi E: $v_d = \mu \frac{V}{L}$ Dimana: μ = mobilitas elektron, E = medan listrik.',
          ),
          const SizedBox(height: 20),
          // Langkah 4
          _buildDerivationStep(
            stepNumber: 4,
            title: 'Hubungan Arus dengan Kecepatan Drift',
            description: 'Arus listrik:',
            formula: r'I = nqAv_d',
            explanation:
                r'Substitusi $v_d$: $I = nqA \left(\mu \frac{V}{L}\right) = \frac{nqA\mu}{L} V$ Dimana: n = jumlah elektron per volume, q = muatan elektron, A = luas penampang, $v_d$ = kecepatan drift.',
          ),
          const SizedBox(height: 20),
          // Langkah 5
          _buildDerivationStep(
            stepNumber: 5,
            title: 'Definisi Hambatan',
            description: 'Dari persamaan di atas:',
            formula: r'V = \frac{L}{nqA\mu} I',
            explanation:
                r'Bagian $\frac{L}{nqA\mu}$ adalah konstanta hambatan (R), sehingga: $V = IR$',
          ),
        ],
      ),
    );
  }

  // Tab 4: Grafik
  Widget _buildGrafikTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('GRAFIK HUKUM OHM'),
          const SizedBox(height: 16),
          _buildBodyText(
            'Dalam eksperimen fisika, grafik yang menghubungkan Tegangan (V) dan Arus (I) '
            'disebut sebagai Kurva Karakteristik V-I.',
          ),
          const SizedBox(height: 16),
          _buildBodyText(
            'Untuk Hukum Ohm, grafik ini merupakan representasi matematis dari sifat '
            'konduktif suatu material.',
          ),
          const SizedBox(height: 20),
          _buildSubSectionTitle('Karakteristik Grafik Hukum Ohm:'),
          const SizedBox(height: 12),
          _buildBulletPoint('Linear (Garis Lurus) yang dimulai dari titik pusat (0,0)'),
          _buildBulletPoint(
            'Linearitas: Menunjukkan bahwa hubungan antara V dan I adalah sebanding. '
            'Jika V diduakalikan, maka I juga otomatis menjadi dua kali lipat.',
          ),
          _buildBulletPoint(
            'Titik Origin (0,0): Menunjukkan bahwa tanpa adanya beda potensial, '
            'tidak akan ada arus yang mengalir.',
          ),
          const SizedBox(height: 24),
          Center(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 400),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                'assets/images/grafik_hukum_ohm.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSubSectionTitle('Penjelasan Grafik:'),
          const SizedBox(height: 12),
          _buildBodyText(
            'Grafik karakteristik V-I tersebut menggambarkan hubungan antara beda potensial '
            '(tegangan) dan kuat arus listrik, di mana kemiringan garisnya menunjukkan sifat '
            'hambatan dari suatu material.',
          ),
          const SizedBox(height: 16),
          _buildSubSectionTitle('Garis Ohmik (Linier):'),
          const SizedBox(height: 8),
          _buildBodyText(
            'Garis lurus yang melintasi titik pusat (0,0) disebut sebagai garis Ohmik, yang '
            'merepresentasikan kondisi ideal sesuai Hukum Ohm di mana nilai hambatan (R) bersifat '
            'konstan dan arus meningkat secara linear sebanding dengan kenaikan tegangan. Kondisi ini '
            'biasanya ditemukan pada resistor berkualitas tinggi atau konduktor logam yang suhunya '
            'terjaga stabil selama eksperimen berlangsung.',
          ),
          const SizedBox(height: 16),
          _buildSubSectionTitle('Material Non-Ohmik:'),
          const SizedBox(height: 8),
          _buildBodyText(
            'Pada kenyataannya, banyak komponen yang bersifat Non-Ohmik, seperti yang '
            'ditunjukkan oleh dua kurva melengkung pada grafik tersebut.',
          ),
          const SizedBox(height: 12),
          _buildBulletPoint(
            'Kurva melengkung ke atas: Hambatan berkurang ketika tegangan naik, sering '
            'ditemukan pada material semikonduktor.',
          ),
          _buildBulletPoint(
            'Kurva melengkung ke bawah: Hambatan bertambah seiring naiknya tegangan. '
            'Fenomena ini sangat umum pada praktikum riil akibat efek termal, di mana arus '
            'listrik yang mengalir menyebabkan kenaikan suhu pada komponen, sehingga getaran '
            'atom di dalamnya menghambat laju elektron dan meningkatkan nilai hambatan.',
          ),
        ],
      ),
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

  Widget _buildSubSectionTitle(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.black,
            fontWeight: FontWeight.w600,
          ),
    );
  }

  Widget _buildBodyText(String text) {
    // Check if text contains LaTeX
    if (!_isLatexContent(text)) {
      return Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.greyDark,
              height: 1.6,
            ),
        textAlign: TextAlign.justify,
      );
    }

    // Parse and render mixed LaTeX and text
    return _buildMixedLatexText(text, Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppTheme.greyDark,
          height: 1.6,
        ));
  }

  Widget _buildMixedLatexText(String text, TextStyle? style) {
    final parts = <InlineSpan>[];
    final pattern = RegExp(r'\$[^$]+\$|\\[a-zA-Z]+(?:\s*\{[^}]*\})*');
    
    int lastIndex = 0;
    for (final match in pattern.allMatches(text)) {
      // Add text before LaTeX
      if (match.start > lastIndex) {
        parts.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: style,
        ));
      }

      // Add LaTeX
      String latexContent = match.group(0)!;
      // Remove $ if present
      if (latexContent.startsWith('\$') && latexContent.endsWith('\$')) {
        latexContent = latexContent.substring(1, latexContent.length - 1);
      }

      parts.add(WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Math.tex(
          latexContent,
          textStyle: style,
        ),
      ));

      lastIndex = match.end;
    }

    // Add remaining text
    if (lastIndex < text.length) {
      parts.add(TextSpan(
        text: text.substring(lastIndex),
        style: style,
      ));
    }

    return RichText(
      text: TextSpan(children: parts),
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 8, right: 12),
            decoration: BoxDecoration(
              color: AppTheme.primaryPink,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: !_isLatexContent(text)
                ? Text(
                    text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.greyDark,
                          height: 1.5,
                        ),
                    textAlign: TextAlign.justify,
                  )
                : _buildMixedLatexText(text, Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.greyDark,
                      height: 1.5,
                    )),
          ),
        ],
      ),
    );
  }

  Widget _buildDefinitionItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              color: AppTheme.primaryPink,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: _isLatexContent(title) ? '' : '$title: ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.black,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  if (_isLatexContent(title))
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Math.tex(
                        title,
                        textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.black,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  if (_isLatexContent(title))
                    TextSpan(
                      text: ': ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.black,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  if (_isLatexContent(description))
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Math.tex(
                        description,
                        textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.greyDark,
                              height: 1.5,
                            ),
                      ),
                    )
                  else
                    TextSpan(
                      text: description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.greyDark,
                            height: 1.5,
                          ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isLatexContent(String text) {
    return text.contains(RegExp(r'\\|_|\^|{|}|\$'));
  }

  Widget _buildFormulaSection({
    required String title,
    required String description,
    required String formula,
    required List<(String, String)> definitions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubSectionTitle(title),
        const SizedBox(height: 8),
        _buildBodyText(description),
        const SizedBox(height: 12),
        Center(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.primaryPink.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppTheme.primaryPink.withOpacity(0.3),
              ),
            ),
            child: Math.tex(
              formula,
              textStyle: const TextStyle(fontSize: 20),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Keterangan:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.black,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        ...definitions.map((def) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: _buildDefinitionItem(def.$1, def.$2),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildDerivationStep({
    required int stepNumber,
    required String title,
    required String description,
    required String formula,
    String? explanation,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.greyLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryPink.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Langkah $stepNumber: $title',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppTheme.primaryPink,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          _buildBodyText(description),
          const SizedBox(height: 12),
          Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Math.tex(
                formula,
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          if (explanation != null) ...[
            const SizedBox(height: 12),
            _buildBodyText(explanation),
          ],
        ],
      ),
    );
  }
}

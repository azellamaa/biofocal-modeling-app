import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../config/theme.dart';

class MateriTambahanPage extends StatefulWidget {
  const MateriTambahanPage({Key? key}) : super(key: key);

  @override
  State<MateriTambahanPage> createState() => _MateriTambahanPageState();
}

class _MateriTambahanPageState extends State<MateriTambahanPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
          'Materi Tambahan',
          style: TextStyle(
            color: AppTheme.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.primaryPink,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.white),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.white,
          indicatorWeight: 3,
          labelColor: AppTheme.white,
          unselectedLabelColor: AppTheme.white.withOpacity(0.7),
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          tabs: const [
            Tab(
              icon: Icon(Icons.picture_as_pdf),
              text: 'Modul Hukum Ohm',
            ),
            Tab(
              icon: Icon(Icons.play_circle_outline),
              text: 'Video Pembelajaran',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildModulTab(),
          _buildVideoTab(),
        ],
      ),
    );
  }

  Widget _buildModulTab() {
    return Container(
      color: AppTheme.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryPink.withOpacity(0.1),
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.primaryPink.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppTheme.primaryPink,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Modul pembelajaran Hukum Ohm dalam format PDF',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.greyDark,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SfPdfViewer.asset(
              'assets/files/modul_hukum_ohm.pdf',
              enableDoubleTapZooming: true,
              enableTextSelection: true,
              canShowScrollHead: true,
              canShowScrollStatus: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoTab() {
    return VideoPlayerWidget();
  }
}

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({Key? key}) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    
    // Video ID dummy dari YouTube (video tentang Hukum Ohm)
    // Ganti dengan video ID yang sebenarnya nanti
    const videoId = 'dQw4w9WgXcQ'; // Dummy video ID
    
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: true,
        controlsVisibleAtStart: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryPink.withOpacity(0.1),
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.primaryPink.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppTheme.primaryPink,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Video pembelajaran praktikum Hukum Ohm',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.greyDark,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // YouTube Player
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: AppTheme.primaryPink,
              progressColors: ProgressBarColors(
                playedColor: AppTheme.primaryPink,
                handleColor: AppTheme.primaryPink,
              ),
              onReady: () {
                print('Video player is ready');
              },
              onEnded: (data) {
                // Video selesai diputar
              },
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Deskripsi Video
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tentang Video',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryPink,
                      ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.greyLight.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryPink.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        Icons.topic_rounded,
                        'Topik',
                        'Praktikum Hukum Ohm dengan Bifocal Modelling Tools',
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.access_time_rounded,
                        'Durasi',
                        'Estimasi 10-15 menit',
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.lightbulb_outline_rounded,
                        'Materi',
                        'Pengenalan alat, cara pengukuran, dan analisis data hasil praktikum',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  '💡 Tips Belajar',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.black,
                      ),
                ),
                const SizedBox(height: 12),
                _buildTipCard('Siapkan buku catatan untuk mencatat poin-poin penting'),
                _buildTipCard('Tonton video sampai selesai untuk pemahaman menyeluruh'),
                _buildTipCard('Ulangi bagian yang kurang dipahami'),
                _buildTipCard('Praktikkan langsung setelah menonton video'),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppTheme.primaryPink,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.greyDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.black,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTipCard(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppTheme.primaryPink,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.greyDark,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

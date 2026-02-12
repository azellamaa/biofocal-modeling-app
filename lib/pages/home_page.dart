import 'package:flutter/material.dart';
import '../config/theme.dart';
import 'materi_page.dart';
import 'praktikum_page.dart';
import 'lkpd_page.dart';
import 'materi_tambahan_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryPink.withOpacity(0.08),
              AppTheme.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting Section with Icon
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Text Section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Halo! 👋',
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    color: AppTheme.black,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 32,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Mari belajar Hukum Ohm dengan Azel',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppTheme.primaryPink,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    height: 1.2,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      // Logo Icon (mentok kanan)
                      Transform.translate(
                        offset: const Offset(20, 0),
                        child: Opacity(
                          opacity: 0.9,
                          child: Image.asset(
                            'assets/icons/icon_eduzell_new_tr.png',
                            width: 160,
                            height: 160,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryPink.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.school_rounded,
                          color: AppTheme.primaryPink,
                          size: 20,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Yuk, mulai petualangan belajar!\nBelajar jadi seru bersama Azel',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.primaryPink,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),

                  // Menu Section
                  Text(
                    'Menu Pembelajaran',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.black,
                          fontSize: 20,
                        ),
                  ),
                  const SizedBox(height: 24),

                  // Menu Grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 1.1,
                    children: [
                      _buildMenuCard(
                        context,
                        title: 'Materi',
                        subtitle: 'Pelajari konsep',
                        icon: Icons.menu_book_rounded,
                        color: AppTheme.primaryPink,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MateriPage(),
                            ),
                          );
                        },
                      ),
                      _buildMenuCard(
                        context,
                        title: 'Praktikum',
                        subtitle: 'Eksperimen langsung',
                        icon: Icons.science_rounded,
                        color: const Color(0xFFFF6B9D),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PraktikumPage(),
                            ),
                          );
                        },
                      ),
                      _buildMenuCard(
                        context,
                        title: 'LKPD',
                        subtitle: 'Lembar kerja siswa',
                        icon: Icons.assignment_rounded,
                        color: const Color(0xFFE91E63),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LkpdPage(),
                            ),
                          );
                        },
                      ),
                      _buildMenuCard(
                        context,
                        title: 'Materi Tambahan',
                        subtitle: 'Modul & Video',
                        icon: Icons.video_library_rounded,
                        color: const Color(0xFFC2185B),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MateriTambahanPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.15),
                color.withOpacity(0.05),
              ],
            ),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withOpacity(0.15),
                    ),
                    child: Icon(
                      icon,
                      size: 36,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.black,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.greyDark.withOpacity(0.6),
                          fontSize: 11,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

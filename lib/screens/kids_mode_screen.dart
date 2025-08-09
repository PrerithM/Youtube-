import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/video.dart';

class KidsModeScreen extends StatefulWidget {
  const KidsModeScreen({super.key});

  @override
  State<KidsModeScreen> createState() => _KidsModeScreenState();
}

class _KidsModeScreenState extends State<KidsModeScreen> {
  List<Video> _videos = [];
  bool _isLoading = false;

  // Educational videos only
  static const List<Video> _educationalVideos = [
    Video(
      id: '1',
      title: 'Fun Science Experiments for Kids',
      channel: 'SciShow Kids',
      channelId: 'UCbCmjCuTUZos6Inko4u57UQ',
      thumbnail: 'https://via.placeholder.com/320x180/4ECDC4/FFFFFF?text=Science',
      duration: '8:45',
      views: '2.1M views',
      publishedAt: '2 days ago',
    ),
    Video(
      id: '2',
      title: 'Learning Math with Fun Games',
      channel: 'Khan Academy',
      channelId: 'UC4a-Gbdw7vOaccHmFo40b9g',
      thumbnail: 'https://via.placeholder.com/320x180/45B7D1/FFFFFF?text=Math',
      duration: '12:30',
      views: '1.8M views',
      publishedAt: '1 week ago',
    ),
    Video(
      id: '3',
      title: 'Wildlife Documentary for Children',
      channel: 'National Geographic Kids',
      channelId: 'UCJ5v_MCY6GNUBTO8-D3XoAg',
      thumbnail: 'https://via.placeholder.com/320x180/FF6B6B/FFFFFF?text=Nature',
      duration: '15:20',
      views: '3.2M views',
      publishedAt: '3 days ago',
    ),
    Video(
      id: '4',
      title: 'Fun Coding Tutorial for Beginners',
      channel: 'Coding for Kids',
      channelId: 'UCsooa4yRKGN_zEE8iknghZA',
      thumbnail: 'https://via.placeholder.com/320x180/96CEB4/FFFFFF?text=Coding',
      duration: '10:15',
      views: '1.5M views',
      publishedAt: '5 days ago',
    ),
    Video(
      id: '5',
      title: 'Learning Colors and Shapes',
      channel: 'SciShow Kids',
      channelId: 'UCbCmjCuTUZos6Inko4u57UQ',
      thumbnail: 'https://via.placeholder.com/320x180/FFD93D/FFFFFF?text=Colors',
      duration: '6:30',
      views: '1.2M views',
      publishedAt: '1 day ago',
    ),
    Video(
      id: '6',
      title: 'Reading Stories for Kids',
      channel: 'Khan Academy',
      channelId: 'UC4a-Gbdw7vOaccHmFo40b9g',
      thumbnail: 'https://via.placeholder.com/320x180/A8E6CF/FFFFFF?text=Stories',
      duration: '9:45',
      views: '890K views',
      publishedAt: '4 days ago',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadEducationalVideos();
  }

  Future<void> _loadEducationalVideos() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _videos = _educationalVideos;
      _isLoading = false;
    });
  }

  void _handleVideoTap(Video video) {
    context.push('/video-player', extra: video);
  }

  Future<void> _handleExitKidsMode() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Kids Mode'),
        content: const Text('Are you sure you want to exit Kids Mode?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'Kids Mode',
              style: TextStyle(color: Color(0xFFFF6B6B)),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1), // ignore: deprecated_member_use
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withOpacity(0.3)), // ignore: deprecated_member_use
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shield,
                    size: 14,
                    color: Colors.green[700],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Safe',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _handleExitKidsMode,
            tooltip: 'Exit Kids Mode',
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Info
          Container(
            width: double.infinity,
            color: theme.colorScheme.surface,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Safe educational content for children',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.verified_user,
                      size: 16,
                      color: Colors.green[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Parent Approved Content',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.green[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomScrollView(
                    slivers: [
                      // Welcome Section
                      SliverToBoxAdapter(
                        child: _buildWelcomeSection(theme),
                      ),
                      
                      // Video Grid
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Adjusted to display a proper grid layout
                            childAspectRatio: 16 / 9,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final video = _videos[index];
                              return _buildVideoCard(video, theme);
                            },
                            childCount: _videos.length,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(theme),
    );
  }

  Widget _buildWelcomeSection(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), // ignore: deprecated_member_use
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Welcome to Kids Mode! 👋',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: const Color(0xFFFF6B6B),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Here you\'ll find fun and educational videos that are safe for children.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFeatureItem(
                icon: Icons.school,
                label: 'Educational',
                color: theme.colorScheme.primary,
              ),
              _buildFeatureItem(
                icon: Icons.verified_user,
                label: 'Safe Content',
                color: Colors.green,
              ),
              _buildFeatureItem(
                icon: Icons.child_care,
                label: 'Kid Friendly',
                color: theme.colorScheme.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1), // ignore: deprecated_member_use
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildVideoCard(Video video, ThemeData theme) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _handleVideoTap(video),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: video.thumbnail,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.broken_image,
                        size: 48,
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                  // Safe Content Badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.9), // ignore: deprecated_member_use
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.verified_user,
                            color: Colors.white,
                            size: 12,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'SAFE',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Duration Badge
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8), // ignore: deprecated_member_use
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        video.duration,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Video Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      video.channel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${video.views} • ${video.publishedAt}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), // ignore: deprecated_member_use
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => context.go('/home'),
              icon: const Icon(Icons.home),
              label: const Text('Home'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => context.push('/settings'),
              icon: const Icon(Icons.settings),
              label: const Text('Settings'),
            ),
          ),
        ],
      ),
    );
  }
}


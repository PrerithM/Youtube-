import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../providers/filter_provider.dart';
import '../providers/auth_provider.dart';
import '../models/video.dart';
import '../services/rss_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final RssService _rssService = RssService();
  List<Video> _videos = [];
  List<Video> _filteredVideos = [];
  bool _isLoading = false;
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _loadVideos();
    _loadBannerAd();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  Future<void> _loadVideos() async {
    setState(() {
      _isLoading = true;
    });

    final filterProvider = context.read<FilterProvider>();
    final channelIds = filterProvider.settings.allowedChannels
        .map((channel) => channel.id)
        .toList();

    if (channelIds.isNotEmpty) {
      final videos = await _rssService.fetchVideosFromRss(channelIds);
      setState(() {
        _videos = videos;
        _filteredVideos = videos;
        _isLoading = false;
      });
    } else {
      // Handle case where no channels are selected
      setState(() {
        _videos = [];
        _filteredVideos = [];
        _isLoading = false;
      });
    }
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Test ad unit ID
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {});
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    )..load();
  }

  void _handleSearch(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filteredVideos = _videos;
      } else {
        _filteredVideos = _videos.where((video) {
          return video.title.toLowerCase().contains(query.toLowerCase()) ||
                 video.channelTitle.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _handleVideoTap(Video video) {
    context.push('/video-player', extra: video);
  }

  Future<void> _handleKidsMode() async {
    final filterProvider = context.read<FilterProvider>();
    
    if (filterProvider.settings.parentalPin != null && 
        !filterProvider.settings.isKidsMode) {
      final pin = await _showPinDialog();
      if (pin == filterProvider.settings.parentalPin) {
        if (mounted) {
          context.push('/kids-mode');
        }
      } else if (pin != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incorrect PIN')),
          );
        }
      }
    } else {
      context.push('/kids-mode');
    }
  }

  Future<String?> _showPinDialog() async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Parental Control'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Enter PIN',
              hintText: 'Enter PIN to access Kids Mode',
            ),
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: 4,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('Enter'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleSignOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await context.read<AuthProvider>().signOut();
      if (mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Filter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleSignOut,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar and Filters
          _buildHeader(theme),
          
          // Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredVideos.isEmpty
                    ? _buildEmptyState(theme)
                    : _buildVideoList(),
          ),
          if (_bannerAd != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/settings'),
        icon: const Icon(Icons.add),
        label: const Text('Add Channel'),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search videos...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _handleSearch('');
                      },
                    )
                  : null,
            ),
            onChanged: _handleSearch,
          ),
          const SizedBox(height: 16),
          
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Consumer<FilterProvider>(
              builder: (context, filterProvider, _) {
                return Row(
                  children: [
                    _buildFilterChip(
                      icon: Icons.shield_outlined,
                      label: '${filterProvider.settings.allowedChannels.length} Channels',
                      onTap: () => context.push('/settings'),
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      icon: filterProvider.settings.isKidsMode 
                          ? Icons.child_care 
                          : Icons.school,
                      label: 'Kids Mode',
                      isActive: filterProvider.settings.isKidsMode,
                      onTap: _handleKidsMode,
                    ),
                    if (filterProvider.settings.hideShorts) ...[
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        icon: Icons.videocam_off,
                        label: 'No Shorts',
                      ),
                    ],
                    if (filterProvider.settings.hideTrending) ...[
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        icon: Icons.trending_down,
                        label: 'No Trending',
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required IconData icon,
    required String label,
    bool isActive = false,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onTap,
      backgroundColor: isActive 
          ? theme.colorScheme.primary.withOpacity(0.1) // ignore: deprecated_member_use
          : null,
      side: isActive 
          ? BorderSide(color: theme.colorScheme.primary)
          : null,
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    final filterProvider = context.watch<FilterProvider>();
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No videos found',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              filterProvider.settings.allowedChannels.isEmpty
                  ? 'Add some channels to your allowed list to see videos here.'
                  : 'Try adjusting your search or filter settings.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.push('/settings'),
              child: const Text('Add Channels'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredVideos.length,
      itemBuilder: (context, index) {
        final video = _filteredVideos[index];
        return _buildVideoCard(video);
      },
    );
  }

  Widget _buildVideoCard(Video video) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _handleVideoTap(video),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: video.thumbnailUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.play_circle_outline,
                        size: 48,
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ),
                  // Duration Badge
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(204), // 0.8 * 255 = 204
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Video Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    video.channelTitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '', // No longer have view count or published date
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


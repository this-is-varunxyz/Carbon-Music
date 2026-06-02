import 'package:flutter/material.dart';
import 'package:carbon_music/features/auth/domain/auth_repository.dart';
import 'package:carbon_music/features/auth/presentation/login_screen.dart';
import 'package:carbon_music/features/music/domain/entities/song_entity.dart';
import 'package:carbon_music/features/music/domain/repositories/music_repository.dart';
import 'package:carbon_music/injection_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  List<SongEntity> _searchResults = [];
  String? _errorMessage;

  Future<void> _handleSignOut(BuildContext context) async {
    final authRepo = sl<AuthRepository>();
    await authRepo.signOut();
    
    if (!mounted) return;
    
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _searchSongs() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final musicRepo = sl<MusicRepository>();
    final result = await musicRepo.searchSongs(query);

    setState(() {
      _isLoading = false;
    });

    result.fold(
      (failure) => setState(() => _errorMessage = failure.message),
      (songs) => setState(() => _searchResults = songs),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7), 
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: const Icon(Icons.album_rounded, size: 24, color: Colors.black87),
                      ),
                      const SizedBox(width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CARBON',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                              letterSpacing: 4,
                              height: 1,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'MUSIC',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                              letterSpacing: 6,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout_rounded, color: Colors.black54),
                    onPressed: () => _handleSignOut(context),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _searchSongs(),
                  decoration: InputDecoration(
                    hintText: 'Search for songs, artists...',
                    hintStyle: TextStyle(color: Colors.black.withValues(alpha: 0.3)),
                    prefixIcon: const Icon(Icons.search_rounded, color: Colors.black54),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: Colors.black54))
                : _errorMessage != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    )
                  : _searchResults.isEmpty
                    ? _buildEmptyState()
                    : _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.graphic_eq_rounded, size: 48, color: Colors.black.withValues(alpha: 0.1)),
        const SizedBox(height: 20),
        const Text(
          'SEARCH FOR MUSIC',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.black45,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final song = _searchResults[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(8),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                song.thumbnailUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.black12,
                  child: const Icon(Icons.music_note, color: Colors.black45),
                ),
              ),
            ),
            title: Text(
              song.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
            subtitle: Text(
              song.artist,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.play_arrow_rounded, color: Colors.black87),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Preparing to play ${song.title}...')),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
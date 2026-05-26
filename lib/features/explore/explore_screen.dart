import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../models/post.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../utils/constants.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedOccasion = 'All';

  // State to track user's active likes on the Explore screen
  final Set<String> _likedPostIds = {};

  // Mock data for MVP
  final List<Post> _posts = [
    Post(
      id: '1',
      imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=600',
      occasion: 'Casual',
      createdAt: DateTime.now(),
      likes: 234,
    ),
    Post(
      id: '2',
      imageUrl: 'https://images.unsplash.com/photo-1496747611176-843222e1e57c?w=600',
      occasion: 'Wedding',
      createdAt: DateTime.now(),
      likes: 567,
    ),
    Post(
      id: '3',
      imageUrl: 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=600',
      occasion: 'Streetwear',
      createdAt: DateTime.now(),
      likes: 892,
    ),
    Post(
      id: '4',
      imageUrl: 'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=600',
      occasion: 'Ethnic',
      createdAt: DateTime.now(),
      likes: 445,
    ),
    Post(
      id: '5',
      imageUrl: 'https://images.unsplash.com/photo-1485968579169-a6b2e8a7f6af?w=600',
      occasion: 'College',
      createdAt: DateTime.now(),
      likes: 321,
    ),
    Post(
      id: '6',
      imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600',
      occasion: 'Casual',
      createdAt: DateTime.now(),
      likes: 678,
    ),
  ];

  List<Post> get _filteredPosts {
    if (_selectedOccasion == 'All') return _posts;
    return _posts.where((post) => post.occasion == _selectedOccasion).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildOccasionFilters(),
            Expanded(
              child: _buildMasonryGrid(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Text(
            'Explore',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(AppConstants.textColorValue),
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Show filter options
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search styles...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
              : null,
        ),
        onChanged: (value) => setState(() {}),
      ),
    );
  }

  Widget _buildOccasionFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildOccasionChip('All'),
            ...AppConstants.occasions.map((occasion) => _buildOccasionChip(occasion)),
          ],
        ),
      ),
    );
  }

  Widget _buildOccasionChip(String occasion) {
    final isSelected = _selectedOccasion == occasion;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(occasion),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedOccasion = occasion;
          });
        },
        backgroundColor: Colors.grey.shade100,
        selectedColor: const Color(AppConstants.primaryColorValue).withOpacity(0.2),
        checkmarkColor: const Color(AppConstants.primaryColorValue),
        labelStyle: TextStyle(
          color: isSelected
              ? const Color(AppConstants.primaryColorValue)
              : const Color(AppConstants.textLightColorValue),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildMasonryGrid() {
    if (_filteredPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.explore_off_rounded,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No outfits found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        itemCount: _filteredPosts.length,
        itemBuilder: (context, index) {
          return _buildPostCard(_filteredPosts[index]);
        },
      ),
    );
  }

  Widget _buildPostCard(Post post) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
            child: CachedNetworkImage(
              imageUrl: post.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder: (context, url) => Container(
                color: Colors.grey.shade200,
                height: 200,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade200,
                height: 200,
                child: const Icon(Icons.error),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(AppConstants.primaryColorValue).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    post.occasion,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(AppConstants.primaryColorValue),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_likedPostIds.contains(post.id)) {
                        _likedPostIds.remove(post.id);
                      } else {
                        _likedPostIds.add(post.id);
                      }
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _likedPostIds.contains(post.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 18,
                        color: _likedPostIds.contains(post.id)
                            ? Colors.red
                            : Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.likes + (_likedPostIds.contains(post.id) ? 1 : 0)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: _likedPostIds.contains(post.id)
                              ? Colors.red.shade600
                              : Colors.grey.shade600,
                          fontWeight: _likedPostIds.contains(post.id)
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
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

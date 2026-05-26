import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../models/clothing.dart';
import '../../models/outfit.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/outfit_card.dart';
import '../../services/outfit_service.dart';
import '../../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Mock data for MVP
  final List<Clothing> _recentClothes = [
    Clothing(
      id: '1',
      imageUrl: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400',
      category: 'Upper Wear',
      color: 'Beige',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Clothing(
      id: '2',
      imageUrl: 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=400',
      category: 'Lower Wear',
      color: 'Blue',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Clothing(
      id: '3',
      imageUrl: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400',
      category: 'Footwear',
      color: 'Gray',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // Dynamic getter fetching today's outfit from the central service database
  Outfit get _todayOutfit {
    return OutfitService.instance.outfits.firstWhere((o) => o.id == '1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTodayAIFit(),
                    const SizedBox(height: 24),
                    _buildQuickCategories(),
                    const SizedBox(height: 24),
                    _buildRecentlyAdded(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Profile Picture
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200, width: 2),
            ),
            child: ClipOval(
              child: Image.network(
                'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Morning, Alex',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const Text(
                  'FitMuse',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(AppConstants.textColorValue),
                  ),
                ),
              ],
            ),
          ),
          // Icons
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTodayAIFit() {
    final todayFit = _todayOutfit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Today's AI Fit",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(AppConstants.textColorValue),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 280,
          child: OutfitCard(
            outfit: todayFit,
            clothingItems: _recentClothes,
            onSave: () {
              setState(() {
                OutfitService.instance.toggleSave(todayFit.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(!todayFit.isSaved ? 'Outfit saved!' : 'Outfit removed'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            onGenerateAgain: () => context.go('/outfit-generator'),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Categories',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(AppConstants.textColorValue),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildCategoryCard(
              icon: Icons.checkroom_rounded,
              label: 'Upper Wear',
              color: const Color(0xFF8B5CF6),
            ),
            const SizedBox(width: 12),
            _buildCategoryCard(
              icon: Icons.accessibility_rounded,
              label: 'Lower Wear',
              color: const Color(0xFFEC4899),
            ),
            const SizedBox(width: 12),
            _buildCategoryCard(
              icon: Icons.shopping_bag_rounded,
              label: 'Footwear',
              color: const Color(0xFF10B981),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentlyAdded() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recently Added',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(AppConstants.textColorValue),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _recentClothes.length,
            itemBuilder: (context, index) {
              final clothing = _recentClothes[index];
              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: 12),
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
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: clothing.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (context, url) => Container(
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            clothing.category,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${DateTime.now().difference(clothing.createdAt).inDays}d ago',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

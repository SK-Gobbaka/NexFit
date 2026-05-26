import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../services/outfit_service.dart';
import '../../models/outfit.dart';
import '../../models/clothing.dart';
import '../../utils/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Read live saved outfits and clothing mapping from singleton service
    final savedOutfits = OutfitService.instance.savedOutfits;
    final clothingMap = OutfitService.instance.outfitClothingMap;

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
                    _buildProfileCard(),
                    const SizedBox(height: 24),
                    _buildStatsSection(savedOutfits.length),
                    const SizedBox(height: 24),
                    _buildSavedOutfitsSection(savedOutfits, clothingMap),
                    const SizedBox(height: 24),
                    _buildSettingsSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 4),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Text(
            'Profile',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(AppConstants.textColorValue),
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(AppConstants.primaryColorValue),
            Color(AppConstants.secondaryColorValue),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(AppConstants.primaryColorValue).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
                fit: BoxFit.cover,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alex Johnson',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Fashion Enthusiast',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // Edit profile
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(int savedCount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('24', 'Clothes'),
          _buildVerticalDivider(),
          _buildStatItem('12', 'Outfits'),
          _buildVerticalDivider(),
          _buildStatItem('$savedCount', 'Saved'), // FIXED: Live saved outfits count
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(AppConstants.textColorValue),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(AppConstants.textLightColorValue),
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.shade200,
    );
  }

  Widget _buildSavedOutfitsSection(List<Outfit> savedOutfits, Map<String, List<Clothing>> clothingMap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Saved Outfits',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(AppConstants.textColorValue),
          ),
        ),
        const SizedBox(height: 12),
        if (savedOutfits.isEmpty)
          // FIXED: Elegant Empty State for favorites list
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bookmark_outline_rounded,
                  color: Colors.grey.shade400,
                  size: 44,
                ),
                const SizedBox(height: 12),
                Text(
                  'No saved outfits yet',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Swipe right or bookmark outfits to see your favorite fits here!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          )
        else
          // FIXED: Beautiful grid view showing live saved outfit clothing items
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: savedOutfits.length,
              itemBuilder: (context, index) {
                final outfit = savedOutfits[index];
                final clothes = clothingMap[outfit.id] ?? [];

                return Container(
                  width: 110,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Column(
                      children: [
                        // Miniature grid of the clothes in this outfit
                        Expanded(
                          child: clothes.isEmpty
                              ? Container(
                                  color: Colors.grey.shade100,
                                  child: const Center(
                                    child: Icon(Icons.checkroom, color: Colors.grey),
                                  ),
                                )
                              : GridView.builder(
                                  padding: const EdgeInsets.all(4),
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 4,
                                    mainAxisSpacing: 4,
                                    childAspectRatio: 1,
                                  ),
                                  itemCount: math.min(clothes.length, 4),
                                  itemBuilder: (context, cIndex) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: CachedNetworkImage(
                                        imageUrl: clothes[cIndex].imageUrl,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(color: Colors.grey.shade100),
                                        errorWidget: (context, url, error) => const Icon(Icons.error, size: 8),
                                      ),
                                    );
                                  },
                                ),
                        ),
                        // Match score badge
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          color: const Color(AppConstants.primaryColorValue).withOpacity(0.08),
                          child: Center(
                            child: Text(
                              '${outfit.matchPercentage}% Fit',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(AppConstants.primaryColorValue),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(AppConstants.textColorValue),
          ),
        ),
        const SizedBox(height: 12),
        _buildSettingTile(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          onTap: () {},
        ),
        _buildSettingTile(
          icon: Icons.lock_outline,
          title: 'Privacy',
          onTap: () {},
        ),
        _buildSettingTile(
          icon: Icons.help_outline,
          title: 'Help & Support',
          onTap: () {},
        ),
        _buildSettingTile(
          icon: Icons.info_outline,
          title: 'About',
          onTap: () {},
        ),
        _buildSettingTile(
          icon: Icons.logout,
          title: 'Logout',
          onTap: () {},
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDestructive
                    ? Colors.red.withOpacity(0.1)
                    : const Color(AppConstants.primaryColorValue).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isDestructive
                    ? Colors.red
                    : const Color(AppConstants.primaryColorValue),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: isDestructive
                      ? Colors.red
                      : const Color(AppConstants.textColorValue),
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../models/clothing.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/clothing_card.dart';
import '../../utils/constants.dart';

class ClosetScreen extends StatefulWidget {
  const ClosetScreen({super.key});

  @override
  State<ClosetScreen> createState() => _ClosetState();
}

class _ClosetState extends State<ClosetScreen> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  // Mock data for MVP
  final List<Clothing> _allClothes = [
    Clothing(
      id: '1',
      imageUrl: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400',
      category: 'Upper Wear',
      color: 'Beige',
      createdAt: DateTime.now(),
    ),
    Clothing(
      id: '2',
      imageUrl: 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=400',
      category: 'Lower Wear',
      color: 'Blue',
      createdAt: DateTime.now(),
    ),
    Clothing(
      id: '3',
      imageUrl: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400',
      category: 'Footwear',
      color: 'Gray',
      createdAt: DateTime.now(),
    ),
    Clothing(
      id: '4',
      imageUrl: 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=400',
      category: 'Upper Wear',
      color: 'Black',
      createdAt: DateTime.now(),
    ),
    Clothing(
      id: '5',
      imageUrl: 'https://images.unsplash.com/photo-1584370848010-d7fe6bc767ec?w=400',
      category: 'Lower Wear',
      color: 'White',
      createdAt: DateTime.now(),
    ),
    Clothing(
      id: '6',
      imageUrl: 'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=400',
      category: 'Footwear',
      color: 'Brown',
      createdAt: DateTime.now(),
    ),
  ];

  List<Clothing> get _filteredClothes {
    var clothes = _allClothes;
    if (_selectedCategory != 'All') {
      clothes = clothes.where((c) => c.category == _selectedCategory).toList();
    }
    if (_searchController.text.isNotEmpty) {
      clothes = clothes
          .where((c) =>
              c.category.toLowerCase().contains(_searchController.text.toLowerCase()) ||
              c.color.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    }
    return clothes;
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
            _buildCategoryChips(),
            Expanded(
              child: _buildClothingGrid(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Text(
            'My Closet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(AppConstants.textColorValue),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(AppConstants.primaryColorValue).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_allClothes.length} items',
              style: const TextStyle(
                color: Color(AppConstants.primaryColorValue),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
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
          hintText: 'Search clothes...',
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

  Widget _buildCategoryChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildCategoryChip('All'),
            ...AppConstants.clothingCategories.map((category) => _buildCategoryChip(category)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
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

  Widget _buildClothingGrid() {
    if (_filteredClothes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.checkroom_rounded,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No clothes found',
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
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: _filteredClothes.length,
        itemBuilder: (context, index) {
          return ClothingCard(
            clothing: _filteredClothes[index],
            onTap: () {
              // Show clothing details
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/clothing.dart';
import '../../models/outfit.dart';
import '../../widgets/outfit_card.dart';
import '../../utils/constants.dart';

class OutfitGeneratorScreen extends StatefulWidget {
  const OutfitGeneratorScreen({super.key});

  @override
  State<OutfitGeneratorScreen> createState() => _OutfitGeneratorScreenState();
}

class _OutfitGeneratorScreenState extends State<OutfitGeneratorScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _isGenerating = false;

  // Mock data for MVP
  final List<Outfit> _outfits = [
    Outfit(
      id: '1',
      clothingIds: ['1', '2', '3'],
      matchPercentage: 98,
      createdAt: DateTime.now(),
    ),
    Outfit(
      id: '2',
      clothingIds: ['4', '5', '6'],
      matchPercentage: 92,
      createdAt: DateTime.now(),
    ),
    Outfit(
      id: '3',
      clothingIds: ['1', '5', '3'],
      matchPercentage: 85,
      createdAt: DateTime.now(),
    ),
  ];

  final Map<String, List<Clothing>> _outfitClothingMap = {
    '1': [
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
    ],
    '2': [
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
    ],
    '3': [
      Clothing(
        id: '1',
        imageUrl: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400',
        category: 'Upper Wear',
        color: 'Beige',
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
        id: '3',
        imageUrl: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400',
        category: 'Footwear',
        color: 'Gray',
        createdAt: DateTime.now(),
      ),
    ],
  };

  void _generateNewOutfit() {
    setState(() {
      _isGenerating = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isGenerating = false;
        _currentIndex = (_currentIndex + 1) % _outfits.length;
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  void _saveOutfit(int index) {
    setState(() {
      _outfits[index] = _outfits[index].copyWith(isSaved: !_outfits[index].isSaved);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_outfits[index].isSaved ? 'Outfit saved!' : 'Outfit removed'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
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
            Expanded(
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemCount: _outfits.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: OutfitCard(
                          outfit: _outfits[index],
                          clothingItems: _outfitClothingMap[_outfits[index].id] ?? [],
                          onSave: () => _saveOutfit(index),
                          onGenerateAgain: _generateNewOutfit,
                        ),
                      );
                    },
                  ),
                  if (_isGenerating)
                    Container(
                      color: Colors.white.withOpacity(0.8),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text(
                              'Generating outfit...',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(AppConstants.textColorValue),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            _buildPageIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'AI Outfit Generator',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(AppConstants.textColorValue),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          _outfits.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 8,
            width: _currentIndex == index ? 24 : 8,
            decoration: BoxDecoration(
              color: _currentIndex == index
                  ? const Color(AppConstants.primaryColorValue)
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}

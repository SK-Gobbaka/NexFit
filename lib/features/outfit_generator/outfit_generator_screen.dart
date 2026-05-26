import 'package:flutter/material.dart';
import '../../models/clothing.dart';
import '../../models/outfit.dart';
import '../../widgets/outfit_card.dart';
import '../../widgets/swipeable_outfit_stack.dart';
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

  // Swipe Mode States
  bool _isSwipeMode = false;
  List<Outfit> _swipeOutfits = [];
  String _scanningStatus = 'Analyzing style profile...';

  // Mock data for individual clothes to build combinations dynamically
  late final Map<String, Clothing> _allClothing;

  // Mock data for MVP (PageView)
  late final List<Outfit> _outfits;
  late final Map<String, List<Clothing>> _outfitClothingMap;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();

    _allClothing = {
      '1': Clothing(
        id: '1',
        imageUrl: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400',
        category: 'Upper Wear',
        color: 'Beige',
        createdAt: now,
      ),
      '2': Clothing(
        id: '2',
        imageUrl: 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=400',
        category: 'Lower Wear',
        color: 'Blue',
        createdAt: now,
      ),
      '3': Clothing(
        id: '3',
        imageUrl: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400',
        category: 'Footwear',
        color: 'Gray',
        createdAt: now,
      ),
      '4': Clothing(
        id: '4',
        imageUrl: 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=400',
        category: 'Upper Wear',
        color: 'Black',
        createdAt: now,
      ),
      '5': Clothing(
        id: '5',
        imageUrl: 'https://images.unsplash.com/photo-1584370848010-d7fe6bc767ec?w=400',
        category: 'Lower Wear',
        color: 'White',
        createdAt: now,
      ),
      '6': Clothing(
        id: '6',
        imageUrl: 'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=400',
        category: 'Footwear',
        color: 'Brown',
        createdAt: now,
      ),
    };

    _outfits = [
      Outfit(
        id: '1',
        clothingIds: ['1', '2', '3'],
        matchPercentage: 98,
        createdAt: now,
      ),
      Outfit(
        id: '2',
        clothingIds: ['4', '5', '6'],
        matchPercentage: 92,
        createdAt: now,
      ),
      Outfit(
        id: '3',
        clothingIds: ['1', '5', '3'],
        matchPercentage: 85,
        createdAt: now,
      ),
    ];

    _outfitClothingMap = {
      '1': [_allClothing['1']!, _allClothing['2']!, _allClothing['3']!],
      '2': [_allClothing['4']!, _allClothing['5']!, _allClothing['6']!],
      '3': [_allClothing['1']!, _allClothing['5']!, _allClothing['3']!],
    };
  }

  // Generates 5 unique outfits for Swipe Mode
  void _generateSwipeOutfits() {
    final now = DateTime.now();
    _swipeOutfits = [
      Outfit(
        id: 's1',
        clothingIds: ['1', '5', '3'],
        matchPercentage: 96,
        createdAt: now,
      ),
      Outfit(
        id: 's2',
        clothingIds: ['4', '2', '6'],
        matchPercentage: 94,
        createdAt: now,
      ),
      Outfit(
        id: 's3',
        clothingIds: ['1', '2', '6'],
        matchPercentage: 89,
        createdAt: now,
      ),
      Outfit(
        id: 's4',
        clothingIds: ['4', '5', '3'],
        matchPercentage: 87,
        createdAt: now,
      ),
      Outfit(
        id: 's5',
        clothingIds: ['1', '5', '6'],
        matchPercentage: 82,
        createdAt: now,
      ),
    ];

    // Map each swipe outfit to clothing items
    _outfitClothingMap['s1'] = [_allClothing['1']!, _allClothing['5']!, _allClothing['3']!];
    _outfitClothingMap['s2'] = [_allClothing['4']!, _allClothing['2']!, _allClothing['6']!];
    _outfitClothingMap['s3'] = [_allClothing['1']!, _allClothing['2']!, _allClothing['6']!];
    _outfitClothingMap['s4'] = [_allClothing['4']!, _allClothing['5']!, _allClothing['3']!];
    _outfitClothingMap['s5'] = [_allClothing['1']!, _allClothing['5']!, _allClothing['6']!];
  }

  // Triggers the radar AI animation and sets up the Swipeable Stack
  void _triggerOutfitSwipeGeneration() {
    setState(() {
      _isGenerating = true;
      _scanningStatus = 'Analyzing style profile...';
    });

    // Cycle scanning status text to simulate authentic AI processing
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _scanningStatus = 'Matching color palettes...');
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _scanningStatus = 'Optimizing outfit match index...');
    });
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _scanningStatus = 'Finalizing your curated deck...');
    });

    Future.delayed(const Duration(milliseconds: 2400), () {
      if (mounted) {
        _generateSwipeOutfits();
        setState(() {
          _isGenerating = false;
          _isSwipeMode = true;
        });
      }
    });
  }

  // Legacy page-view generator (not used but kept for references/fallbacks)
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

  // Handles outfit saving from both standard list and Swipe Mode
  void _handleSwipeSave(Outfit outfit, bool isSaved) {
    setState(() {
      // Keep isSaved flag in sync in standard outfits list
      for (int i = 0; i < _outfits.length; i++) {
        if (_outfits[i].id == outfit.id) {
          _outfits[i] = _outfits[i].copyWith(isSaved: isSaved);
        }
      }

      // Keep in sync in swipe outfits list
      for (int i = 0; i < _swipeOutfits.length; i++) {
        if (_swipeOutfits[i].id == outfit.id) {
          _swipeOutfits[i] = _swipeOutfits[i].copyWith(isSaved: isSaved);
        }
      }
    });

    if (isSaved) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.bookmark_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Text('Outfit saved to favorites! (${outfit.matchPercentage}% match)'),
            ],
          ),
          backgroundColor: const Color(0xFF10B981), // Mint Green
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
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
                  if (_isSwipeMode)
                    SwipeableOutfitStack(
                      outfits: _swipeOutfits,
                      outfitClothingMap: _outfitClothingMap,
                      onSwipe: _handleSwipeSave,
                      onRegenerate: _triggerOutfitSwipeGeneration,
                      onBackToPageView: () {
                        setState(() {
                          _isSwipeMode = false;
                        });
                      },
                    )
                  else
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
                            onGenerateAgain: _triggerOutfitSwipeGeneration, // Trigger Swipe Mode!
                          ),
                        );
                      },
                    ),
                  if (_isGenerating)
                    RadarScanningLoader(statusText: _scanningStatus),
                ],
              ),
            ),
            if (!_isSwipeMode) _buildPageIndicator(),
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
            onPressed: () {
              if (_isSwipeMode) {
                setState(() {
                  _isSwipeMode = false;
                });
              } else {
                Navigator.pop(context);
              }
            },
          ),
          Expanded(
            child: Text(
              _isSwipeMode ? 'Swipe Outfits' : 'AI Outfit Generator',
              style: const TextStyle(
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

// Stateful AI loader mimicking radar scans and wardobe curation
class RadarScanningLoader extends StatefulWidget {
  final String statusText;
  const RadarScanningLoader({super.key, required this.statusText});

  @override
  State<RadarScanningLoader> createState() => _RadarScanningLoaderState();
}

class _RadarScanningLoaderState extends State<RadarScanningLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Radar concentric expanding pulses
            SizedBox(
              width: 220,
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                children: List.generate(3, (index) {
                  return AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final progress = (_controller.value + (index / 3)) % 1.0;
                      return Container(
                        width: 220 * progress,
                        height: 220 * progress,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(AppConstants.primaryColorValue)
                                .withOpacity((1.0 - progress) * 0.35),
                            width: 3.5,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
            const SizedBox(height: 40),
            // Glowing sparkles icon
            const Icon(
              Icons.auto_awesome_rounded,
              color: Color(AppConstants.primaryColorValue),
              size: 38,
            ),
            const SizedBox(height: 16),
            // Status text
            Text(
              widget.statusText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(AppConstants.textColorValue),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'NexFit AI is orchestrating new combinations...',
              style: TextStyle(
                fontSize: 12,
                color: Color(AppConstants.textLightColorValue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

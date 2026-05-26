import '../models/outfit.dart';
import '../models/clothing.dart';

class OutfitService {
  static final OutfitService instance = OutfitService._internal();
  OutfitService._internal();

  final List<Outfit> _allOutfits = [];
  final Map<String, List<Clothing>> _outfitClothingMap = {};

  // Flag to track mock initialization
  bool _isInitialized = false;

  void initializeMockData() {
    if (_isInitialized) return;
    
    final now = DateTime.now();

    // Setup clothing
    final beigeUpper = Clothing(
      id: '1',
      imageUrl: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400',
      category: 'Upper Wear',
      color: 'Beige',
      createdAt: now,
    );
    final blueLower = Clothing(
      id: '2',
      imageUrl: 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=400',
      category: 'Lower Wear',
      color: 'Blue',
      createdAt: now,
    );
    final grayShoes = Clothing(
      id: '3',
      imageUrl: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400',
      category: 'Footwear',
      color: 'Gray',
      createdAt: now,
    );
    final blackUpper = Clothing(
      id: '4',
      imageUrl: 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=400',
      category: 'Upper Wear',
      color: 'Black',
      createdAt: now,
    );
    final whiteLower = Clothing(
      id: '5',
      imageUrl: 'https://images.unsplash.com/photo-1584370848010-d7fe6bc767ec?w=400',
      category: 'Lower Wear',
      color: 'White',
      createdAt: now,
    );
    final brownShoes = Clothing(
      id: '6',
      imageUrl: 'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=400',
      category: 'Footwear',
      color: 'Brown',
      createdAt: now,
    );

    // Default daily outfits
    _allOutfits.addAll([
      Outfit(
        id: '1',
        clothingIds: ['1', '2', '3'],
        matchPercentage: 98,
        createdAt: now,
        isSaved: false,
      ),
      Outfit(
        id: '2',
        clothingIds: ['4', '5', '6'],
        matchPercentage: 92,
        createdAt: now,
        isSaved: false,
      ),
      Outfit(
        id: '3',
        clothingIds: ['1', '5', '3'],
        matchPercentage: 85,
        createdAt: now,
        isSaved: false,
      ),
    ]);

    _outfitClothingMap['1'] = [beigeUpper, blueLower, grayShoes];
    _outfitClothingMap['2'] = [blackUpper, whiteLower, brownShoes];
    _outfitClothingMap['3'] = [beigeUpper, whiteLower, grayShoes];

    _isInitialized = true;
  }

  List<Outfit> get outfits {
    initializeMockData();
    return _allOutfits;
  }

  Map<String, List<Clothing>> get outfitClothingMap {
    initializeMockData();
    return _outfitClothingMap;
  }

  List<Outfit> get savedOutfits {
    initializeMockData();
    return _allOutfits.where((o) => o.isSaved).toList();
  }

  void saveOutfit(Outfit outfit, bool isSaved, List<Clothing> clothes) {
    initializeMockData();
    
    // Cache clothing mapping
    _outfitClothingMap[outfit.id] = clothes;

    final index = _allOutfits.indexWhere((o) => o.id == outfit.id);
    if (index != -1) {
      _allOutfits[index] = _allOutfits[index].copyWith(isSaved: isSaved);
    } else {
      _allOutfits.add(outfit.copyWith(isSaved: isSaved));
    }
  }

  void toggleSave(String outfitId) {
    initializeMockData();
    final index = _allOutfits.indexWhere((o) => o.id == outfitId);
    if (index != -1) {
      _allOutfits[index] = _allOutfits[index].copyWith(isSaved: !_allOutfits[index].isSaved);
    }
  }
}

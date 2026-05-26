import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/outfit.dart';
import '../models/clothing.dart';
import './outfit_card.dart';
import '../utils/constants.dart';

class SwipeableOutfitStack extends StatefulWidget {
  final List<Outfit> outfits;
  final Map<String, List<Clothing>> outfitClothingMap;
  final Function(Outfit outfit, bool isSaved) onSwipe;
  final VoidCallback onRegenerate;
  final VoidCallback? onBackToPageView;

  const SwipeableOutfitStack({
    super.key,
    required this.outfits,
    required this.outfitClothingMap,
    required this.onSwipe,
    required this.onRegenerate,
    this.onBackToPageView,
  });

  @override
  State<SwipeableOutfitStack> createState() => _SwipeableOutfitStackState();
}

class _SwipeableOutfitStackState extends State<SwipeableOutfitStack>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  // Gesture State
  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;

  // Stack State
  List<Outfit> _remainingOutfits = [];
  final List<Outfit> _history = [];
  final List<bool> _historyDirections = []; // true = saved, false = skipped

  @override
  void initState() {
    super.initState();
    _remainingOutfits = List.from(widget.outfits);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.addListener(() {
      if (!_isDragging) {
        setState(() {
          _dragOffset = _slideAnimation.value;
        });
      }
    });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_isDragging) {
        // If animated to off-screen, pop the top card and handle the swipe
        final dx = _slideAnimation.value.dx;
        if (dx.abs() > 250) {
          final poppedOutfit = _remainingOutfits.removeAt(0);
          final isSaved = dx > 0;

          // Record history for Undo/Rewind
          _history.add(poppedOutfit);
          _historyDirections.add(isSaved);

          widget.onSwipe(poppedOutfit, isSaved);

          setState(() {
            _dragOffset = Offset.zero;
          });
          _animationController.reset();
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Swipe programmatically via bottom control buttons
  void _swipeProgrammatically(bool isSaved) {
    if (_remainingOutfits.isEmpty || _animationController.isAnimating) return;

    final targetDx = isSaved ? 500.0 : -500.0;
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(targetDx, 100),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward(from: 0.0);
  }

  // Rewind programmatically
  void _rewind() {
    if (_history.isEmpty || _animationController.isAnimating) return;

    final lastOutfit = _history.removeLast();
    final wasSaved = _historyDirections.removeLast();

    // Signal parent that we are undoing save if it was saved
    if (wasSaved) {
      widget.onSwipe(lastOutfit, false); // Toggle back to unsaved
    }

    setState(() {
      _remainingOutfits.insert(0, lastOutfit);
      // Position the card off-screen so it slides back in
      _dragOffset = Offset(wasSaved ? 500.0 : -500.0, 50.0);
    });

    _slideAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward(from: 0.0);
  }

  void _onPanStart(DragStartDetails details) {
    if (_remainingOutfits.isEmpty || _animationController.isAnimating) return;
    setState(() {
      _isDragging = true;
    });
    _animationController.stop();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_remainingOutfits.isEmpty || _animationController.isAnimating) return;
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_remainingOutfits.isEmpty || _animationController.isAnimating) return;

    setState(() {
      _isDragging = false;
    });

    final threshold = MediaQuery.of(context).size.width * 0.3;
    final velocityDx = details.velocity.pixelsPerSecond.dx;

    if (_dragOffset.dx.abs() > threshold || velocityDx.abs() > 800) {
      // Execute Swipe Fly-Away Animation
      final isSaved = _dragOffset.dx > 0 || (velocityDx > 300 && _dragOffset.dx > -50);
      final targetDx = isSaved ? 500.0 : -500.0;
      final targetDy = _dragOffset.dy + (velocityDx.abs() > 800 ? details.velocity.pixelsPerSecond.dy / 10 : 0);

      _slideAnimation = Tween<Offset>(
        begin: _dragOffset,
        end: Offset(targetDx, targetDy),
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ));

      _animationController.forward(from: 0.0);
    } else {
      // Execute Spring-Back Animation
      _slideAnimation = Tween<Offset>(
        begin: _dragOffset,
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ));

      _animationController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        // Stack area
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _remainingOutfits.isEmpty
                ? _buildEmptyState()
                : Stack(
                    clipBehavior: Clip.none,
                    children: _buildCards(size),
                  ),
          ),
        ),

        // Controls at the bottom
        _buildBottomControls(),
      ],
    );
  }

  List<Widget> _buildCards(Size screenSize) {
    final List<Widget> cardList = [];

    // Render up to 3 cards in the stack for performance and neatness
    final maxCardsToShow = math.min(3, _remainingOutfits.length);

    for (int i = maxCardsToShow - 1; i >= 0; i--) {
      final outfit = _remainingOutfits[i];
      final clothes = widget.outfitClothingMap[outfit.id] ?? [];
      final isTopCard = i == 0;

      Widget cardWidget = OutfitCard(
        outfit: outfit,
        clothingItems: clothes,
        showActions: false, // Hide actions since swiping is the action!
      );

      if (isTopCard) {
        // Drag calculations for Top Card
        final rotationAngle = (_dragOffset.dx / screenSize.width) * 0.15;
        final saveStampOpacity = (_dragOffset.dx / 100).clamp(0.0, 1.0);
        final skipStampOpacity = (-_dragOffset.dx / 100).clamp(0.0, 1.0);

        cardWidget = GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: Transform.translate(
            offset: _dragOffset,
            child: Transform.rotate(
              angle: rotationAngle,
              child: Stack(
                children: [
                  cardWidget,
                  
                  // Visual Stamp Overlay - SAVE
                  Positioned(
                    top: 40,
                    left: 20,
                    child: Opacity(
                      opacity: saveStampOpacity,
                      child: Transform.rotate(
                        angle: -0.2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green.shade600, width: 4),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white.withOpacity(0.95),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.bookmark_rounded, color: Colors.green.shade600, size: 24),
                              const SizedBox(width: 4),
                              Text(
                                'SAVE FIT',
                                style: TextStyle(
                                  color: Colors.green.shade600,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Visual Stamp Overlay - SKIP
                  Positioned(
                    top: 40,
                    right: 20,
                    child: Opacity(
                      opacity: skipStampOpacity,
                      child: Transform.rotate(
                        angle: 0.2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red.shade600, width: 4),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white.withOpacity(0.95),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.close_rounded, color: Colors.red.shade600, size: 24),
                              const SizedBox(width: 4),
                              Text(
                                'SKIP FIT',
                                style: TextStyle(
                                  color: Colors.red.shade600,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        // Background card scale & slide animation based on top card drag
        final progress = (_dragOffset.dx.abs() / (screenSize.width * 0.3)).clamp(0.0, 1.0);
        
        // As top card is swiped, second card scales up and moves up
        final double scale = 0.94 + (progress * 0.06);
        final double dyOffset = 18 - (progress * 18);

        cardWidget = Transform.translate(
          offset: Offset(0, dyOffset),
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.bottomCenter,
            child: Opacity(
              opacity: 0.7 + (progress * 0.3), // Fades in as top card moves
              child: IgnorePointer(
                child: cardWidget,
              ),
            ),
          ),
        );
      }

      cardList.add(cardWidget);
    }

    return cardList;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Elegant hanging room icon
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(AppConstants.primaryColorValue).withOpacity(0.06),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.checkroom_rounded,
              size: 72,
              color: Color(AppConstants.primaryColorValue),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Outfits Cleared!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(AppConstants.textColorValue),
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'You have reviewed all the curated styles in this batch.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(AppConstants.textLightColorValue),
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Actions on empty
          ElevatedButton.icon(
            onPressed: widget.onRegenerate,
            icon: const Icon(Icons.auto_awesome_rounded),
            label: const Text('Generate New Batch'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              backgroundColor: const Color(AppConstants.primaryColorValue),
              foregroundColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          if (widget.onBackToPageView != null) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: widget.onBackToPageView,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Daily View'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(AppConstants.textLightColorValue),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    final canUndo = _history.isNotEmpty;
    final hasCards = _remainingOutfits.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24, top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 1. Rewind Button
          _buildActionButton(
            onPressed: canUndo ? _rewind : null,
            icon: Icons.replay_rounded,
            color: const Color(0xFFFFB300), // Rich Golden Yellow
            iconSize: 22,
            buttonSize: 48,
            enabled: canUndo,
            tooltip: 'Rewind Swipe',
          ),
          const SizedBox(width: 20),

          // 2. Dislike/Nope Button
          _buildActionButton(
            onPressed: hasCards ? () => _swipeProgrammatically(false) : null,
            icon: Icons.close_rounded,
            color: const Color(0xFFEF4444), // Crimson Red
            iconSize: 28,
            buttonSize: 58,
            enabled: hasCards,
            tooltip: 'Skip Fit',
          ),
          const SizedBox(width: 20),

          // 3. Like/Save Button
          _buildActionButton(
            onPressed: hasCards ? () => _swipeProgrammatically(true) : null,
            icon: Icons.bookmark_rounded,
            color: const Color(0xFF10B981), // Vibrant Mint Green
            iconSize: 28,
            buttonSize: 58,
            enabled: hasCards,
            tooltip: 'Save Fit',
          ),
          const SizedBox(width: 20),

          // 4. Regenerate Button
          _buildActionButton(
            onPressed: widget.onRegenerate,
            icon: Icons.auto_awesome_rounded,
            color: const Color(AppConstants.primaryColorValue), // Purple
            iconSize: 22,
            buttonSize: 48,
            enabled: true,
            tooltip: 'Fresh Generator',
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required Color color,
    required double iconSize,
    required double buttonSize,
    required bool enabled,
    required String tooltip,
  }) {
    final isSecondary = buttonSize < 55;

    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: enabled 
              ? color.withOpacity(isSecondary ? 0.15 : 0.25)
              : Colors.black.withOpacity(0.04),
            blurRadius: isSecondary ? 10 : 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          splashColor: color.withOpacity(0.1),
          highlightColor: color.withOpacity(0.05),
          child: Center(
            child: Icon(
              icon,
              color: enabled ? color : Colors.grey.shade300,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}

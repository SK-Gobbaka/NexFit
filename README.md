# NexFit - AI-Powered Fashion Wardrobe App

An AI-powered digital wardrobe and outfit recommendation mobile application built with Flutter.

## Features

- **Clothing Upload**: Capture or upload clothing images from gallery
- **Background Removal**: Automatic background removal using remove.bg API
- **Digital Closet**: Organize clothes into categories (Upper Wear, Lower Wear, Footwear, Accessories)
- **AI Outfit Generation**: Generate outfit combinations with match percentages
- **Color Detection**: Detect dominant clothing colors
- **Community Inspiration**: Browse outfit inspirations from the community
- **Profile Management**: View wardrobe statistics and saved outfits

## Tech Stack

### Frontend
- **Flutter**: Cross-platform mobile development
- **Riverpod**: State management
- **GoRouter**: Navigation
- **CachedNetworkImage**: Image caching
- **Flutter Staggered Grid View**: Masonry layouts
- **Flutter Animate**: Smooth animations
- **Lottie**: Animated graphics

### Backend
- **Firebase**: Authentication, Firestore, Storage

### APIs
- **remove.bg**: Background removal API

### Image Processing
- **palette_generator**: Color detection
- **image**: Image manipulation

## Project Structure

```
lib/
 ├── core/              # Core functionality (router)
 ├── features/          # Feature-based screens
 │   ├── splash/        # Splash screen
 │   ├── onboarding/    # Onboarding screens
 │   ├── home/          # Home screen
 │   ├── closet/        # Closet/digital wardrobe
 │   ├── upload/        # Clothing upload
 │   ├── outfit_generator/  # AI outfit generation
 │   ├── explore/       # Community inspiration
 │   └── profile/       # User profile
 ├── models/            # Data models
 ├── services/          # Business logic & API services
 ├── widgets/           # Reusable UI components
 ├── utils/             # Utilities (constants, theme)
 └── main.dart          # App entry point
```

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code
- Firebase account (for backend integration)

### Installation

1. Clone the repository
2. Navigate to the project directory
3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Configure Firebase:
   - Create a Firebase project
   - Add Android app to Firebase
   - Download `google-services.json` and place it in `android/app/`
   - Enable Firebase Authentication, Firestore, and Storage

5. Configure remove.bg API:
   - Sign up at [remove.bg](https://www.remove.bg/)
   - Get your API key
   - Update the API key in `lib/utils/constants.dart`

6. Run the app:
   ```bash
   flutter run
   ```

## Screens

### 1. Splash Screen
- App logo with loading animation
- Auto-navigation to onboarding

### 2. Onboarding Screens
- Upload your wardrobe
- Generate AI outfits
- Explore community styles

### 3. Home Screen
- Greeting section
- Today's AI Fit with match percentage
- Quick categories
- Recently added items

### 4. Closet Screen
- Clothing categories filter
- Search functionality
- Grid layout of clothing items

### 5. Upload Screen
- Camera capture
- Gallery upload
- Category selection
- Color selection
- Background removal preview

### 6. Outfit Generator Screen
- Swipeable outfit cards
- Match percentage display
- Generate again functionality
- Save outfit option

### 7. Explore Screen
- Community feed
- Occasion filters
- Pinterest-style masonry layout
- Search functionality

### 8. Profile Screen
- User profile card
- Wardrobe statistics
- Saved outfits
- Settings menu

## MVP Scope

### Included Features
✅ Clothing upload
✅ Background removal
✅ Closet organization
✅ Color detection
✅ Outfit generation
✅ Community inspiration feed
✅ Profile screen

### Excluded Features (Future Enhancements)
❌ Authentication (planned for v2)
❌ Messaging
❌ Reels/videos
❌ Advanced AI models
❌ Virtual try-on
❌ E-commerce integration
❌ Social following system

## Design Guidelines

- **Color Palette**: Purple accent (#8B5CF6), white background, light gray surfaces
- **Typography**: Clean, minimal fonts
- **UI Style**: Modern, fashion-focused, premium aesthetic
- **Components**: Large visual cards, rounded corners, spacious layouts

## Contributing

This project is currently in MVP development. Contributions will be welcomed in future versions.

## License

Proprietary - All rights reserved

## Contact

For inquiries about this project, please contact the development team.

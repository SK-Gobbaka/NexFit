package com.example.nexfit.navigation

sealed class Screen(val route: String) {
    object Home : Screen("home")
    object Closet : Screen("closet")
    object Upload : Screen("upload")
    object Explore : Screen("explore")
    object Profile : Screen("profile")
    object Favorites : Screen("favorites")
    object Notifications : Screen("notifications")
    object Scanning : Screen("scanning")
}

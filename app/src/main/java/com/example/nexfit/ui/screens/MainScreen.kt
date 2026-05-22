package com.example.nexfit.ui.screens

import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material.icons.rounded.AutoAwesome
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.navigation.NavDestination.Companion.hierarchy
import androidx.navigation.NavGraph.Companion.findStartDestination
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import com.example.nexfit.navigation.Screen
import androidx.lifecycle.viewmodel.compose.viewModel
import com.example.nexfit.ui.viewmodel.HomeViewModel

@Composable
fun MainScreen(viewModel: HomeViewModel = viewModel()) {
    val navController = rememberNavController()
    val navBackStackEntry by navController.currentBackStackEntryAsState()
    val currentDestination = navBackStackEntry?.destination

    val items = listOf(
        Screen.Home,
        Screen.Closet,
        Screen.Upload,
        Screen.Explore,
        Screen.Profile
    )

    Scaffold(
        bottomBar = {
            NavigationBar(
                containerColor = Color.White,
                tonalElevation = 8.dp
            ) {
                items.forEach { screen ->
                    val selected = currentDestination?.hierarchy?.any { it.route == screen.route } == true
                    
                    if (screen == Screen.Upload) {
                        // Special FAB-like button for Upload
                        NavigationBarItem(
                            selected = false,
                            onClick = {
                                navController.navigate(screen.route) {
                                    popUpTo(navController.graph.findStartDestination().id) {
                                        saveState = true
                                    }
                                    launchSingleTop = true
                                    restoreState = true
                                }
                            },
                            icon = {
                                Surface(
                                    shape = CircleShape,
                                    color = MaterialTheme.colorScheme.primary,
                                    modifier = Modifier.padding(bottom = 8.dp)
                                ) {
                                    Icon(
                                        Icons.Rounded.AutoAwesome,
                                        contentDescription = null,
                                        modifier = Modifier.padding(12.dp),
                                        tint = Color.White
                                    )
                                }
                            },
                            label = null
                        )
                    } else {
                        NavigationBarItem(
                            icon = {
                                Icon(
                                    imageVector = when (screen) {
                                        Screen.Home -> Icons.Default.Home
                                        Screen.Closet -> Icons.Default.Checkroom
                                        Screen.Explore -> Icons.Default.Explore
                                        Screen.Profile -> Icons.Default.Person
                                        else -> Icons.Default.Home
                                    },
                                    contentDescription = null
                                )
                            },
                            selected = selected,
                            onClick = {
                                navController.navigate(screen.route) {
                                    popUpTo(navController.graph.findStartDestination().id) {
                                        saveState = true
                                    }
                                    launchSingleTop = true
                                    restoreState = true
                                }
                            }
                        )
                    }
                }
            }
        }
    ) { innerPadding ->
        NavHost(
            navController = navController,
            startDestination = Screen.Home.route,
            modifier = Modifier.padding(innerPadding)
        ) {
            composable(Screen.Home.route) { 
                HomeScreen(
                    viewModel = viewModel,
                    onNavigateToFavorites = { navController.navigate(Screen.Favorites.route) },
                    onNavigateToNotifications = { navController.navigate(Screen.Notifications.route) }
                ) 
            }
            composable(Screen.Closet.route) { 
                ClosetScreen() 
            }
            composable(Screen.Upload.route) { 
                UploadScreen(onUploadStart = { uri ->
                    viewModel.addMockItem(uri.toString())
                    navController.navigate(Screen.Scanning.route) 
                })
            }
            composable(Screen.Explore.route) { 
                ExploreScreen() 
            }
            composable(Screen.Profile.route) { 
                ProfileScreen() 
            }
            composable(Screen.Favorites.route) { 
                FavoritesScreen() 
            }
            composable(Screen.Notifications.route) { 
                NotificationsScreen() 
            }
            composable(Screen.Scanning.route) { 
                ScanningScreen(onScanComplete = { 
                    navController.popBackStack(Screen.Home.route, false)
                })
            }
        }
    }
}

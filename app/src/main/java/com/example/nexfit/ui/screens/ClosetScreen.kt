package com.example.nexfit.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.KeyboardArrowDown
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import coil.compose.AsyncImage
import com.example.nexfit.data.model.ClothingCategory
import com.example.nexfit.data.model.ClothingItem
import com.example.nexfit.ui.components.HomeHeader

@Composable
fun ClosetScreen(
    onNavigateToFavorites: () -> Unit = {},
    onNavigateToNotifications: () -> Unit = {}
) {
    val categories = listOf(
        ClothingCategory.UPPER_WEAR to "Upper ware",
        ClothingCategory.LOWER_WEAR to "Bottom ware",
        ClothingCategory.FOOTWEAR to "Foot ware",
        ClothingCategory.ACCESSORIES to "Accessories"
    )

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFFFBFBFE)),
        contentPadding = PaddingValues(bottom = 16.dp)
    ) {
        item {
            HomeHeader(
                onFavoritesClick = onNavigateToFavorites,
                onNotificationsClick = onNavigateToNotifications
            )
        }

        categories.forEach { (category, title) ->
            item {
                CategorySection(title = title, items = getMockItems(category))
            }
        }
    }
}

@Composable
fun CategorySection(title: String, items: List<ClothingItem>) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp)
            .background(Color.White, RoundedCornerShape(24.dp))
            .padding(16.dp)
    ) {
        Text(
            text = title,
            fontSize = 18.sp,
            fontWeight = FontWeight.Bold,
            modifier = Modifier.padding(bottom = 16.dp)
        )
        
        // Using a simple Row/Column grid because it's inside a LazyColumn
        Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
            val rows = items.chunked(3)
            rows.take(2).forEach { rowItems ->
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    rowItems.forEach { item ->
                        AsyncImage(
                            model = item.imageUrl,
                            contentDescription = null,
                            modifier = Modifier
                                .weight(1f)
                                .aspectRatio(1f)
                                .clip(RoundedCornerShape(16.dp))
                                .background(Color(0xFFF3F4F6)),
                            contentScale = ContentScale.Fit
                        )
                    }
                    // Fill empty spots if less than 3
                    repeat(3 - rowItems.size) {
                        Spacer(modifier = Modifier.weight(1f))
                    }
                }
            }
        }
        
        IconButton(
            onClick = { /* TODO */ },
            modifier = Modifier.align(Alignment.CenterHorizontally)
        ) {
            Icon(Icons.Default.KeyboardArrowDown, contentDescription = null, tint = Color.Gray)
        }
    }
}

fun getMockItems(category: ClothingCategory): List<ClothingItem> {
    val urls = when(category) {
        ClothingCategory.UPPER_WEAR -> listOf(
            "https://images.unsplash.com/photo-1591047139829-d91aecb6caea?q=80&w=200",
            "https://images.unsplash.com/photo-1576566582402-38a8e3579133?q=80&w=200",
            "https://images.unsplash.com/photo-1618354691373-d851c5c3a990?q=80&w=200"
        )
        ClothingCategory.LOWER_WEAR -> listOf(
            "https://images.unsplash.com/photo-1542272604-787c3835535d?q=80&w=200",
            "https://images.unsplash.com/photo-1541099649105-f69ad21f3246?q=80&w=200"
        )
        ClothingCategory.FOOTWEAR -> listOf(
            "https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=200",
            "https://images.unsplash.com/photo-1560769629-975ec94e6a86?q=80&w=200"
        )
        else -> listOf("https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=200")
    }
    
    return List(6) {
        ClothingItem(
            name = "Item $it",
            category = category,
            imageUrl = urls[it % urls.size]
        )
    }
}

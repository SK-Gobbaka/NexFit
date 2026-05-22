package com.example.nexfit.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid
import androidx.compose.foundation.lazy.staggeredgrid.StaggeredGridCells
import androidx.compose.foundation.lazy.staggeredgrid.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.unit.dp
import coil.compose.AsyncImage
import com.example.nexfit.ui.components.HomeHeader

@Composable
fun ExploreScreen() {
    val items = listOf(
        "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=400",
        "https://images.unsplash.com/photo-1434389677669-e08b4cac3105?q=80&w=400",
        "https://images.unsplash.com/photo-1483985988355-763728e1935b?q=80&w=400",
        "https://images.unsplash.com/photo-1490481651871-ab68de25d43d?q=80&w=400",
        "https://images.unsplash.com/photo-1445205170230-053b83016050?q=80&w=400",
        "https://images.unsplash.com/photo-1539109136881-3be0616acf4b?q=80&w=400"
    )

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFFFBFBFE))
    ) {
        HomeHeader()
        
        LazyVerticalStaggeredGrid(
            columns = StaggeredGridCells.Fixed(2),
            modifier = Modifier.fillMaxSize(),
            contentPadding = PaddingValues(16.dp),
            horizontalArrangement = Arrangement.spacedBy(16.dp),
            verticalItemSpacing = 16.dp
        ) {
            items(items) { imageUrl ->
                ExploreItem(imageUrl)
            }
        }
    }
}

@Composable
fun ExploreItem(imageUrl: String) {
    Card(
        shape = RoundedCornerShape(24.dp),
        colors = CardDefaults.cardColors(containerColor = Color.White),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
    ) {
        AsyncImage(
            model = imageUrl,
            contentDescription = null,
            modifier = Modifier
                .fillMaxWidth()
                .wrapContentHeight()
                .clip(RoundedCornerShape(24.dp))
                .background(Color(0xFFF3F4F6)),
            contentScale = ContentScale.FillWidth
        )
    }
}

package com.example.nexfit.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Notifications
import androidx.compose.material.icons.outlined.FavoriteBorder
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
import androidx.lifecycle.viewmodel.compose.viewModel
import coil.compose.AsyncImage
import com.example.nexfit.data.model.ClothingItem
import com.example.nexfit.data.model.Outfit
import com.example.nexfit.ui.components.HomeHeader
import com.example.nexfit.ui.theme.PurpleBrand
import com.example.nexfit.ui.theme.PurpleLight
import com.example.nexfit.ui.viewmodel.HomeViewModel

@Composable
fun HomeScreen(
    viewModel: HomeViewModel = viewModel(),
    onNavigateToFavorites: () -> Unit = {},
    onNavigateToNotifications: () -> Unit = {}
) {
    val todayFit by viewModel.todayFit.collectAsState()
    val recentlyAdded by viewModel.recentlyAdded.collectAsState()

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFFFBFBFE))
    ) {
        item { 
            HomeHeader(
                onFavoritesClick = onNavigateToFavorites,
                onNotificationsClick = onNavigateToNotifications
            ) 
        }
        
        item {
            SectionHeader(title = "Today's AI Fit", trailing = {
                todayFit?.let {
                    MatchPercentageChip(it.matchPercentage)
                }
            })
        }
        
        item {
            todayFit?.let {
                TodayFitCard(it, onGenerateAgain = { viewModel.generateOutfit() })
            }
        }
        
        item {
            SectionHeader(title = "Quick Categories")
        }
        
        item {
            QuickCategoriesRow()
        }
        
        item {
            SectionHeader(title = "Recently Added", trailing = {
                Text(
                    text = "View All",
                    color = PurpleBrand,
                    fontSize = 12.sp,
                    fontWeight = FontWeight.Medium
                )
            })
        }
        
        item {
            RecentlyAddedRow(recentlyAdded)
        }
        
        item { Spacer(modifier = Modifier.height(24.dp)) }
    }
}

@Composable
fun SectionHeader(title: String, trailing: @Composable () -> Unit = {}) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp, vertical = 8.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        Text(text = title, fontSize = 18.sp, fontWeight = FontWeight.Bold)
        trailing()
    }
}

@Composable
fun MatchPercentageChip(percentage: Int) {
    Surface(
        color = PurpleLight,
        shape = RoundedCornerShape(16.dp)
    ) {
        Text(
            text = "$percentage% Match",
            modifier = Modifier.padding(horizontal = 12.dp, vertical = 4.dp),
            color = PurpleBrand,
            fontSize = 12.sp,
            fontWeight = FontWeight.Bold
        )
    }
}

@Composable
fun TodayFitCard(outfit: Outfit, onGenerateAgain: () -> Unit = {}) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp),
        shape = RoundedCornerShape(24.dp),
        colors = CardDefaults.cardColors(containerColor = Color.White),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceEvenly
            ) {
                outfit.items.forEach { item ->
                    AsyncImage(
                        model = item.imageUrl,
                        contentDescription = null,
                        modifier = Modifier
                            .size(100.dp)
                            .clip(RoundedCornerShape(16.dp))
                            .background(Color(0xFFF3F4F6)),
                        contentScale = ContentScale.Fit
                    )
                }
            }
            Spacer(modifier = Modifier.height(24.dp))
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                OutlinedButton(
                    onClick = onGenerateAgain,
                    modifier = Modifier.weight(1f),
                    shape = RoundedCornerShape(12.dp)
                ) {
                    Text("Generate Again")
                }
                Button(
                    onClick = { /* TODO */ },
                    modifier = Modifier.weight(1f),
                    shape = RoundedCornerShape(12.dp),
                    colors = ButtonDefaults.buttonColors(containerColor = PurpleBrand)
                ) {
                    Text("Save Fit")
                }
            }
        }
    }
}

@Composable
fun QuickCategoriesRow() {
    LazyRow(
        contentPadding = PaddingValues(horizontal = 16.dp),
        horizontalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        items(4) {
            Box(
                modifier = Modifier
                    .size(100.dp)
                    .clip(RoundedCornerShape(16.dp))
                    .background(PurpleLight)
            )
        }
    }
}

@Composable
fun RecentlyAddedRow(items: List<ClothingItem>) {
    LazyRow(
        contentPadding = PaddingValues(horizontal = 16.dp),
        horizontalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        items(items) { item ->
            Column(modifier = Modifier.width(120.dp)) {
                AsyncImage(
                    model = item.imageUrl,
                    contentDescription = null,
                    modifier = Modifier
                        .size(120.dp)
                        .clip(RoundedCornerShape(20.dp))
                        .background(Color(0xFFF3F4F6)),
                    contentScale = ContentScale.Fit
                )
                Spacer(modifier = Modifier.height(8.dp))
                Text(text = item.name, fontWeight = FontWeight.Bold, fontSize = 14.sp)
                Text(text = "5d ago", color = Color.Gray, fontSize = 12.sp)
            }
        }
    }
}

package com.example.nexfit.ui.components

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Notifications
import androidx.compose.material.icons.outlined.FavoriteBorder
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import coil.compose.AsyncImage
import com.example.nexfit.ui.theme.PurpleBrand

@Composable
fun HomeHeader(
    onFavoritesClick: () -> Unit = {},
    onNotificationsClick: () -> Unit = {}
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        AsyncImage(
            model = "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6",
            contentDescription = null,
            modifier = Modifier
                .size(48.dp)
                .clip(CircleShape),
            contentScale = ContentScale.Crop
        )
        Spacer(modifier = Modifier.width(12.dp))
        Column(modifier = Modifier.weight(1.0f)) {
            Text(text = "Morning, Alex", fontSize = 12.sp, color = Color.Gray)
            Text(text = "NexFit", fontSize = 20.sp, fontWeight = FontWeight.Bold, color = PurpleBrand)
        }
        IconButton(onClick = onFavoritesClick) {
            Icon(Icons.Outlined.FavoriteBorder, contentDescription = null, tint = PurpleBrand)
        }
        IconButton(onClick = onNotificationsClick) {
            Icon(Icons.Default.Notifications, contentDescription = null, tint = PurpleBrand)
        }
    }
}

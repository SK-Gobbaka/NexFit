package com.example.nexfit.ui.screens

import androidx.compose.animation.core.*
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.nexfit.ui.components.HomeHeader
import kotlinx.coroutines.delay

@Composable
fun ScanningScreen(onScanComplete: () -> Unit = {}) {
    LaunchedEffect(Unit) {
        delay(3000)
        onScanComplete()
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFFFBFBFE))
    ) {
        HomeHeader()
        
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp)
        ) {
            Text(
                text = "Adding Collection to Wardrobe",
                fontSize = 20.sp,
                fontWeight = FontWeight.Bold,
                modifier = Modifier.padding(vertical = 16.dp)
            )
            
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .weight(1f)
                    .padding(vertical = 16.dp),
                shape = RoundedCornerShape(32.dp),
                colors = CardDefaults.cardColors(containerColor = Color.White),
                elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
            ) {
                Column(
                    modifier = Modifier.fillMaxSize(),
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.Center
                ) {
                    Text(
                        text = "Scanning and Organizing the dress",
                        color = Color.Gray,
                        fontSize = 14.sp
                    )
                    
                    Spacer(modifier = Modifier.height(48.dp))
                    
                    ScanningFrame()
                }
            }
        }
    }
}

@Composable
fun ScanningFrame() {
    val infiniteTransition = rememberInfiniteTransition(label = "scanning")
    val translateY by infiniteTransition.animateFloat(
        initialValue = 0f,
        targetValue = 250f,
        animationSpec = infiniteRepeatable(
            animation = tween(2000, easing = LinearEasing),
            repeatMode = RepeatMode.Reverse
        ),
        label = "lineTranslation"
    )

    Box(
        modifier = Modifier
            .size(200.dp, 250.dp),
        contentAlignment = Alignment.Center
    ) {
        // Simple representation of the scanning corners
        Column(modifier = Modifier.fillMaxSize(), verticalArrangement = Arrangement.SpaceBetween) {
            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                Corner(Alignment.TopStart)
                Corner(Alignment.TopEnd)
            }
            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                Corner(Alignment.BottomStart)
                Corner(Alignment.BottomEnd)
            }
        }
        
        // Animated scanning line
        Canvas(modifier = Modifier.fillMaxSize()) {
            drawLine(
                color = Color.Black,
                start = Offset(x = 0f, y = translateY.dp.toPx()),
                end = Offset(x = size.width, y = translateY.dp.toPx()),
                strokeWidth = 4f
            )
        }
    }
}

@Composable
fun Corner(alignment: Alignment) {
    Box(
        modifier = Modifier
            .size(30.dp)
            .border(2.dp, Color.Black, RoundedCornerShape(
                topStart = if (alignment == Alignment.TopStart) 8.dp else 0.dp,
                topEnd = if (alignment == Alignment.TopEnd) 8.dp else 0.dp,
                bottomStart = if (alignment == Alignment.BottomStart) 8.dp else 0.dp,
                bottomEnd = if (alignment == Alignment.BottomEnd) 8.dp else 0.dp
            ))
            .padding(2.dp) // Offset to show only the corner
            .background(Color.White)
    )
}

package com.example.nexfit.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Edit
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
import com.example.nexfit.ui.components.HomeHeader
import com.example.nexfit.ui.theme.PurpleBrand
import com.example.nexfit.ui.theme.PurpleLight

@Composable
fun ProfileScreen() {
    var name by remember { mutableStateOf("") }
    var email by remember { mutableStateOf("") }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFFFBFBFE))
    ) {
        HomeHeader()
        
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                text = "Profile Page",
                fontSize = 24.sp,
                fontWeight = FontWeight.Bold,
                modifier = Modifier.align(Alignment.Start)
            )
            
            Spacer(modifier = Modifier.height(32.dp))
            
            Box {
                AsyncImage(
                    model = "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6",
                    contentDescription = null,
                    modifier = Modifier
                        .size(150.dp)
                        .clip(CircleShape),
                    contentScale = ContentScale.Crop
                )
                IconButton(
                    onClick = { /* TODO */ },
                    modifier = Modifier
                        .align(Alignment.BottomEnd)
                        .background(PurpleLight, CircleShape)
                        .size(40.dp)
                ) {
                    Icon(Icons.Default.Edit, contentDescription = null, tint = PurpleBrand, modifier = Modifier.size(20.dp))
                }
            }
            
            Spacer(modifier = Modifier.height(32.dp))
            
            ProfileTextField(value = name, onValueChange = { name = it }, label = "Name")
            Spacer(modifier = Modifier.height(16.dp))
            ProfileTextField(value = email, onValueChange = { email = it }, label = "E-mail")
            
            Spacer(modifier = Modifier.height(32.dp))
            
            Button(
                onClick = { /* TODO */ },
                colors = ButtonDefaults.buttonColors(containerColor = Color(0xFFFFEBF0)),
                shape = RoundedCornerShape(20.dp)
            ) {
                Text(text = "Log Out", color = Color(0xFFFF4D6D), fontWeight = FontWeight.Bold)
            }
        }
    }
}

@Composable
fun ProfileTextField(value: String, onValueChange: (String) -> Unit, label: String) {
    Surface(
        shape = RoundedCornerShape(16.dp),
        shadowElevation = 2.dp,
        modifier = Modifier.fillMaxWidth()
    ) {
        OutlinedTextField(
            value = value,
            onValueChange = onValueChange,
            placeholder = { Text(text = "$label |", color = Color.LightGray) },
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(16.dp),
            colors = OutlinedTextFieldDefaults.colors(
                unfocusedContainerColor = Color.White,
                focusedContainerColor = Color.White,
                unfocusedBorderColor = Color.Transparent,
                focusedBorderColor = PurpleBrand
            ),
            singleLine = true
        )
    }
}

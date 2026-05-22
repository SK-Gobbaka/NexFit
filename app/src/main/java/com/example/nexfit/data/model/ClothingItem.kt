package com.example.nexfit.data.model

import java.util.UUID

enum class ClothingCategory {
    UPPER_WEAR,
    LOWER_WEAR,
    FOOTWEAR,
    ACCESSORIES,
    TRADITIONAL
}

data class ClothingItem(
    val id: String = UUID.randomUUID().toString(),
    val imageUrl: String,
    val category: ClothingCategory,
    val color: String? = null,
    val style: String? = null,
    val name: String,
    val createdAt: Long = System.currentTimeMillis()
)

data class Outfit(
    val id: String = UUID.randomUUID().toString(),
    val items: List<ClothingItem>,
    val name: String? = null,
    val matchPercentage: Int = 0,
    val occasion: String? = null
)

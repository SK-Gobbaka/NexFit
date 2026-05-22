package com.example.nexfit.ui.viewmodel

import androidx.lifecycle.ViewModel
import com.example.nexfit.data.model.ClothingCategory
import com.example.nexfit.data.model.ClothingItem
import com.example.nexfit.data.model.Outfit
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow

class HomeViewModel : ViewModel() {
    private val _todayFit = MutableStateFlow<Outfit?>(null)
    val todayFit: StateFlow<Outfit?> = _todayFit.asStateFlow()

    private val _recentlyAdded = MutableStateFlow<List<ClothingItem>>(emptyList())
    val recentlyAdded: StateFlow<List<ClothingItem>> = _recentlyAdded.asStateFlow()

    init {
        // Load mock data
        loadMockData()
    }

    private fun loadMockData() {
        val item1 = ClothingItem(name = "Beige Sweater", category = ClothingCategory.UPPER_WEAR, imageUrl = "https://images.unsplash.com/photo-1576566582402-38a8e3579133?q=80&w=300")
        val item2 = ClothingItem(name = "Blue Jeans", category = ClothingCategory.LOWER_WEAR, imageUrl = "https://images.unsplash.com/photo-1542272604-787c3835535d?q=80&w=300")
        val item3 = ClothingItem(name = "White Sneakers", category = ClothingCategory.FOOTWEAR, imageUrl = "https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=300")
        val item4 = ClothingItem(name = "Black Watch", category = ClothingCategory.ACCESSORIES, imageUrl = "https://images.unsplash.com/photo-1524592094714-0f0654e20314?q=80&w=300")

        _todayFit.value = Outfit(
            items = listOf(item1, item2, item3),
            matchPercentage = 98
        )

        _recentlyAdded.value = listOf(item1, item2, item3, item4)
    }

    fun generateOutfit() {
        // Mock generation
        val items = _recentlyAdded.value.shuffled().take(3)
        if (items.size >= 3) {
            _todayFit.value = Outfit(
                items = items,
                matchPercentage = (80..100).random()
            )
        }
    }

    fun addMockItem(imageUrl: String) {
        val newItem = ClothingItem(
            name = "New Item",
            category = ClothingCategory.UPPER_WEAR,
            imageUrl = imageUrl
        )
        _recentlyAdded.value = listOf(newItem) + _recentlyAdded.value
    }
}

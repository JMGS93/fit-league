package com.josegarciasegura.fitleague

import android.os.Bundle
import android.view.WindowManager
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsControllerCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    
    WindowCompat.setDecorFitsSystemWindows(window, false)

    
    window.clearFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
    
    window.addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)

    super.onCreate(savedInstanceState)

    
    val controller = WindowInsetsControllerCompat(window, window.decorView)
    controller.isAppearanceLightStatusBars = true      
    controller.isAppearanceLightNavigationBars = false 
  }
}
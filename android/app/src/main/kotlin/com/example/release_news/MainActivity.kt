package com.example.release_news

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import android.util.Log
import android.view.View
import android.widget.Toast
import android.view.WindowManager
import android.view.WindowManager.LayoutParams.TYPE_SYSTEM_ALERT


class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
     val window = getWindow()
     val params = window.getAttributes()
    //  params.systemUiVisibility = View.SYSTEM_UI_FLAG_HIDE_NAVIGATION or View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
    //  window.setAttributes(params)
    //  window.addFlags(WindowManager.LayoutParams.TYPE_SYSTEM_ALERT)



    // val params = getWindow().getDecorView().setSystemUiVisibility(
    //         View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
    //                 or View.SYSTEM_UI_FLAG_LAYOUT_STABLE
    //                 or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
    //                 or View.SYSTEM_UI_FLAG_IMMERSIVE
    //                 or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN)

    // Toast.makeText(this, "!!!!!!!!!!!!!!!!", Toast.LENGTH_SHORT).show()
    // GeneratedPluginRegistrant.registerWith(this)
  }
    // private val FLAG_HOMEKEY_DISPATCHED = -0x80000000
    // override fun onAttachedToWindow() {
    //   getWindow().clearFlags(FLAG_HOMEKEY_DISPATCHED )//屏蔽菜单键
    //     this.getWindow().setType(
    //             WindowManager.LayoutParams.TYPE_KEYGUARD_DIALOG)
    //     super.onAttachedToWindow();
    //     // super.onAttachedToWindow()
    //     // val window = getWindow()
    //     // window.addFlags(WindowManager.LayoutParams.FLAG_HOMEKEY_DISPATCHED)
    // }
}


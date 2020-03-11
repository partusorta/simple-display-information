package com.suyetech.ezhan.esite

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import com.example.release_news.MainActivity

class BootCompleteReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        if (Intent.ACTION_BOOT_COMPLETED.equals(intent.getAction())) {
            val thisIntent = Intent(context, MainActivity::class.java)
            thisIntent.setAction("android.intent.action.MAIN")
            thisIntent.addCategory("android.intent.category.LAUNCHER")
            thisIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(thisIntent)
        }
    }
}
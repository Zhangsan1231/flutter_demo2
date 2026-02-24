package zhangsan.flutter_demo2

import android.app.Application
import io.flutter.app.FlutterApplication   // ← 新增这行
import android.util.Log
import com.eiot.ringsdk.ServiceSdkCommandV2
// ... 其他 import 保持不变

class MyApplication : FlutterApplication() {   // ← 改成 FlutterApplication()

    companion object {
        lateinit var instance: MyApplication
            private set
        private const val TAG = "AIZO_SDK"
    }

    override fun onCreate() {
        super.onCreate()          // ← 必须第一行调用 super！！！

        instance = this

        Log.i(TAG, "🚀 MyApplication onCreate 开始执行")

        try {
            ServiceSdkCommandV2.init(
                this,
                region = 2,
                version = "1.0",
                name = "AIZO RING",
                id = "zhangsan.flutter_demo2",
                country = "CN",
                language = "ZH",
                debugging = true
            )
            Log.i(TAG, "✅ AIZO RING SDK 初始化成功！")
        } catch (e: Exception) {
            Log.e(TAG, "❌ AIZO SDK 初始化失败！", e)
            e.printStackTrace()
        }
    }
}
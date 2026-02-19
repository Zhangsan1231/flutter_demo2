package zhangsan.flutter_demo2

import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import com.aojmedical.plugin.ble.AHDevicePlugin
import com.eiot.aizo.sdk.AizoDevice
import com.eiot.aizo.sdk.callback.AizoDeviceConnectCallback
import com.eiot.ringsdk.ServiceSdkCommandV2
import com.fluttercandies.flutter_image_compress.logger.log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import java.util.logging.Logger

/**
 * 主 Activity，负责 Flutter 与 AIZO RING SDK 的原生桥接
 * 核心功能：
 * 1. 通过 MethodChannel 接收 Flutter 的 SDK 初始化请求
 * 2. 通过 EventChannel 实时推送设备连接状态和电池信息给 Flutter
 */
class MainActivity : FlutterActivity() {

    // Flutter 与原生通信的 MethodChannel 名称（必须与 Flutter 端保持一致）
    private val CHANNEL = "com.zhangsan/aizo_ring"

    // 电池/连接状态事件通道名称，用于原生主动推送实时数据给 Flutter
    private val BATTERY_EVENT_CHANNEL = "com.zhangsan/aizo_ring_batteryStatus"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // 初始化 AHDevicePlugin（插件初始化，通常在引擎注册时自动完成，这里手动调用作为备用）
        val result = AHDevicePlugin.getInstance().initPlugin(this)
        print("测试 Android SDK 版本: ${Build.VERSION.SDK_INT}")

        // 获取 Flutter 引擎的消息信使（用于创建通信通道）
        flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->

            // 注册 MethodChannel：接收 Flutter 的方法调用（如 initSDK）
            MethodChannel(messenger, CHANNEL).setMethodCallHandler { call, result ->
                when (call.method) {
                    // Flutter 调用 "init" 方法时执行 SDK 初始化
                    "init" -> {
                        try {
                            // 调用 AIZO RING SDK 初始化（文档第二章）
                            ServiceSdkCommandV2.init(
                                application,             // 推荐使用 Application Context
                                region = 1,              // 地区：1=国内，2=海外（根据服务器选择）
                                version = "1.0.0",       // 应用版本号（建议与 build.gradle 一致）
                                name = "SDK_DEMO_APP",   // 应用名称（用于日志或统计）
                                id = "com.eiot.demo.app",  // 应用包名（必须与 applicationId 一致）
                                country = "CN",          // 国家代码（中国用 CN）
                                language = "ZH",         // 语言（中文用 ZH）
                                debugging = true         // true=调试模式（输出更多日志），上线改 false
                            )
                            result.success(true)     // 返回成功给 Flutter
                        } catch (e: Exception) {
                            println(e)               // 打印异常信息
                            result.success(false)    // 返回失败给 Flutter
                        }
                    }
                    else -> result.notImplemented()
                }
            }

            // 注册 EventChannel：原生主动推送设备连接状态和电池信息
            EventChannel(messenger, BATTERY_EVENT_CHANNEL).setStreamHandler(object : EventChannel.StreamHandler {

                // 用于在主线程推送事件
                private var handler: Handler? = null

                /**
                 * Flutter 开始监听事件时调用
                 * @param arguments Flutter 传过来的参数（本次未使用）
                 * @param events 事件推送对象，用于发送数据给 Flutter
                 */
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    handler = Handler(Looper.getMainLooper())  // 创建主线程 Handler，确保推送在 UI 线程
//                    eventSink = events  // 保存事件 sink，后续回调中会用它推送数据

                    // 注册 AIZO SDK 连接状态回调（文档中提到的 AizoDeviceConnectCallback）
                    ServiceSdkCommandV2.addCallback(object : AizoDeviceConnectCallback {

                        // 连接成功回调
                        override fun connect() {
                            handler?.post {
                                events?.success("CONNECTED")  // 推送连接成功事件给 Flutter
                            }
                        }

                        // 连接出错回调
                        override fun connectError(throwable: Throwable, state: Int) {
                            handler?.post {
                                events?.success("$state")  // 推送错误状态码给 Flutter
                            }
                        }

                        // 断开连接回调
                        override fun disconnect() {
                            handler?.post {
                                events?.success("DISCONNECTED")  // 推送断开事件给 Flutter
                            }
                        }
                    })
                }

                /**
                 * Flutter 取消监听事件时调用
                 * 清理资源，避免内存泄漏
                 */
                override fun onCancel(arguments: Any?) {
//                    eventSink = null
                    handler?.removeCallbacksAndMessages(null)
                    handler = null
                }
            })
        }
    }
}
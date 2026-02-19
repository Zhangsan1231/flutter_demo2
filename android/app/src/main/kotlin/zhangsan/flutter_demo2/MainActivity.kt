package zhangsan.flutter_demo2

import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import com.aojmedical.plugin.ble.AHDevicePlugin
import com.eiot.aizo.ext.yes
import com.eiot.aizo.sdk.AizoDevice
import com.eiot.aizo.sdk.callback.AizoDeviceConnectCallback
import com.eiot.ringsdk.ServiceSdkCommandV2
import com.eiot.ringsdk.battery.PowerState
import com.eiot.ringsdk.be.DeviceManager
import com.eiot.ringsdk.callback.BCallback
import com.eiot.ringsdk.callback.PowerStateCallback
import com.eiot.ringsdk.ext.logIx
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
    // 只保留一个主要的状态通道（连接 + 电池都走这里）
    private val DEVICE_STATUS_CHANNEL = "com.zhangsan/aizo_ring/device_status"

    private val POWER_EVENT_CHANNEL = "com.zhangsan/aizo_ring_power"
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
                                id = "zhangsan.flutter_demo2",  // 应用包名（必须与 applicationId 一致）
                                country = "CN",          // 国家代码（中国用 CN）
                                language = "ZH",         // 语言（中文用 ZH）
                                debugging = true         // true=调试模式（输出更多日志），上线改 false
                            )
                            result.success(true)     // 返回成功给 Flutter
                        } catch (e: Throwable) {
                            e.printStackTrace()   // 打印完整堆栈到 Logcat
                            android.util.Log.e("AizoInit", "Init failed", e)
                            result.error(
                                "INIT_FAILED", e.message ?: "Unknown error", e.stackTraceToString()
                            )
                        }
                    }

                    // 新增：通知绑定戒指
                    "notifyBoundDevice" -> {
                        try {
                            // 从 Flutter 传过来的 Map 参数
                            val args = call.arguments as? Map<String, Any>
                            val deviceName = args?.get("deviceName") as? String ?: ""
                            val deviceMac = args?.get("deviceMac") as? String ?: ""

                            if (deviceName.isEmpty() || deviceMac.isEmpty()) {
                                result.error(
                                    "INVALID_ARGS", "deviceName 或 deviceMac 不能为空", null
                                )
                                return@setMethodCallHandler
                            }

                            // 调用 SDK 的 notifyBoundDevice
                            ServiceSdkCommandV2.notifyBoundDevice(
                                deviceName = deviceName,
                                deviceMac = deviceMac,
                                callback = object : BCallback {
                                    override fun result(r: Boolean) {
                                        r.yes {
                                            "notifyBoundDevice true".logIx()
                                        }
                                    }
                                }


                            )
                            // 注意：这里不立即 success，因为是异步回调
                            // 等 SDK 回调后再 result.success(r)
                        } catch (e: Throwable) {
                            e.printStackTrace()
                            android.util.Log.e("AizoBind", "notifyBoundDevice failed", e)
                            result.error("BIND_FAILED", e.message ?: "绑定通知异常", null)
                        }
                    }
                    // 新增：戒指解绑/复位/重启
                    "deviceSet" -> {
                        try {
                            val args = call.arguments as? Map<String, Any>
                            val type = (args?.get("type") as? Number)?.toInt() ?: -1

                            if (type !in listOf(1, 2, 4)) {
                                result.error("INVALID_TYPE", "type 必须是 1、2 或 4", null)
                                return@setMethodCallHandler
                            }

                            ServiceSdkCommandV2.deviceSet(type) { success: Boolean ->
                                android.util.Log.d(
                                    "AizoDeviceSet", "deviceSet($type) 回调: $success"
                                )
                                runOnUiThread {
                                    result.success(success)
                                }
                            }

                            // 注意：这里不立即 result.success()，因为是异步，等回调返回
                        } catch (e: Throwable) {
                            e.printStackTrace()
                            android.util.Log.e("AizoDeviceSet", "deviceSet 调用异常", e)
                            result.error("DEVICE_SET_FAILED", e.message ?: "操作失败", null)
                        }
                    }

                    "getCurrentPowerState" -> {
                        getCurrentPowerState(result)
                    }


                    // 新增：获取硬件信息
                    "getFirmwareInfo" -> {
                        try {
                            // 先检查是否已连接（推荐，防止 SDK 抛异常）
                            if (!DeviceManager.isConnect()) {
                                android.util.Log.w("AizoFirmware", "设备未连接，无法获取硬件信息")
                                result.success(null)  // 或 result.error("NOT_CONNECTED", "设备未连接", null)
                                return@setMethodCallHandler
                            }

                            // 调用 SDK 获取 FirmwareParams
                            val params = ServiceSdkCommandV2.getFirmwareParams()

                            if (params == null) {
                                android.util.Log.w("AizoFirmware", "getFirmwareParams 返回 null")
                                result.success(null)
                                return@setMethodCallHandler
                            }

                            // 转换为 Map 返回给 Flutter
                            val infoMap = mapOf(
                                "platform"     to (params.platform ?: ""),
                                "brandName"    to (params.brandName ?: ""),
                                "modelName"    to (params.modelName ?: ""),
                                "fwmVersion"   to (params.fwmVersion ?: ""),
                                "resVersion"   to (params.resVersion ?: ""),
                                "batteryCode"  to (params.batteryCode ?: ""),
                                "productSn"    to (params.productSn ?: ""),
                                "reserved"     to (params.reserved ?: "")
                            )

                            android.util.Log.d("AizoFirmware", "硬件信息: $infoMap")
                            result.success(infoMap)
                        } catch (e: Throwable) {
                            e.printStackTrace()
                            android.util.Log.e("AizoFirmware", "getFirmwareParams 异常", e)
                            result.error("FIRMWARE_FAILED", e.message ?: "获取硬件信息失败", null)
                        }
                    }


                    else -> result.notImplemented()
                }
            }

            // 注册 EventChannel：原生主动推送设备连接状态和电池信息
            EventChannel(messenger, BATTERY_EVENT_CHANNEL).setStreamHandler(object :
                EventChannel.StreamHandler {

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


            // 新增：电池电量实时推送通道
            EventChannel(messenger, POWER_EVENT_CHANNEL).setStreamHandler(object : EventChannel.StreamHandler {

                private var handler: Handler? = null
                private var powerListener: PowerStateCallback? = null   // ← 新增：保存 listener 引用

                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    handler = Handler(Looper.getMainLooper())

                    // 创建 listener 并保存引用
                    powerListener = object : PowerStateCallback {
                        override fun PowerState(bean: PowerState) {
                            handler?.post {
                                val powerMap = mapOf(
                                    "electricity" to bean.electricity,
                                    "workingMode" to bean.workingMode,
                                    "toString" to bean.toString()
                                )
                                events?.success(powerMap)
                                android.util.Log.d("AizoPower", "电池推送: $powerMap")
                            }
                        }
                    }

                    // 注册（使用保存的引用）
                    powerListener?.let {
                        ServiceSdkCommandV2.registerPowerStateListener(it)
                    }
                }

                override fun onCancel(arguments: Any?) {
                    // 1. 清理 handler
                    handler?.removeCallbacksAndMessages(null)
                    handler = null

                    // 2. 注销 SDK 监听（关键！）
                    powerListener?.let {
                        ServiceSdkCommandV2.unregisterPowerStateListener(it)
                        android.util.Log.d("AizoPower", "已注销电池状态监听")
                    }
                    powerListener = null   // 清空引用，帮助 GC

                    // 如果 events 还活着，可以发个结束信号（可选）
                    // events?.endOfStream()   // 但通常 Flutter 侧 cancel 后就不需要了
                }
            })


        }


    }

    private fun getCurrentPowerState(result: MethodChannel.Result) {
        if (!DeviceManager.isConnect()) {
            android.util.Log.w("AizoPower", "设备未连接，无法获取即时电池状态")
            result.error("DEVICE_NOT_CONNECTED", "设备未连接，请先连接戒指", null)
            return
        }

        val callback = object : PowerStateCallback {
            override fun PowerState(bean: PowerState) {
                Handler(Looper.getMainLooper()).post {
                    val map = mapOf(
                        "electricity"   to bean.electricity,     // Int? 电量百分比
                        "workingMode"   to bean.workingMode,     // Int?  0=未充电 1=充电中
                        "fetchTimeMs"   to System.currentTimeMillis(),  // 可选：采集时间
                        // "debugInfo"  to bean.toString()       // 可选：调试用
                    )
                    android.util.Log.d("AizoPower", "getInstantPowerState 成功: $map")
                    result.success(map)
                }
            }
        }

        try {
            ServiceSdkCommandV2.getInstantPowerState()
        } catch (e: Exception) {
            android.util.Log.e("AizoPower", "调用 getInstantPowerState 异常", e)
            result.error("SDK_CALL_FAILED", "获取电池状态失败：${e.message}", null)
        }
    }
}

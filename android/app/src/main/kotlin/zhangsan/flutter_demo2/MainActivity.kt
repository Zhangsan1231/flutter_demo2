package zhangsan.flutter_demo2

import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
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
import com.eiot.ringsdk.heartrate.MeasureTimeCallback
import com.eiot.ringsdk.heartrate.MeasureTimeData
import com.eiot.ringsdk.measure.MeasureResult
import com.eiot.ringsdk.measure.MeasureResultCallback
import com.eiot.ringsdk.userinfo.UserInfo
import com.eiot.ringsdk.userinfo.UserInfoCallback
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
    private val DEVICE_STATUS_CHANNEL = "com.zhangsan/aizo_ring/device_status"
    private val POWER_EVENT_CHANNEL = "com.zhangsan/aizo_ring_power"

    // 由 SDK connect(mac) 触发的连接结果，在 AizoDeviceConnectCallback.connect() 里回调给 Flutter
    private var pendingConnectResult: MethodChannel.Result? = null
    private var pendingDeviceName: String? = null
    private var pendingDeviceMac: String? = null

    // 连接状态事件 sink（供全局连接回调推送 CONNECTED/DISCONNECTED）
    private var connectionEventSink: EventChannel.EventSink? = null
    private val connectionHandler = Handler(Looper.getMainLooper())

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val result = AHDevicePlugin.getInstance().initPlugin(this)
        android.util.Log.d("MainActivity", "测试 Android SDK 版本: ${Build.VERSION.SDK_INT}")
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger

        // 先注册 SDK 连接回调（文档 2.1.2：addCallback 后 connect(mac)）
        ServiceSdkCommandV2.addCallback(object : AizoDeviceConnectCallback {
            override fun connect() {
                connectionHandler.post {
                    android.util.Log.d("AizoConnect", "SDK 连接成功，执行 notifyBoundDevice")
                    val name = pendingDeviceName ?: "AIZO RING"
                    val mac = pendingDeviceMac ?: ""
                    if (mac.isNotEmpty() && pendingConnectResult != null) {
                        ServiceSdkCommandV2.notifyBoundDevice(
                            deviceName = name,
                            deviceMac = mac,
                            callback = object : BCallback {
                                override fun result(r: Boolean) {
                                    runOnUiThread {
                                        pendingConnectResult?.success(r)
                                        pendingConnectResult = null
                                        pendingDeviceName = null
                                        pendingDeviceMac = null
                                    }
                                    "notifyBoundDevice $r".logIx()
                                }
                            }
                        )
                    } else {
                        runOnUiThread {
                            pendingConnectResult?.success(true)
                            pendingConnectResult = null
                            pendingDeviceName = null
                            pendingDeviceMac = null
                        }
                    }
                    connectionEventSink?.success("CONNECTED")
                }
            }

            override fun connectError(throwable: Throwable, state: Int) {
                connectionHandler.post {
                    android.util.Log.e("AizoConnect", "SDK 连接失败: $state", throwable)
                    pendingConnectResult?.error(
                        "CONNECT_FAILED",
                        throwable.message ?: "state=$state",
                        null
                    )
                    pendingConnectResult = null
                    pendingDeviceName = null
                    pendingDeviceMac = null
                    connectionEventSink?.success("ERROR_$state")
                }
            }

            override fun disconnect() {
                connectionHandler.post {
                    connectionEventSink?.success("DISCONNECTED")
                }
            }
        })

        // 注册 MethodChannel：接收 Flutter 的方法调用（如 init、connect、notifyBoundDevice）
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
                            val args = call.arguments as? Map<String, Any>
                            val deviceName = args?.get("deviceName") as? String ?: ""
                            val deviceMac = args?.get("deviceMac") as? String ?: ""

                            if (deviceName.isEmpty() || deviceMac.isEmpty()) {
                                result.error("INVALID_ARGS", "deviceName 或 deviceMac 不能为空", null)
                                return@setMethodCallHandler
                            }

                            ServiceSdkCommandV2.notifyBoundDevice(
                                deviceName = deviceName,
                                deviceMac = deviceMac,
                                callback = object : BCallback {
                                    override fun result(r: Boolean) {
                                        runOnUiThread {
                                            result.success(r)  // 关键：在这里返回结果给 Flutter
                                        }
                                        "notifyBoundDevice $r".logIx()
                                    }
                                }
                            )
                            // 注意：这里不要 result.success()，因为是异步，等回调
                        } catch (e: Throwable) {
                            e.printStackTrace()
                            android.util.Log.e("AizoBind", "notifyBoundDevice 异常", e)
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

                    // 断开设备（文档 2.1.4：deviceSet(2) 解绑戒指，SDK 会断开连接）
                    "disconnect" -> {
                        try {
                            if (!DeviceManager.isConnect()) {
                                android.util.Log.d("AizoDisconnect", "当前未连接，直接返回成功")
                                result.success(true)
                                return@setMethodCallHandler
                            }
                            ServiceSdkCommandV2.deviceSet(2) { success: Boolean ->
                                android.util.Log.d("AizoDisconnect", "deviceSet(2) 解绑回调: $success")
                                runOnUiThread {
                                    result.success(success)
                                }
                            }
                        } catch (e: Throwable) {
                            e.printStackTrace()
                            android.util.Log.e("AizoDisconnect", "断开异常", e)
                            result.error("DISCONNECT_FAILED", e.message ?: "断开失败", null)
                        }
                    }

                    // 由 SDK 发起连接（文档 2.1.2：先 addCallback，再 connect(mac)；连接成功后在回调里 notifyBoundDevice）
                    "connect" -> {
                        try {
                            val args = call.arguments as? Map<String, Any>
                            val deviceMac = args?.get("deviceMac") as? String ?: ""
                            val deviceName = args?.get("deviceName") as? String ?: "AIZO RING"
                            if (deviceMac.isEmpty()) {
                                result.error("INVALID_ARGS", "deviceMac 不能为空", null)
                                return@setMethodCallHandler
                            }
                            pendingConnectResult = result
                            pendingDeviceName = deviceName
                            pendingDeviceMac = deviceMac
                            android.util.Log.d("AizoConnect", "SDK 开始连接: $deviceMac")
                            ServiceSdkCommandV2.connect(deviceMac)
                        } catch (e: Throwable) {
                            e.printStackTrace()
                            android.util.Log.e("AizoConnect", "connect 异常", e)
                            result.error("CONNECT_FAILED", e.message ?: "连接异常", null)
                        }
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

                    //获取用户信息
                    "getUserInfo" -> {
                        try {
                            if (!DeviceManager.isConnect()) {
                                android.util.Log.w("AizoUser", "设备未连接，无法获取用户信息")
                                result.error("NOT_CONNECTED", "设备未连接", null)
                                return@setMethodCallHandler
                            }

                            ServiceSdkCommandV2.getUserInfo(object : UserInfoCallback {
                                override fun userInfo(bean: UserInfo) {
                                    runOnUiThread {
                                        val infoMap = mapOf(
                                            "gender" to (bean.gender ?: 1),     // 1男 2女
                                            "birth" to (bean.birth ?: "2000-01"),
                                            "weight" to (bean.weight ?: 0.0),
                                            "height" to (bean.height ?: 0.0)
                                        )
                                        android.util.Log.d("AizoUser", "用户信息: $infoMap")
                                        result.success(infoMap)
                                    }
                                }
                            })
                        } catch (e: Throwable) {
                            e.printStackTrace()
                            android.util.Log.e("AizoUser", "getUserInfo 异常", e)
                            result.error("USERINFO_FAILED", e.message ?: "获取用户信息失败", null)
                        }
                    }

                    "getDeviceMeasureTime" -> {
                        try {
                            if (!DeviceManager.isConnect()) {
                                android.util.Log.w("AizoHeart", "设备未连接，无法获取心率间隔")
                                result.error("NOT_CONNECTED", "设备未连接", null)
                                return@setMethodCallHandler
                            }

                            ServiceSdkCommandV2.getDeviceMeasureTime(object : MeasureTimeCallback {
                                override fun measureTime(bean: MeasureTimeData) {
                                    runOnUiThread {
                                        val dataMap = mapOf(
                                            "currentInterval"   to (bean.currentInterval ?: 0),
                                            "defaultInterval"   to (bean.defaultInterval ?: 0),
                                            "intervalList"      to (bean.intervalList?.map { it } ?: emptyList<Any>())
                                        )
                                        android.util.Log.d("AizoHeart", "心率间隔数据: $dataMap")
                                        result.success(dataMap)
                                    }
                                }
                            })
                        } catch (e: Throwable) {
                            e.printStackTrace()
                            android.util.Log.e("AizoHeart", "getDeviceMeasureTime 异常", e)
                            result.error("MEASURE_TIME_FAILED", e.message ?: "获取心率间隔失败", null)
                        }
                    }


                    "instantMeasurement" -> {
                        try {
                            val args = call.arguments as? Map<String, Any>
                            val type = (args?.get("type") as? Number)?.toInt() ?: -1
                            val operation = (args?.get("operation") as? Number)?.toInt() ?: 1

                            if (type !in listOf(1, 2, 3, 9)) {
                                result.error("INVALID_TYPE", "无效的测量类型: $type", null)
                                return@setMethodCallHandler
                            }

                            if (!DeviceManager.isConnect()) {
                                android.util.Log.w("AizoMeasure", "设备未连接，无法开始测量")
                                result.error("NOT_CONNECTED", "设备未连接", null)
                                return@setMethodCallHandler
                            }

                            ServiceSdkCommandV2.instantMeasurement(type, operation, object : MeasureResultCallback {
                                override fun measureResult(bean: MeasureResult) {
                                    runOnUiThread {
                                        val resultMap = mapOf(
                                            "result"        to bean.result,
                                            "type"          to bean.type,
                                            "time"          to bean.time,
                                            "heartrate"     to (bean.heartrate ?: 0),
                                            "bloodoxygen"   to (bean.bloodoxygen ?: 0),
                                            "bodytemp"      to (bean.bodytemp ?: 0.0),
                                            "envtemp"       to (bean.envtemp ?: 0.0),
//                                            "pressure"      to bean.pressure
                                        )
                                        Log.d("AizoMeasure", "测量结果返回: $resultMap")
                                        result.success(resultMap)
                                    }
                                }
                            })

                            android.util.Log.d("AizoMeasure", "已发起测量: type=$type, operation=$operation")
                        } catch (e: Throwable) {
                            e.printStackTrace()
                            android.util.Log.e("AizoMeasure", "instantMeasurement 异常", e)
                            result.error("MEASURE_FAILED", e.message ?: "测量失败", null)
                        }
                    }


                    else -> result.notImplemented()
                }
            }

            // 注册 EventChannel：连接状态由上方全局 AizoDeviceConnectCallback 推送到 connectionEventSink
            EventChannel(messenger, BATTERY_EVENT_CHANNEL).setStreamHandler(object :
                EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    connectionEventSink = events
                }
                override fun onCancel(arguments: Any?) {
                    connectionEventSink = null
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

    private fun getCurrentPowerState(result: MethodChannel.Result) {
        if (!DeviceManager.isConnect()) {
            android.util.Log.w("AizoPower", "设备未连接，无法获取即时电池状态")
            result.error("DEVICE_NOT_CONNECTED", "设备未连接，请先连接戒指", null)
            return
        }

        val resultSent = booleanArrayOf(false)
        var timeoutRunnable: Runnable? = null

        val callback = object : PowerStateCallback {
            override fun PowerState(bean: PowerState) {
                Handler(Looper.getMainLooper()).post {
                    if (resultSent[0]) return@post
                    resultSent[0] = true
                    timeoutRunnable?.let { connectionHandler.removeCallbacks(it) }
                    try {
                        ServiceSdkCommandV2.unregisterPowerStateListener(this)
                    } catch (_: Exception) {}
                    val map = mapOf(
                        "electricity"   to (bean.electricity ?: 0),
                        "workingMode"   to (bean.workingMode ?: 0),
                        "fetchTimeMs"   to System.currentTimeMillis(),
                    )
                    android.util.Log.d("AizoPower", "getInstantPowerState 成功: $map")
                    result.success(map)
                }
            }
        }

        timeoutRunnable = Runnable {
            if (resultSent[0]) return@Runnable
            resultSent[0] = true
            try {
                ServiceSdkCommandV2.unregisterPowerStateListener(callback)
            } catch (_: Exception) {}
            android.util.Log.w("AizoPower", "getCurrentPowerState 超时，SDK 未回调，返回 null")
            result.success(null)
        }

        connectionHandler.postDelayed(timeoutRunnable!!, 3000)

        try {
            ServiceSdkCommandV2.registerPowerStateListener(callback)
            ServiceSdkCommandV2.getInstantPowerState()
        } catch (e: Exception) {
            if (!resultSent[0]) {
                resultSent[0] = true
                timeoutRunnable?.let { connectionHandler.removeCallbacks(it) }
                android.util.Log.e("AizoPower", "调用 getInstantPowerState 异常", e)
                try { ServiceSdkCommandV2.unregisterPowerStateListener(callback) } catch (_: Exception) {}
                result.error("SDK_CALL_FAILED", "获取电池状态失败：${e.message}", null)
            }
        }
    }


}

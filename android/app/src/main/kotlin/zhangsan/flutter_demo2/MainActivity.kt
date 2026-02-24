package zhangsan.flutter_demo2
import android.os.Bundle
import android.util.Log
import com.eiot.aizo.sdk.callback.AizoDeviceConnectCallback
import com.eiot.ringsdk.ServiceSdkCommandV2
import com.eiot.ringsdk.battery.PowerState
import com.eiot.ringsdk.callback.BCallback
import com.eiot.ringsdk.callback.PowerStateCallback
import com.eiot.ringsdk.ext.logIx
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
//import android.util.Log
import android.os.Handler
import android.os.Looper
import com.blankj.utilcode.util.ToastUtils
import com.eiot.aizo.ext.otherwise
import com.eiot.aizo.ext.yes
import com.eiot.ringsdk.be.DeviceManager
import com.eiot.ringsdk.score.ActivityGoalsCallback

class MainActivity : FlutterActivity() {

    companion object {
        private const val TAG = "AIZO_SDK"
        private const val METHOD_CHANNEL = "com.zhangsan/aizo_ring"      // 方法通道
        private const val EVENT_CHANNEL = "com.zhangsan/aizo_ring/events" // 事件通道（管道）
    }

    // 用于给 Flutter 发送实时事件
    private var eventSink: EventChannel.EventSink? = null
    private var powerStateListener: PowerStateCallback? = null

    // AIZO SDK 蓝牙连接回调（直接对接文档里的三个方法）
    private val connectCallback = object : AizoDeviceConnectCallback {
        override fun connect() {
            Log.i(TAG, "🔗 设备已连接")
            eventSink?.success(mapOf(
                "event" to "connect",
                "status" to "connected",
                "message" to "设备连接成功"
            ))
        }



        override fun disconnect() {
            Log.i(TAG, "❌ 设备已断开")
            eventSink?.success(mapOf(
                "event" to "disconnect",
                "status" to "disconnected",
                "message" to "设备已断开"
            ))
        }

        override fun connectError(throwable: Throwable, state: Int) {
            Log.e(TAG, "❌ 连接失败")
            eventSink?.success(mapOf(
                "event" to "connectError",
                "status" to "error",
                "message" to "连接出错"
            ))
        }
    }

    // 新增：标记是否已注册，避免重复
    private var isCallbackRegistered = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.i(TAG, "🎉 MainActivity onCreate 执行")
    }

    /**
     * Flutter 引擎配置 → 注册「管道函数」
     */
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // ==================== 1. MethodChannel（Flutter 调用原生） ====================
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "connect" -> {

                        val mac = call.argument<String>("mac")
                        if (mac.isNullOrBlank()) {
                            result.error("INVALID_ARGUMENT", "mac 地址不能为空", null)
                            return@setMethodCallHandler
                        }

                        try {
                            // 【关键修复】每次都先 remove，保证永远只有一个实例
                            ServiceSdkCommandV2.removeCallback(connectCallback)
                            ServiceSdkCommandV2.addCallback(connectCallback)
                            isCallbackRegistered = true
                            Log.i(TAG, "✅ connectCallback 已注册（先remove再add，防重复）")

                            ServiceSdkCommandV2.connect(mac)
                            result.success(true)
                        }catch (e: Exception) {
                            Log.e(TAG, "❌ connect 调用失败", e)
                            result.error("CONNECT_FAILED", e.message, null)
                        }
                    }

                    // ==================== 新增：notifyBoundDevice ====================
                    "notifyBoundDevice" -> {
                        val deviceName = call.argument<String>("deviceName") ?: ""
                        val deviceMac = call.argument<String>("deviceMac") ?: ""

                        // 两个参数都是必填（按文档要求）
                        if (deviceName.isBlank() || deviceMac.isBlank()) {
                            result.error("INVALID_ARGUMENT", "deviceName 和 deviceMac 都不能为空", null)
                            return@setMethodCallHandler
                        }

                        try {
                            ServiceSdkCommandV2.notifyBoundDevice(
                                deviceName = deviceName,
                                deviceMac = deviceMac,
                                callback = object : BCallback {
                                    override fun result(r: Boolean) {
                                        val eventData = mapOf(
                                            "event" to "notifyBoundDeviceResult",   // 事件名称，可自定义
                                            "success" to r,
                                            "status" to if (r) "success" else "failed",
                                            "message" to if (r) "SDK 绑定通知成功" else "SDK 绑定通知失败"
                                        )
                                        eventSink?.success(eventData)   // 通过你已有的 EventChannel 推送结果

                                        Log.i(TAG, "✅ notifyBoundDevice 回调结果: $r")
                                    }
                                }
                            )

                            // 立即告诉 Flutter：调用已成功发起（和你的 connect 逻辑保持一致）
                            result.success(true)
                            Log.i(TAG, "🚀 已调用 notifyBoundDevice → name=$deviceName, mac=$deviceMac")
                        } catch (e: Exception) {
                            Log.e(TAG, "❌ notifyBoundDevice 调用失败", e)
                            result.error("NOTIFY_BOUND_DEVICE_FAILED", e.message ?: "未知错误", null)
                        }
                    }


                    "deviceSet" -> {
                        val type = call.argument<Int>("type") ?: -1

                        if (type !in listOf(1, 2, 4)) {
                            result.error("INVALID_ARGUMENT", "type 参数必须是 1、2 或 4", null)
                            return@setMethodCallHandler
                        }

                        try {
                            ServiceSdkCommandV2.deviceSet(
                                type,
                                callback = object : BCallback {
                                    override fun result(r: Boolean) {
                                        val action = when (type) {
                                            1 -> "恢复出厂设置"
                                            2 -> "解绑戒指"
                                            4 -> "重启戒指"
                                            else -> "未知操作"
                                        }

                                        val eventData = mapOf(
                                            "event" to "deviceSetResult",
                                            "type" to type,
                                            "success" to r,
                                            "status" to if (r) "success" else "failed",
                                            "message" to if (r) "$action 成功" else "$action 失败"
                                        )

                                        eventSink?.success(eventData)

                                        Log.i(TAG, "✅ deviceSet(type=$type) 回调结果: $r")
                                    }
                                }
                            )

                            // 立即返回给 Flutter：指令已下发
                            Log.i(TAG, "🚀 已调用 deviceSet(type=$type)")
                            result.success(true)
                        } catch (e: Exception) {
                            Log.e(TAG, "❌ deviceSet(type=$type) 调用失败", e)
                            result.error("DEVICE_SET_FAILED", e.message ?: "设备操作失败", null)
                        }
                    }

                    // ==================== 2.1.6.3 获取实时电池状态（严格按图片实现） ====================
                    // ==================== 2.1.6.3 获取实时电池状态（完全按图片实现） ====================
                    "getInstantPowerState" -> {
                        try {
                            // 100% 还原图片写法：DeviceManager.isConnect().yes { } .otherwise { }
                            DeviceManager.isConnect().yes {
                                ServiceSdkCommandV2.getInstantPowerState()   // ← 无参数（SDK 实际签名）
                                result.success(true)   // 指令已下发（和你的 connect / deviceSet / notifyBoundDevice 风格一致）
                                Log.i(TAG, "🚀 已触发获取实时电量")
                            }.otherwise {
                                // 使用硬编码字符串，避免 R.string.str_device_connect_tip 未定义
                                ToastUtils.showLong("设备未连接，请先连接设备")
                                result.error("DEVICE_NOT_CONNECTED", "设备未连接", null)
                            }
                        } catch (e: Exception) {
                            Log.e(TAG, "❌ getInstantPowerState 调用失败", e)
                            result.error("GET_INSTANT_POWER_FAILED", e.message ?: "未知错误", null)
                        }
                    }


                    // ==================== 2.2.3 获取当前活动目标（最终干净版） ====================
                    "getCurrentActivityGoals" -> {
                        try {
                            ServiceSdkCommandV2.getCurrentActivityGoals(object : com.eiot.ringsdk.score.ActivityGoalsCallback {
                                override fun ActivityGoals(bean: com.eiot.ringsdk.score.ActivityGoals) {
                                    // 真实字段映射（解决文档与 SDK 不一致）
                                    Log.i(TAG, "📊 ActivityGoals 真实字段 → stepGoals=${bean.stepGoals}, caloriesGoals=${bean.caloriesGoals}, distanceGoals=${bean.distanceGoals}")

                                    val data = mapOf<String, Any>(
                                        "stepGlobal"     to (bean.stepGoals ?: 8000),        // 文档要求的 key
                                        "distanceGlobal" to (bean.distanceGoals ?: 5000.0), // 单位：千米
                                        "caloriesGlobal" to (bean.caloriesGoals ?: 300)      // 单位：千卡
                                    )

                                    Handler(Looper.getMainLooper()).post {
                                        result.success(data)
                                    }

                                    Log.i(TAG, "✅ 当前活动目标已返回给 Flutter")
                                }
                            })

                            Log.i(TAG, "🚀 已发起 getCurrentActivityGoals 请求")
                        } catch (e: Exception) {
                            Log.e(TAG, "❌ getCurrentActivityGoals 调用失败", e)
                            result.error("GET_ACTIVITY_GOALS_FAILED", e.message ?: "未知错误", null)
                        }
                    }

                    else -> {
                        result.notImplemented()
                    }
                }
            }

        // ==================== 2. EventChannel（原生推送给 Flutter） ====================
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                    Log.i(TAG, "📡 EventChannel 已监听，准备推送连接状态")
                    registerPowerStateListener()   // ← 重点：在这里注册电池
                }

                override fun onCancel(arguments: Any?) {
                    eventSink = null
                    Log.i(TAG, "📴 EventChannel 已取消")
                }
            })

    }
    // ====================== 电池状态监听（完全按你截图实现） ======================
    private fun registerPowerStateListener() {
        powerStateListener = object : PowerStateCallback {
            override fun PowerState(bean: PowerState) {
                bean.toString().logIx("电量信息")   // 你原来的日志

                val data = mapOf<String, Any>(
                    "event" to "powerState",
                    "electricity" to (bean.electricity ?: 0),
                    "workingMode" to (bean.workingMode ?: 0),
                    "status" to when (bean.workingMode) {
                        0 -> "未充电"
                        1 -> "充电中"
                        else -> "未知"
                    }
                )

                // 主线程发送（EventChannel 必须主线程）
                Handler(Looper.getMainLooper()).post {
                    eventSink?.success(data)
                }

                Log.i(TAG, "🔋 电池更新已发送 → ${bean.electricity}% | mode=${bean.workingMode}")
            }
        }

        ServiceSdkCommandV2.registerPowerStateListener(powerStateListener!!)
        Log.i(TAG, "✅ 戒指电池状态监听器注册成功（充电状态变化或电量>10%变化时自动回调）")
    }
    // ==================== 【修复2】页面销毁时移除 callback ====================
    override fun onDestroy() {
        super.onDestroy()
        if (isCallbackRegistered) {
            ServiceSdkCommandV2.removeCallback(connectCallback)  // ← 加上这行
            isCallbackRegistered = false
            Log.i(TAG, "🗑️ connectCallback 已移除")
        }
        // powerStateListener 也可以在这里移除
        powerStateListener?.let {
            ServiceSdkCommandV2.unregisterPowerStateListener(it)
        }
    }
}
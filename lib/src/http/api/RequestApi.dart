import 'package:flutter/foundation.dart';

/// API constants for the application
class RequestApi {
  // 根据构建模式自动选择环境
  static String get baseurl {
    if (kDebugMode) {
      // 调试模式：使用开发环境
      return 'http://192.168.1.85:5000';
    } else {
      // 发布模式：使用生产环境
      return 'https://api.worker-man.com';
    }
  }

  //注册
  static String get register => '$baseurl/auth/register';

  //密码登录
  static String get loginPassword => '$baseurl/auth/login/password';

  //短信登录
  static String get loginSms => '$baseurl/auth/login/sms';

  //登出
  static String get logout => '$baseurl/auth/logout';

  //获取验证码
  static String get getCode => '$baseurl/auth/sms/send';

  //获取图形验证码
  static String get getCaptcha => '$baseurl/auth/captcha';

  //修改密码
  static String get changePassword => '$baseurl/api/user/password';

  //忘记密码
  static String get resetPassword => '$baseurl/auth/reset_password';

  //修改个人信息(PUT)  获取个人信息(GET)
  static String get editUserInfo => '$baseurl/api/user/profile';

  //AI员工 - 发送对话信息
  static String get sendMessage => '$baseurl/api/chat';

  //AI员工 - 创建会话(POST)  获取会话列表(GET)
  static String get createSessions => '$baseurl/api/sessions';

  //AI员工 - 获取会话详情信息
  static String getSessionDetail(String sessionId) =>
      "$baseurl/api/sessions/$sessionId/messages";

  //AI员工 - 删除会话(DELETE)
  static String deleteSession(String sessionId) =>
      "$baseurl/api/sessions/$sessionId";

  //AI员工 - 中断对话
  static String get interruptDialogue => '$baseurl/api/interrupt';

  //语言模型 - 充值余额
  static String get rechargeBalance => '$baseurl/api/payment/recharge';

  //语言模型 - 创建会话(POST) 获取会话列表(GET)
  static String get createChatSessions => '$baseurl/api/chat/sessions';

  //语言模型 - 发送对话
  static String get sendChatCompletion => '$baseurl/api/chat/completion';

  //语言模型 - 获取会话详情
  static String getChatSessionsDetail(String sessionsId) =>
      '$baseurl/api/chat/sessions/$sessionsId/messages';

  //语言模型 - 删除会话
  static String deleteChatSessions(String sessionsId) =>
      '$baseurl/api/chat/sessions/$sessionsId';

  //语言模型 - 中断对话
  static String get interruptChatDialogue => '$baseurl/api/chat/interrupt';

  //查询订单状态
  static String getOrderStatus(String orderId) =>
      '$baseurl/api/pay/query/$orderId';

  //关闭订单
  static String closeOrder(String orderId) => '$baseurl/api/pay/close/$orderId';

  //查询用户余额
  static String get getUserBalance => '$baseurl/api/user/balance';

  //查询任务执行状态
  static String get getTaskStatus => '$baseurl/api/purchased-files';

  //获取文件下载链接
  static String getFileDownloadUrl(int purchasedChatId) =>
      '$baseurl/api/purchased-files/$purchasedChatId/download';

  //创建支付订单
  static String get createPayOrder => '$baseurl/api/pay/create';

  // 支付相关接口
  static String queryOrder(String orderId) => '$baseurl/api/pay/query/$orderId';

  // 图片生成相关接口
  //图片生成请求接口
  static String get generateImage => '$baseurl/api/kling/image';

  //获取任务结果接口
  static String getTaskResult(int taskId) => '$baseurl/api/kling/tasks/$taskId';

  // 图像/视频生成会话管理接口（32-34号接口）
  //获取图像/视频生成会话列表接口
  static String get getKlingSessions => '$baseurl/api/kling/sessions';

  //获取图像/视频生成会话详情接口
  static String getKlingSessionDetail(int klingId) =>
      '$baseurl/api/kling/sessions/$klingId';

  //创建图像/视频生成会话接口
  static String get createKlingSessions => '$baseurl/api/kling/sessions';

  //文字生成视频请求接口（31号接口）
  static String get generateVideo => '$baseurl/api/kling/video/text2video';

  //图像合成请求接口（35号接口 - AI换装）
  static String get virtualTryOn => '$baseurl/api/kling/virtual-try-on';

  //AI开发获取定价请求接口（36号接口）
  static String get getPayPreview => '$baseurl/api/pay/preview';

  //图片转视频请求接口（37号接口）
  static String get imageToVideo => '$baseurl/api/kling/video/image2video';

  //删除图像/视频生成会话接口（38号接口）
  static String deleteKlingSession(int klingSessionId) =>
      '$baseurl/api/kling/sessions/$klingSessionId';

  //获取可灵资产列表接口（39号接口）
  static String get klingAssets => '$baseurl/api/kling/results';

  //视频拓展请求接口（40号接口）
  static String get videoExtend => '$baseurl/api/kling/video/video-extend';

  //唇形同步请求接口（41号接口）
  static String get lipSync => '$baseurl/api/kling/lip-sync';

  //查询任务执行状态接口（18号接口）
  static String get purchasedFiles => '$baseurl/api/purchased-files';

  //获取新版本信息接口（42号接口）
  static String get appVersion => '$baseurl/api/app/version';

  //获取版本下载文件接口（43号接口）
  static String appDownload(String version) =>
      '$baseurl/api/app/download/$version';

  //获取可用的大模型接口（44号接口）
  static String get llmModels => '$baseurl/api/llm/models';

  //用户注销账号接口（45号接口）
  static String get deleteUserAccount => '$baseurl/api/user/delete';

  /// 根据环境拼接完整的缩略图URL
  /// [thumbnailPath] 缩略图相对路径，如 "/static/thumbnails/thumb_183_1751868483.jpg"
  /// 返回完整的缩略图URL
  static String getFullThumbnailUrl(String? thumbnailPath) {
    if (thumbnailPath == null || thumbnailPath.isEmpty) {
      return '';
    }

    // 如果已经是完整URL，直接返回
    if (thumbnailPath.startsWith('http://') ||
        thumbnailPath.startsWith('https://')) {
      return thumbnailPath;
    }

    // 根据环境拼接完整URL
    return '$baseurl$thumbnailPath';
  }

  /// 获取当前环境信息（用于调试）
  static String get currentEnvironment {
    return kDebugMode ? 'Development' : 'Production';
  }

  /// 打印当前使用的API环境（用于调试）
  static void printCurrentEnvironment() {
    print('🌐 当前API环境: $currentEnvironment');
    // print('🔗 API Base URL: $baseurl');
  }
}

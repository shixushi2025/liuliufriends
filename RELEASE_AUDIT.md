# 发布前审查记录

审查日期：2026-05-30
版本：0.30
Bundle ID：`baby.dudou.liuliufriends`

## 结论

当前 App 工程、官网源码、隐私说明和上架元数据已经达到可提交 App Store Connect 的工程准备状态。仍需要在 App Store Connect 后台完成证书签名、截图上传、隐私问卷、年龄分级问卷和最终人工真机检查。

## 本次已修复

- 移除 0.30 版本未开放功能对应的 `NSMicrophoneUsageDescription`，并从本版二进制移除 `AVAudioRecorder` / `requestRecordPermission` 录音实现，避免“未使用麦克风”和静态扫描结果不一致。
- 官网源码将邮箱从 `mailto:hello@dudou.baby` 改为文本 `hello [at] dudou.baby`，避免 Cloudflare Email Obfuscation 自动注入脚本，保持官网静态、无分析脚本。

## 已验证

- App 名称：`肚兜启蒙`。
- Bundle ID：`baby.dudou.liuliufriends`。
- 版本号：`0.30`，Build：`1`。
- 支持设备：iPhone、iPad。
- iPhone 方向：竖屏。
- iPad 方向：横屏；`UIRequiresFullScreen = YES`。
- App Icon：1024×1024，`hasAlpha: no`。
- 隐私清单：`NSPrivacyTracking = false`，`NSPrivacyCollectedDataTypes = []`，仅声明 `UserDefaults` required reason API。
- 最终 Release App `Info.plist` 未包含 `NSMicrophoneUsageDescription`、`NSUserTrackingUsageDescription` 等敏感权限说明。
- 最终 Release 二进制未发现 `AVAudioRecorder`、`requestRecordPermission`、`playAndRecord`、`NSMicrophoneUsageDescription` 字符串。
- 未发现 `URLSession`、`WKWebView`、`StoreKit`、`AdSupport`、`AppTrackingTransparency`、定位、相机、照片、通知、通讯录、剪贴板等敏感能力使用。
- 未发现仓库内 GitHub token、OpenAI key、AWS key、私钥等明显密钥模式。
- 官网源码无第三方分析、广告、Cookie 脚本；包含中英文首页、中英文隐私政策、`robots.txt`、`sitemap.xml` 和 Cloudflare Pages `_headers`。
- 线上 `https://dudou.baby/`、`https://dudou.baby/privacy.html`、`https://dudou.baby/en/`、`https://dudou.baby/en/privacy.html` 可访问。
- 线上隐私政策页已确认不含 Cloudflare Email Obfuscation 注入脚本。
- iPhone 16 模拟器可安装并启动，首屏截图 `/tmp/liuliu-iphone16-start.png` 已人工检查无明显安全区遮挡。

## 验证命令

```bash
xcodebuild test -project LiuliuFriends.xcodeproj -scheme LiuliuFriends -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.2'
xcodebuild build -project LiuliuFriends.xcodeproj -scheme LiuliuFriends -configuration Release -destination 'generic/platform=iOS' CODE_SIGNING_ALLOWED=NO
xcodebuild archive -project LiuliuFriends.xcodeproj -scheme LiuliuFriends -configuration Release -destination 'generic/platform=iOS' -archivePath /tmp/LiuliuFriends-AppStoreCheck.xcarchive CODE_SIGNING_ALLOWED=NO SKIP_INSTALL=NO
```

结果：测试通过，Release 构建通过，无签名 archive 通过，`Validate ... -validate-for-store` 通过。

## App Store Connect 建议填写

- 隐私问卷：不收集数据；不追踪；无第三方广告；无第三方分析 SDK。
- 麦克风：0.30 不开放家长录音入口，工程不声明麦克风权限，问卷按不使用麦克风填写。
- 年龄分级：建议 `4+`；无暴力、成人内容、UGC、不受限制网页访问、位置共享、赌博、医疗内容。
- 类别：优先 `教育`；如后台可选 Kids Category，需要继续保持无广告、无追踪、无儿童可误触外链。
- 审核备注：说明无账号、无广告、无内购、无网络请求；首次语音需点击开始后播放；家长设置可控制音效、语音、自动下一题、休息提醒、护眼模式、减少动画和玩法开关。

## 仍需人工完成

- 在 App Store Connect 选择正确 Bundle ID、Team、证书和 Provisioning Profile。
- 上传 iPhone 和 iPad 截图并人工确认无文字遮挡、无安全区问题。
- 真机检查：声音开关、语音提示、休息提醒、护眼模式、自动下一题、减少动画、玩法开关、iPhone 竖屏、iPad 横屏。
- 确认 `hello@dudou.baby` 可以真实收信。

## 后续变更红线

如果加入网络请求、崩溃日志 SDK、统计分析 SDK、广告 SDK、账号、云同步、推送通知、外链、内购、麦克风录音入口或服务端日志，需要同步更新隐私政策、App Store Connect 隐私问卷、权限说明和审核备注。

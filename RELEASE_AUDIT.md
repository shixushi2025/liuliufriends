# 发布前审查记录

审查日期：2026-05-30

## 结论

当前代码结构、隐私实现、网站静态页面和基础测试情况接近可提交 App Store。送审前仍需要在真实 App Store Connect 环境完成签名、截图、隐私问卷、年龄分级和隐私政策线上可访问性确认。

## 已验证

- App 无账号、无广告、无内购、无网络请求。
- 未发现 `URLSession`、`WKWebView`、`StoreKit`、`AdSupport`、`AppTrackingTransparency`、定位、相机、照片、通知等敏感 API 使用。
- 未发现仓库内 GitHub token、OpenAI key、AWS key、私钥等明显密钥模式。
- iPhone 使用竖屏；iPad 使用横屏并声明 `UIRequiresFullScreen`，避免 iPad 方向支持上架警告。
- Release 真机构建通过：`xcodebuild build -project LiuliuFriends.xcodeproj -scheme LiuliuFriends -configuration Release -destination 'generic/platform=iOS' CODE_SIGNING_ALLOWED=NO`
- 单元测试通过：`xcodebuild test -project LiuliuFriends.xcodeproj -scheme LiuliuFriends -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.2'`
- 官网为静态 HTML/CSS，无 JS 分析脚本、无 Cookie、无第三方广告脚本。
- 官网包含中文/英文首页、中文/英文隐私政策、`robots.txt`、`sitemap.xml` 和 Cloudflare Pages `_headers`。

## 仍需人工确认

- `https://dudou.baby/privacy.html` 已部署并公网可访问。
- `hello@dudou.baby` 可以真实收信。
- App Store Connect 中 Bundle ID、Team、证书和 Provisioning Profile 正确。
- App Store Connect 隐私问卷填写“未收集数据”，并注明麦克风仅用于家长本地录音、不上传。
- 年龄分级问卷按无暴力、无成人内容、无 UGC、无网页访问、无定位共享填写。
- iPhone 6.7、iPhone 6.5、iPad 13、iPad 12.9 所需截图全部生成并人工检查无遮挡。
- 真机上验证声音开关、语音提示、家长录音、休息提醒、护眼模式、自动下一题、减少动画、iPad 横屏和 iPhone 竖屏。

## 后续变更红线

如果加入网络请求、崩溃日志 SDK、统计分析 SDK、广告 SDK、账号、云同步、推送通知、外链、内购或服务端日志，需要同步更新隐私政策、App Store Connect 隐私问卷和审核备注。

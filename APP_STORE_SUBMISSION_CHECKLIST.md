# App Store Connect 提交清单

版本：0.30  
App 名称：肚兜启蒙  
Bundle ID：`baby.dudou.liuliufriends`  
官网：`https://dudou.baby/`  
隐私政策：`https://dudou.baby/privacy.html`

## 1. App 信息

- App 名称：`肚兜启蒙`
- 副标题：`宝宝早教认颜色形状动物`
- 主要语言：简体中文
- 类别：教育
- 第二类别：儿童或游戏；如果后台只能选普通类别，优先教育
- 价格：免费
- SKU：`dudou-liuliu-friends-ios`
- 版权：`© 2026 Dudou Baby`

## 2. 隐私问卷

按 0.30 当前二进制填写：

- 是否收集用户数据：否
- 是否用于追踪：否
- 是否包含第三方广告：否
- 是否包含第三方分析 SDK：否
- 是否需要账号：否
- 是否使用定位：否
- 是否使用相机：否
- 是否使用照片：否
- 是否使用通讯录：否
- 是否使用麦克风：否
- 是否有网络请求或服务端上传：否

说明：0.30 已从二进制移除麦克风录音实现和权限请求，隐私清单只声明 UserDefaults required reason API。

## 3. 年龄分级问卷

建议结果：`4+`

按当前内容填写：

- 卡通或幻想暴力：无
- 真实暴力：无
- 成人或性内容：无
- 恐怖/惊悚：无
- 医疗/治疗信息：无
- 赌博/竞赛：无
- 酒精/烟草/药物：无
- 用户生成内容：无
- 不受限制网页访问：无
- 位置共享：无

## 4. App Review 信息

### 登录

不需要登录。

### 审核备注

本应用为儿童启蒙配对游戏，App 名称为「肚兜启蒙」，当前小游戏为「六六找朋友」。无账号登录、无广告、无内购、无网络请求。主要功能包括动物识别、声音配对、颜色识别、形状认知、大小比较和影子匹配。进入游戏后需要点击「开始玩」才会播放第一条语音提示。家长设置页可关闭音效、语音提示、自动下一题、休息提醒、护眼模式、减少动画和具体玩法类别。

### 联系信息

- 邮箱：`hello@dudou.baby`
- 电话：填写可接听电话
- 姓名：填写开发者真实姓名

## 5. 截图必须人工确认

至少准备：

- iPhone 6.7 英寸：开始页、动物/声音、颜色/形状、设置页
- iPhone 6.5 英寸：按 App Store Connect 要求补齐
- iPad 13 英寸：横屏开始页、玩法页、设置页
- iPad 12.9 英寸：按 App Store Connect 要求补齐

截图检查标准：

- 无文字被安全区、灵动岛、底部 Home Indicator 遮挡
- 设置页手机端内容不超宽
- iPad 横屏不出现异常偏移
- App Icon 显示无白边、无透明通道
- 页面中没有“录音”“麦克风”“内购”“登录”等 0.30 未开放内容

## 6. 上传前最后命令

```bash
xcodebuild test -project LiuliuFriends.xcodeproj -scheme LiuliuFriends -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.2'
xcodebuild archive -project LiuliuFriends.xcodeproj -scheme LiuliuFriends -configuration Release -destination 'generic/platform=iOS' -archivePath /tmp/LiuliuFriends-AppStoreCheck.xcarchive CODE_SIGNING_ALLOWED=NO SKIP_INSTALL=NO
```

真正上传时需要用 Xcode Organizer 或 App Store Connect API 使用正式 Apple Developer 签名归档上传。

## 7. 人工确认项

- Apple Developer 后台 Bundle ID 存在且为 `baby.dudou.liuliufriends`
- App Store Connect App 已选择正确 Bundle ID
- 证书和 Provisioning Profile 有效
- `hello@dudou.baby` 可收信
- `https://dudou.baby/privacy.html` 可访问
- TestFlight 包上传后无 ITMS 隐私/权限警告

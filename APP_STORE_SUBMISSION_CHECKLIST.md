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

本应用为儿童启蒙配对游戏，App 名称为「肚兜启蒙」，当前小游戏为「六六找朋友」。无账号登录、无广告、无内购、无网络请求。主要功能包括动物识别、声音配对、颜色识别、形状认知、大小比较、影子匹配、数量认知、位置认知和分类认知。进入游戏后需要点击「开始玩」才会播放第一条语音提示。家长设置页可关闭音效、语音提示、自动下一题、休息提醒、护眼模式、减少动画和具体玩法类别。

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

## 8. 本轮 iPhone / iPad 检查记录

- iPhone 休息提示：已修复小屏文字超出问题，弹窗宽度、字号、行数和按钮高度会按短屏压缩。
- iPhone 休息提示：已改为内容自适应高度，避免卡片在 iPhone SE 上出现大面积空白。
- iPhone 首屏语音：进入 App 先显示「开始玩」，点击后才播放第一条“找……”语音，避免打开 App 突然出声。
- iPhone 顶部控件：积分、设置入口已按安全区布局，仍需真机复查刘海/灵动岛机型。
- iPad 横屏：已检查本轮休息提示相关改动，横屏未发现文字溢出或弹窗异常。
- iPad 截图：App Store Connect 需要使用后台要求的 iPad 尺寸；截图必须来自当前最终 build。

## 9. App Store Connect 填写补充

- App Icon / Logo：Connect 不单独设置 Logo，图标来自所选 build 内的 `Assets.xcassets/AppIcon.appiconset`。
- Build 选择：Archive 上传并处理完成后，在版本页 `Build` 区域点 `Add Build` / `Select a build`，选择最新 build 后才能提交审核。
- Xcode Archive：打包本地工作区当前文件，不按 Git commit 打包；`Assets.xcassets` 当前图片资源会进入包内。
- 加密合规：当前 0.30 未实现自定义加密或自行实现标准加密，`App Encryption Documentation` 选择 `None of the algorithms mentioned above`。
- 年龄分级：当前问卷计算结果建议保持 `4+`；如使用儿童类目，继续保持无广告、无追踪、无儿童可误触外链。
- 内容权利：当前素材如均为自有/生成并已授权使用，可选择不包含、展示或访问第三方内容。

## 10. 备案 / 平台资料留档

以下信息用于域名、应用市场或应用备案材料整理，提交前按实际后台字段核对：

| 字段 | 当前建议 |
| --- | --- |
| App 名称 | 肚兜启蒙 |
| 当前小游戏名称 | 六六找朋友 |
| Bundle ID | `baby.dudou.liuliufriends` |
| 官网域名 | `dudou.baby` |
| 官网 URL | `https://dudou.baby/` |
| 隐私政策 URL | `https://dudou.baby/privacy.html` |
| 支持邮箱 | `hello@dudou.baby` |
| 版本 | `0.30` |
| 平台 | iOS，支持 iPhone / iPad |
| 内容分类 | 儿童启蒙、早教认知、教育游戏；如果后台只有普通分类，优先选教育，其次游戏或工具 |
| 主要功能 | 动物、声音、颜色、形状、大小、影子、数量、位置和分类配对认知 |
| 用户体系 | 无账号注册、无登录 |
| 数据收集 | 不收集用户数据，不追踪 |
| 网络能力 | 当前 App 主要本地运行，无业务服务端请求 |
| 广告/内购 | 当前无广告、无内购 |
| 证书 SHA-1 | 应为 40 位十六进制字符，不能包含冒号、空格或非十六进制字符 |
| 公钥信息 | 以备案后台要求为准，通常从 Apple 签名证书导出；提交前确认对应当前发布证书 |

备案材料注意：

- SHA-1 如果后台提示格式错误，优先检查是否复制了冒号分隔格式；备案字段通常要填写连续 40 位十六进制。
- 公钥、SHA-1、Bundle ID 必须对应实际用于发布的证书和 App 标识，不能用模拟器、本地调试证书或旧证书。
- 若后续加入账号、云同步、统计、广告、推送、录音上传或服务端日志，需要同步更新备案说明、隐私政策和 App Store 隐私问卷。

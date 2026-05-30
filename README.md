# 肚兜游戏 - 六六找朋友

这是一个 SwiftUI iOS/iPadOS 原型项目，面向 1-2 岁婴幼儿。

## 定位

- 系列品牌：肚兜游戏
- 首款游戏：六六找朋友
- 目标设备：iPad 优先，兼容 iPhone
- 目标年龄：1-2 岁

## 第一版玩法

游戏采用单屏循环，不做分数、失败、倒计时。

1. 颜色朋友：帮六六找到同颜色的朋友。
2. 影子朋友：把小动物放到自己的影子上。
3. 声音朋友：听声音，点出对应动物。
4. 大小朋友：帮小伙伴找到同样大小的家。

## 当前功能完整性

- 首页游戏循环：已完成
- 设置页：已完成，支持音效、语音提示、家长录音、自动下一题、休息提醒、护眼模式、减少动画
- 家长设置：已完成，包含设置开关、隐私、网络、广告和内容说明
- 角色系统：已完成六六普通状态、开心状态和图标概念
- 测试：已加入 `LiuliuFriendsTests`
- 正式素材：已接入 App 图标、六六、小猫小狗和常见动物/水果/车辆/物品图片
- 语音系统：默认使用系统 TTS，可由家长为当前目标录制本地自定义读音

## 角色设定

- 系列品牌：肚兜游戏
- 主角：六六
- 造型：穿红肚兜的圆圆小宝宝，偏玩偶感，不做真实婴儿
- 性格：好奇、开心、爱找朋友
- 反馈：点对时开心拍手/跳跳，点错时温和提醒，不批评孩子
- 图标方向：六六大头 + 红肚兜，不在图标内放完整游戏名

## 运行

用 Xcode 打开 `LiuliuFriends.xcodeproj`，选择 iPad 或 iPhone 模拟器运行。

推荐验证命令：

```bash
xcodebuild test -project LiuliuFriends.xcodeproj -scheme LiuliuFriends -destination 'platform=iOS Simulator,name=iPad (10th generation)'
```

在 `LiuliuFriends/Views/CharacterViews.swift` 里有两个 Xcode Preview：

- 六六角色：普通状态和开心状态
- 图标概念：六六头像 + 红肚兜的 App 图标方向

## 后续适合补充

- 按 `DESIGN_BRIEF.md` 重新设计正式 UI、角色和多玩法视觉系统
- 替换 SwiftUI 矢量插画为正式 PNG/SVG 资源
- 增加真人录制中文语音提示
- 增加更多动物、水果、形状和大小匹配
- 增加 App Store 截图和更多设备人工验收记录

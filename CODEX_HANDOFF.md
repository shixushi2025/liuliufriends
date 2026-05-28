# Codex 交接文档：肚兜游戏 / 六六找朋友

这份文档给另一台电脑上的 Codex 使用。请先阅读本文件，再阅读 `README.md`、`PRIVACY.md`、`TESTING.md` 和 Swift 源码。

## 项目定位

- 系列品牌：肚兜游戏
- 首款游戏：六六找朋友
- 平台：iOS / iPadOS，SwiftUI
- 目标设备：iPad 优先，兼容 iPhone
- 目标年龄：1-2 岁婴幼儿
- 产品原则：单屏、少目标、大触控、即时反馈、无失败惩罚、无广告、无内购、无账号

## 命名与品牌决策

- 系列名使用“肚兜游戏”，用于承载后续多款低龄启蒙游戏。
- 首款游戏名使用“六六找朋友”。
- “六六”是第一主角，不是整个系列的唯一品牌限制。
- 桌面 App 显示名可以用“六六找朋友”，5 个中文字可接受。
- App 图标不建议放完整文字，建议只放六六头像和红肚兜视觉。
- 域名讨论结果：系列官网优先考虑 `dudoukids.com`，备选 `dudouplay.com`。

## 角色设定

主角：六六

- 形象：穿红肚兜的圆圆小宝宝，偏玩偶感，不做真实婴儿
- 视觉：暖黄色/米色身体、红肚兜、圆脸、大眼睛、小短手、温和表情
- 性格：好奇、开心、爱找朋友
- 交互：点对后开心跳跳/拍手，点错只温和提醒，不批评孩子
- 当前实现：SwiftUI 矢量角色，包含普通状态、开心状态和图标概念组件

## 当前已实现

仓库地址：

```text
https://github.com/shixushi2025/liuliufriends
```

当前主要提交：

- `2abfda8 Initial SwiftUI prototype`
- `ec66827 Complete MVP app structure`

已完成内容：

- SwiftUI Xcode 项目：`LiuliuFriends.xcodeproj`
- 游戏主界面：左侧六六角色，右侧互动区
- 设置页：音效、提示音、自动下一题、减少动画
- 家长区：隐私/网络/广告/内容说明，三击解锁清除进度
- 玩法：
  - 颜色朋友
  - 影子朋友
  - 声音朋友
  - 大小朋友
- 角色：
  - `LiuliuMascot`
  - `LiuliuAppIconConcept`
- 模块化：
  - `GameModels.swift`
  - `GameContent.swift`
  - `GameViewModel.swift`
  - `FeedbackPlayer.swift`
  - `ContentView.swift`
  - `Views/CharacterViews.swift`
- 测试目标：
  - `LiuliuFriendsTests/GameViewModelTests.swift`
- 文档：
  - `README.md`
  - `PRIVACY.md`
  - `TESTING.md`
  - `.gitignore`
  - `.gitattributes`

## 技术约束

用户的通用偏好：

- Java 使用 Java 17
- 前端 Vue3 使用选项式 API
- Java 代码不要使用 stream / Optional

本项目当前是 SwiftUI，不涉及 Java/Vue。

SwiftUI 方向：

- 继续保持 iPad 优先
- 控件要大，适合 1-2 岁
- 不做分数、倒计时、失败惩罚
- 不加入广告、内购、账号、外链
- 不引入不必要的第三方 SDK
- 如果后续加网络、统计、崩溃上报或第三方 SDK，需要同步更新隐私说明

## 安全与隐私

当前设计：

- 无网络请求
- 无账号系统
- 无广告
- 无内购入口
- 无位置、通讯录、相册、麦克风、摄像头权限
- 家长区有三击解锁，避免婴幼儿误触

注意：

- 之前用户曾在聊天中提供过 GitHub token。不要复用聊天里的 token。
- 建议用户撤销旧 token，改用本机 GitHub 登录、SSH key 或新的本地环境变量。

## Mac 上需要验证

当前开发环境是 Windows，无法运行 Xcode，因此需要在 Mac 上验证：

```bash
xcodebuild test -project LiuliuFriends.xcodeproj -scheme LiuliuFriends -destination 'platform=iOS Simulator,name=iPad (10th generation)'
```

如果模拟器名称不同：

```bash
xcrun simctl list devices available
```

人工验收重点：

- Xcode 能否打开项目
- Scheme 是否可见
- App 是否能在 iPad 模拟器运行
- iPad 横屏是否无重叠
- iPhone 竖屏是否可用
- 点对、点错、自动下一题是否正常
- 设置页开关是否生效
- 家长区三击解锁是否正常
- 测试是否通过

## 下一步建议

优先级从高到低：

1. 在 Mac 上修复所有 Xcode 编译或测试问题。
2. 做 iPad/iPhone 多尺寸 UI 打磨，尤其是横屏 iPad 和小屏 iPhone。
3. 把系统提示音替换为正式中文语音和柔和音效。
4. 生成或绘制正式 PNG/SVG 素材，替换当前 SwiftUI 占位插画。
5. 生成正式 App Icon 资源。
6. 增加更多轮次，但每轮仍保持最多 2 个候选。
7. 增加 UI 测试，覆盖设置页、家长区和基础游戏流程。
8. 准备 App Store 上架资料：隐私政策链接、截图、描述、年龄分级。

## 设计判断

对 1-2 岁用户：

- 主操作应以点击为主，轻拖作为后续扩展，不应依赖精细拖拽。
- 每轮最多两个候选。
- 反馈要明确但温和。
- 错误不能用叉号、刺耳声音或失败文案。
- 动画要短、慢、清楚，提供“减少动画”设置。
- 文本不应承担主要引导，后续应使用语音提示。

## 当前不足

这个项目已经比最初原型完整，但还不是可直接上架版本：

- 未在 Xcode 编译验证
- 未在真实 iPad/iPhone 上验证
- 没有正式音频资源
- 没有正式图标和美术资源
- 没有 App Store 截图和隐私政策网页
- UI 测试还未加入
- 当前玩法仍偏 MVP，需要更多真实低龄体验打磨

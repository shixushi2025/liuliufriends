# 测试说明

## 已覆盖

`LiuliuFriendsTests/GameViewModelTests.swift` 覆盖：

- 每轮只有一个正确选项
- 1-2 岁玩法每轮最多两个候选
- 点对后记录完成状态
- 点错后进入重试反馈
- 下一轮切换
- 重置进度回到第一轮

## Mac 上运行

```bash
xcodebuild test -project LiuliuFriends.xcodeproj -scheme LiuliuFriends -destination 'platform=iOS Simulator,name=iPad (10th generation)'
```

如果本机模拟器名称不同，先查看可用设备：

```bash
xcrun simctl list devices available
```

## 人工验收清单

- iPad 横屏：主游戏页没有文字或按钮重叠
- iPhone 竖屏：主要按钮仍然可点，文字没有截断到不可读
- 点对：星星、音效、六六开心状态正常出现
- 点错：候选轻微摇动，不出现失败惩罚
- 设置页：四个开关能即时影响游戏反馈
- 家长区：连续点三下后才显示清除进度
- 无网络：运行时不弹系统权限请求

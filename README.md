# 巨魔应用全局悬浮窗口实现方案

本文档提供巨魔（TrollStore）应用实现**全局悬浮窗口**（含锁屏界面显示）的完整配置及使用步骤，包含可触摸交互与穿透不可触摸两种悬浮窗类型。

## 一、功能介绍

通过配置特殊权限与自定义窗口，实现应用在 iOS 全局（包括主屏幕、应用内、锁屏界面）显示悬浮窗口，支持两种模式：

- **可触摸悬浮窗**：窗口及内部视图支持点击、输入等交互操作。

- **不可触摸穿透悬浮窗**：窗口仅作显示，不拦截底层视图的触摸事件（点击可穿透至下方界面）。

## 二、使用步骤

### 1. 导入头文件

在需要操作悬浮窗口的任意视图类中，导入 AppDelegate 头文件：

```objc

#import "AppDelegate.h"
```

### 2. 获取 AppDelegate 实例

通过 UIApplication 单例获取应用代理对象，用于访问悬浮窗属性：

```objc

AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
```

### 3. 添加视图到可触摸悬浮窗

将自定义视图添加至可触摸悬浮窗，支持交互操作：

```objc

[appDelegate.overlayWindowIsTouch addSubview:你的视图]; // 替换“你的视图”为实际视图对象
```

### 4. 添加视图到不可触摸穿透悬浮窗

将自定义视图添加至不可触摸悬浮窗，仅显示不拦截事件：

```objc

[appDelegate.overlayWindowNoTouch addSubview:你的视图]; // 替换“你的视图”为实际视图对象
```

## 三、权限配置（info.plist）

需在项目的 `info.plist` 中添加以下权限配置，以支持全局悬浮窗显示（含锁屏权限）：

```xml

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.frontboard</key>
    <dict>
        <key>DerivedServiceRestrictions</key>
        <array>
            <string>com.apple.uis.applicationStateService</string>
            <string>com.apple.uis.applicationSupportService</string>
            <string>com.apple.frontboard.layout-monitor</string>
        </array>
        <key>Services</key>
        <dict>
            <key>com.apple.frontboard.system-service</key>
            <dict/>
            <key>com.apple.frontboard.workspace-service</key>
            <dict/>
        </dict>
    </dict>
</dict>
</plist>
```

**说明**：该配置用于获取前端服务权限，是悬浮窗突破应用边界、显示在全局及锁屏的核心前提。

## 四、签名打包（ entitlements.plist ）

编译完成后，需通过项目内的 `entitlements.plist` 进行签名，再打包为 IPA 。核心步骤如下：

### 1. 核心签名脚本

精简后仅需一行脚本，实现签名功能（注意 `-S` 后面无空格）：

```bash

ldid -S<entitlements.plist文件路径> <.app路径>
```

### 2. Xcode 配置示例（可选）

可在项目 `Build Phases > Run Script` 中添加脚本，实现编译后自动签名（示例为打包至 iCloud 云盘，可按需修改路径）：

```bash

# 示例：自动签名并打包IPA至iCloud云盘
APP_PATH="${BUILT_PRODUCTS_DIR}/${TARGET_NAME}.app"
ENTITLEMENTS_PATH="${PROJECT_DIR}/entitlements.plist" # 替换为你的plist路径
IPA_PATH="${HOME}/Library/Mobile Documents/com~apple~CloudDocs/你的文件夹/${TARGET_NAME}.ipa"

# 签名
ldid -S${ENTITLEMENTS_PATH} ${APP_PATH}

# 打包为IPA
mkdir -p "${APP_PATH}/Payload"
cp -R "${APP_PATH}" "${APP_PATH}/Payload/"
zip -r "${IPA_PATH}" "${APP_PATH}/Payload/"
rm -rf "${APP_PATH}/Payload"
```

## 五、注意事项

- 悬浮窗需提前在 AppDelegate 中初始化（如创建 UIWindow 实例，设置 `windowLevel` 为高优先级，确保全局显示）。

- 若悬浮窗内有输入控件（如 UITextField ），需确保窗口开启交互权限（避免重写 `_ignoresHitTest` 并返回 YES ，否则会拦截所有触摸事件）。

- 锁屏显示需确保应用拥有后台运行权限，可在 info.plist 中添加 `UIBackgroundModes` 配置（如 `fetch` 或 `remote-notification` ）。

- 签名时需确保 ldid 工具已安装（可通过 Homebrew 安装：`brew install ldid` ）。

- 不同 iOS 版本（尤其 iOS 15+ ）权限机制可能有差异，需针对性测试适配。

## 六、常见问题

### Q1：悬浮窗无法显示在锁屏界面？

A1：检查 info.plist 权限配置是否完整，同时确保应用处于后台运行状态，且未被系统杀死。

### Q2：悬浮窗无法交互或穿透失效？

A2：确认悬浮窗 UIWindow 的 `userInteractionEnabled` 属性设置正确（可触摸设为 YES ，不可触摸设为 NO ），且未被其他视图遮挡。

### Q3：签名后安装失败？

A3：检查 entitlements.plist 路径是否正确、脚本中 `-S` 后无空格，同时确保 ldid 版本兼容当前 iOS 系统。
> （注：文档部分内容可能由 AI 生成）

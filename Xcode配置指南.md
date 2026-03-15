# PennyWise Xcode 配置指南

本文档提供 PennyWise iOS 应用的 Xcode 配置详细步骤，包括 WidgetKit 和 iCloud Sync 功能。

---

## 目录

1. [项目基础配置](#1-项目基础配置)
2. [WidgetKit 配置](#2-widgetkit-配置)
3. [iCloud Sync 配置](#3-icloud-sync-配置)
4. [验证构建](#4-验证构建)

---

## 1. 项目基础配置

### 1.1 打开项目

1. 打开 Xcode
2. 点击 **File → Open**
3. 选择 `/Volumes/ORICO-APFS/app/PennyWise/PennyWise/PennyWise.xcodeproj`

### 1.2 配置最低部署版本

1. 在项目导航器中选择 **PennyWise** 项目
2. 点击 **Build Settings** 标签
3. 搜索 `iOS Deployment Target`
4. 确保设置为 **iOS 17.0** 或更高

### 1.3 配置 Bundle Identifier

1. 选择 **PennyWise** target
2. 点击 **General** 标签
3. 在 **Identity** 部分确认 Bundle Identifier (例如: `com.pennywise.app`)

---

## 2. WidgetKit 配置

WidgetKit 需要创建独立的 Widget Extension Target。

### 2.1 创建 Widget Extension

**步骤 1: 新建 Target**

1. 在 Xcode 中，点击菜单 **File → New → Target**
2. 在搜索框输入 `Widget Extension`
3. 选择 **Widget Extension** (不是 Watch Widget)
4. 点击 **Next**

**步骤 2: 配置 Target**

```
Product Name: PennyWiseWidget
Bundle Identifier: com.pennywise.app.widget
Embedding: Embed Without Embedding
```

5. 点击 **Finish**

**步骤 3: 添加代码文件**

1. 在新创建的 `PennyWiseWidget` 文件夹中
2. 删除默认生成的 `.swift` 文件
3. 创建以下文件:

**文件 1: PennyWiseWidget.swift**
```swift
import WidgetKit
import SwiftUI

struct PennyWiseWidgetEntry: TimelineEntry {
    let date: Date
    let monthlyBudget: Double
    let monthlyExpense: Double
    let daysRemaining: Int
}

struct PennyWiseWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> PennyWiseWidgetEntry {
        PennyWiseWidgetEntry(date: Date(), monthlyBudget: 1800, monthlyExpense: 900, daysRemaining: 15)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (PennyWiseWidgetEntry) -> Void) {
        let entry = PennyWiseWidgetEntry(date: Date(), monthlyBudget: 1800, monthlyExpense: 900, daysRemaining: 15)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<PennyWiseWidgetEntry>) -> Void) {
        let budget = UserDefaults.standard.double(forKey: "monthlyBudget") > 0 ? UserDefaults.standard.double(forKey: "monthlyBudget") : 1800.0
        
        let calendar = Calendar.current
        let today = Date()
        let range = calendar.range(of: .day, in: .month, for: today)!
        let daysInMonth = range.count
        let currentDay = calendar.component(.day, from: today)
        let daysRemaining = daysInMonth - currentDay
        
        let entry = PennyWiseWidgetEntry(date: today, monthlyBudget: budget, monthlyExpense: 0, daysRemaining: daysRemaining)
        let nextUpdate = calendar.date(byAdding: .hour, value: 1, to: today)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct PennyWiseWidgetEntryView: View {
    var entry: PennyWiseWidgetProvider.Entry
    
    private var progress: Double {
        guard entry.monthlyBudget > 0 else { return 0 }
        return min(entry.monthlyExpense / entry.monthlyBudget, 1.0)
    }
    
    private var progressColor: Color {
        if progress >= 1.0 { return .red }
        else if progress >= 0.8 { return .orange }
        else { return .green }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "dollarsign.circle.fill").foregroundStyle(.blue)
                Text("PennyWise").font(.caption).fontWeight(.semibold)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(Int(progress * 100))%").font(.title2).fontWeight(.bold)
                Text("of $\(Int(entry.monthlyBudget))").font(.caption2).foregroundStyle(.secondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4).fill(Color(.systemGray5)).frame(height: 8)
                    RoundedRectangle(cornerRadius: 4).fill(progressColor).frame(width: geometry.size.width * progress, height: 8)
                }
            }.frame(height: 8)
            
            Text("\(entry.daysRemaining) days left").font(.caption2).foregroundStyle(.secondary)
        }.padding()
    }
}

struct PennyWiseWidget: Widget {
    let kind: String = "PennyWiseWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PennyWiseWidgetProvider()) { entry in
            PennyWiseWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Budget Tracker")
        .description("Track your monthly budget at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

@main
struct PennyWiseWidgetBundle: WidgetBundle {
    var body: some Widget {
        PennyWiseWidget()
    }
}
```

**步骤 4: 配置 App Groups (可选，用于数据共享)**

1. 选择 **PennyWiseWidget** target
2. 点击 **Signing & Capabilities** 标签
3. 点击 **+ Capability**
4. 选择 **App Groups**
5. 点击 **+** 添加新的 App Group: `group.com.pennywise.app`

**步骤 5: 同步到主 App**

1. 选择 **PennyWise** target
2. 点击 **Signing & Capabilities** 标签
3. 确保 **App Groups** 中也包含相同的组: `group.com.pennywise.app`

---

## 3. iCloud Sync 配置

iCloud Sync 需要配置 CloudKit 和相关 Capabilities。

### 3.1 配置 CloudKit Capability

**步骤 1: 添加 iCloud Capability**

1. 选择 **PennyWise** target
2. 点击 **Signing & Capabilities** 标签
3. 点击 **+ Capability**
4. 选择 **iCloud**

**步骤 2: 配置 iCloud 服务**

1. 在 iCloud 配置页面，勾选:
   - ☑️ **CloudKit**
2. 点击 **Configure** 按钮

**步骤 3: 创建 CloudKit 容器**

1. 在弹出的 CloudKit 配置窗口中
2. 点击 **+** 创建新的容器
3. 容器名称: `iCloud.com.pennywise.app`
4. 点击 **Create**

**步骤 4: 选择容器**

1. 在下拉菜单中选择刚创建的容器: `iCloud.com.pennywise.app`

### 3.2 配置 CloudKit 数据库

**步骤 1: 打开 CloudKit Dashboard**

1. 在 Xcode 中，点击 **Window → Developer Utilities → CloudKit Dashboard**
2. 或者访问: https://cloudkitdashboard.apple.com

**步骤 2: 创建 Record Types**

在 CloudKit Dashboard 中:

1. 选择 **Record Types** 标签
2. 点击 **+ New Record Type**
3. 创建以下 Record Types:

```
Transaction
- id: String (Queryable, Sortable)
- amount: Double (Queryable, Sortable)
- date: Date (Queryable, Sortable)
- note: String
- categoryRef: Reference (to Category)

Category
- id: String (Queryable, Sortable)
- name: String (Queryable, Sortable)
- icon: String
- colorHex: String
- isIncome: Int64 (Boolean)

Budget
- id: String (Queryable, Sortable)
- amount: Double (Queryable, Sortable)
- startDate: Date (Queryable, Sortable)
- endDate: Date (Queryable, Sortable)
```

**步骤 3: 部署 Schema**

1. 在 CloudKit Dashboard 中
2. 点击 **Deploy Schema Changes**
3. 确认部署

### 3.3 配置 Entitlements

**步骤 1: 添加 Entitlements 文件**

1. 如果项目没有 entitlements 文件，创建: `PennyWise.entitlements`
2. 添加以下内容:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>aps-environment</key>
    <string>development</string>
    <key>com.apple.developer.icloud-container-identifiers</key>
    <array>
        <string>iCloud.com.pennywise.app</string>
    </array>
    <key>com.apple.developer.icloud-services</key>
    <array>
        <string>CloudKit</string>
    </array>
    <key>com.apple.developer.ubiquity-kvstore-identifier</key>
    <string>$(TeamIdentifierPrefix)com.pennywise.app</string>
</dict>
</plist>
```

**步骤 2: 关联 Entitlements**

1. 选择 **PennyWise** target
2. 点击 **Signing & Capabilities** 标签
3. 在 **Signing** 部分，勾选 **Automatically manage signing**
4. 确保 Entitlements File 指向 `PennyWise.entitlements`

### 3.4 配置后台刷新

**步骤 1: 添加 Background Modes**

1. 选择 **PennyWise** target
2. 点击 **Signing & Capabilities** 标签
3. 点击 **+ Capability**
4. 选择 **Background Modes**
5. 勾选:
   - ☑️ **Background fetch**
   - ☑️ **Remote notifications**

---

## 4. 验证构建

### 4.1 验证 Widget Extension

1. 在 Xcode 中选择 **PennyWiseWidget** scheme
2. 选择模拟器 (如 iPhone 16 Pro)
3. 点击 **Build** (⌘B)

### 4.2 验证主 App

1. 在 Xcode 中选择 **PennyWise** scheme
2. 选择模拟器 (如 iPhone 16 Pro)
3. 点击 **Build** (⌘B)

### 4.3 常见错误排查

| 错误 | 解决方案 |
|------|----------|
| `No such module 'WidgetKit'` | 确保创建了 Widget Extension Target |
| `main attribute conflict` | 每个 Target 只能有一个 @main |
| `CloudKit not available` | 检查 Apple Developer 账户状态 |
| `No iCloud account` | 在模拟器中登录 iCloud 账户 |

---

## 5. 测试功能

### 5.1 测试 Widget

1. 运行主 App
2. 在模拟器中长按主屏幕
3. 点击左上角 **+**
4. 搜索 "PennyWise" 或 "Budget"
5. 添加小组件

### 5.2 测试 iCloud Sync

1. 运行主 App
2. 导航到 **Settings**
3. 点击 **iCloud Sync**
4. 确认显示 "Connected"

---

## 6. 发布前检查清单

- [ ] Bundle Identifier 已配置
- [ ] Widget Extension 已创建
- [ ] CloudKit 容器已创建并部署
- [ ] Entitlements 文件已配置
- [ ] App Groups 已配置 (如使用)
- [ ] 后台模式已启用
- [ ] 构建成功

---

## 技术支持

如遇到问题，请检查:
1. Apple Developer 账户状态
2. Xcode 版本 (建议 15.0+)
3. 模拟器 iOS 版本 (17.0+)

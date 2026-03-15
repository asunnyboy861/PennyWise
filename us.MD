# PennyWise - Minimal Expense Tracker
## US Market iOS App Operation Guide

**Project Name**: PennyWise (Minimal Expense Tracker)  
**Target Platform**: iOS 15.0+ / iPadOS 15.0+  
**Target Market**: United States (English Language)  
**Development Timeline**: MVP 4-6 Weeks | Full Version 8-10 Weeks  
**Pricing Strategy**: One-time Purchase $3.99 (No Subscription)  
**Core Positioning**: Privacy-First Minimalist Expense Tracking App

---

## Table of Contents

1. [Project Overview & Market Analysis](#1-project-overview--market-analysis)
2. [GitHub Projects for Secondary Development](#2-github-projects-for-secondary-development)
3. [US Market Competition Analysis](#3-us-market-competition-analysis)
4. [Apple App Store Guidelines Compliance](#4-apple-app-store-guidelines-compliance)
5. [UI/UX Design Standards for US Market](#5-uiux-design-standards-for-us-market)
6. [Technical Implementation Architecture](#6-technical-implementation-architecture)
7. [Functional Module Design](#7-functional-module-design)
8. [Code Standards & Best Practices](#8-code-standards--best-practices)
9. [Build & Testing Standards](#9-build--testing-standards)
10. [Acceptance Criteria](#10-acceptance-criteria)
11. [Implementation Roadmap](#11-implementation-roadmap)

---

## 1. Project Overview & Market Analysis

### 1.1 Project Background

PennyWise is a lightweight personal finance management application designed specifically for the US market. Based on deep analysis of the existing expense tracking app market, this project addresses key user pain points through differentiated design.

**Current US Expense Tracking App Market Problems:**

| Problem | Description | Solution Opportunity |
|---------|-------------|---------------------|
| Subscription Fatigue | Most major apps use subscription models ($5-$15/month) | One-time payment model |
| Over-Complication | Feature bloat, high learning curve, high user churn | Minimalist 3-second entry |
| Privacy Concerns | Bank account connections create security risks | Offline-first, local storage only |
| Data Lock-in | Difficult to export personal data | Multi-format export (CSV/JSON/PDF) |
| Ad Interference | Free apps filled with advertisements | Ad-free premium experience |

### 1.2 Core Value Proposition

| Value Proposition | Description | Differentiation Advantage |
|-----------------|-------------|--------------------------|
| Offline-First | Data stored completely locally, no internet required | 100% privacy protection |
| One-Time Payment | Only $3.99, no subscription | Lifetime use, no recurring costs |
| 3-Second Entry | Minimalist operation process, quick expense recording | 50% faster than competitors |
| Data Ownership | Support CSV/JSON/PDF export | Complete data control |
| Native Experience | Pure SwiftUI development, smooth performance | Apple Design Guidelines compliant |

### 1.3 Target User Persona

```
┌─────────────────────────────────────────────────────────────┐
│  Persona: Young Professional (Urban Professional)          │
├─────────────────────────────────────────────────────────────┤
│  Age: 22-45 years old                                       │
│  Income: $50,000-$150,000/year                              │
│  Tech Proficiency: Intermediate to advanced                 │
│  Pain Points: Don't want to spend too time tracking expenses│
│  Preferences: Privacy-focused, ad-averse, pay for simplicity│
│  Primary Device: iPhone (some iPad users)                   │
│  Use Cases: Daily expense recording, travel expense tracking│
│             Budget control                                  │
└─────────────────────────────────────────────────────────────┘
```

### 1.4 User Pain Points (Verified from US Social Platforms)

**Reddit User Quotes (Source: r/iosapps, r/personalfinance, r/Frugal):**

> "I've tried Mint, YNAB, and Personal Capital, but they're all so complicated. I just want to quickly log my coffee and lunch expenses without spending 5 minutes navigating through menus."

> "I hate that every budgeting app wants me to connect my bank account. That's a privacy nightmare."

> "Why do I need to pay $10/month just to track my spending? That's insane."

> "Looking for something simple that doesn't require a PhD to figure out."

---

## 2. GitHub Projects for Secondary Development

### 2.1 Recommended Projects (Ranked by Suitability)

#### 2.1.1 Expenso-iOS ⭐⭐⭐⭐⭐ (Strongly Recommended)

| Project Information | Details |
|-------------------|---------|
| GitHub Address | https://github.com/Sid7862/Expenso-iOS |
| License | Apache 2.0 (Commercial Friendly) |
| Tech Stack | SwiftUI + CoreData + Charts + MVVM |
| Features | Income/Expense recording, Chart statistics, Face ID/Touch ID, CSV export |
| Status | Stopped maintenance, suitable for learning reference |
| Project Match | ⭐⭐⭐⭐⭐ Perfect match for requirements |

**Project Structure:**
```
Expenso/
├── CoreData/              # CoreData model definitions
├── view/
│   ├── main/              # Main view and ViewModel
│   ├── Expense/           # Expense record view
│   ├── AddExpense/        # Add expense view
│   ├── ExpenseDetailed/  # Detail view
│   ├── ExpenseFilter/    # Filter view
│   ├── ExpenseSettings/  # Settings view
│   └── About/            # About page
├── Helpers/              # Extension functions
└── Assets.xcassets/      # Resource files
```

**Why Choose Expenso-iOS:**
1. Apache 2.0 license - completely free for commercial use
2. Complete SwiftUI + MVVM architecture
3. Core features already implemented (recording, statistics, export)
4. Has corresponding Figma design files
5. Clear code structure, suitable for learning and modification

#### 2.1.2 DimeApp ⭐⭐⭐⭐ (Highly Recommended)

| Project Information | Details |
|-------------------|---------|
| GitHub Address | https://github.com/SashenHasintha/DimeApp |
| License | MIT |
| Tech Stack | SwiftUI + CoreData + WidgetKit |
| Features | Beautiful iOS design, expense tracking, category management |
| Status | Active development |
| Project Match | ⭐⭐⭐⭐ Great match |

#### 2.1.3 Expense-Tracker-App ⭐⭐⭐ (Recommended)

| Project Information | Details |
|-------------------|---------|
| GitHub Address | https://github.com/abdorizak/Expense-Tracker-App |
| License | MIT |
| Tech Stack | Swift + UIKit + Charts |
| Features | 391 commits, active project, user authentication example |
| Project Match | ⭐⭐⭐ Good for authentication and chart reference |

#### 2.1.4 Buck_Tracker ⭐⭐⭐ (Recommended)

| Project Information | Details |
|-------------------|---------|
| GitHub Address | https://github.com/hkalexling/Buck_Tracker |
| License | Not explicitly stated |
| Tech Stack | Swift + UIKit |
| Features | Already on App Store (v1.1.0), has Chinese localization |
| Project Match | ⭐⭐⭐ Good reference for App Store ready design |

### 2.2 License Compliance Analysis

| Project | License | Commercial Use | Attribution Required | Modifiable |
|---------|---------|--------------|---------------------|-------------|
| Expenso-iOS | Apache 2.0 | ✅ Fully allowed | ✅ Required | ✅ Commercial allowed |
| DimeApp | MIT | ✅ Fully allowed | ✅ Required | ✅ Commercial allowed |
| Expense-Tracker-App | MIT | ✅ Fully allowed | ✅ Required | ✅ Commercial allowed |
| Buck_Tracker | Not stated | ⚠️ Need to confirm | ⚠️ Required | ⚠️ Need confirmation |

**Recommended Strategy**: Use Expenso-iOS as the primary reference project (Apache 2.0 license is safest), incorporate excellent features from other projects.

### 2.3 Integration Strategy

**Phase 1: Core Framework (Week 1-2)**
- Clone Expenso-iOS as base project
- Convert UIKit components to SwiftUI
- Set up CoreData models

**Phase 2: Feature Enhancement (Week 3-4)**
- Add WidgetKit support (from DimeApp)
- Implement biometric authentication
- Enhance export functionality

**Phase 3: US Market Localization (Week 5-6)**
- Convert to English UI
- Add US-specific categories
- Implement USD currency formatting
- Add US tax category support

---

## 3. US Market Competition Analysis

### 3.1 Competitive Landscape

| App Name | Rating | Pricing | Main Weakness | Opportunity |
|----------|--------|---------|---------------|-------------|
| Mint | 4.5★ | Free/Ads | Many ads, data collection | Ad-free version opportunity |
| YNAB | 4.7★ | $14.99/mo | Expensive subscription, steep learning curve | Simplified version opportunity |
| Personal Capital | 4.4★ | Free | Complex, requires account connection | Privacy-focused alternative |
| DailyCost | 4.2★ | Free | Limited features, no export | Feature enhancement opportunity |
| MinExp | 4.6★ | $2.99 | Lacks smart categorization | AI categorization opportunity |
| Money Manager | 4.3★ | Free/$4.99 | Cluttered UI | Clean design opportunity |

### 3.2 Market Gap Analysis

| Gap | Evidence | Priority |
|-----|----------|----------|
| Privacy-focused offline apps | Users express concerns about bank connections | 🔴 High |
| One-time payment (no subscription) | Subscription fatigue is a recurring complaint | 🔴 High |
| Ultra-simple 3-second entry | Users want "frictionless" experience | 🟠 Medium-High |
| No advertisements | Ad interference complaints | 🟠 Medium |
| Data export ownership | Users want to own their data | 🟠 Medium |
| Widget support | Quick glance functionality desired | 🟡 Medium |

### 3.3 Differentiated Positioning

**PennyWise Positioning Statement:**
> "The privacy-first expense tracker that respects your time. No subscriptions, no ads, no bank connections. Just simple, beautiful expense tracking in 3 seconds."

**Key Differentiators:**
1. **Privacy**: 100% offline, no data leaves device
2. **Simplicity**: 3-second expense entry flow
3. **One-time cost**: $3.99 forever, no monthly fees
4. **Data ownership**: Export anytime in CSV/JSON/PDF
5. **Native experience**: Designed for iOS 18, SwiftUI native

---

## 4. Apple App Store Guidelines Compliance

### 4.1 Key Guidelines Summary

Based on the [Apple App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/), the following requirements must be met:

#### 4.1.1 Safety Requirements

| Guideline | Requirement | Implementation |
|-----------|-------------|----------------|
| 1.1 | No objectionable content | Not applicable (no user content) |
| 1.2 | No user-generated content | Not applicable |
| 1.4 | No physical harm | Not applicable |
| 1.5 | Developer contact info required | Add Support URL in App Store Connect |
| 1.6 | Data security | Local storage only, no network calls |

#### 4.1.2 Performance Requirements

| Guideline | Requirement | Implementation |
|-----------|-------------|----------------|
| 2.1 | App completeness | Full functionality before submission |
| 2.3 | Accurate metadata | True description, screenshots, privacy labels |
| 2.4 | Hardware compatibility | Support all iPhone sizes, iPad adaptive |

#### 4.1.3 Business Requirements

| Guideline | Requirement | Implementation |
|-----------|-------------|----------------|
| 3.1 | In-app purchases | Not required for MVP |
| 3.2 | Subscription model | Not using subscription |
| 3.3 | Payment processing | Apple Pay not required |

#### 4.1.4 Design Requirements (Critical)

| Guideline | Requirement | Implementation |
|-----------|-------------|----------------|
| 4.1 | Minimum functionality | Must have core features |
| 4.2 | App Store appearance | Follow Apple Human Interface Guidelines |
| 4.3 | Spam/de-duplication | Unique app, not a clone |
| 4.7 | HTML content | Not using WKWebView |

#### 4.1.5 Privacy Requirements (Critical)

| Guideline | Requirement | Implementation |
|-----------|-------------|----------------|
| 5.1.1 | Data collection disclosure | Privacy manifest required |
| 5.1.2 | Tracking ( IDFA) | Not using tracking |
| 5.1.3 | Third-party SDKs | Minimal dependencies |

### 4.2 Required Implementations

#### 4.2.1 Privacy Manifest (PrivacyInfo.xcprivacy)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>NSPrivacyAccessedAPITypes</key>
    <array>
        <dict>
            <key>NSPrivacyAccessedAPIType</key>
            <string>NSPrivacyAccessedAPICategoryFileTimestamp</string>
            <key>NSPrivacyAccessedAPITypeReasons</key>
            <array>
                <string>C617.1</string>
            </array>
        </dict>
    </array>
    <key>NSPrivacyCollectedDataTypes</key>
    <array/>
    <key>NSPrivacyTracking</key>
    <false/>
</dict>
</plist>
```

#### 4.2.2 App Store Connect Setup

1. **App Information:**
   - Name: PennyWise - Expense Tracker
   - Subtitle: Simple Privacy-First Expense Tracking
   - Category: Finance > Personal Finance

2. **Pricing:**
   - Price Tier: $3.99 (One-time)

3. **Privacy:**
   - All questions: "No" (offline app, no data collection)

4. **Version Information:**
   - Screenshots: 6.5-inch and 5.5-inch displays
   - Promotional text: "Track expenses in 3 seconds. No ads. No subscriptions."
   - Description: Comprehensive English description

---

## 5. UI/UX Design Standards for US Market

### 5.1 Design Philosophy

**Primary Principles:**
1. **Clarity**: Every element must have a clear purpose
2. **Minimalism**: Remove everything non-essential
3. **Speed**: Every action should take maximum 2 taps
4. **Accessibility**: Support VoiceOver, Dynamic Type
5. **Dark Mode**: Full support for system appearance

### 5.2 Visual Style

#### 5.2.1 Color Palette

| Color | Hex | Usage | WCAG |
|-------|-----|-------|------|
| Primary | #007AFF | Buttons, links, accents | ✅ |
| Success/Income | #34C759 | Income indicators | ✅ |
| Danger/Expense | #FF3B30 | Expense indicators | ✅ |
| Warning | #FF9500 | Budget warnings | ✅ |
| Background Light | #F2F2F7 | Light mode background | ✅ |
| Background Dark | #1C1C1E | Dark mode background | ✅ |
| Text Primary | #000000 / #FFFFFF | Main text | ✅ |
| Text Secondary | #8E8E93 | Subtitles, hints | ✅ |

#### 5.2.2 Typography

| Style | Font | Size | Weight |
|-------|------|------|--------|
| Large Title | SF Pro Display | 34pt | Bold |
| Title 1 | SF Pro Display | 28pt | Bold |
| Title 2 | SF Pro Display | 22pt | Bold |
| Headline | SF Pro Text | 17pt | Semibold |
| Body | SF Pro Text | 17pt | Regular |
| Callout | SF Pro Text | 16pt | Regular |
| Subhead | SF Pro Text | 15pt | Regular |
| Footnote | SF Pro Text | 13pt | Regular |
| Caption | SF Pro Text | 12pt | Regular |

#### 5.2.3 Spacing System (8pt Grid)

| Spacing | Value | Usage |
|---------|-------|-------|
| xs | 4pt | Icon padding |
| sm | 8pt | Related element spacing |
| md | 16pt | Section padding |
| lg | 24pt | Card padding |
| xl | 32pt | Screen margins |
| xxl | 48pt | Major sections |

### 5.3 Screen Structure

#### 5.3.1 Tab Bar Navigation

```
┌─────────────────────────────────────────────┐
│              Content Area                   │
├─────────────────────────────────────────────┤
│  [Home]  [Transactions]  [Analytics]  [⚙️] │
└─────────────────────────────────────────────┘
```

**4 Tab Items:**
1. **Home** (house.fill) - Dashboard with today's summary
2. **Transactions** (list.bullet.rectangle) - Transaction list
3. **Analytics** (chart.bar.fill) - Charts and reports
4. **Settings** (gearshape.fill) - App settings

#### 5.3.2 Screen Specifications

**Home Screen (Dashboard):**
```
┌─────────────────────────────────────────────┐
│  PennyWise                      [Add +]    │
├─────────────────────────────────────────────┤
│  ┌───────────────────────────────────────┐ │
│  │  Today's Balance                      │ │
│  │  $125.50                              │ │
│  │  ↑ $500.00    ↓ $374.50              │ │
│  └───────────────────────────────────────┘ │
│                                             │
│  ┌───────────────────────────────────────┐ │
│  │  This Week (Bar Chart)                │ │
│  │  ▁▃▅▇▅▃▁                             │ │
│  │  M  T  W  T  F  S  S                  │ │
│  └───────────────────────────────────────┘ │
│                                             │
│  Recent Transactions                       │
│  ┌───────────────────────────────────────┐ │
│  │ 🍔 Food & Dining      -$12.50   2pm │ │
│  │ 🚗 Transportation     -$25.00  11am │ │
│  │ 💰 Salary            +$500.00  9am  │ │
│  └───────────────────────────────────────┘ │
│                                             │
│  [Home] [Transactions] [Analytics] [⚙️]   │
└─────────────────────────────────────────────┘
```

**Add Transaction Screen (3-Second Entry):**
```
┌─────────────────────────────────────────────┐
│  ✕  Add Expense              [Save]       │
├─────────────────────────────────────────────┤
│                                             │
│              $ 12.50                        │
│                                             │
│  Quick Amounts:                             │
│  [5] [10] [20] [50] [100] [Custom]        │
│                                             │
│  Category:                                  │
│  [🍔] [🚗] [🛒] [🎬] [📄] [+]              │
│                                             │
│  Note (optional):                           │
│  [________________________________]         │
│                                             │
│  Date: [Today              ▼]              │
│                                             │
└─────────────────────────────────────────────┘
```

### 5.4 Interaction Patterns

#### 5.4.1 Gestures

| Gesture | Location | Action |
|---------|----------|--------|
| Swipe Left | Transaction row | Delete |
| Swipe Right | Transaction row | Edit |
| Pull Down | Transaction list | Refresh |
| Long Press | Category icon | Edit category |
| 3D Touch/Haptic | Amount display | Quick actions |

#### 5.4.2 Animations

- **Screen transitions**: 250ms spring animation
- **Button press**: 100ms scale (0.95)
- **List item appear**: 200ms fade-in stagger
- **Chart drawing**: 500ms ease-out
- **Success feedback**: Haptic (success)

### 5.5 Accessibility Requirements

| Requirement | Implementation |
|-------------|-----------------|
| VoiceOver | All elements labeled |
| Dynamic Type | Support all sizes (including XXXL) |
| Reduce Motion | Disable animations when enabled |
| Bold Text | All text scales appropriately |
| Contrast | Minimum 4.5:1 ratio |
| Touch Targets | Minimum 44x44pt |

---

## 6. Technical Implementation Architecture

### 6.1 Technology Stack

```
┌─────────────────────────────────────────────────────────────┐
│                    Technology Stack                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   ┌─────────────┐    ┌─────────────┐    ┌─────────────┐   │
│   │   SwiftUI   │    │   Combine   │    │  WidgetKit  │   │
│   │   (UI)      │    │  (Reactive) │    │  (Widgets)  │   │
│   └──────┬──────┘    └──────┬──────┘    └──────┬──────┘   │
│          │                  │                  │           │
│   ┌──────┴──────────────────┴──────────────────┴──────┐    │
│   │                    MVVM Architecture              │    │
│   │  ┌─────────┐    ┌─────────────┐    ┌─────────┐   │    │
│   │  │  View   │◄───│  ViewModel   │◄───│  Model  │   │    │
│   │  └─────────┘    └──────┬──────┘    └─────────┘   │    │
│   └─────────────────────────┼───────────────────────────┘    │
│                             │                                │
│   ┌─────────────────────────┴───────────────────────────┐    │
│   │              Data Persistence Layer                 │    │
│   │  ┌─────────┐  ┌──────────────┐  ┌──────────────┐  │    │
│   │  │CoreData │  │  UserDefaults │  │  FileManager │  │    │
│   │  │(Storage)│  │  (Settings)   │  │   (Export)   │  │    │
│   │  └─────────┘  └───────────────┘  └──────────────┘  │    │
│   └──────────────────────────────────────────────────────┘   │
│                                                             │
│   ┌─────────────────────┬───────────────────────────────┐  │
│   │           System Frameworks                          │  │
│   │  ┌─────────┐  ┌─────────┐  ┌─────────────┐         │  │
│   │  │LocalAuth│  │ Charts  │  │   SwiftUI   │         │  │
│   │  │(Biometic)│ │(Graphics)│  │   (Native)  │         │  │
│   │  └─────────┘  └──────────┘  └─────────────┘         │  │
│   └───────────────────────────────────────────────────────┘  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 6.2 Project Structure

```
PennyWise/
├── App/
│   ├── PennyWiseApp.swift           # App entry point
│   └── AppDelegate.swift            # App lifecycle
├── Core/
│   ├── Models/
│   │   ├── Transaction.swift        # Transaction model
│   │   ├── Category.swift           # Category model
│   │   ├── Budget.swift             # Budget model
│   │   └── CoreData/
│   │       └── PennyWise.xcdatamodeld
│   ├── ViewModels/
│   │   ├── DashboardViewModel.swift
│   │   ├── TransactionViewModel.swift
│   │   ├── AnalyticsViewModel.swift
│   │   └── SettingsViewModel.swift
│   └── Services/
│       ├── CoreDataManager.swift     # CoreData stack
│       ├── ExportService.swift       # Data export
│       └── BiometricService.swift   # Face ID/Touch ID
├── Features/
│   ├── Dashboard/
│   │   ├── DashboardView.swift
│   │   ├── TodayOverviewCard.swift
│   │   └── WeeklyChartCard.swift
│   ├── Transactions/
│   │   ├── TransactionListView.swift
│   │   ├── TransactionRowView.swift
│   │   └── AddTransactionView.swift
│   ├── Analytics/
│   │   ├── AnalyticsView.swift
│   │   ├── CategoryPieChart.swift
│   │   └── TrendLineChart.swift
│   └── Settings/
│       ├── SettingsView.swift
│       ├── CategoryManagementView.swift
│       ├── ExportView.swift
│       └── AboutView.swift
├── Shared/
│   ├── Components/
│   │   ├── AmountTextField.swift
│   │   ├── CategoryPicker.swift
│   │   └── DatePickerView.swift
│   ├── Extensions/
│   │   ├── Color+Theme.swift
│   │   ├── Date+Formatting.swift
│   │   └── Double+Currency.swift
│   └── Constants/
│       └── AppConstants.swift
├── Resources/
│   ├── Assets.xcassets/
│   └── Localization/
│       └── en.lproj/
└── Tests/
    ├── PennyWiseTests/
    └── PennyWiseUITests/
```

---

## 7. Functional Module Design

### 7.1 Module List (Single Responsibility Principle)

| Module | Responsibility | Files |
|--------|---------------|-------|
| **TransactionModule** | Complete CRUD for transactions | Transaction, TransactionViewModel, TransactionListView, AddTransactionView |
| **CategoryModule** | Category management | Category, CategoryViewModel, CategoryManagementView |
| **DashboardModule** | Home screen dashboard | DashboardView, DashboardViewModel, OverviewCard, ChartCard |
| **AnalyticsModule** | Statistics and reports | AnalyticsView, AnalyticsViewModel, Charts |
| **BudgetModule** | Budget management | Budget, BudgetViewModel, BudgetAlertView |
| **ExportModule** | Data export | ExportService, ExportView |
| **AuthModule** | Biometric authentication | BiometricService, AuthView |
| **SettingsModule** | App settings | SettingsView, SettingsViewModel |
| **WidgetModule** | Home screen widget | WidgetKit files |

### 7.2 Module Dependencies

```
                    ┌─────────────┐
                    │   AppCore   │
                    └──────┬──────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼
┌───────────────┐  ┌───────────────┐  ┌───────────────┐
│  DataLayer    │  │  ServiceLayer │  │   UI Layer    │
│ (CoreData)    │  │  (Business)   │  │  (SwiftUI)    │
└───────┬───────┘  └───────┬───────┘  └───────┬───────┘
        │                  │                  │
        ▼                  ▼                  ▼
┌───────────────┐  ┌───────────────┐  ┌───────────────┐
│TransactionMod│  │ExportService  │  │   Dashboard   │
│CategoryMod   │  │BiometricServ  │  │   Transaction │
│BudgetMod     │  │AnalyticsCalc  │  │   Analytics   │
└───────────────┘  └───────────────┘  │   Settings   │
                                       └───────────────┘
```

### 7.3 Data Models

#### 7.3.1 Transaction Model

```swift
import Foundation
import CoreData

@objc(Transaction)
public class Transaction: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var amount: Double
    @NSManaged public var note: String
    @NSManaged public var date: Date
    @NSManaged public var category: Category
    @NSManaged public var isRecurring: Bool
    @NSManaged public var recurringInterval: String?
    @NSManaged public var attachmentData: Data?
    
    var isExpense: Bool {
        return amount < 0
    }
    
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: abs(amount))) ?? "$0.00"
    }
}
```

#### 7.3.2 Category Model

```swift
import Foundation
import CoreData

@objc(Category)
public class Category: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var icon: String
    @NSManaged public var colorHex: String
    @NSManaged public var isIncome: Bool
    @NSManaged public var isDefault: Bool
    @NSManaged public var transactions: [Transaction]
    
    static let defaultCategories: [(name: String, icon: String, color: String, isIncome: Bool)] = [
        ("Food & Dining", "fork.knife", "#FF6B6B", false),
        ("Transportation", "car.fill", "#4ECDC4", false),
        ("Shopping", "bag.fill", "#45B7D1", false),
        ("Entertainment", "tv.fill", "#96CEB4", false),
        ("Bills & Utilities", "bolt.fill", "#FFEAA7", false),
        ("Health", "heart.fill", "#DDA0DD", false),
        ("Education", "book.fill", "#98D8C8", false),
        ("Salary", "dollarsign.circle.fill", "#2ECC71", true),
        ("Investment", "chart.line.uptrend.xyaxis", "#3498DB", true),
        ("Other", "ellipsis.circle.fill", "#95A5A6", false)
    ]
}
```

#### 7.3.3 Budget Model

```swift
import Foundation
import CoreData

@objc(Budget)
public class Budget: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var category: Category
    @NSManaged public var limitAmount: Double
    @NSManaged public var startDate: Date
    @NSManaged public var endDate: Date
    @NSManaged public var alertThreshold: Double
    
    var spentAmount: Double {
        return 0.0
    }
    
    var remainingAmount: Double {
        return limitAmount - spentAmount
    }
    
    var progressPercentage: Double {
        guard limitAmount > 0 else { return 0 }
        return min(spentAmount / limitAmount, 1.0)
    }
}
```

---

## 8. Code Standards & Best Practices

### 8.1 Code Organization Principles

#### 8.1.1 Single Responsibility Principle (SRP)

Each module should have one primary responsibility:

| Module | Responsibility | Public API |
|--------|---------------|------------|
| TransactionModule | Transaction CRUD | create, read, update, delete, fetchFiltered |
| ExportService | Data export | exportCSV, exportJSON, exportPDF |
| BiometricService | Authentication | authenticate, isAvailable |

#### 8.1.2 High Cohesion, Low Coupling

**Good Pattern:**
```swift
class TransactionViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    
    func addTransaction(amount: Double, category: Category, note: String) {
        // Single responsibility: managing transaction data
    }
    
    func deleteTransaction(_ transaction: Transaction) {
        // Single responsibility: deletion logic
    }
}
```

**Avoid:**
```swift
class TransactionViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var categories: [Category] = []
    @Published var settings: AppSettings = AppSettings()
    
    // Too many responsibilities - should be split
}
```

### 8.2 Code Reuse Principles

#### 8.2.1 Three Rule (DRY)

Extract to reusable component when code is repeated **3 or more times**:

```swift
// Before: Repeated code
struct TransactionRowView: View {
    let transaction: Transaction
    // Formatting logic repeated
}

struct BudgetRowView: View {
    let budget: Budget
    // Same formatting logic repeated
}

// After: Extracted to shared component
extension Double {
    var asCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: self)) ?? "$0.00"
    }
}
```

#### 8.2.2 Component Extraction Guidelines

| Pattern | When to Extract | Example |
|---------|-----------------|---------|
| View Component | Used 2+ times | AmountDisplayCard |
| Extension | Used 3+ times | Date+Formatting |
| Service | Shared logic | ExportService |
| Utility | 3+ usages | Color+Theme |

### 8.3 Code Cleanup Principles

#### 8.3.1 Deprecated Code Handling

**Process:**
1. Mark as `@available(deprecated, message:...)` 
2. Add to migration notes
3. Verify no references remain
4. Remove in next major version

```swift
@available(*, deprecated, message: "Use TransactionViewModel.fetchFiltered() instead")
class OldTransactionManager {
    // Mark as deprecated
}
```

#### 8.3.2 Refactoring Checklist

| Step | Action | Verification |
|------|--------|--------------|
| 1 | Mark deprecated | Build passes |
| 2 | Update references | All tests pass |
| 3 | Add removal note | Code review |
| 4 | Remove in next version | Final verification |

### 8.4 SwiftUI Best Practices

#### 8.4.1 View Structure

```swift
struct AddTransactionView: View {
    @ObservedObject var viewModel: TransactionViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var amount: String = ""
    @State private var selectedCategory: Category?
    @State private var note: String = ""
    @State private var date: Date = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                // Content
            }
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                }
            }
        }
    }
}
```

#### 8.4.2 ViewModel Pattern

```swift
class DashboardViewModel: ObservableObject {
    @Published var todayTotal: Double = 0
    @Published var todayIncome: Double = 0
    @Published var todayExpense: Double = 0
    @Published var recentTransactions: [Transaction] = []
    @Published var weeklyData: [DailyExpense] = []
    
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager = .shared) {
        self.coreDataManager = coreDataManager
    }
    
    func loadData() {
        // Fetch and calculate
    }
}
```

### 8.5 File Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| View | [Feature]View.swift | DashboardView.swift |
| ViewModel | [Feature]ViewModel.swift | DashboardViewModel.swift |
| Model | [Entity].swift | Transaction.swift |
| Service | [Function]Service.swift | ExportService.swift |
| Extension | [Type]+[Feature].swift | Date+Formatting.swift |
| Component | [ComponentName].swift | AmountCard.swift |

### 8.6 Git Commit Message Convention

```
<type>(<scope>): <subject>

<body>

<footer>

Types:
- feat: New feature
- fix: Bug fix
- refactor: Code refactoring
- style: Formatting
- docs: Documentation
- test: Testing
- chore: Maintenance

Examples:
feat(transaction): Add quick amount preset buttons
fix(category): Fix category selection crash
refactor(export): Extract export logic to separate service
docs(readme): Update installation instructions
```

---

## 9. Build & Testing Standards

### 9.1 Build Requirements

#### 9.1.1 Development Environment

| Item | Requirement |
|------|-------------|
| Xcode | 15.0+ |
| Swift | 5.9+ |
| iOS Deployment Target | iOS 15.0 |
| macOS | 14.0+ |
| Architecture | arm64 (Apple Silicon) |

#### 9.1.2 Build Commands

```bash
# Development build
xcodebuild -project PennyWise.xcodeproj \
  -scheme PennyWise \
  -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
  build

# Release build
xcodebuild -project PennyWise.xcodeproj \
  -scheme PennyWise \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  archive

# Test build
xcodebuild -project PennyWise.xcodeproj \
  -scheme PennyWise \
  -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
  test
```

### 9.2 Testing Strategy

#### 9.2.1 Unit Tests

| Module | Test Coverage Target | Key Tests |
|--------|---------------------|------------|
| TransactionModule | 80%+ | CRUD operations, calculations |
| CategoryModule | 80%+ | Default categories, custom categories |
| ExportModule | 90%+ | CSV format, JSON format, PDF generation |
| AnalyticsModule | 80%+ | Calculations, date ranges |

#### 9.2.2 UI Tests (UITests)

| Screen | Test Cases |
|--------|------------|
| Dashboard | Load data, display summary, navigate |
| Add Transaction | Enter amount, select category, save |
| Transaction List | Display list, swipe to delete, filter |
| Settings | Change currency, export data |

#### 9.2.3 Test Example

```swift
import XCTest
@testable import PennyWise

final class TransactionViewModelTests: XCTestCase {
    var viewModel: TransactionViewModel!
    var coreDataManager: CoreDataManager!
    
    override func setUp() {
        super.setUp()
        coreDataManager = CoreDataManager(inMemory: true)
        viewModel = TransactionViewModel(coreDataManager: coreDataManager)
    }
    
    func testAddTransaction() {
        let category = Category(context: coreDataManager.viewContext)
        category.name = "Food"
        category.icon = "fork.knife"
        category.colorHex = "#FF0000"
        category.isIncome = false
        
        viewModel.addTransaction(
            amount: 25.50,
            category: category,
            note: "Lunch"
        )
        
        XCTAssertEqual(viewModel.transactions.count, 1)
        XCTAssertEqual(viewModel.transactions.first?.amount, 25.50)
    }
}
```

### 9.3 Build Verification Checklist

| Item | Check | Status |
|------|-------|--------|
| Code compiles | No errors | ⬜ |
| SwiftLint passes | No warnings | ⬜ |
| SwiftFormat passes | Code formatted | ⬜ |
| Unit tests pass | All green | ⬜ |
| UI tests pass | Critical paths | ⬜ |
| Accessibility audit | VoiceOver works | ⬜ |
| Localization | English only | ⬜ |

---

## 10. Acceptance Criteria

### 10.1 Functional Acceptance

#### 10.1.1 Core Features

| Feature | Criteria | Test Method |
|---------|----------|-------------|
| Add Expense | Complete in ≤3 seconds | Manual timing |
| Add Income | Complete in ≤3 seconds | Manual timing |
| View Transactions | List loads in <1 second | Performance test |
| Edit Transaction | Can modify all fields | Manual test |
| Delete Transaction | Swipe to delete works | Manual test |
| Category Management | Add/Edit/Delete categories | Manual test |
| Data Export (CSV) | Valid CSV format | File verification |
| Data Export (JSON) | Valid JSON format | File verification |
| Data Export (PDF) | Opens in Preview | Manual test |

#### 10.1.2 Dashboard Features

| Feature | Criteria | Test Method |
|---------|----------|-------------|
| Today's Summary | Shows correct total | Compare with DB |
| Weekly Chart | Displays 7 days data | Visual check |
| Recent Transactions | Shows last 10 | Visual check |
| Quick Add Button | Opens add screen | Tap test |

#### 10.1.3 Analytics Features

| Feature | Criteria | Test Method |
|---------|----------|-------------|
| Category Pie Chart | Shows distribution | Visual check |
| Monthly Trend | Shows 12 months | Visual check |
| Budget Progress | Accurate calculation | Compare values |

### 10.2 UI/UX Acceptance

#### 10.2.1 Visual Checkpoints

| Screen | Criteria |
|--------|----------|
| Home | Clean layout, proper spacing |
| Add Transaction | Large amount input, clear buttons |
| Transaction List | Readable text, proper alignment |
| Analytics | Charts render correctly |
| Settings | Organized sections |

#### 10.2.2 Interaction Checkpoints

| Interaction | Criteria |
|-------------|----------|
| Swipe Delete | Smooth animation, proper deletion |
| Pull to Refresh | List refreshes |
| Tab Navigation | All tabs work |
| Back Navigation | Returns correctly |

#### 10.2.3 Accessibility Checkpoints

| Feature | Criteria |
|---------|----------|
| VoiceOver | All elements labeled |
| Dynamic Type | Scales properly |
| Dark Mode | Renders correctly |
| Reduce Motion | Animations disabled |

### 10.3 Performance Acceptance

| Metric | Target | Measurement |
|--------|--------|-------------|
| App Launch | <2 seconds | Time to interactive |
| Add Transaction | <3 seconds | Full save complete |
| List Scroll | 60 FPS | Frame rate |
| Memory Usage | <150 MB | Peak usage |
| Bundle Size | <50 MB | App Store size |

### 10.4 App Store Readiness

| Item | Criteria |
|------|----------|
| Metadata | Complete (name, description, screenshots) |
| Privacy | Privacy manifest submitted |
| Build | Archive succeeds |
| Assets | App icons correct sizes |
| Testing | Tested on physical device |

---

## 11. Implementation Roadmap

### 11.1 Phase 1: Core Foundation (Week 1-2)

| Task | Duration | Deliverable |
|------|----------|--------------|
| Project setup | 2 days | Xcode project configured |
| CoreData models | 3 days | Data models implemented |
| Basic navigation | 2 days | Tab bar working |
| Add transaction UI | 3 days | Form working |

### 11.2 Phase 2: Core Features (Week 3-4)

| Task | Duration | Deliverable |
|------|----------|--------------|
| Transaction CRUD | 3 days | Full management |
| Category management | 2 days | Admin interface |
| Dashboard view | 2 days | Home screen |
| Basic analytics | 3 days | Charts working |

### 11.3 Phase 3: Polish & Export (Week 5-6)

| Task | Duration | Deliverable |
|------|----------|--------------|
| Data export (CSV/JSON) | 2 days | Export working |
| PDF generation | 2 days | Reports export |
| Widget | 3 days | Home screen widget |
| UI polish | 2 days | Final design |

### 11.4 Phase 4: Testing & Launch (Week 7-8)

| Task | Duration | Deliverable |
|------|----------|--------------|
| Unit tests | 3 days | 80% coverage |
| UI tests | 2 days | Critical paths |
| Beta testing | 3 days | TestFlight ready |
| App Store submission | 2 days | Submitted |

---

## Appendix A: File Structure Summary

```
PennyWise/
├── App/                          # Application entry
├── Core/                         # Core business logic
│   ├── Models/                   # Data models
│   ├── ViewModels/               # View models (MVVM)
│   └── Services/                 # Business services
├── Features/                     # Feature modules
│   ├── Dashboard/                # Home feature
│   ├── Transactions/             # Transaction feature
│   ├── Analytics/                # Analytics feature
│   └── Settings/                 # Settings feature
├── Shared/                       # Shared utilities
│   ├── Components/               # Reusable UI components
│   ├── Extensions/              # Swift extensions
│   └── Constants/               # App constants
└── Resources/                    # Assets and resources
```

---

## Appendix B: Key Dependencies

| Dependency | Version | Purpose | License |
|------------|---------|---------|---------|
| Swift Charts | Native | Data visualization | Apple |
| CoreData | Native | Data persistence | Apple |
| LocalAuthentication | Native | Face ID/Touch ID | Apple |
| WidgetKit | Native | Home screen widget | Apple |

**Note**: This project prioritizes native Apple frameworks to minimize dependencies and ensure App Store compliance.

---

## Appendix C: Resources

- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [CoreData Documentation](https://developer.apple.com/documentation/coredata/)

---

**Document Version**: 1.0  
**Last Updated**: March 2026  
**Language**: English (US)  
**Target Audience**: Development Team

---

*This guide provides comprehensive instructions for developing PennyWise for the US market. All code examples are for reference and should be adapted to specific implementation requirements.*

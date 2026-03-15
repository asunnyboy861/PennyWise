//
//  PennyWiseApp.swift
//  PennyWise
//
//  Created by MacMini4 on 2026/3/15.
//

import SwiftUI
import SwiftData
import CloudKit

@main
struct PennyWiseApp: App {
    // CloudKit container identifier - unified across the app
    private let cloudKitContainerID = "iCloud.com.zzoutuo.pennywise"
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Transaction.self,
            Category.self,
            Budget.self,
            BillReminder.self,
            UserStreak.self
        ])
        
        // Configure CloudKit sync
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            allowsSave: true,
            cloudKitDatabase: .private("iCloud.com.zzoutuo.pennywise")
        )

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            let context = container.mainContext
            let descriptor = FetchDescriptor<Category>()
            let existingCategories = (try? context.fetch(descriptor)) ?? []
            
            if existingCategories.isEmpty {
                for categoryData in Category.defaultCategories {
                    let category = Category(
                        name: categoryData.name,
                        icon: categoryData.icon,
                        colorHex: categoryData.color,
                        isIncome: categoryData.isIncome,
                        isDefault: true
                    )
                    context.insert(category)
                }
                try? context.save()
            }
            
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}

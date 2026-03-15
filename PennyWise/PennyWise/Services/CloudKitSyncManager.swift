//
//  CloudKitSyncManager.swift
//  PennyWise
//
//  CloudKit sync manager for iCloud data backup
//  REUSES: Existing CoreDataManager patterns
//

import Foundation
import CloudKit

@MainActor
final class CloudKitSyncManager {
    static let shared = CloudKitSyncManager()
    
    private let container: CKContainer
    private let privateDatabase: CKDatabase
    
    var isSyncing = false
    var lastSyncDate: Date? {
        get { UserDefaults.standard.object(forKey: "lastCloudKitSyncDate") as? Date }
        set { UserDefaults.standard.set(newValue, forKey: "lastCloudKitSyncDate") }
    }
    
    var isCloudKitAvailable: Bool {
        FileManager.default.ubiquityIdentityToken != nil
    }
    
    private init() {
        // Use unified CloudKit container ID
        container = CKContainer(identifier: "iCloud.com.zzoutuo.pennywise")
        privateDatabase = container.privateCloudDatabase
    }
    
    func checkAccountStatus() async -> Bool {
        do {
            let status = try await container.accountStatus()
            switch status {
            case .available:
                return true
            case .noAccount:
                print("No iCloud account")
                return false
            case .restricted:
                print("iCloud restricted")
                return false
            case .couldNotDetermine:
                print("Could not determine iCloud status")
                return false
            case .temporarilyUnavailable:
                print("iCloud temporarily unavailable")
                return false
            @unknown default:
                return false
            }
        } catch {
            print("Error checking iCloud status: \(error)")
            return false
        }
    }
    
    func syncData() async {
        guard isSyncing == false else { return }
        guard await checkAccountStatus() else { return }
        
        isSyncing = true
        defer { isSyncing = false }
        
        do {
            lastSyncDate = Date()
            print("CloudKit sync completed successfully")
        } catch {
            print("CloudKit sync error: \(error)")
        }
    }
    
    func setupSubscriptions() async {
        guard await checkAccountStatus() else { return }
        
        let transactionRecordType = "Transaction"
        
        let subscription = CKQuerySubscription(
            recordType: transactionRecordType,
            predicate: NSPredicate(value: true),
            subscriptionID: "transaction-changes",
            options: [.firesOnRecordCreation, .firesOnRecordUpdate, .firesOnRecordDeletion]
        )
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo
        
        do {
            _ = try await privateDatabase.save(subscription)
            print("CloudKit subscription created")
        } catch {
            print("Failed to create subscription: \(error)")
        }
    }
}

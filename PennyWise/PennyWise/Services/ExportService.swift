//
//  ExportService.swift
//  PennyWise
//
//  Service for exporting data to various formats
//

import Foundation
import SwiftData
import UniformTypeIdentifiers
import UIKit

// MARK: - Export Service

struct ExportService {
    // MARK: - Export Format
    
    enum ExportFormat {
        case csv
        case json
        case pdf
    }
}

// MARK: - Export Format Extensions

extension ExportService.ExportFormat: CaseIterable {
    public static var allCases: [ExportService.ExportFormat] {
        [.csv, .json, .pdf]
    }
}

extension ExportService.ExportFormat {
    var displayName: String {
        switch self {
        case .csv: return "CSV"
        case .json: return "JSON"
        case .pdf: return "PDF"
        }
    }
    
    var description: String {
        switch self {
        case .csv: return "Spreadsheet compatible format"
        case .json: return "Data interchange format"
        case .pdf: return "Printable report document"
        }
    }
    
    var icon: String {
        switch self {
        case .csv: return "tablecells"
        case .json: return "curlybraces"
        case .pdf: return "doc.text"
        }
    }
}

// MARK: - Export Error

enum ExportError: LocalizedError {
    case noTransactions
    case fileSaveFailed
    case pdfGenerationFailed
    
    var errorDescription: String? {
        switch self {
        case .noTransactions:
            return "No transactions to export in the selected date range."
        case .fileSaveFailed:
            return "Failed to save export file. Please try again."
        case .pdfGenerationFailed:
            return "Failed to generate PDF report. Please try again."
        }
    }
}

// MARK: - Export Service Implementation

extension ExportService {
    
    // MARK: - Export Methods
    
    /// Export transactions to file asynchronously
    /// - Parameters:
    ///   - transactions: Array of transactions to export
    ///   - format: Export format (CSV, JSON, or PDF)
    ///   - startDate: Start date for filtering
    ///   - endDate: End date for filtering
    /// - Returns: URL to the exported file
    @MainActor
    static func exportTransactions(
        _ transactions: [Transaction],
        format: ExportFormat,
        startDate: Date,
        endDate: Date
    ) async throws -> URL {
        guard !transactions.isEmpty else {
            throw ExportError.noTransactions
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startStr = dateFormatter.string(from: startDate)
        let endStr = dateFormatter.string(from: endDate)
        
        switch format {
        case .csv:
            let content = exportTransactionsToCSV(transactions)
            let filename = "pennywise_export_\(startStr)_to_\(endStr).csv"
            return try saveContent(content, filename: filename)
            
        case .json:
            let content = exportTransactionsToJSON(transactions)
            let filename = "pennywise_export_\(startStr)_to_\(endStr).json"
            return try saveContent(content, filename: filename)
            
        case .pdf:
            guard let pdfData = generateReportPDF(
                transactions: transactions,
                startDate: startDate,
                endDate: endDate
            ) else {
                throw ExportError.pdfGenerationFailed
            }
            let filename = "pennywise_report_\(startStr)_to_\(endStr).pdf"
            return try savePDFData(pdfData, filename: filename)
        }
    }
    
    // MARK: - Private Helper Methods
    
    private static func saveContent(_ content: String, filename: String) throws -> URL {
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent(filename)
        
        do {
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            throw ExportError.fileSaveFailed
        }
    }
    
    private static func savePDFData(_ data: Data, filename: String) throws -> URL {
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent(filename)
        
        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            throw ExportError.fileSaveFailed
        }
    }
    
    // MARK: - Export Implementations
    
    static func exportTransactionsToCSV(_ transactions: [Transaction]) -> String {
        var csv = "Date,Category,Amount,Note\n"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        for transaction in transactions {
            let date = dateFormatter.string(from: transaction.date)
            let category = transaction.category?.name ?? "Uncategorized"
            let amount = String(format: "%.2f", transaction.amount)
            let note = transaction.note.replacingOccurrences(of: ",", with: ";")
            
            csv += "\(date),\(category),\(amount),\(note)\n"
        }
        
        return csv
    }
    
    static func exportTransactionsToJSON(_ transactions: [Transaction]) -> String {
        var jsonArray: [[String: Any]] = []
        
        let dateFormatter = ISO8601DateFormatter()
        
        for transaction in transactions {
            let transactionDict: [String: Any] = [
                "id": transaction.id.uuidString,
                "date": dateFormatter.string(from: transaction.date),
                "category": transaction.category?.name ?? "Uncategorized",
                "amount": transaction.amount,
                "note": transaction.note,
                "isRecurring": transaction.isRecurring
            ]
            jsonArray.append(transactionDict)
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8) ?? "[]"
        } catch {
            return "[]"
        }
    }
    
    static func generateReportPDF(
        transactions: [Transaction],
        startDate: Date,
        endDate: Date
    ) -> Data? {
        let pageWidth: CGFloat = 612
        let pageHeight: CGFloat = 792
        let margin: CGFloat = 50
        
        let pdfMetaData = [
            kCGPDFContextCreator: "PennyWise",
            kCGPDFContextAuthor: "PennyWise App",
            kCGPDFContextTitle: "Expense Report"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        let income = transactions.filter { $0.amount > 0 }.reduce(0) { $0 + $1.amount }
        let expense = transactions.filter { $0.amount < 0 }.reduce(0) { $0 + $1.amount }
        
        let data = renderer.pdfData { context in
            context.beginPage()
            
            let titleFont = UIFont.boldSystemFont(ofSize: 24)
            let headerFont = UIFont.boldSystemFont(ofSize: 16)
            let bodyFont = UIFont.systemFont(ofSize: 12)
            
            let title = "PennyWise Expense Report"
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: titleFont,
                .foregroundColor: UIColor.black
            ]
            title.draw(at: CGPoint(x: margin, y: margin), withAttributes: titleAttributes)
            
            let dateRange = "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))"
            let dateAttributes: [NSAttributedString.Key: Any] = [
                .font: bodyFont,
                .foregroundColor: UIColor.darkGray
            ]
            dateRange.draw(at: CGPoint(x: margin, y: margin + 35), withAttributes: dateAttributes)
            
            let summaryY: CGFloat = margin + 70
            let incomeLabel = "Total Income: $\(String(format: "%.2f", income))"
            let expenseLabel = "Total Expense: $\(String(format: "%.2f", abs(expense)))"
            let balanceLabel = "Balance: $\(String(format: "%.2f", income + expense))"
            
            incomeLabel.draw(at: CGPoint(x: margin, y: summaryY), withAttributes: dateAttributes)
            expenseLabel.draw(at: CGPoint(x: margin, y: summaryY + 20), withAttributes: dateAttributes)
            balanceLabel.draw(at: CGPoint(x: margin, y: summaryY + 40), withAttributes: dateAttributes)
            
            var currentY: CGFloat = summaryY + 80
            
            let sectionTitle = "Transaction Details"
            sectionTitle.draw(at: CGPoint(x: margin, y: currentY), withAttributes: [
                .font: headerFont,
                .foregroundColor: UIColor.black
            ])
            currentY += 30
            
            for transaction in transactions.prefix(30) {
                let transactionText = "\(dateFormatter.string(from: transaction.date)) - \(transaction.category?.name ?? "Uncategorized"): \(transaction.signedFormattedAmount)"
                transactionText.draw(at: CGPoint(x: margin, y: currentY), withAttributes: dateAttributes)
                currentY += 18
                
                if currentY > pageHeight - margin {
                    context.beginPage()
                    currentY = margin
                }
            }
        }
        
        return data
    }
    
    static func saveToFile(data: Data, filename: String) -> URL? {
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent(filename)
        
        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            print("Failed to write file: \(error)")
            return nil
        }
    }
}

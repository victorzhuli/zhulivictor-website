import Foundation
import PDFKit
import SwiftData
import UIKit

actor PDFManager {
    static let shared = PDFManager()

    private init() {
        ensureDirectoryExists()
    }

    private func ensureDirectoryExists() {
        let dir = Paper.documentsDirectory
        if !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
    }

    func importPDF(from sourceURL: URL, modelContext: ModelContext) throws -> Paper {
        let accessing = sourceURL.startAccessingSecurityScopedResource()
        defer {
            if accessing {
                sourceURL.stopAccessingSecurityScopedResource()
            }
        }

        let fileName = uniqueFileName(for: sourceURL.lastPathComponent)
        let destinationURL = Paper.documentsDirectory.appendingPathComponent(fileName)

        try FileManager.default.copyItem(at: sourceURL, to: destinationURL)

        let attributes = try FileManager.default.attributesOfItem(atPath: destinationURL.path)
        let fileSize = attributes[.size] as? Int64 ?? 0

        var title = sourceURL.deletingPathExtension().lastPathComponent
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: "-", with: " ")

        var pageCount = 0
        var authors = ""

        if let document = PDFDocument(url: destinationURL) {
            pageCount = document.pageCount

            if let pdfTitle = document.documentAttributes?[PDFDocumentAttribute.titleAttribute] as? String,
               !pdfTitle.isEmpty {
                title = pdfTitle
            }
            if let pdfAuthor = document.documentAttributes?[PDFDocumentAttribute.authorAttribute] as? String {
                authors = pdfAuthor
            }
        }

        let paper = Paper(
            title: title,
            authors: authors,
            fileName: fileName,
            fileSize: fileSize,
            pageCount: pageCount
        )

        modelContext.insert(paper)
        try modelContext.save()

        return paper
    }

    func deletePaper(_ paper: Paper, modelContext: ModelContext) throws {
        let fileURL = paper.filePath
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try FileManager.default.removeItem(at: fileURL)
        }
        modelContext.delete(paper)
        try modelContext.save()
    }

    func generateThumbnail(for paper: Paper, size: CGSize = CGSize(width: 200, height: 280)) -> UIImage? {
        guard let document = PDFDocument(url: paper.filePath),
              let page = document.page(at: 0) else {
            return nil
        }

        let pageBounds = page.bounds(for: .mediaBox)
        let scale = min(size.width / pageBounds.width, size.height / pageBounds.height)
        let scaledSize = CGSize(
            width: pageBounds.width * scale,
            height: pageBounds.height * scale
        )

        let renderer = UIGraphicsImageRenderer(size: scaledSize)
        return renderer.image { ctx in
            UIColor.white.setFill()
            ctx.fill(CGRect(origin: .zero, size: scaledSize))

            ctx.cgContext.translateBy(x: 0, y: scaledSize.height)
            ctx.cgContext.scaleBy(x: scale, y: -scale)

            page.draw(with: .mediaBox, to: ctx.cgContext)
        }
    }

    private func uniqueFileName(for originalName: String) -> String {
        let dir = Paper.documentsDirectory
        var name = originalName
        var counter = 1

        while FileManager.default.fileExists(atPath: dir.appendingPathComponent(name).path) {
            let baseName = (originalName as NSString).deletingPathExtension
            let ext = (originalName as NSString).pathExtension
            name = "\(baseName)_\(counter).\(ext)"
            counter += 1
        }

        return name
    }
}

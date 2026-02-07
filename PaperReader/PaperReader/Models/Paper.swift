import Foundation
import SwiftData

@Model
final class Paper {
    var id: UUID
    var title: String
    var authors: String
    var fileName: String
    var fileSize: Int64
    var pageCount: Int
    var dateAdded: Date
    var lastOpened: Date?
    var currentPage: Int
    var isFavorite: Bool
    var tags: [String]

    @Relationship(deleteRule: .cascade)
    var bookmarks: [Bookmark]

    var filePath: URL {
        Paper.documentsDirectory.appendingPathComponent(fileName)
    }

    static var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Papers", isDirectory: true)
    }

    init(
        title: String,
        authors: String = "",
        fileName: String,
        fileSize: Int64 = 0,
        pageCount: Int = 0,
        currentPage: Int = 0,
        tags: [String] = []
    ) {
        self.id = UUID()
        self.title = title
        self.authors = authors
        self.fileName = fileName
        self.fileSize = fileSize
        self.pageCount = pageCount
        self.dateAdded = Date()
        self.lastOpened = nil
        self.currentPage = currentPage
        self.isFavorite = false
        self.tags = tags
        self.bookmarks = []
    }

    var readingProgress: Double {
        guard pageCount > 0 else { return 0 }
        return Double(currentPage) / Double(pageCount)
    }

    var formattedFileSize: String {
        ByteCountFormatter.string(fromByteCount: fileSize, countStyle: .file)
    }

    var formattedDateAdded: String {
        dateAdded.formatted(date: .abbreviated, time: .omitted)
    }
}

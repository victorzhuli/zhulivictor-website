import Foundation
import SwiftData

@Model
final class Bookmark {
    var id: UUID
    var pageNumber: Int
    var label: String
    var note: String
    var dateCreated: Date
    var color: BookmarkColor

    @Relationship(inverse: \Paper.bookmarks)
    var paper: Paper?

    init(pageNumber: Int, label: String = "", note: String = "", color: BookmarkColor = .red) {
        self.id = UUID()
        self.pageNumber = pageNumber
        self.label = label.isEmpty ? "Page \(pageNumber + 1)" : label
        self.note = note
        self.dateCreated = Date()
        self.color = color
    }
}

enum BookmarkColor: String, Codable, CaseIterable {
    case red, orange, yellow, green, blue, purple

    var displayName: String {
        rawValue.capitalized
    }
}

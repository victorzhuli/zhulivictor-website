import SwiftUI

@Observable
final class ReadingSettings {
    var colorScheme: ReaderColorScheme {
        didSet { save() }
    }
    var scrollMode: ScrollMode {
        didSet { save() }
    }
    var autoScaleToFit: Bool {
        didSet { save() }
    }
    var showThumbnails: Bool {
        didSet { save() }
    }
    var defaultSortOrder: SortOrder {
        didSet { save() }
    }

    init() {
        let defaults = UserDefaults.standard
        self.colorScheme = ReaderColorScheme(rawValue: defaults.string(forKey: "colorScheme") ?? "") ?? .system
        self.scrollMode = ScrollMode(rawValue: defaults.string(forKey: "scrollMode") ?? "") ?? .vertical
        self.autoScaleToFit = defaults.object(forKey: "autoScaleToFit") as? Bool ?? true
        self.showThumbnails = defaults.object(forKey: "showThumbnails") as? Bool ?? true
        self.defaultSortOrder = SortOrder(rawValue: defaults.string(forKey: "defaultSortOrder") ?? "") ?? .dateAdded
    }

    private func save() {
        let defaults = UserDefaults.standard
        defaults.set(colorScheme.rawValue, forKey: "colorScheme")
        defaults.set(scrollMode.rawValue, forKey: "scrollMode")
        defaults.set(autoScaleToFit, forKey: "autoScaleToFit")
        defaults.set(showThumbnails, forKey: "showThumbnails")
        defaults.set(defaultSortOrder.rawValue, forKey: "defaultSortOrder")
    }
}

enum ReaderColorScheme: String, CaseIterable {
    case system, light, dark, sepia

    var displayName: String {
        switch self {
        case .system: "System"
        case .light: "Light"
        case .dark: "Dark"
        case .sepia: "Sepia"
        }
    }

    var backgroundColor: Color {
        switch self {
        case .system: .clear
        case .light: .white
        case .dark: Color(white: 0.15)
        case .sepia: Color(red: 0.96, green: 0.93, blue: 0.87)
        }
    }

    var foregroundStyle: Color {
        switch self {
        case .system: .primary
        case .light: .black
        case .dark: .white
        case .sepia: Color(red: 0.35, green: 0.25, blue: 0.15)
        }
    }
}

enum ScrollMode: String, CaseIterable {
    case vertical, horizontal, singlePage

    var displayName: String {
        switch self {
        case .vertical: "Continuous Scroll"
        case .horizontal: "Horizontal Pages"
        case .singlePage: "Single Page"
        }
    }

    var icon: String {
        switch self {
        case .vertical: "arrow.up.arrow.down"
        case .horizontal: "arrow.left.arrow.right"
        case .singlePage: "doc"
        }
    }
}

enum SortOrder: String, CaseIterable {
    case dateAdded, lastOpened, title, author

    var displayName: String {
        switch self {
        case .dateAdded: "Date Added"
        case .lastOpened: "Last Opened"
        case .title: "Title"
        case .author: "Author"
        }
    }
}

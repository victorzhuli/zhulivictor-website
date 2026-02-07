# PaperReader

A native iOS app for comfortably reading academic papers in PDF format.

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Features

### Library Management
- Import PDFs from the Files app (supports multi-select)
- Grid and list view layouts with paper thumbnails
- Sort by date added, last opened, title, or author
- Search across paper titles, authors, and tags
- Swipe actions for quick favorites and delete
- Automatic metadata extraction (title, author, page count)

### PDF Reader
- Smooth PDF rendering via PDFKit
- Three scroll modes: continuous vertical, horizontal page-flip, single page
- Page slider for quick navigation
- Tap to show/hide reading controls
- Reading progress tracking (auto-saves current page)

### Reading Comfort
- Four color themes: System, Light, Dark, Sepia
- Auto-fit pages to screen width
- Landscape orientation support
- Full-screen reading mode

### Bookmarks & Navigation
- Bookmark any page with custom labels, notes, and colors
- Table of contents navigation (for PDFs with TOC)
- Full-text search within documents
- Go-to-page dialog

### Data Persistence
- SwiftData for paper metadata and bookmarks
- PDFs stored in app's Documents directory
- Reading progress saved automatically
- Settings persisted via UserDefaults

## Getting Started

1. Open `PaperReader.xcodeproj` in Xcode
2. Select your target device or simulator
3. Build and run (Cmd+R)

## Architecture

```
PaperReader/
├── PaperReaderApp.swift     # App entry point, SwiftData container
├── ContentView.swift        # Tab-based root view
├── Models/
│   ├── Paper.swift          # Paper data model (SwiftData)
│   ├── Bookmark.swift       # Bookmark data model (SwiftData)
│   └── ReadingSettings.swift # Observable settings with UserDefaults
├── Views/
│   ├── LibraryView.swift    # Main library with grid/list toggle
│   ├── PaperGridItem.swift  # Grid thumbnail card
│   ├── PaperListRow.swift   # List row with metadata
│   ├── PDFReaderView.swift  # Full reader with controls overlay
│   ├── PDFKitView.swift     # UIViewRepresentable PDFKit wrapper
│   ├── TOCView.swift        # Table of contents browser
│   ├── BookmarkListView.swift # Bookmark manager + editor
│   ├── SearchView.swift     # Full-text search
│   ├── FavoritesView.swift  # Filtered favorites list
│   └── SettingsView.swift   # App preferences
├── Services/
│   └── PDFManager.swift     # File import, deletion, thumbnails
├── Extensions/
│   └── Color+Bookmark.swift # Bookmark color mapping
└── Resources/
    └── Assets.xcassets/     # App icon, accent color
```

## Tech Stack

- **SwiftUI** - Declarative UI
- **PDFKit** - Native PDF rendering
- **SwiftData** - Persistence layer
- **Observation** - Reactive state management

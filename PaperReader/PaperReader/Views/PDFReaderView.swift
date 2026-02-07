import SwiftUI
import PDFKit

struct PDFReaderView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(ReadingSettings.self) private var settings

    @Bindable var paper: Paper

    @State private var pdfDocument: PDFDocument?
    @State private var currentPage: Int = 0
    @State private var showingControls = true
    @State private var showingTOC = false
    @State private var showingBookmarks = false
    @State private var showingSearch = false
    @State private var showingPageJump = false
    @State private var searchText = ""
    @State private var pageJumpText = ""
    @State private var brightness: Double = UIScreen.main.brightness

    var body: some View {
        ZStack {
            readerBackground

            if let document = pdfDocument {
                PDFKitView(
                    document: document,
                    currentPage: $currentPage,
                    scrollMode: settings.scrollMode,
                    autoScaleToFit: settings.autoScaleToFit
                )
                .ignoresSafeArea(edges: .bottom)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showingControls.toggle()
                    }
                }
            } else {
                ProgressView("Loading PDF...")
            }

            if showingControls {
                controlsOverlay
            }
        }
        .statusBarHidden(!showingControls)
        .onAppear {
            loadPDF()
            currentPage = paper.currentPage
        }
        .onDisappear {
            saveProgress()
        }
        .onChange(of: currentPage) { _, newValue in
            paper.currentPage = newValue
        }
        .sheet(isPresented: $showingTOC) {
            TOCView(document: pdfDocument, currentPage: $currentPage)
        }
        .sheet(isPresented: $showingBookmarks) {
            BookmarkListView(paper: paper, currentPage: $currentPage)
        }
        .sheet(isPresented: $showingSearch) {
            SearchView(document: pdfDocument, currentPage: $currentPage)
        }
        .alert("Go to Page", isPresented: $showingPageJump) {
            TextField("Page number", text: $pageJumpText)
                .keyboardType(.numberPad)
            Button("Go") {
                if let page = Int(pageJumpText), page > 0, page <= (pdfDocument?.pageCount ?? 0) {
                    currentPage = page - 1
                }
                pageJumpText = ""
            }
            Button("Cancel", role: .cancel) {
                pageJumpText = ""
            }
        } message: {
            Text("Enter page number (1-\(pdfDocument?.pageCount ?? 0))")
        }
    }

    private var readerBackground: some View {
        Group {
            switch settings.colorScheme {
            case .system:
                Color(.systemBackground)
            case .light:
                Color.white
            case .dark:
                Color(white: 0.12)
            case .sepia:
                Color(red: 0.96, green: 0.93, blue: 0.87)
            }
        }
        .ignoresSafeArea()
    }

    private var controlsOverlay: some View {
        VStack {
            topBar
            Spacer()
            bottomBar
        }
    }

    private var topBar: some View {
        HStack {
            Button {
                saveProgress()
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .symbolRenderingMode(.hierarchical)
            }

            Spacer()

            Text(paper.title)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(1)

            Spacer()

            Menu {
                Button {
                    showingTOC = true
                } label: {
                    Label("Table of Contents", systemImage: "list.bullet")
                }

                Button {
                    showingBookmarks = true
                } label: {
                    Label("Bookmarks", systemImage: "bookmark")
                }

                Button {
                    showingSearch = true
                } label: {
                    Label("Search", systemImage: "magnifyingglass")
                }

                Button {
                    showingPageJump = true
                } label: {
                    Label("Go to Page", systemImage: "number")
                }

                Divider()

                Button {
                    addBookmark()
                } label: {
                    Label("Bookmark This Page", systemImage: "bookmark.fill")
                }

                Divider()

                Menu("Reading Mode") {
                    ForEach(ReaderColorScheme.allCases, id: \.self) { scheme in
                        Button {
                            settings.colorScheme = scheme
                        } label: {
                            HStack {
                                Text(scheme.displayName)
                                if settings.colorScheme == scheme {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }

                Menu("Scroll Mode") {
                    ForEach(ScrollMode.allCases, id: \.self) { mode in
                        Button {
                            settings.scrollMode = mode
                        } label: {
                            HStack {
                                Label(mode.displayName, systemImage: mode.icon)
                                if settings.scrollMode == mode {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }
            } label: {
                Image(systemName: "ellipsis.circle.fill")
                    .font(.title2)
                    .symbolRenderingMode(.hierarchical)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
    }

    private var bottomBar: some View {
        VStack(spacing: 8) {
            if let document = pdfDocument {
                HStack(spacing: 16) {
                    Button {
                        if currentPage > 0 {
                            currentPage -= 1
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .disabled(currentPage == 0)

                    Slider(
                        value: Binding(
                            get: { Double(currentPage) },
                            set: { currentPage = Int($0) }
                        ),
                        in: 0...Double(max(document.pageCount - 1, 1)),
                        step: 1
                    )

                    Button {
                        if currentPage < document.pageCount - 1 {
                            currentPage += 1
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                    }
                    .disabled(currentPage >= document.pageCount - 1)
                }

                Text("Page \(currentPage + 1) of \(document.pageCount)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
    }

    private func loadPDF() {
        pdfDocument = PDFDocument(url: paper.filePath)
    }

    private func saveProgress() {
        paper.currentPage = currentPage
        paper.lastOpened = Date()
        try? modelContext.save()
    }

    private func addBookmark() {
        let existingBookmark = paper.bookmarks.first { $0.pageNumber == currentPage }
        if existingBookmark == nil {
            let bookmark = Bookmark(pageNumber: currentPage)
            paper.bookmarks.append(bookmark)
            try? modelContext.save()
        }
    }
}

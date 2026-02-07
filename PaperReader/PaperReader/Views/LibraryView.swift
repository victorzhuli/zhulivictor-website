import SwiftUI
import SwiftData

struct LibraryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(ReadingSettings.self) private var settings
    @Query private var papers: [Paper]

    @State private var searchText = ""
    @State private var showingImporter = false
    @State private var showingGrid = true
    @State private var sortOrder: SortOrder = .dateAdded
    @State private var selectedPaper: Paper?
    @State private var importError: String?
    @State private var showingError = false

    private var filteredPapers: [Paper] {
        let filtered: [Paper]
        if searchText.isEmpty {
            filtered = papers
        } else {
            filtered = papers.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.authors.localizedCaseInsensitiveContains(searchText) ||
                $0.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }

        return filtered.sorted { a, b in
            switch sortOrder {
            case .dateAdded:
                return a.dateAdded > b.dateAdded
            case .lastOpened:
                return (a.lastOpened ?? .distantPast) > (b.lastOpened ?? .distantPast)
            case .title:
                return a.title.localizedCompare(b.title) == .orderedAscending
            case .author:
                return a.authors.localizedCompare(b.authors) == .orderedAscending
            }
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if papers.isEmpty {
                    emptyLibraryView
                } else if showingGrid {
                    gridView
                } else {
                    listView
                }
            }
            .navigationTitle("Library")
            .searchable(text: $searchText, prompt: "Search papers...")
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Menu {
                        Picker("Sort", selection: $sortOrder) {
                            ForEach(SortOrder.allCases, id: \.self) { order in
                                Text(order.displayName).tag(order)
                            }
                        }
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }

                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        withAnimation {
                            showingGrid.toggle()
                        }
                    } label: {
                        Image(systemName: showingGrid ? "list.bullet" : "square.grid.2x2")
                    }

                    Button {
                        showingImporter = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .fileImporter(
                isPresented: $showingImporter,
                allowedContentTypes: [.pdf],
                allowsMultipleSelection: true
            ) { result in
                handleImport(result)
            }
            .alert("Import Error", isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(importError ?? "An unknown error occurred.")
            }
            .fullScreenCover(item: $selectedPaper) { paper in
                PDFReaderView(paper: paper)
            }
        }
    }

    private var emptyLibraryView: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)

            Text("No Papers Yet")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Tap the + button to import PDF papers\nfrom your files.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button {
                showingImporter = true
            } label: {
                Label("Import PDF", systemImage: "doc.badge.plus")
                    .font(.headline)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }

    private var gridView: some View {
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 150, maximum: 200), spacing: 16)],
                spacing: 20
            ) {
                ForEach(filteredPapers, id: \.id) { paper in
                    PaperGridItem(paper: paper)
                        .onTapGesture {
                            openPaper(paper)
                        }
                        .contextMenu {
                            paperContextMenu(for: paper)
                        }
                }
            }
            .padding()
        }
    }

    private var listView: some View {
        List(filteredPapers, id: \.id) { paper in
            PaperListRow(paper: paper)
                .contentShape(Rectangle())
                .onTapGesture {
                    openPaper(paper)
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        deletePaper(paper)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }

                    Button {
                        paper.isFavorite.toggle()
                    } label: {
                        Label(
                            paper.isFavorite ? "Unfavorite" : "Favorite",
                            systemImage: paper.isFavorite ? "star.slash" : "star"
                        )
                    }
                    .tint(.yellow)
                }
        }
        .listStyle(.plain)
    }

    @ViewBuilder
    private func paperContextMenu(for paper: Paper) -> some View {
        Button {
            paper.isFavorite.toggle()
        } label: {
            Label(
                paper.isFavorite ? "Remove from Favorites" : "Add to Favorites",
                systemImage: paper.isFavorite ? "star.slash" : "star"
            )
        }

        Button(role: .destructive) {
            deletePaper(paper)
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }

    private func openPaper(_ paper: Paper) {
        paper.lastOpened = Date()
        selectedPaper = paper
    }

    private func deletePaper(_ paper: Paper) {
        Task {
            try? await PDFManager.shared.deletePaper(paper, modelContext: modelContext)
        }
    }

    private func handleImport(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            Task {
                for url in urls {
                    do {
                        _ = try await PDFManager.shared.importPDF(from: url, modelContext: modelContext)
                    } catch {
                        importError = error.localizedDescription
                        showingError = true
                    }
                }
            }
        case .failure(let error):
            importError = error.localizedDescription
            showingError = true
        }
    }
}

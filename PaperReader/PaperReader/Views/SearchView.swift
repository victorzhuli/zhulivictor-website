import SwiftUI
import PDFKit

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss

    let document: PDFDocument?
    @Binding var currentPage: Int

    @State private var searchText = ""
    @State private var searchResults: [PDFSelection] = []
    @State private var isSearching = false

    var body: some View {
        NavigationStack {
            VStack {
                if searchText.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 48))
                            .foregroundStyle(.secondary)

                        Text("Search in Document")
                            .font(.headline)

                        Text("Type to search for text in this PDF.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxHeight: .infinity)
                } else if isSearching {
                    ProgressView("Searching...")
                        .frame(maxHeight: .infinity)
                } else if searchResults.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 48))
                            .foregroundStyle(.secondary)

                        Text("No Results")
                            .font(.headline)

                        Text("No matches found for \"\(searchText)\"")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    List(Array(searchResults.enumerated()), id: \.offset) { _, selection in
                        Button {
                            if let page = selection.pages.first,
                               let document = document {
                                currentPage = document.index(for: page)
                                dismiss()
                            }
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                if let page = selection.pages.first,
                                   let document = document {
                                    Text("Page \(document.index(for: page) + 1)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Text(contextString(for: selection))
                                    .font(.subheadline)
                                    .lineLimit(3)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .searchable(text: $searchText, prompt: "Search text...")
            .onChange(of: searchText) { _, newValue in
                performSearch(query: newValue)
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("\(searchResults.count) results")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func performSearch(query: String) {
        guard !query.isEmpty, let document = document else {
            searchResults = []
            return
        }

        isSearching = true

        DispatchQueue.global(qos: .userInitiated).async {
            let results = document.findString(query, withOptions: [.caseInsensitive])

            DispatchQueue.main.async {
                searchResults = results
                isSearching = false
            }
        }
    }

    private func contextString(for selection: PDFSelection) -> String {
        let extendedSelection = PDFSelection(document: document!)
        extendedSelection.add(selection)

        extendedSelection.extendForLineBoundaries()
        return extendedSelection.string ?? selection.string ?? ""
    }
}

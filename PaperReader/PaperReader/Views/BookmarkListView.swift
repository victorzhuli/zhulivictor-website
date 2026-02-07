import SwiftUI

struct BookmarkListView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Bindable var paper: Paper
    @Binding var currentPage: Int

    @State private var editingBookmark: Bookmark?

    var body: some View {
        NavigationStack {
            Group {
                if paper.bookmarks.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "bookmark")
                            .font(.system(size: 48))
                            .foregroundStyle(.secondary)

                        Text("No Bookmarks")
                            .font(.headline)

                        Text("Tap the menu button while reading\nto bookmark a page.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                } else {
                    List {
                        ForEach(paper.bookmarks.sorted(by: { $0.pageNumber < $1.pageNumber }), id: \.id) { bookmark in
                            Button {
                                currentPage = bookmark.pageNumber
                                dismiss()
                            } label: {
                                HStack {
                                    Circle()
                                        .fill(bookmark.color.color)
                                        .frame(width: 10, height: 10)

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(bookmark.label)
                                            .foregroundStyle(.primary)

                                        if !bookmark.note.isEmpty {
                                            Text(bookmark.note)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                                .lineLimit(2)
                                        }
                                    }

                                    Spacer()

                                    Text("p. \(bookmark.pageNumber + 1)")
                                        .font(.caption)
                                        .foregroundStyle(.tertiary)
                                }
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    deleteBookmark(bookmark)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }

                                Button {
                                    editingBookmark = bookmark
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Bookmarks")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(item: $editingBookmark) { bookmark in
                EditBookmarkView(bookmark: bookmark)
            }
        }
    }

    private func deleteBookmark(_ bookmark: Bookmark) {
        paper.bookmarks.removeAll { $0.id == bookmark.id }
        modelContext.delete(bookmark)
        try? modelContext.save()
    }
}

struct EditBookmarkView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Bindable var bookmark: Bookmark

    var body: some View {
        NavigationStack {
            Form {
                Section("Label") {
                    TextField("Bookmark label", text: $bookmark.label)
                }

                Section("Note") {
                    TextEditor(text: $bookmark.note)
                        .frame(minHeight: 100)
                }

                Section("Color") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
                        ForEach(BookmarkColor.allCases, id: \.self) { color in
                            Circle()
                                .fill(color.color)
                                .frame(width: 36, height: 36)
                                .overlay {
                                    if bookmark.color == color {
                                        Image(systemName: "checkmark")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.white)
                                    }
                                }
                                .onTapGesture {
                                    bookmark.color = color
                                }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Edit Bookmark")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        try? modelContext.save()
                        dismiss()
                    }
                }
            }
        }
    }
}

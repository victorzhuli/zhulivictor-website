import SwiftUI
import PDFKit

struct TOCView: View {
    @Environment(\.dismiss) private var dismiss

    let document: PDFDocument?
    @Binding var currentPage: Int

    var body: some View {
        NavigationStack {
            Group {
                if let outline = document?.outlineRoot, outlineHasChildren(outline) {
                    List {
                        outlineItems(for: outline)
                    }
                    .listStyle(.plain)
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "list.bullet.rectangle")
                            .font(.system(size: 48))
                            .foregroundStyle(.secondary)

                        Text("No Table of Contents")
                            .font(.headline)

                        Text("This PDF doesn't have a table of contents.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Table of Contents")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    @ViewBuilder
    private func outlineItems(for outline: PDFOutline) -> some View {
        ForEach(0..<outline.numberOfChildren, id: \.self) { index in
            if let child = outline.child(at: index) {
                outlineRow(for: child)
            }
        }
    }

    @ViewBuilder
    private func outlineRow(for item: PDFOutline) -> some View {
        if item.numberOfChildren > 0 {
            DisclosureGroup {
                outlineItems(for: item)
            } label: {
                outlineLabel(for: item)
            }
        } else {
            outlineLabel(for: item)
        }
    }

    private func outlineLabel(for item: PDFOutline) -> some View {
        Button {
            if let page = item.destination?.page,
               let document = document {
                currentPage = document.index(for: page)
                dismiss()
            }
        } label: {
            HStack {
                Text(item.label ?? "Untitled")
                    .foregroundStyle(.primary)

                Spacer()

                if let page = item.destination?.page,
                   let document = document {
                    Text("p. \(document.index(for: page) + 1)")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
        }
    }

    private func outlineHasChildren(_ outline: PDFOutline) -> Bool {
        outline.numberOfChildren > 0
    }
}

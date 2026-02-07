import SwiftUI

struct PaperGridItem: View {
    let paper: Paper
    @State private var thumbnail: UIImage?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray5))

                if let thumbnail {
                    Image(uiImage: thumbnail)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } else {
                    Image(systemName: "doc.text")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)
                }
            }
            .aspectRatio(3/4, contentMode: .fit)
            .overlay(alignment: .topTrailing) {
                if paper.isFavorite {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                        .padding(6)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                if paper.readingProgress > 0 {
                    Text("\(Int(paper.readingProgress * 100))%")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.ultraThinMaterial, in: Capsule())
                        .padding(6)
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(paper.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(2)

                if !paper.authors.isEmpty {
                    Text(paper.authors)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
        }
        .task {
            thumbnail = await PDFManager.shared.generateThumbnail(for: paper)
        }
    }
}

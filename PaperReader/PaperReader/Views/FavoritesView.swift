import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Paper> { $0.isFavorite }) private var favorites: [Paper]

    @State private var selectedPaper: Paper?

    var body: some View {
        NavigationStack {
            Group {
                if favorites.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "star")
                            .font(.system(size: 48))
                            .foregroundStyle(.secondary)

                        Text("No Favorites")
                            .font(.headline)

                        Text("Swipe right on a paper in the Library\nor use the context menu to add favorites.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                } else {
                    List(favorites.sorted(by: { $0.dateAdded > $1.dateAdded }), id: \.id) { paper in
                        PaperListRow(paper: paper)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                paper.lastOpened = Date()
                                selectedPaper = paper
                            }
                            .swipeActions(edge: .trailing) {
                                Button {
                                    paper.isFavorite = false
                                } label: {
                                    Label("Unfavorite", systemImage: "star.slash")
                                }
                                .tint(.yellow)
                            }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Favorites")
            .fullScreenCover(item: $selectedPaper) { paper in
                PDFReaderView(paper: paper)
            }
        }
    }
}

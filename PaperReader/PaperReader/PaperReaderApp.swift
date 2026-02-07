import SwiftUI
import SwiftData

@main
struct PaperReaderApp: App {
    let modelContainer: ModelContainer

    init() {
        do {
            let schema = Schema([Paper.self, Bookmark.self])
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            modelContainer = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(ReadingSettings())
        }
        .modelContainer(modelContainer)
    }
}

import SwiftUI

struct SettingsView: View {
    @Environment(ReadingSettings.self) private var settings

    var body: some View {
        @Bindable var settings = settings

        NavigationStack {
            Form {
                Section("Reading") {
                    Picker("Color Theme", selection: $settings.colorScheme) {
                        ForEach(ReaderColorScheme.allCases, id: \.self) { scheme in
                            Text(scheme.displayName).tag(scheme)
                        }
                    }

                    Picker("Scroll Mode", selection: $settings.scrollMode) {
                        ForEach(ScrollMode.allCases, id: \.self) { mode in
                            Label(mode.displayName, systemImage: mode.icon).tag(mode)
                        }
                    }

                    Toggle("Auto-fit Pages", isOn: $settings.autoScaleToFit)
                }

                Section("Library") {
                    Picker("Default Sort", selection: $settings.defaultSortOrder) {
                        ForEach(SortOrder.allCases, id: \.self) { order in
                            Text(order.displayName).tag(order)
                        }
                    }

                    Toggle("Show Thumbnails", isOn: $settings.showThumbnails)
                }

                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Text("Built with")
                        Spacer()
                        Text("SwiftUI & PDFKit")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

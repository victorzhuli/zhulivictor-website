import SwiftUI
import PDFKit

struct PDFKitView: UIViewRepresentable {
    let document: PDFDocument
    @Binding var currentPage: Int
    let scrollMode: ScrollMode
    let autoScaleToFit: Bool

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = document
        pdfView.autoScales = autoScaleToFit
        pdfView.backgroundColor = .clear
        pdfView.pageShadowsEnabled = false

        applyScrollMode(to: pdfView)

        // Navigate to saved page
        if let page = document.page(at: currentPage) {
            pdfView.go(to: page)
        }

        NotificationCenter.default.addObserver(
            context.coordinator,
            selector: #selector(Coordinator.pageChanged(_:)),
            name: .PDFViewPageChanged,
            object: pdfView
        )

        return pdfView
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {
        if pdfView.document !== document {
            pdfView.document = document
        }

        pdfView.autoScales = autoScaleToFit
        applyScrollMode(to: pdfView)

        // Only navigate if the page changed from outside (slider, bookmark, etc.)
        if let currentPDFPage = pdfView.currentPage,
           let currentIndex = document.index(for: currentPDFPage),
           currentIndex != currentPage {
            if let page = document.page(at: currentPage) {
                pdfView.go(to: page)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    private func applyScrollMode(to pdfView: PDFView) {
        switch scrollMode {
        case .vertical:
            pdfView.displayMode = .singlePageContinuous
            pdfView.displayDirection = .vertical
        case .horizontal:
            pdfView.displayMode = .singlePage
            pdfView.displayDirection = .horizontal
            pdfView.usePageViewController(true, withViewOptions: nil)
        case .singlePage:
            pdfView.displayMode = .singlePage
            pdfView.displayDirection = .vertical
        }
    }

    class Coordinator: NSObject {
        var parent: PDFKitView

        init(_ parent: PDFKitView) {
            self.parent = parent
        }

        @objc func pageChanged(_ notification: Notification) {
            guard let pdfView = notification.object as? PDFView,
                  let currentPage = pdfView.currentPage,
                  let document = pdfView.document,
                  let pageIndex = Optional(document.index(for: currentPage)) else {
                return
            }

            DispatchQueue.main.async {
                if self.parent.currentPage != pageIndex {
                    self.parent.currentPage = pageIndex
                }
            }
        }

        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    }
}

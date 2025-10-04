import SwiftUI

/// The entry point for the LeftoverLink prototype application.
///
/// This version of the app runs entirely on device without any
/// network dependencies. It seeds a mock repository with sample data
/// and injects a single `ListingListViewModel` into the view hierarchy
/// using `@StateObject`. The `ContentView` then passes this view
/// model down via environment for both browsing and adding listings.
@main
struct LeftoverLinkApp: App {
    /// A single shared view model for listing operations. Injected as an
    /// environment object so all child views observe the same data source.
    @StateObject private var listViewModel = ListingListViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(listViewModel)
        }
    }
}

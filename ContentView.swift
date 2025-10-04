import SwiftUI

/// The root view of the application. It hosts a `TabView` with two
/// destinations: one for browsing existing food listings and one for
/// creating a new listing. Tabs are labelled with SF Symbols to make
/// navigation intuitive for users.
/// The main tab view for LeftoverLink. It displays the listings and the
/// form to add a new listing. A shared `ListingListViewModel` is
/// provided via the environment from `LeftoverLinkApp`.
struct ContentView: View {
    var body: some View {
        TabView {
            ListingsView()
                .tabItem {
                    Label("Listings", systemImage: "list.bullet.rectangle")
                }
            AddListingView()
                .tabItem {
                    Label("New Post", systemImage: "plus.circle.fill")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

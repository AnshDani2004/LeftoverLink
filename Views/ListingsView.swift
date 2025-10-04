import SwiftUI

/// The listings tab displays all available food posts. Users can search,
/// filter by dietary tag, pull to refresh and swipe to delete posts. Each
/// row is styled as a rounded card with location badges and coloured tag
/// pills. If there are no listings an empty state is shown.
struct ListingsView: View {
    @EnvironmentObject private var viewModel: ListingListViewModel
    /// Available filter tags. The first entry should be "All" to indicate
    /// no filtering.
    private let filterTags: [String] = ["All", "Vegetarian", "Vegan", "Gluten-Free", "Nut-Free"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Filter bar at the top
                TagFilterBar(selectedTag: $viewModel.selectedTag, tags: filterTags)
                // Main content
                if viewModel.listings.isEmpty {
                    Spacer()
                    VStack(spacing: 8) {
                        Text("🥗")
                            .font(.system(size: 56))
                        Text("No listings yet — add your first post!")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.listings) { listing in
                            NavigationLink {
                                ListingDetailView(listing: listing)
                            } label: {
                                ListingRowView(listing: listing)
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteListing)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Food Listings")
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search listings")
            .refreshable {
                viewModel.refresh()
            }
        }
    }

    /// Delete handler for swipe to delete.
    private func deleteListing(at offsets: IndexSet) {
        offsets.map { viewModel.listings[$0] }.forEach { listing in
            viewModel.delete(listing)
        }
    }
}

struct ListingsView_Previews: PreviewProvider {
    static var previews: some View {
        ListingsView()
            .environmentObject(ListingListViewModel())
    }
}
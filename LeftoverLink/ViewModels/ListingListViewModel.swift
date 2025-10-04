import Foundation
import Combine

/// A view model that coordinates listing data for the UI. It binds the
/// repository’s publisher to an array of filtered listings based on the
/// current search text and selected dietary tag. The view model exposes
/// methods to add and delete listings, as well as trigger a refresh.
class ListingListViewModel: ObservableObject {
    /// The repository providing listing data.
    private let repository: ListingRepository
    /// The filtered listings displayed in the UI.
    @Published var listings: [FoodListing] = []
    /// The current search text entered by the user.
    @Published var searchText: String = ""
    /// The currently selected dietary tag filter. A nil value means no filter.
    @Published var selectedTag: String? = nil

    private var cancellables = Set<AnyCancellable>()

    init(repository: ListingRepository = MockListingRepository()) {
        self.repository = repository
        // Combine the latest values of the repository's listings, search text
        // and selected tag to compute the filtered result. Whenever any of
        // these publishers emit, the closure runs and updates `listings` on
        // the main thread.
        Publishers
            .CombineLatest3(repository.listingsPublisher, $searchText, $selectedTag)
            .map { listings, search, tag -> [FoodListing] in
                var results = listings
                // Filter by search text if provided
                if !search.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    let lower = search.lowercased()
                    results = results.filter { listing in
                        listing.title.lowercased().contains(lower) ||
                        listing.description.lowercased().contains(lower)
                    }
                }
                // Filter by tag if one is selected (and not the catch‑all "All")
                if let tag = tag, tag != "All" {
                    results = results.filter { listing in
                        listing.dietaryTags.contains(tag)
                    }
                }
                return results
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \ListingListViewModel.listings, on: self)
            .store(in: &cancellables)
    }

    /// Add a new listing to the repository.
    func add(_ listing: FoodListing) {
        repository.add(listing)
    }

    /// Delete a listing from the repository.
    func delete(_ listing: FoodListing) {
        repository.delete(listing)
    }

    /// Trigger a refresh of the repository. In the mock implementation this
    /// simply re‑emits the existing data, allowing the pull‑to‑refresh UI
    /// gesture to complete.
    func refresh() {
        repository.refresh()
    }
}
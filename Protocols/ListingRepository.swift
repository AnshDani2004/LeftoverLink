import Combine

/// An abstraction describing how listing data should be managed. Both
/// network‑backed and in‑memory repositories can conform to this protocol.
/// The prototype implementation uses a mock repository that stores
/// everything in a `CurrentValueSubject` so UI updates happen in real time.
protocol ListingRepository {
    /// A publisher that emits the current array of `FoodListing` objects
    /// whenever they change. The publisher never fails.
    var listingsPublisher: AnyPublisher<[FoodListing], Never> { get }
    /// Add a new listing to the data source.
    func add(_ listing: FoodListing)
    /// Delete an existing listing from the data source.
    func delete(_ listing: FoodListing)
    /// Optional method to refresh the data. For the mock repository this
    /// simply re‑emits the current listings.
    func refresh()
}
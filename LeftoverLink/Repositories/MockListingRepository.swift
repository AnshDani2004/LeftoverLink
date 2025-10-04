import Foundation
import Combine

/// A mock repository that stores listings entirely in memory. It seeds
/// initial sample data so the app feels populated on first launch. The
/// repository uses a `CurrentValueSubject` to publish changes to the
/// listings array. Whenever a listing is added or deleted the subject
/// emits an updated array to its subscribers.
final class MockListingRepository: ListingRepository {
    /// The underlying subject that holds the current array of listings.
    private let subject: CurrentValueSubject<[FoodListing], Never>

    /// Initialize the repository with a set of sample listings. These
    /// examples provide variety in location and dietary tags to showcase
    /// the UI.
    init() {
        let seed: [FoodListing] = [
            FoodListing(title: "Leftover Pasta",
                        description: "Delicious penne pasta with marinara sauce and veggies.",
                        location: "Dorm A",
                        dietaryTags: ["Vegetarian"],
                        imageData: nil,
                        createdAt: Date().addingTimeInterval(-3600)),
            FoodListing(title: "Half a Pizza",
                        description: "Half of a pepperoni pizza from last night.",
                        location: "Apartment 3C",
                        dietaryTags: ["Nut-Free"],
                        imageData: nil,
                        createdAt: Date().addingTimeInterval(-7200)),
            FoodListing(title: "Gluten-free Muffins",
                        description: "Freshly baked gluten-free banana muffins.",
                        location: "Library Cafe",
                        dietaryTags: ["Gluten-Free"],
                        imageData: nil,
                        createdAt: Date().addingTimeInterval(-86400)),
            FoodListing(title: "Vegan Salad",
                        description: "Mixed greens with quinoa and chickpeas.",
                        location: "Dorm B",
                        dietaryTags: ["Vegan"],
                        imageData: nil,
                        createdAt: Date().addingTimeInterval(-5400)),
            FoodListing(title: "Fruit Bowl",
                        description: "Assorted seasonal fruits.",
                        location: "Student Center",
                        dietaryTags: ["Vegetarian", "Nut-Free"],
                        imageData: nil,
                        createdAt: Date().addingTimeInterval(-18000))
        ]
        self.subject = CurrentValueSubject<[FoodListing], Never>(seed)
    }

    // MARK: - ListingRepository Conformance

    var listingsPublisher: AnyPublisher<[FoodListing], Never> {
        subject.eraseToAnyPublisher()
    }

    func add(_ listing: FoodListing) {
        var current = subject.value
        // Insert new listings at the beginning so they appear at the top.
        current.insert(listing, at: 0)
        subject.send(current)
    }

    func delete(_ listing: FoodListing) {
        var current = subject.value
        if let id = listing.id {
            current.removeAll { $0.id == id }
            subject.send(current)
        }
    }

    func refresh() {
        // For a mock repository we simply re‑emit the current listings. In a
        // real implementation this would trigger a network fetch.
        let current = subject.value
        subject.send(current)
    }
}
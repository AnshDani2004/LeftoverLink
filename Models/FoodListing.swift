import Foundation
import SwiftUI

/// A local data model representing a food listing. This version does not
/// depend on Firestore and instead stores all properties in memory. Each
/// listing has a unique identifier, descriptive fields, a list of dietary
/// tags, optional image data and a creation timestamp. The default values
/// allow easy instantiation for both seeds and new user posts.
struct FoodListing: Identifiable, Codable {
    /// A unique identifier for the listing. When a new listing is created the
    /// identifier is generated automatically.
    var id: String? = UUID().uuidString
    /// A short title describing the food item.
    var title: String
    /// A longer description with additional details.
    var description: String
    /// The general location where the item can be picked up.
    var location: String
    /// Dietary tags associated with the item (e.g. Vegetarian, Vegan).
    var dietaryTags: [String]
    /// Optional raw image data for a photo selected from the library. The
    /// `ListingRowView` and `ListingDetailView` convert this into a `UIImage`.
    var imageData: Data?
    /// Timestamp for sorting listings chronologically. Defaults to now.
    var createdAt: Date = Date()
}
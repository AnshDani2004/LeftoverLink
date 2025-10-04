import SwiftUI

/// A stylised card representing a single food listing. The row displays
/// the title, a brief description, a coloured location badge and coloured
/// pills for each dietary tag. An optional thumbnail image is shown on
/// the left; otherwise a placeholder icon is used.
struct ListingRowView: View {
    let listing: FoodListing

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)

            HStack(alignment: .top, spacing: 12) {
                // Thumbnail image or placeholder
                if let data = listing.imageData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.2))
                        Image(systemName: "photo")
                            .foregroundColor(.secondary)
                    }
                    .frame(width: 60, height: 60)
                }

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(listing.title)
                            .font(.headline)
                        Spacer()
                        locationBadge(for: listing.location)
                    }
                    Text(listing.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    HStack(spacing: 4) {
                        ForEach(listing.dietaryTags, id: \.self) { tag in
                            tagPill(for: tag)
                        }
                    }
                }
            }
            .padding(12)
        }
        .padding(.vertical, 4)
    }

    private func locationBadge(for location: String) -> some View {
        Text(location)
            .font(.caption2).bold()
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.accentColor.opacity(0.2))
            .foregroundColor(Color.accentColor)
            .clipShape(Capsule())
    }

    private func tagPill(for tag: String) -> some View {
        Text(tag)
            .font(.caption2)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(tagColor(tag).opacity(0.2))
            .foregroundColor(tagColor(tag))
            .clipShape(Capsule())
    }

    private func tagColor(_ tag: String) -> Color {
        switch tag {
        case "Vegetarian": return .green
        case "Vegan": return .purple
        case "Gluten-Free": return .orange
        case "Nut-Free": return .blue
        default: return .gray
        }
    }
}

import SwiftUI

/// A detailed card view presenting all information about a `FoodListing`.
/// It displays a large image (or placeholder), the title, location badge,
/// coloured dietary tags, description and a relative timestamp.
struct ListingDetailView: View {
    let listing: FoodListing

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Image
                if let data = listing.imageData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.gray.opacity(0.2))
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .padding(40)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .aspectRatio(4/3, contentMode: .fit)
                    .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
                }
                // Title and metadata
                Text(listing.title)
                    .font(.title)
                    .bold()
                locationBadge(for: listing.location)
                HStack(spacing: 4) {
                    ForEach(listing.dietaryTags, id: \.self) { tag in
                        tagPill(for: tag)
                    }
                }
                Text(listing.description)
                    .font(.body)
                Text("Posted \(timeAgo(from: listing.createdAt))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func locationBadge(for location: String) -> some View {
        Text(location)
            .font(.caption).bold()
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.accentColor.opacity(0.2))
            .foregroundColor(Color.accentColor)
            .clipShape(Capsule())
    }

    private func tagPill(for tag: String) -> some View {
        Text(tag)
            .font(.caption2)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
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

struct ListingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ListingDetailView(listing: FoodListing(title: "Extra Pasta",
                                               description: "Leftover penne pasta with marinara sauce.",
                                               location: "Apartment 3B",
                                               dietaryTags: ["Vegetarian"],
                                               imageData: nil))
    }
}

import SwiftUI

/// A horizontally scrolling bar of dietary tags used to filter listings.
/// Selecting a tag highlights it and updates the bound `selectedTag`. Tapping
/// the selected tag again clears the filter. The first item should be
/// "All" to indicate no tag filter.
struct TagFilterBar: View {
    @Binding var selectedTag: String?
    /// Available tags including the catch‑all "All". Tags must be unique.
    let tags: [String]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(tags, id: \.self) { tag in
                    let isSelected = (selectedTag == nil && tag == "All") || (selectedTag == tag)
                    Text(tag)
                        .font(.caption)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(backgroundColor(for: tag, selected: isSelected))
                        .foregroundColor(foregroundColor(for: tag, selected: isSelected))
                        .clipShape(Capsule())
                        .onTapGesture {
                            if tag == "All" {
                                selectedTag = nil
                            } else if selectedTag == tag {
                                selectedTag = nil
                            } else {
                                selectedTag = tag
                            }
                        }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
        }
    }

    /// Determines the background colour for a tag. Selected tags use their
    /// primary colour; unselected tags use a faint variant.
    private func backgroundColor(for tag: String, selected: Bool) -> Color {
        let base = tagColor(tag)
        return selected ? base : base.opacity(0.2)
    }

    /// Determines the text colour for a tag. Selected tags use white for
    /// contrast; unselected tags use their primary colour.
    private func foregroundColor(for tag: String, selected: Bool) -> Color {
        let base = tagColor(tag)
        return selected ? Color.white : base
    }

    /// Returns a colour associated with a particular tag. Unknown tags use
    /// a neutral grey. The special tag "All" uses the system secondary
    /// colour.
    private func tagColor(_ tag: String) -> Color {
        switch tag {
        case "Vegetarian": return .green
        case "Vegan": return .purple
        case "Gluten-Free": return .orange
        case "Nut-Free": return .blue
        case "All": return .secondary
        default: return .gray
        }
    }
}

struct TagFilterBar_Previews: PreviewProvider {
    static var previews: some View {
        TagFilterBar(selectedTag: .constant(nil), tags: ["All", "Vegetarian", "Vegan", "Gluten-Free", "Nut-Free"])
            .previewLayout(.sizeThatFits)
    }
}

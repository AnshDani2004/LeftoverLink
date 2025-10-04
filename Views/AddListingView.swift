import SwiftUI
import PhotosUI

struct AddListingView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: ListingListViewModel

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var location: String = ""
    @State private var selectedTags: Set<String> = []
    @State private var selectedPhotosPickerItem: PhotosPickerItem?
    @State private var imageData: Data?

    private let dietaryOptions: [String] = ["Vegetarian", "Vegan", "Gluten-Free", "Nut-Free"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Card: ZStack ensures the shape matches the content
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemBackground))
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)

                        VStack(alignment: .leading, spacing: 16) {
                            // Input fields
                            TextField("Title", text: $title)
                                .textFieldStyle(.roundedBorder)
                            TextField("Description", text: $description, axis: .vertical)
                                .textFieldStyle(.roundedBorder)
                            TextField("Location", text: $location)
                                .textFieldStyle(.roundedBorder)

                            // Dietary tag picker
                            Text("Dietary Tags")
                                .font(.headline)
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 8)], spacing: 8) {
                                ForEach(dietaryOptions, id: \.self) { tag in
                                    let isSelected = selectedTags.contains(tag)
                                    Text(tag)
                                        .font(.caption)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(isSelected ? tagColor(tag) : tagColor(tag).opacity(0.2))
                                        .foregroundColor(isSelected ? .white : tagColor(tag))
                                        .clipShape(Capsule())
                                        .onTapGesture {
                                            if isSelected { selectedTags.remove(tag) } else { selectedTags.insert(tag) }
                                        }
                                }
                            }

                            // Image picker
                            HStack {
                                if let data = imageData, let uiImage = UIImage(data: data) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                                } else {
                                    ZStack {
                                        Circle().fill(Color.gray.opacity(0.2))
                                        Image(systemName: "photo")
                                            .font(.title)
                                            .foregroundColor(.secondary)
                                    }
                                    .frame(width: 80, height: 80)
                                }

                                PhotosPicker(selection: $selectedPhotosPickerItem, matching: .images) {
                                    Text("Choose Photo")
                                        .font(.subheadline)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 16)
                                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.accentColor.opacity(0.2)))
                                        .foregroundColor(Color.accentColor)
                                }
                                .onChange(of: selectedPhotosPickerItem) { oldItem, newItem in
                                    guard let newItem else { return }
                                    Task {
                                        if let data = try? await newItem.loadTransferable(type: Data.self) {
                                            await MainActor.run { self.imageData = data }
                                        }
                                    }
                                }
                            }

                            // Post Listing button
                            Button(action: submitListing) {
                                Text("Post Listing")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        LinearGradient(colors: [.green, .blue], startPoint: .leading, endPoint: .trailing)
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .disabled(!isFormValid)
                            .opacity(isFormValid ? 1.0 : 0.5)
                        }
                        .padding(24)
                    }
                    .frame(maxWidth: .infinity)
                }
                // Large top padding pushes the card below the notch/Dynamic Island
                .padding(EdgeInsets(top: 100, leading: 16, bottom: 16, trailing: 16))
            }
            // Inline nav bar avoids large-title overlaps
            .navigationTitle("New Listing")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func submitListing() {
        let listing = FoodListing(
            title: title,
            description: description,
            location: location,
            dietaryTags: Array(selectedTags),
            imageData: imageData,
            createdAt: Date()
        )
        viewModel.add(listing)
        title = ""
        description = ""
        location = ""
        selectedTags.removeAll()
        imageData = nil
        selectedPhotosPickerItem = nil
        dismiss()
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

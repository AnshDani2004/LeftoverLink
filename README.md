# LeftoverLink – SwiftUI Prototype

LeftoverLink is a SwiftUI prototype designed to demonstrate a polished food‑sharing app for students. This version runs entirely in memory without any network or Firebase dependencies. It implements a clean MVVM architecture with a protocol‑based repository, a mock data source, and a modern, colourful user interface inspired by real apps.

## Features

* **Seeded Listings** – On first launch the app loads five sample posts with a variety of dietary tags and locations so the listings tab feels alive.
* **Listings Tab** – Browse available food posts in a list of rounded cards. Each card shows the title, a short description, a coloured location badge and dietary tags styled as coloured pills. Pull to refresh re‑emits the current data. Swipe left to delete a listing.
* **Search & Filter** – Use the search bar to find posts by title or description. A horizontal filter bar at the top lets you narrow results by diet (Vegetarian, Vegan, Gluten‑Free, Nut‑Free). Select “All” to clear the filter.
* **Add New Post** – The second tab hosts a form to add a listing. Enter a title, description and location, select dietary tags with coloured pill buttons, and optionally choose an image via the PhotosPicker. The save button uses a green‑to‑blue gradient and is disabled until required fields are filled.
* **Detail View** – Tapping a card shows a full page with a larger image placeholder, the coloured location badge, dietary pills, description and a relative “Posted X ago” timestamp.
* **MVVM Architecture** – A `ListingRepository` protocol defines the interface for data operations. `MockListingRepository` uses a `CurrentValueSubject` to store listings in memory and seeds sample data. The `ListingListViewModel` combines repository data with search text and tag filters to produce the UI’s list.
* **Extensible Design** – You can swap out the mock repository for a real backend later by conforming to `ListingRepository`. Persistence, authentication or network calls can be added without touching the UI.

## Project Structure

```
LeftoverLink/
  LeftoverLinkApp.swift       // App entry point, injects view model
  Models/
    FoodListing.swift         // Data model with title, description, location, tags, imageData, timestamp
  Protocols/
    ListingRepository.swift    // Repository protocol abstraction
  Repositories/
    MockListingRepository.swift // In‑memory repository with seeded sample data
  ViewModels/
    ListingListViewModel.swift  // View model with search & filter logic
  Views/
    ContentView.swift          // Tab view with listings and add views
    ListingsView.swift         // List with search, filter bar, pull to refresh, delete
    ListingRowView.swift       // Card style row for listings
    ListingDetailView.swift    // Full detail page
    AddListingView.swift       // Form for creating new posts
    TagFilterBar.swift         // Horizontal bar of dietary filter pills
  Helpers/
    TimeAgo.swift             // Utility to compute relative timestamps
    ImagePicker.swift         // UIKit image picker wrapper (unused in this version but included for reference)
  README.md                  // This file
```

## Running the App

1. Open `LeftoverLink.xcodeproj` (or create a new SwiftUI iOS project and copy this directory into it). The project requires Xcode 15+ and iOS 17+.
2. Select an iOS simulator (e.g. **iPhone 15 Pro**) and press **⌘R** to run.
3. On launch you will see five seeded posts. Use the search bar and filter pills to explore. Add new posts from the **New Post** tab and observe them appear at the top of the list. Swipe left on a row to delete.

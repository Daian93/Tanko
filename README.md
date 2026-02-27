<div align="center">

<img src="Tanko/Assets.xcassets/AppIcon.appiconset/Contents.json" width="0" height="0"/>

# Tanko

### Your personal manga collection manager

**Swift Developer Program 2025 · Apple Coding Academy**  
Final Project — Autumn 2025

[![Swift](https://img.shields.io/badge/Swift-6.0-orange?logo=swift)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-16+-blue?logo=xcode)](https://developer.apple.com/xcode/)
[![iOS](https://img.shields.io/badge/iOS-17+-black?logo=apple)](https://developer.apple.com/ios/)
[![iPadOS](https://img.shields.io/badge/iPadOS-17+-black?logo=apple)](https://developer.apple.com/ipados/)
[![macOS](https://img.shields.io/badge/macOS-14+-black?logo=apple)](https://developer.apple.com/macos/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

</div>

---

## 📖 About

**Tanko** is a native multi-platform Apple app that lets manga lovers explore a catalogue of over **64,000 manga titles** and manage their personal collection. Browse, search, filter and track every volume you own and every page you've read — all synced to the cloud and available on iPhone, iPad and Mac.

> Developed as the **final capstone project** of the *Swift Developer Program 2025* at **Apple Coding Academy**, this app covers all four delivery tiers: Basic, Medium, Advanced and Deluxe.

---

## 📱 Screenshots

### Onboarding · Login · Register

| Onboarding | Login | Register |
|:---:|:---:|:---:|
| ![Onboarding iPhone](Tanko/Screenshots/iPhone/onboarding_iphone.PNG) | ![Login iPhone](Tanko/Screenshots/iPhone/login_iphone.PNG) | ![Register iPhone](Tanko/Screenshots/iPhone/register_iphone.PNG) |

### Manga Explorer

| Manga List | Manga Detail | Manga Detail (cont.) |
|:---:|:---:|:---:|
| ![Manga iPhone](Tanko/Screenshots/iPhone/manga_iphone.PNG) | ![Detail iPhone](Tanko/Screenshots/iPhone/mangaDetail_iphone.PNG) | ![Detail 2 iPhone](Tanko/Screenshots/iPhone/mangaDetail2_iphone.PNG) |

### Author · Search · Filters

| Author | Search | Filter Search |
|:---:|:---:|:---:|
| ![Author iPhone](Tanko/Screenshots/iPhone/author_iphone.PNG) | ![Search iPhone](Tanko/Screenshots/iPhone/search_iphone.PNG) | ![Filter iPhone](Tanko/Screenshots/iPhone/filterSearch_iphone.PNG) |

| Filters Panel | Search Results |
|:---:|:---:|
| ![Filters iPhone](Tanko/Screenshots/iPhone/filters_iphone.PNG) | ![Search Result iPhone](Tanko/Screenshots/iPhone/searchResult_iphone.PNG) |

### Collection · Add · Edit

| Collection | Add to Collection | Edit Manga |
|:---:|:---:|:---:|
| ![Collection iPhone](Tanko/Screenshots/iPhone/collection_iphone.PNG) | ![Add iPhone](Tanko/Screenshots/iPhone/addToCollection_iphone.PNG) | ![Edit iPhone](Tanko/Screenshots/iPhone/editManga_iphone.PNG) |

### Profile

| Profile (Light) | Profile (Dark) | Profile (Spanish) |
|:---:|:---:|:---:|
| ![Profile Light](Tanko/Screenshots/iPhone/profileWhite_iphone.PNG) | ![Profile Dark](Tanko/Screenshots/iPhone/profileDark_iphone.PNG) | ![Profile ES](Tanko/Screenshots/iPhone/profile_spanish_iphone.PNG) |

---

### 📲 iPad

| Manga | Manga Detail | Author |
|:---:|:---:|:---:|
| ![Manga iPad](Tanko/Screenshots/iPad/manga_ipad.PNG) | ![Detail iPad](Tanko/Screenshots/iPad/mangaDetail_ipad.PNG) | ![Author iPad](Tanko/Screenshots/iPad/author_ipad.PNG) |

| Collection | Search (Light) | Search (Dark) |
|:---:|:---:|:---:|
| ![Collection iPad](Tanko/Screenshots/iPad/collection_ipad.PNG) | ![Search White iPad](Tanko/Screenshots/iPad/searchWhite_ipad.PNG) | ![Search Dark iPad](Tanko/Screenshots/iPad/searchDark_ipad.PNG) |

| Add Manga | Edit Manga | Onboarding |
|:---:|:---:|:---:|
| ![Add iPad](Tanko/Screenshots/iPad/addManga_ipad.PNG) | ![Edit iPad](Tanko/Screenshots/iPad/editManga_ipad.PNG) | ![Onboarding iPad](Tanko/Screenshots/iPad/onboarding_ipad.PNG) |

| Login | Register | Profile (Dark) |
|:---:|:---:|:---:|
| ![Login iPad](Tanko/Screenshots/iPad/login_ipad.PNG) | ![Register iPad](Tanko/Screenshots/iPad/register_ipad.PNG) | ![Profile Dark iPad](Tanko/Screenshots/iPad/profileDark_ipad.PNG) |

---

### 🖥️ macOS

| Manga | Manga Detail | Author |
|:---:|:---:|:---:|
| ![Manga Mac](Tanko/Screenshots/Mac/manga_mac.png) | ![Detail Mac](Tanko/Screenshots/Mac/mangaDetail_mac.png) | ![Author Mac](Tanko/Screenshots/Mac/author_mac.png) |

| Collection | Search | Filters |
|:---:|:---:|:---:|
| ![Collection Mac](Tanko/Screenshots/Mac/collection_mac.png) | ![Search Mac](Tanko/Screenshots/Mac/search_mac.png) | ![Add Mac](Tanko/Screenshots/Mac/addManga_mac.png) |

| Edit Manga | Onboarding | Profile |
|:---:|:---:|:---:|
| ![Edit Mac](Tanko/Screenshots/Mac/editManga_mac.png) | ![Onboarding Mac](Tanko/Screenshots/Mac/onboarding_mac.png) | ![Profile Mac](Tanko/Screenshots/Mac/profile_mac.png) |

---

### 🪄 Widgets

| Small & Medium (Light) | Small & Medium (Dark) | Large (Light) | Large (Dark) |
|:---:|:---:|:---:|:---:|
| ![Widget SM Light](Tanko/Screenshots/Widget/smallAndMedium_clear_widget.PNG) | ![Widget SM Dark](Tanko/Screenshots/Widget/smallAndMedium_dark_widget.PNG) | ![Widget L Light](Tanko/Screenshots/Widget/large_clear_widget.PNG) | ![Widget L Dark](Tanko/Screenshots/Widget/large_dark_widget.PNG) |

| iPad Widgets | Mac Widgets | Add Widget |
|:---:|:---:|:---:|
| ![iPad Widgets](Tanko/Screenshots/Widget/ipad_widgets.PNG) | ![Mac Widgets](Tanko/Screenshots/Widget/mac_widgets.png) | ![Add Widget](Tanko/Screenshots/Widget/add_widget.PNG) |

---

## ✨ Features by Delivery Tier

### 🟢 Basic — Core functionality

- **Manga catalogue** with paginated list of 64,000+ titles, each showing the cover image loaded from URL.
- **Manga detail** view with full info: titles (original, English, Japanese), authors, publication year, genres, themes, demographics, synopsis and background.
- **Best Manga carousel** — a horizontal scrollable showcase of the top 19 highest-rated manga.
- **Bookmark icon** on every manga card for quick add/remove from the personal collection.
- **Add to collection sheet** with:
  - Volumes owned (individual volume selection).
  - Current reading volume.
  - Whether the collection is complete.
- **My Collection view** showing all saved manga with filtering tabs: All · To Read · Reading · Read · Complete.
- **Collection statistics** panel: total titles, currently reading, total volumes owned, complete collections.
- Persistent storage with **SwiftData** (local-first).
- Responsive layout for **iPhone and iPad**.

---

### 🟡 Medium — Filters & multiple layouts

- **Simple search** (`searchMangasContains`) — case-insensitive, paginated, with debounce.
- **Advanced search** with full filter set:
  - Title (partial / exact toggle).
  - Author first name and last name.
  - Genres, themes and demographics (multi-select chips).
  - Partial/contains mode toggle.
- **Genre / Theme / Demographic pills** in the manga detail — tapping any pill deep-links to the Search tab with that filter pre-applied.
- **Author view** — tapping an author pill in the detail navigates to the author's full paginated manga catalogue.
  - Grid layout on iPad and Mac (horizontal).
  - Carousel on iPhone (portrait).
- **Multiple layouts**: list (manga explorer), detail, and grid (author & widget views).
- Consistent empty, loading and error states throughout all views.

---

### 🔴 Advanced — Cloud sync & authentication

- **JWT Bearer authentication** — login, registration and token renewal via the REST API.
- **JWT token stored securely in the iOS/macOS Keychain** using `Security.framework`.
- **Guest mode** — full local functionality without an account; guest-to-authenticated upgrade merges local and remote collections.
- **Cloud collection management** — every add, update and remove is sent to the API for the authenticated user.
- **Bidirectional sync** on login: local and remote collections are merged using `updatedAt` timestamps — the most recent version of each manga always wins.
- **Offline queue** — when the device has no internet connection, operations are persisted as `PendingOperation` (SwiftData model) and replayed automatically when connectivity is restored, thanks to `NWPathMonitor`.
- **Offline banner** shown in the Collection view when the device is offline.
- **Cross-device sync** — any change made on one device is reflected on all others after the next sync.
- **Logout security** — on sign-out the local SwiftData database is wiped clean via `LocalDatabaseCleaner`, and the Keychain token is deleted.
- **Per-user settings** — `AppSettings` namespaces all `UserDefaults` keys by user ID, so each account remembers its own preferences independently (including the guest session).

---

### 🟣 Deluxe — Extra platforms & widget

- **macOS support** — the app runs natively on macOS (Mac Catalyst / multiplatform SwiftUI) with a `1100×750` default window, transparent titlebar, custom window background colour and `.plain` button style.
- **WidgetKit extension** (`TankoWidget`) with three sizes:
  - **Small** — 1 manga with cover, title and reading progress.
  - **Medium** — 2×1 grid of manga.
  - **Large** — 2×2 grid of 4 manga.
- **Smart rotation timeline** — the widget update interval adapts to the size of the user's reading list:
  - 0–5 manga → refresh every 4 h.
  - 6–20 manga → every 1 h.
  - 20+ manga → every 30 min.
- Widget data is shared with the main app via an **App Group** (`group.com.dianars.Tanko`) using a JSON file written by `WidgetDataManager`; covers are pre-fetched from the network so they appear immediately.
- **Dark, Default and Monochrome** app icons created with **Icon Composer**.
- **Localisation** — all UI strings are translated to **English** and **Spanish** via `Localizable.xcstrings`; the active language is switchable at runtime from the Profile tab.

---

## 🏗️ Architecture

Tanko follows **MVVM (Model–View–ViewModel)** with a clean, layered structure:

```
┌─────────────────────────────────────────────────────┐
│                       Views                         │
│  SwiftUI Views + Components (purely declarative)    │
└───────────────────┬─────────────────────────────────┘
                    │  @Observable ViewModels
┌───────────────────▼─────────────────────────────────┐
│                   ViewModels                        │
│  @Observable @MainActor final class *ViewModel      │
│  Owns state, drives view updates                    │
└───────────────────┬─────────────────────────────────┘
                    │  protocol-based repositories
┌───────────────────▼─────────────────────────────────┐
│              Repository Layer                       │
│  NetworkRepository  ·  MangaCollectionRepository    │
│  (protocols with concrete Network / Local impls.)   │
└───────────────────┬─────────────────────────────────┘
                    │
┌───────────────────▼─────────────────────────────────┐
│           Services & Data Layer                     │
│  SessionManager · AppSettings · OfflineOperationsManager │
│  MangaCollectionSyncService · LocalDatabaseCleaner  │
│  WidgetDataManager · KeychainService                │
│  SwiftData (UserManga · PendingOperation)           │
└─────────────────────────────────────────────────────┘
```

### Key patterns

| Pattern | Usage |
|---|---|
| `@Observable` + `@MainActor` | All ViewModels and services — zero-boilerplate reactive state on the main actor |
| `@Environment` injection | `SessionManager`, `AppSettings`, `MangaViewModel` and `UserMangaCollectionViewModel` are injected via `.environment()` at the root |
| Protocol-based repositories | `NetworkRepository` & `MangaCollectionRepository` interfaces decouple business logic from concrete implementations and enable easy testing/mocking |
| `async/await` + typed throws | All network and persistence calls use structured concurrency; errors are typed (`throws(NetworkError)`) for exhaustive handling |
| `Task` / `Task.cancel` | Debounced search, pagination and offline queue processing all use structured `Task` management with cancellation |
| `NWPathMonitor` | Real-time connectivity monitoring wrapped inside `OfflineOperationsManager` to trigger queue replay |
| `NavigationPath` + `NavigationRouter` | Centralised navigation router (singleton `@Observable`) handles deep links, cross-tab navigation and filter pre-application |
| `matchedTransitionSource` | Cover images use `Namespace` for smooth hero transitions between list and detail views |
| `SwiftData` | `@Model UserManga` and `@Model PendingOperation` with `#Index` and `@Attribute(.unique)` for efficient querying |

---

## 🗂️ Project Structure

```
Tanko/
├── System/
│   ├── TankoApp.swift          # @main entry, modelContainer, environment setup
│   └── AppSettings.swift       # @Observable per-user settings (dark mode, language, emoji)
├── Views/                      # SwiftUI screens
│   ├── MainTabView.swift
│   ├── Onboarding/             # RootView · OnboardingView · LoginView · RegisterView · LoadingView
│   ├── Manga/                  # ContentView (iPhone) · ContentViewiPad · MangaDetailView
│   ├── Collection/             # CollectionView · AddMangaToCollectionView · UserMangaDetailView
│   ├── Search/                 # SearchView · SearchViewiPad · FiltersView
│   ├── Author/                 # AuthorView
│   └── Profile/                # ProfileView · EmojiPickerView
├── Components/                 # Reusable view components per feature
│   ├── Manga/Content/          # MangaCard · MangaCarousel · MangaGridCard · MangaRow …
│   ├── Manga/MangaDetail/      # Banner · Metadata · Stats · ExpandableText …
│   ├── Collection/             # CollectionStatsGrid · CollectionFilterBar · MangaProgressRow …
│   ├── Author/                 # AuthorHeader · AuthorMangaCarousel · AuthorMangaGrid
│   └── Onboarding/             # Onboarding components
├── ViewModel/
│   ├── Manga/                  # MangaViewModel · BestMangaViewModel · MangaDetailViewModel
│   ├── Collection/             # UserMangaCollectionViewModel · AddMangaViewModel · UserMangaDetailViewModel
│   ├── Search/                 # SearchViewModel · FiltersViewModel
│   ├── Author/                 # AuthorViewModel
│   └── Onboarding/             # LoginViewModel · RegisterViewModel
├── Model/
│   ├── Domain/                 # Manga · Author · User · Page · Enums (Genre/Theme/Demographic) …
│   └── DTO/                    # MangaDTO · UserDTO · CustomSearchDTO · MangaSyncData …
├── DataModel/
│   ├── UserManga/Model.swift   # @Model UserManga (SwiftData)
│   └── PendingOperation.swift  # @Model PendingOperation (offline queue)
├── Repository/
│   ├── Network/                # Network (concrete NetworkRepository impl.)
│   └── Collection/             # LocalMangaCollectionRepository · RemoteMangaCollectionRepository
├── Services/
│   ├── SessionManager.swift    # Auth state, JWT lifecycle
│   ├── AppSettings.swift       # Per-user preferences
│   ├── KeychainService.swift   # Keychain CRUD wrapper
│   ├── MangaCollectionSyncService.swift  # Local ↔ Remote bidirectional sync
│   ├── OfflineOperationsManager.swift    # NWPathMonitor + pending queue
│   ├── LocalDatabaseCleaner.swift        # Wipe SwiftData on logout
│   ├── NavigationRouter.swift  # Centralised navigation & deep links
│   └── WidgetDataManager.swift # App Group JSON bridge for WidgetKit
├── Interface/                  # Networking layer (URLSession, URLRequest builders, URL extensions)
├── Covers/                     # CoverView · CoverVM (async image loading + caching)
├── Styleguide/                 # AppColors (semantic colour tokens)
├── Extensions/                 # AuthValidator · Extensions · UIImage helpers
└── Mocks/                      # Preview helpers and mock data

TankoWidget/
├── TankoWidgetBundle.swift
├── TankoWidget.swift           # Widget definition, supported families
├── TankoTimeline.swift         # TimelineProvider with smart rotation logic
├── TimelineEntry.swift         # MangaEntry
├── Views/                      # SmallWidgetView · MediumWidgetView · LargeWidgetView
└── Helpers/                    # Widget theme, image cache helpers
```

---

## 🔧 Technology Stack

| Technology | Usage |
|---|---|
| **Swift 6** | Primary language, strict concurrency |
| **SwiftUI** | 100 % declarative UI across all platforms |
| **SwiftData** | Local persistence (`UserManga`, `PendingOperation`) |
| **WidgetKit** | Home screen / lock screen widgets (small, medium, large) |
| **Observation framework** (`@Observable`) | Reactive state management without Combine boilerplate |
| **Swift Concurrency** (`async/await`, `Task`, `Actor`) | All async work; `@MainActor` isolates UI state |
| **Network framework** (`NWPathMonitor`) | Real-time online/offline detection |
| **Security framework** (Keychain) | Secure JWT storage |
| **`Localizable.xcstrings`** | Runtime language switching (English · Spanish · System) |
| **Icon Composer** | Default, Dark and Monochrome app icon variants |
| **App Groups** | Shared data container between app and widget extension |
| **REST API** | `https://mymanga-acacademy-5607149ebe3d.herokuapp.com` — 64,000+ manga, JWT auth |

---

## 🌐 API Overview

The app communicates with a REST API that exposes:

| Endpoint category | Examples |
|---|---|
| **Manga list** | `GET /list/mangas` · `GET /list/bestMangas` |
| **Manga detail** | `GET /search/manga/:id` |
| **Search** | `GET /search/mangasContains/:query` · `POST /search/manga` (advanced) |
| **Filters** | `GET /list/genres` · `GET /list/themes` · `GET /list/demographics` |
| **Authors** | `GET /search/author/:name` · `GET /list/mangas/author/:id` |
| **Auth** | `POST /auth/register` · `POST /auth/login` · `GET /auth/me` |
| **Collection (cloud)** | `GET /user/collection` · `POST /user/collection` · `DELETE /user/collection/:id` |

Authentication uses **JWT Bearer tokens** sent in the `Authorization: Bearer <token>` header on all protected endpoints.

---

## 🔐 Authentication Flow

```
App Launch
    │
    ├─► Keychain has token? ──Yes──► Restore session ──► Load user profile
    │                                                            │
    │                                                    Token valid? ──No──► Logout
    │
    └─► No token ──► OnboardingView
                            │
                   ┌────────┴────────┐
                   │                 │
              Continue           Login / Register
              as Guest               │
                   │            JWT saved to Keychain
                   │                 │
                   └────────┬────────┘
                            │
                    MainTabView (app)
                            │
                    Sync local ↔ cloud (if authenticated)
```

- **Guest mode**: all collection data lives only in SwiftData. No credentials needed.
- **Login/Register**: credentials sent over HTTPS; JWT returned and stored in Keychain.
- **Logout**: Keychain token deleted + local SwiftData wiped for security.
- **Session restore**: token read from Keychain on cold launch; user profile fetched from `/auth/me`.

---

## 📶 Offline Support

When the network is unavailable:

1. `OfflineOperationsManager` detects the change via `NWPathMonitor`.
2. Any add / update / delete on the collection is **enqueued** as a `PendingOperation` in SwiftData instead of sent to the API.
3. An **offline banner** is displayed in the Collection view showing the number of pending operations.
4. When connectivity is restored, the pending queue is **replayed** in order and then cleared.
5. Duplicate operations for the same manga are automatically de-duplicated in the queue.

---

## 🔄 Collection Sync Strategy

`MangaCollectionSyncService` implements a **last-write-wins** merge on the `updatedAt` timestamp:

| Situation | Action |
|---|---|
| Item exists locally & remotely | Compare `updatedAt`; push local if newer, pull remote if newer |
| Item only in local | Upload to cloud |
| Item only in remote | Download to local |

This guarantees that no data is lost when switching devices or upgrading from guest to authenticated mode.

---

## 🗺️ Navigation

The app uses a **centralised `NavigationRouter`** singleton (`@Observable @MainActor`) to handle:

- **Deep links** (`tanko://manga/<id>`) — navigates to the correct tab and pushes the manga detail.
- **Cross-tab navigation** — tapping a genre/theme/demographic pill in the manga detail switches to the Search tab and pre-applies the filter.
- **Author navigation** — tapping an author pill navigates to the author's manga grid/carousel.
- **`NavigationPath`** is used for each tab's navigation stack, allowing programmatic push/pop.

---

## 🎨 Design System

### Colour Palette

All colours are defined as **semantic tokens** in `AppColors.swift` using `extension ShapeStyle where Self == Color`, and are backed by named colour assets in `Assets.xcassets` with **separate light and dark variants** — so the entire app adapts automatically to the system appearance (and to the in-app dark-mode toggle).

| Token | Swift name | Light `#` | Dark `#` | Usage |
|---|---|:---:|:---:|---|
| Background | `.tankoBackground` | `#FBFAF8` | `#0F1115` | Main screen background |
| Surface | `.surface` | `#EFEDEA` | `#23272F` | Card & sheet surfaces |
| Primary | `.tankoPrimary` | `#C62828` | `#EF5350` | Brand accent, buttons, interactive elements |
| Secondary | `.tankoSecondary` | `#424242` | `#B0B0B0` | Supporting accent, secondary actions |
| Text Primary | `.textPrimary` | `#1C1C1C` | `#EDEDEDED` | Headings & body text |
| Text Secondary | `.textSecondary` | `#6B6B6B` | `#9E9E9E` | Captions, metadata, placeholders |

> The primary accent transitions from a deep crimson red (`#C62828`) in light mode to a lighter coral red (`#EF5350`) in dark mode, maintaining brand identity and WCAG contrast ratios across both appearances.

### Custom SF Symbols

Three custom vector symbols are bundled in the asset catalogue:

| Symbol | Name | Usage |
|---|---|---|
| Bookmark + badge | `bookmark.plus` | Add manga to collection |
| Bookmark filled − badge | `bookmark.fill.minus` | Remove manga from collection |
| Filter badge | `line.3.horizontal.decrease.circle.badge` | Active filters indicator |

Custom SF Symbols are included for the bookmark actions (`bookmark.plus`, `bookmark.fill.minus`).

---

## 🌍 Localisation

All user-facing strings are managed through **`Localizable.xcstrings`** (the modern String Catalogue format). Supported languages:

| Language | Identifier |
|---|---|
| English 🇬🇧 | `en` |
| Spanish 🇪🇸 | `es` |
| System default 🌐 | follows device locale |

The active language is switched at runtime from the **Profile** tab using `AppSettings.appLanguage` + `.environment(\.locale, settings.locale)` injected at the root, so the entire app re-renders without restarting.

---

## 🔭 Roadmap

The following improvements are planned for future versions of Tanko:

### 🧪 Testing with Swift Testing

Unit and integration tests using Apple's modern **Swift Testing** framework (`@Test`, `@Suite`, `#expect`), covering:

- **ViewModels** — `MangaViewModel`, `SearchViewModel`, `UserMangaCollectionViewModel`: state transitions, pagination logic, filter building and offline queue behaviour.
- **Sync logic** — `MangaCollectionSyncService` merge scenarios (local wins, remote wins, new on each side).
- **Network layer** — mock implementations of `NetworkRepository` to test request building, error mapping and typed-throws paths.
- **Keychain & Session** — `KeychainService` read/write/delete cycle and `SessionManager` restore-session flow.

```swift
// Example: Swift Testing style
@Suite("SearchViewModel")
struct SearchViewModelTests {
    @Test("Debounced search resets results on empty query")
    func emptyQueryResetsState() async { … }

    @Test("Advanced filter builds correct DTO")
    func advancedFilterDTO() { … }
}
```

---

### ♿ Accessibility improvements

Making Tanko fully usable for everyone:

- **`accessibilityLabel` & `accessibilityHint`** on all interactive elements (bookmark buttons, filter chips, collection stats cards).
- **`accessibilityValue`** on reading-progress controls to expose the current/total volume count to VoiceOver.
- **Dynamic Type** — verify all text scales correctly up to the *Accessibility XXL* size category; replace fixed `frame` sizes with flexible alternatives where needed.
- **Reduce Motion** — honour `@Environment(\.accessibilityReduceMotion)` to disable the cover hero transition and carousel animations.
- **VoiceOver navigation order** — use `accessibilitySortPriority` and `accessibilityElement(children:)` to give a logical reading order to composite cards.
- **Sufficient colour contrast** audit of the custom palette (primary red on surface backgrounds) in both light and dark modes.

---

### ⌚ watchOS

A companion **watchOS** app showing the user's active reading list at a glance:

- Glanceable list of in-progress manga with current volume badge.
- **Complication** (WidgetKit / ClockKit) mirroring the small widget.
- Read-only view — collection edits stay on iPhone/iPad/Mac.
- Shared data via the existing App Group JSON written by `WidgetDataManager`.

---

### 🥽 visionOS

A spatial adaptation of Tanko for **Apple Vision Pro**:

- **Ornament-based** navigation — tab bar replaced with a window ornament.
- Manga covers rendered as floating `RealityView` panels in a volumetric window for an immersive browsing experience.
- `NavigationSplitView` with a sidebar for filters and a detail column for manga info.
- Hover effects (`hoverEffect(.highlight)`) on manga cards.

---

### 📺 tvOS

A **tvOS** version optimised for the living room:

- Focus-engine-driven grid of manga cards navigable with the Siri Remote.
- `CardButtonStyle` for cover artwork with parallax effect.
- Full-screen detail view with synopsis and author info.
- Collection management via a simple remote-friendly form.

---

## 👤 Author

**Diana Rammal Sansón**  
*Swift Developer Program 2025 — Apple Coding Academy*  
Práctica Final · Autumn 2025

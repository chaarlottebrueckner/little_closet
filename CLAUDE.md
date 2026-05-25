# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Run the app
flutter run

# Generate Drift DB and Riverpod providers (required after changing tables or providers)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for code generation
dart run build_runner watch --delete-conflicting-outputs

# Analyze
flutter analyze

# Run tests
flutter test
```

## Architecture

Feature-based clean architecture:

```
lib/
  core/          # Shared utilities, theme, services, constants
  data/          # Database (Drift) + repositories
  features/      # Feature modules (wardrobe, outfits, collections)
  shared/        # App shell / navigation
```

**State management**: Riverpod. All providers live either next to the repository (`clothing_repository.dart`) or are generated via `@riverpod` annotations. Widgets use `ConsumerWidget` / `ConsumerStatefulWidget`.

**Database**: Drift (SQLite). Tables are in `lib/data/database/tables/`. The database class and providers are in `app_database.dart`. `List<String>` fields (colors, seasons, tags) are stored as JSON via `StringListConverter`. Schema version is currently 7 — increment it and add a migration step in `app_database.dart` when changing tables.

**Navigation**: `AppShell` manages bottom navigation between the three main pages via `IndexedStack`. Modal sheets (`showModalBottomSheet`) are used for detail, upload, filter, and add-clothing flows — not go_router.

## Feature Structure

All three features are fully implemented.

```
wardrobe/
  domain/
    active_filters.dart          # Pure Dart filter state class
  presentation/
    pages/
      wardrobe_page.dart         # Main grid, filter chips, FAB
      upload_page.dart           # Image upload + Gemini classification form
      clothing_detail_page.dart  # Read-only item detail
    widgets/
      clothing_card.dart         # Grid item card
      filter_sheet.dart          # Bottom sheet filter UI
      add_clothing_sheet.dart    # Camera/gallery picker sheet
      wardrobe_header.dart       # Title + filter button
      selection_bar.dart         # Multi-select delete bar (ConsumerWidget, calls repo directly)
      wardrobe_empty_state.dart  # Empty grid state

outfits/
  domain/
    outfit_filters.dart          # Pure Dart filter state class
    outfit_with_items.dart       # Outfit + positioned items aggregate
    editable_item.dart           # Item state on canvas (pos, scale, rotation, zIndex)
  presentation/
    pages/
      outfits_page.dart          # Main grid, filter chips, FAB
      outfit_editor_page.dart    # Drag & drop canvas editor
      outfit_detail_page.dart    # Read-only preview, export as PNG
    widgets/
      outfit_editor_canvas.dart  # GestureDetector canvas with item handles
      outfit_item_handle.dart    # Per-item drag/scale/rotate handle
      outfit_item_tray.dart      # Bottom tray to pick clothing items
      outfit_canvas_preview.dart # Read-only canvas render (used in detail + card)
      outfit_card.dart           # Grid item card
      outfit_filter_sheet.dart   # Bottom sheet filter UI
      outfit_save_sheet.dart     # Tag confirmation before saving
      outfit_tutorial_overlay.dart # First-use tutorial
      outfit_empty_state.dart    # Empty grid state
      outfits_header.dart        # Title + filter button

collections/
  domain/
    collection_with_outfits.dart # Collection + outfit list aggregate
  presentation/
    pages/
      collections_page.dart      # Main grid, FAB
      collection_detail_page.dart # Outfit grid within collection, rename, delete
    widgets/
      collection_card.dart        # Grid item card with mosaic cover
      collection_cover_mosaic.dart # Auto-generated cover from outfit previews
      collections_header.dart     # Title + filter button
      create_collection_sheet.dart # Name input on creation
      outfit_picker_sheet.dart    # Toggle outfits in/out of collection
```

## Design System

All styling comes from `lib/core/theme/app_theme.dart`:
- `LCColors` — color tokens and gradients (`LCColors.primary`, `LCColors.gradientPink`, …)
- `LCGlass` — glass morphism constants (blur, sheet color, border)
- `LCTheme.light` — the MaterialTheme applied in `main.dart`

The app uses a futuristic y2k-girly aesthetic: frosted glass sheets, pink gradients, animated chips.

## Gemini AI Integration

`GeminiService.classifyClothing(Uint8List imageBytes)` sends a base64 image to `gemini-2.5-flash` and returns a `ClothingClassification` (nullable on failure). The response is strict JSON validated against `AppConstants` values. The API key is loaded from `assets/.env` via `flutter_dotenv` — never hardcode it.

`UploadPage` calls the service after image selection, pre-fills the form, and lets the user correct results before saving.

## Constants

All German-language category names, colors, seasons, style tags, and weather tags are centralised in `lib/core/constants/app_constants.dart`. The `colorMap` there maps German color names to `Color` values used for card backgrounds.

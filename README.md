# 💗 little closet

Ein Garderobe-Management-App für Android.  
Studienprojekt — Flutter + Gemini AI + Drift DB.

---

## 🚀 Setup-Anleitung (Schritt für Schritt)

### Voraussetzungen
- Flutter SDK installiert (https://docs.flutter.dev/get-started/install)
- Android Studio oder VS Code mit Flutter-Plugin
- Ein Android-Gerät (Samsung S24) oder Emulator

### 1. Projekt öffnen
```bash
# Diesen Ordner in VS Code oder Android Studio öffnen
cd little_closet
```

### 2. Dependencies installieren
```bash
flutter pub get
```

### 3. Google Fonts — Schriften herunterladen
Die App verwendet **Cormorant Garamond** und **DM Sans**.  
Da `google_fonts` diese automatisch aus dem Internet lädt, brauchst du für den ersten Start eine Internetverbindung.

Optional: Schriften lokal einbetten  
→ Download von https://fonts.google.com  
→ `.ttf`-Dateien in `assets/fonts/` legen

### 4. Gemini API Key eintragen
```dart
// lib/core/constants/app_constants.dart
static const String geminiApiKey = 'DEIN_KEY_HIER';
```
→ Key holen unter: https://aistudio.google.com/app/apikey

### 5. App starten
```bash
flutter run
```

---

## 📁 Projektstruktur

```
lib/
├── main.dart                          # App-Einstiegspunkt
├── core/
│   ├── theme/
│   │   └── app_theme.dart             # Farben, Typografie, Theme
│   └── constants/
│       └── app_constants.dart         # Kategorien, Tags, API-Key
├── features/
│   ├── wardrobe/                      # 🧥 Seite 1: Garderobe
│   │   └── presentation/pages/
│   │       └── wardrobe_page.dart
│   ├── outfits/                       # 👗 Seite 2: Outfits
│   │   └── presentation/pages/
│   │       └── outfits_page.dart
│   └── collections/                   # 📚 Seite 3: Kollektionen
│       └── presentation/pages/
│           └── collections_page.dart
└── shared/
    └── widgets/
        └── app_shell.dart             # Bottom Navigation
```

---

## 🗺️ Roadmap

### ✅ Phase 0 — Grundgerüst (JETZT FERTIG)
- [x] Projektstruktur
- [x] Design-System (Farben, Schriften, Theme)
- [x] 3 Hauptseiten als Platzhalter
- [x] Bottom Navigation
- [x] Android Permissions

### 🔜 Phase 1 — Bild-Upload & KI-Klassifizierung
- [ ] image_picker einbinden (Kamera + Galerie)
- [ ] Bild anzeigen nach Auswahl
- [ ] Gemini API aufrufen → Kategorie, Farbe, Style vorschlagen
- [ ] KI-Ergebnis anzeigen und bearbeitbar machen

### 🔜 Phase 2 — Drift Datenbank
- [ ] ClothingItem-Modell erstellen
- [ ] Isar einrichten und initialisieren
- [ ] Kleidungsstück speichern
- [ ] Kleidungsstücke als Grid anzeigen

### 🔜 Phase 3 — Garderobe vervollständigen
- [ ] Filter-Funktion (Kategorie, Farbe, Saison, Style)
- [ ] Detail-Ansicht für Kleidungsstück
- [ ] Kleidungsstück bearbeiten & löschen
- [ ] Kleidungsstück-Karte mit freigestelltem Bild

### 🔜 Phase 4 — Outfit-Editor
- [ ] Canvas mit Drag-and-Drop
- [ ] Outfit speichern
- [ ] Outfit-Filter

### 🔜 Phase 5 — Kollektionen
- [ ] Kollektion erstellen
- [ ] Outfits zuweisen
- [ ] Cover-Bild generieren

---

## 🎨 Design-System

| Token | Farbe | Verwendung |
|-------|-------|------------|
| `primary` | `#D4789C` | Haupt-Akzentfarbe, Buttons |
| `accent` | `#E8A0BF` | Highlights, helle Elemente |
| `deep` | `#9B4F72` | Kontraste, dunkle Akzente |
| `chrome` | `#C0C0C0` | Silber, futuristische Details |
| `background` | `#FAFAFA` | App-Hintergrund |
| `surface` | `#FFFFFF` | Karten, Böden |
| `textDark` | `#1A1A1A` | Primärer Text |
| `textMuted` | `#8A8A8A` | Sekundärer Text |

**Schriften:** Cormorant Garamond (Headlines) + DM Sans (Body)

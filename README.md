# Flower-Mon 🌸

A daily collectible app for magical Flower-Mons - procedurally generated creatures that bloom each day.

## Features

- 🌸 **Daily Collection**: One unique Flower-Mon generated every morning
- ⚡ **Procedural Generation**: Each Flower-Mon is procedurally generated and never repeated
- 🔔 **Daily Notifications**: Get notified when a new Flower-Mon blooms
- 📚 **FlowerDex**: View your complete collection
- 🎨 **Beautiful Animations**: Soft, calm animations for each Flower-Mon
- 💖 **Romantic Messages**: Each Flower-Mon comes with a unique romantic message

## Tech Stack

- Flutter (latest stable)
- Riverpod (state management)
- GoRouter (navigation)
- GetIt (dependency injection)
- flutter_local_notifications
- CustomPainter & Flutter animations
- SharedPreferences (local storage)

## Getting Started

1. Clone the repository
2. Run `flutter pub get`
3. Run `flutter run`

## Project Structure

```
lib/
├── core/
│   ├── di/          # Dependency injection
│   ├── router/      # Navigation routing
│   └── theme/       # App theme
├── data/
│   ├── models/      # Data models
│   └── services/    # Business logic services
└── presentation/
    ├── providers/   # Riverpod providers
    ├── screens/     # UI screens
    └── widgets/     # Reusable widgets
```

## Screens

1. **Splash Screen**: App initialization
2. **Today's Flower-Mon**: Home screen showing today's Flower-Mon
3. **FlowerDex**: Collection screen showing all collected Flower-Mons
4. **Detail Screen**: Detailed view of a Flower-Mon
5. **Settings Screen**: App settings and preferences
6. **About Screen**: App information

## Flower-Mon Attributes

Each Flower-Mon has:
- Unique ID (based on date)
- Name
- Type (Grass, Fire, Water, Electric, Fairy, Mystic, Air, Shadow)
- Rarity (Common, Rare, Epic, Legendary)
- Primary and Secondary colors
- Petal shape
- Center design
- Animation style
- Romantic message
- Date generated

## Generation Rules

- Deterministic using date as seed
- Same Flower-Mon persists for the whole day
- New one generated the next day
- Legendary rarity is very rare (0.5% chance)

## Notes

- This app does NOT use real Pokémon characters, names, or assets
- All creatures are original Flower-Mons
- Offline-only app with no backend
- No authentication required

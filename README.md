# Sajjad Ali · Portfolio

Personal portfolio for **Sajjad Ali** — a carefully art-directed Flutter Web experience with clean architecture, Cubit state management, and GetIt dependency injection.

## Personality

Precise, confident, creative, and understated. Large typography, generous project imagery, and concise case studies.

## Architecture

```
lib/
  app/                 # App shell, theme, DI
  core/                # Constants, routing, animations, responsive helpers
  features/
    portfolio/         # Domain → Data → Presentation (projects, case studies, profile)
    shell/             # Home shell, section navigation Cubit
  presentation/        # Shared UI widgets
```

Layers follow clean architecture:

- **Domain** — entities, repository contracts, use cases
- **Data** — local data sources and repository implementations
- **Presentation** — Cubits, pages, section widgets

## Run

```bash
flutter pub get
flutter run -d chrome
```

## Analyze

```bash
flutter analyze
flutter test
```

## Design system

| Token | Value |
|---|---|
| Background | `#121416` |
| Text | `#F5F5F0` |
| Secondary | `#B4BAC3` |
| Accent | `#719BFF` |
| Dividers | `#30343B` |
| Headlines | Manrope |
| Body | IBM Plex Sans |
| Meta | IBM Plex Mono |

## Motion

Entrances and scroll reveals use a shared ease (`Cubic(0.16, 1, 0.3, 1)`). Reduced-motion preferences disable movement.

## Hosting

Apache/cPanel deployments should keep `web/.htaccess` so direct routes (`/work`, `/about`, `/contact`, `/work/:id`) rewrite to `index.html`.

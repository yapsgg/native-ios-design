# Color and icons

## Color roles

Put colors in one `Colors.swift` extension, named by role. See [../templates/Colors.swift](../templates/Colors.swift).

- **System colors first.** `.primary`, `.secondary`, `.tertiary`, `Color(uiColor: .systemBackground)`,
  `.secondarySystemBackground` (cards, incoming bubbles), `.tertiarySystemFill` (input fields). They adapt to Dark
  Mode, Increase Contrast, and elevated surfaces.
- **Custom colors adapt too.** Build them with a dynamic `UIColor { traits in ... }` so light and dark values live
  together.
- **Name by role**, not hue: `userBubble`, `surface`, `fieldFill`, `success`, `warning`.

## Contrast

- Text needs at least 4.5:1 against its background below 18 pt, and 3:1 at 18 pt and up or 14 pt bold (WCAG AA,
  which the HIG follows).
- System orange, green, and blue measure roughly 2:1 to 3.4:1 as text on white. In light mode use darker variants
  for status text (about 5:1); in Dark Mode the system colors pass.
- Secondary text on tinted or gray surfaces is the usual failure. Measure it.
- Links on a dark bubble: tint them white, not the accent color.

## Never color alone

- Links are underlined.
- Status pairs color with a symbol and a word ("Needs your approval" with a hand symbol).
- Selected states add a ring, checkmark, or the `.isSelected` trait, not only a color change.

## A distinctive identity, still native

Apps stand out through a confident, limited palette and careful details, not custom chrome:

- One identity color or pair (even black and white), used for the user's own content and the primary action.
- One accent for interactive elements, set as the asset catalog's AccentColor.
- Switch tracks, progress, and selection in the identity color for consistency (`.tint(.black)` on `Toggle`
  works in both appearances if the track stays visible).
- Check the identity color in Dark Mode: a black avatar on a black background disappears. Give it a raised gray or
  a hairline border there.

## Icons

- **SF Symbols for everything** UI-related. Match weight to nearby text by sizing with a font.
- Choose the symbol variant the context expects; the system picks fill for tab bars and swipe actions.
- Animate meaningfully: `.symbolEffect(.variableColor.iterative)` for "working", `.bounce` on a value change,
  `.contentTransition(.symbolEffect(.replace))` when swapping symbols.
- Hide decorative icons from VoiceOver (`.accessibilityHidden(true)`) when a label already says it.

### Icon tiles

Settings-style tiles: a symbol at about 50–55% of a 26–29 pt continuous rounded square with a radius of about
22.5% of the side.

- **Filled:** white symbol on the color's gradient (`color.gradient`).
- **Tinted:** the symbol in its color on a near-black square with a 0.5 pt white hairline at 14% opacity, forced to
  the dark color scheme so colors use their brighter shades. This matches Settings in Dark Mode and reads well in
  both appearances.

## App icon

- Make it in Icon Composer as layers (background, foreground glyph), so the system renders the light, dark, tinted,
  and clear variants with Liquid Glass highlights.
- Simple, bold shapes that read at 29 pt. No text, no screenshots, no photos.
- Don't use Apple's logo, SF Symbols as the whole icon, or another company's marks.

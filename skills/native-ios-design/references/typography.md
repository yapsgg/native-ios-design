# Typography

Goal: text that reads well at the default size and still works, without truncation or broken words, at the
largest accessibility size.

## The system text styles

Default sizes at the Large (default) setting, iOS:

| Style | Size | Weight | Typical use |
|---|---|---|---|
| Large Title | 34 | Regular | Top-level screen titles (system draws these) |
| Title 1 | 28 | Regular | Rare in app UI |
| Title 2 | 22 | Regular | Detail screen titles |
| Title 3 | 20 | Regular | Names on a profile card, editor titles |
| Headline | 17 | Semibold | Row titles, toolbar titles, button labels |
| Body | 17 | Regular | Message and reading text |
| Callout | 16 | Regular | Secondary paragraphs |
| Subheadline | 15 | Regular | Row subtitles, card details |
| Footnote | 13 | Regular | Timestamps, quoted text, footers |
| Caption 1 | 12 | Regular | Smallest reading text |
| Caption 2 | 11 | Regular | Badges and labels only, never paragraphs |

Body grows to 53 pt at the largest accessibility size (AX5). Plan for that.

Modify styles with weight and design, which keeps scaling: `Font.headline`, `Font.body.weight(.semibold)`,
`Font.subheadline.monospaced()`, `Font.system(.title3, design: .rounded).weight(.bold)`.

## One file of roles

Put every font in an extension named by role, with a comment saying where it's used. See
[../templates/Typography.swift](../templates/Typography.swift).

```swift
extension Font {
    /// The main line of a list row, like a contact's name.
    static let rowTitle = Font.headline
    /// The secondary line of a list row, like a preview or schedule.
    static let rowSubtitle = Font.subheadline
    /// Message text in bubbles and the composer.
    static let messageBody = Font.body
}
```

Rules for the file:

- Add a role rather than writing `.font(.subheadline)` in a view.
- Roles describe purpose ("sectionLabel"), never size ("small").
- Keep symbol fonts here too (`symbol`, `symbolLarge`, `symbolTiny`), since SF Symbols size from fonts.
- Mirror roles UIKit needs as `UIFont` statics built from `preferredFont(forTextStyle:)`.

## Large sizes: what breaks and the fix

| Symptom at AX sizes | Cause | Fix |
|---|---|---|
| Text clipped at the bottom | `frame(height:)` on text or its container | `frame(minHeight:)`, padding |
| Words break mid-word ("Notificat-ions") | Icon and text side by side in a narrow row | Stack vertically, or hide the icon (`labelStyle(.titleOnly)`) |
| Names truncated to "Ch…" | Three items per row | Two per row: `containerRelativeFrame(.horizontal, count: isAX ? 2 : 3, spacing:)` |
| Symbols overflow their circles | Fixed circle size, scaling symbol | `@ScaledMetric` size with a cap, and `.dynamicTypeSize(...accessibility1)` on the control |
| Toolbar crowding | Bar controls scale forever | Cap bar controls at accessibility1 |
| Badges dwarf the text they annotate | Counts scale like content | Cap badges at accessibility1, `monospacedDigit()` |
| Two-line limit hides most of a name | `lineLimit(2)` | `lineLimit(isAX ? nil : 2)` |

### Rearranging rows

```swift
/// A horizontal stack that turns vertical at accessibility text sizes, so text gets the full width.
struct AdaptiveStack<Content: View>: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    var alignment: HorizontalAlignment = .leading
    var spacing: CGFloat?
    @ViewBuilder var content: Content

    var body: some View {
        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: alignment, spacing: spacing))
            : AnyLayout(HStackLayout(spacing: spacing))
        layout { content }
    }
}
```

`AnyLayout` keeps view identity when switching, so state and animations survive the change. Prefer it over an
`if`/`else` that builds two different trees. Use `ViewThatFits` when the choice depends on available width rather
than text size.

### Capping chrome

```swift
@ScaledMetric(relativeTo: .body) private var scaledControlSize: CGFloat = 48
private var controlSize: CGFloat { min(scaledControlSize, 64) }

Image(systemName: "plus")
    .font(.title3)
    .frame(width: controlSize, height: controlSize)
    .dynamicTypeSize(...DynamicTypeSize.accessibility1)
```

Cap: toolbar and floating buttons, badges, tab-like chips, avatars' decorative marks. Don't cap: message text, row
titles and subtitles, descriptions, form labels, anything someone reads.

### Text in UIKit

```swift
textView.font = .preferredFont(forTextStyle: .body)
textView.adjustsFontForContentSizeCategory = true
```

For styled runs (a semibold mention), derive the font from the text style's descriptor so it still scales:

```swift
let body = UIFont.preferredFont(forTextStyle: .body).fontDescriptor
let semibold = body.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.semibold]])
let font = UIFont(descriptor: semibold, size: 0)
```

## Balanced lines

Short multi-line text (bubbles, titles, empty-state messages) often ends with one word on the last line. A
`Layout` that finds the narrowest width keeping the same line count fixes it, like CSS `text-wrap: balance`. See
`BalancedText` in [../templates/Components.swift](../templates/Components.swift). Apply only to short text
(under about 280 characters) and not while text is streaming in, or the width changes with every word.

## Numbers and identifiers

- Counts and times that change: `.monospacedDigit()` so they don't jitter.
- Animated counts: `.contentTransition(.numericText())`.
- Model IDs, file names, keys: `Font.subheadline.monospaced()` with `.truncationMode(.middle)`.

## Testing

- Xcode previews: `.environment(\.dynamicTypeSize, .accessibility5)`, or the Dynamic Type variants in the canvas.
- Simulator: Settings → Accessibility → Display & Text Size → Larger Text, or Environment Overrides in Xcode.
- Also turn on Bold Text; it changes widths.

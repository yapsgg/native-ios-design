# Layout and components

## Structure

- **One navigation model for iPhone and iPad.** `NavigationSplitView` with the selection in an `@Observable`
  router. On iPhone it collapses to a push; on iPad the list and detail sit side by side.
  `.navigationSplitViewStyle(.balanced)` keeps both visible in portrait, like Messages.
- **Routes as values.** A `Route` enum with `navigationDestination(for:)`, and a path array you can clear when the
  selection changes. Notifications, widgets, and deep links set the same router.
- **A fresh detail per selection.** `.id(selection)` on the detail view resets drafts and scroll position when
  switching items.
- **Readable widths.** Cap line length on wide screens: chat bubbles at about 560 pt, forms and reading text with
  `.frame(maxWidth:)` or `.scenePadding()`.

## Spacing and sizes

- System padding (`.padding()`, 16 pt) for screen edges; 8–12 pt between related items; 16–24 pt between groups.
- 44 × 44 pt minimum for anything tappable. Small visuals get a larger invisible frame:

```swift
Image(systemName: "xmark")
    .font(.caption2.weight(.heavy))
    .frame(width: 20, height: 20)
    .background(.regularMaterial, in: .circle)
    .frame(width: 36, height: 36)   // the target
    .contentShape(.rect)
```

- Continuous corners for custom shapes (`RoundedRectangle(cornerRadius:style: .continuous)`); nested corners are
  concentric (inner radius = outer radius − padding).

## Shared components

Keep small building blocks in one `Components.swift` and use them everywhere, so a fix lands once:

- `AdaptiveStack`: horizontal, vertical at accessibility sizes.
- `GlassCircleLabel`: the label of a round floating glass button, capped for Dynamic Type.
- `IconTile`: an SF Symbol on a continuous-corner square, filled or tinted.
- `.fieldBackground()`: the rounded fill behind inputs.
- `.closeButton()`: the standard close button in a sheet's toolbar.
- `BalancedText`: even line lengths for short text.

See [../templates/Components.swift](../templates/Components.swift). Screen-specific views stay in their screen's
file; only move a view to Components when a second screen needs it.

## Lists and forms

- Settings-style screens are `Form` or `List(.insetGrouped)` with `Section` headers and footers. Footers explain
  consequences in a sentence.
- Rows use `LabeledContent` for label-value pairs, `Toggle` for switches, `NavigationLink` for drill-down,
  `Picker` for choices. Don't rebuild these.
- Row icons: 26–29 pt tiles, like Settings. Hide them at accessibility sizes if they squeeze the title.
- Swipe actions for the common row actions, always also available in the context menu.

## Menus, sheets, and dialogs

| Need | Use |
|---|---|
| A few actions on an item | `contextMenu`, plus a `Menu` button for discoverability |
| Quick reactions | A palette `ControlGroup` at the top of the context menu, with `.menuActionDismissBehavior` so picking closes it |
| A secondary task | `.sheet` with `presentationDetents([.medium, .large])` |
| Confirming something destructive | `confirmationDialog` with a `.destructive` button and a message saying what's lost |
| Picking photos | `PhotosPicker` (inline or `.photosPicker(isPresented:)`); camera via `UIImagePickerController` in a full-screen cover |
| Picking files | `fileImporter` |
| Sharing | `ShareLink` |

Only one sheet shows at a time. To go from one sheet to another, set a flag in the first sheet's `onDismiss` and
present the second there.

## Text input that feels like Messages

- A growing field: a `UITextView` wrapper that reports `sizeThatFits` up to about 6 lines, then scrolls.
- Paste images: override `canPerformAction` and `paste(_:)` in a `UITextView` subclass.
- Tapping content hides the keyboard; scrolling keeps its state:

```swift
ScrollView { ... }
    .scrollDismissesKeyboard(.never)
    .simultaneousGesture(TapGesture().onEnded { isFocused = false })
```

- Focusing the field doesn't jump to the bottom; only sending does.
- New content scrolls into view with `ScrollPosition.scrollTo(edge: .bottom)` inside `withAnimation`; a "Scroll to
  Bottom" button appears when the reader is more than about 80 pt from the end.

## Gestures

- Every gesture has a visible or menu alternative, and an accessibility action where it matters.
- Horizontal gestures inside vertical scroll views must not fight: decide direction from the first movement and
  let the scroll view win vertical drags.
- Long press opens the context menu; don't attach other long-press behavior to the same view.

## Links

Open web links inside the app with `SFSafariViewController`, by setting an `OpenURLAction` in the environment
near the root. Pass through other schemes (`mailto:`, the app's own deep links) to the system. A screen that
handles its own links (like tapping a mentioned contact) wraps the action and forwards everything else to the outer
one.

## Transitions

- Thumbnail to full screen: `.matchedTransitionSource(id:in:)` on the thumbnail and
  `.navigationTransition(.zoom(sourceID:in:))` on the destination.
- Bars and banners appear with `.transition(.move(edge: .bottom).combined(with: .opacity))`.
- Keep durations short (0.2–0.45 s) and use `.smooth` or `.snappy`.

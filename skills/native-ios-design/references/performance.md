# Performance

Smoothness is part of feeling native. Most SwiftUI jank comes from doing too much in `body` or updating too many
views too often.

## Updates

- **`@Observable` models**, read only what each view needs. A view re-renders when a property it read changes, so
  pass IDs or small values into rows rather than whole models when the row only shows a name.
- **Scroll and geometry observation returns the smallest thing you need:**

```swift
.onScrollGeometryChange(for: Bool.self) { geometry in
    let maxOffset = geometry.contentSize.height - geometry.containerSize.height - geometry.contentInsets.top
    return maxOffset - geometry.contentOffset.y > 80
} action: { _, isAwayFromBottom in
    withAnimation(.smooth(duration: 0.2)) { self.isAwayFromBottom = isAwayFromBottom }
}
```

  The action runs only when the Bool flips, not on every scroll frame.
- **Scope animations** with `.animation(_:value:)` to the value that changed, not a bare `.animation(_:)`.
- **Avoid `GeometryReader` for layout.** Prefer `containerRelativeFrame`, `Layout`, `ViewThatFits`, and
  `onGeometryChange` when you only need a value.

## Lists

- `List` or `LazyVStack` inside `ScrollView` for long content, with stable `Identifiable` IDs. Never use array
  indices as IDs for data that can be inserted or deleted.
- Rows are concrete types, no `AnyView`. Prefer `AnyLayout` over `if`/`else` trees when switching layouts.
- Precompute lookups once per render (a dictionary by ID) instead of searching arrays per row.
- Keep row `body`s cheap: no date formatting with new formatters per row (use `Text(date, format:)` or cached
  formatters), no image decoding.

## Custom layouts

`Layout` types that measure repeatedly (like balanced text, which runs about a dozen measurements) cache results
by proposed width in `makeCache`, and apply only where the input is small.

## Images

- Decode and downsample off the main thread before display: `UIImage.preparingThumbnail(of:)` or
  `byPreparingThumbnail(ofSize:)` for thumbnails; ImageIO downsampling for large files.
- Store attachments as files and keep only IDs in your models, so saving the model doesn't rewrite image data.
- `AsyncImage` for remote images, with a fixed frame so layout doesn't jump.

## Async work

- `.task { }` and `.task(id:)` for work tied to a view; it's cancelled when the view disappears or the ID changes.
- Debounce with `try await Task.sleep(for:)` inside `.task(id:)` and check `Task.isCancelled`.
- Stream long responses into the model incrementally, but don't re-layout expensive views (like balanced text) on
  every token; switch to plain wrapping while streaming.

## Persistence

- Write on meaningful changes, off the main thread when large, and atomically (`.atomic` writes or
  write-then-rename).
- Secrets in the Keychain, small preferences in `UserDefaults` or `@AppStorage`, everything else in Application
  Support.

## Measure

- Instruments: the SwiftUI template (view body counts, update causes), Time Profiler, and Hangs.
- `Self._printChanges()` inside `body` while debugging, to see why a view updated. Remove before committing.
- Test on a real device, especially older ones; the simulator hides GPU cost from glass and blur.

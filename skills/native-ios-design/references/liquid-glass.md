# Liquid Glass

Liquid Glass (iOS 26 and later) is the material for the layer that floats above content: bars, floating controls,
sheets, menus. It bends and reflects what's behind it, reacts to touch, and adapts its tint to the content and the
appearance.

## Principles

1. **Content first, glass on top.** Glass marks controls and navigation. Content (lists, cards, bubbles, photos)
   stays opaque so it reads clearly and the glass has something to refract.
2. **Use less custom glass than you think.** Most of it comes from system components. Add your own only for
   floating controls that aren't in a toolbar.
3. **One layer.** Glass never sits on glass. Inside a glass shape, use a solid fill or plain content.
4. **Group what sits together.** Nearby glass shapes go in one `GlassEffectContainer` so they blend and morph, and
   render in one pass.

## Adopting it: remove before you add

When moving an older app to iOS 26:

- Delete custom `toolbarBackground`, bar tint colors, and opaque bar backgrounds. The system bar is glass.
- Delete `presentationBackground` on sheets. Sheets get glass, and partial-height sheets float with inset corners.
- Delete custom borders and shadows on toolbar buttons. Items are grouped into glass capsules automatically; use
  `ToolbarSpacer` to split groups.
- Replace custom "pill" buttons with `.buttonStyle(.glass)`, and primary actions with `.buttonStyle(.glassProminent)`.
- Replace hand-made close buttons with `Button(role: .close) { dismiss() }` in a `.cancellationAction` item.

## Custom floating controls

```swift
GlassEffectContainer(spacing: 10) {
    HStack(alignment: .bottom, spacing: 10) {
        Button { isAttaching = true } label: {
            Image(systemName: "plus")
                .font(.title3)
                .frame(width: 48, height: 48)
                .contentShape(.circle)
        }
        .tint(.primary)
        .glassEffect(.regular.interactive(), in: .circle)
        .accessibilityLabel("Add")

        messageField
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 24))
    }
}
```

- `.regular` is the standard glass; `.clear` is more transparent, for controls over photos and video only.
- `.interactive()` adds the press and touch response. Use it on anything tappable.
- `.tint(color)` on the glass for a prominent control. Tint sparingly, for the one primary action.
- Shape: circles for single symbols, capsules for text, rounded rects for fields. Keep corner radii concentric with
  the container they sit in.

### Something solid inside glass

A Send button inside the glass field is a solid circle (`Color(.label)` background, `Color(.systemBackground)`
symbol), not more glass.

## Bars over scrolling content

```swift
ScrollView { messages }
    .safeAreaBar(edge: .bottom) {
        ComposerView(...)
            .padding(.horizontal)
            .padding(.bottom, 8)
    }
```

`safeAreaBar` insets the content and adds the scroll edge effect, which fades and blurs content as it passes under
the bar so floating glass stays legible. Standard toolbars get this automatically.

Floating buttons that must sit just above a bar (like Scroll to Bottom) go in an `.overlay` on the scroll view,
not inside the bar: taps outside a bar's bounds don't reach buttons drawn there.

## Tab bars and sidebars

- Tab bars float in glass. `.tabBarMinimizeBehavior(.onScrollDown)` lets them shrink while reading.
- A search tab uses `Tab(role: .search)`.
- On iPad, sidebars float in glass over content. Let hero images extend under them with
  `.backgroundExtensionEffect()`.

## Transitions

Glass shapes morph between states when they share a container and use `glassEffectID(_:in:)` with a namespace,
inside `withAnimation`. Use this for a button that expands into a toolbar, not for unrelated controls.

## Accessibility

System glass responds to Reduce Transparency (frostier, more opaque), Increase Contrast (adds borders), and Reduce
Motion (calmer effects). Imitating glass with `.ultraThinMaterial` and custom blur loses all of that. Check every
glass control with these settings on.

## Performance

- Each glass shape samples the content behind it. Many separate shapes cost more than a few grouped ones; put
  neighbors in one `GlassEffectContainer`.
- Avoid glass on views that redraw every frame or on hundreds of list rows.
- Profile scrolling with Instruments if a screen has many floating controls.

## Further reading

- WWDC25 "Meet Liquid Glass" and "Get to know the new design system"
- WWDC25 session 323, "Build a SwiftUI app with the new design"
- Apple Developer documentation: "Adopting Liquid Glass" and "Applying Liquid Glass to custom views"

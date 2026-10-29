---
name: native-ios-design
description: Design and build iOS and iPadOS apps in SwiftUI that feel fully native, follow Apple's Human Interface Guidelines, adopt Liquid Glass, stay fast, and hold up at every Dynamic Type size. Use when building or reviewing SwiftUI screens, setting up typography, colors, or shared components, adopting Liquid Glass (glassEffect, glass button styles, toolbars, sheets), fixing layouts that break at large text sizes, or checking an app against the HIG.
---

# Native iOS design

Build apps that look like Apple made them, then stand out through restraint and detail rather than custom chrome.
The rules here come from shipping a SwiftUI chat app on iOS 26+ against the Human Interface Guidelines and the
Liquid Glass guidance. Each rule says why, so you can judge the cases it doesn't cover.

## How to work

1. **Start from system components.** `NavigationSplitView`, `NavigationStack`, `List`, `Form`, `toolbar`, `sheet`,
   `Menu`, `contextMenu`, `confirmationDialog`, `searchable`, `PhotosPicker`. They get Liquid Glass, Dynamic Type,
   VoiceOver, keyboard, pointer, and iPad behavior for free. Reach for a custom view only when no system one fits.
2. **Centralize design decisions.** One `Typography.swift` (font roles), one `Colors.swift` (color roles), one
   `Components.swift` (shared building blocks). Views use roles, never raw sizes or colors. Copy the starting
   points in [templates/](templates/) and rename roles for the app.
3. **Check every screen at three settings** before calling it done: the default text size, the largest
   accessibility size (AX5), and Dark Mode. Then once with Increase Contrast and Reduce Transparency.
4. **Review against [references/review-checklist.md](references/review-checklist.md)** when asked to check a screen
   or an app.

## Typography that holds up at large sizes

Full guide: [references/typography.md](references/typography.md).

- **Only system text styles.** `.largeTitle` through `.caption2`, with weight changes where needed. Never
  `.font(.system(size: 17))` for text. Fixed sizes don't scale with Dynamic Type or Bold Text, and they lose the
  system's tracking and leading.
- **Name fonts by role, in one file.** `Font.rowTitle`, `Font.messageBody`, `Font.sectionLabel`, not
  `.font(.subheadline.weight(.semibold))` scattered through views. Changing the scale becomes a one-line edit.
- **Floor and weight limits.** Nothing below Caption 1 for reading text (12 pt at the default size; 11 pt is the
  HIG minimum). No Ultralight, Thin, or Light weights for UI text.
- **Text never gets a fixed height.** Use `minHeight`, padding, and `lineLimit` with care. A fixed `frame(height:)`
  clips at large sizes.
- **Rearrange at accessibility sizes.** When `dynamicTypeSize.isAccessibilitySize`, turn rows from horizontal to
  vertical (`AdaptiveStack` in the templates), drop icons that steal width, show fewer items per row, and remove
  `lineLimit`s. Words should never break mid-word.
- **Cap chrome, not content.** Content text grows without limit. Bar controls, badges, and small round buttons
  stop at `.dynamicTypeSize(...DynamicTypeSize.accessibility1)`, like the system's own toolbars. Their sizes come
  from `@ScaledMetric` with a ceiling: `min(scaledSize, 64)`.
- **Symbols scale with text.** Size SF Symbols with a font (`.font(.body.weight(.semibold))`), not a frame, so they
  follow Dynamic Type and match nearby text weight.
- **UIKit text views** use `UIFont.preferredFont(forTextStyle:)` and `adjustsFontForContentSizeCategory = true`.
- **Short text gets balanced lines** (`BalancedText` in the templates) so a bubble or title doesn't end on one word.

## Liquid Glass

Full guide: [references/liquid-glass.md](references/liquid-glass.md).

- **Glass is for the navigation layer, not content.** Toolbars, tab bars, floating controls, and sheets float above
  content in glass. Lists, cards, and message bubbles stay solid. Glass on content makes everything compete.
- **Let the system draw it first.** Standard toolbars, tab bars, sheets, menus, and `.buttonStyle(.glass)` /
  `.glassProminent` already use Liquid Glass. Remove custom backgrounds, borders, and `presentationBackground`s that
  hide it.
- **Custom floating controls** use `.glassEffect(.regular.interactive(), in: .circle)` (or a rounded rect), grouped
  in one `GlassEffectContainer` so nearby shapes blend and morph together and share one rendering pass.
- **Never glass on glass.** A button inside a glass field gets a solid fill (like a black Send circle), not another
  glass layer.
- **Bars over scrolling content** go in `safeAreaBar(edge:)` so the scroll edge effect softens content under them.
  Use `safeAreaInset` only when you don't want that effect.
- **Close buttons** are `Button(role: .close)` in a `.cancellationAction` toolbar slot; the system draws the glass
  xmark.
- **Accessibility settings adapt glass for you** (Reduce Transparency, Increase Contrast, Reduce Motion), as long as
  you use system glass instead of faking it with materials and blur.

## Layout and components

Full guide: [references/layout-and-components.md](references/layout-and-components.md).

- **iPad gets a sidebar.** `NavigationSplitView` with selection in a router, collapsing to a stack on iPhone.
  Readable widths on wide screens (about 560 pt for chat bubbles).
- **44 × 44 pt minimum hit targets.** Draw a 20 pt badge if you like, but frame it in 36–44 pt and give it a
  `contentShape`.
- **Menus over custom popups.** `Menu`, `contextMenu` (with a palette `ControlGroup` for reactions),
  `confirmationDialog` for destructive confirmation, `.sheet` with `presentationDetents` for secondary tasks.
- **Keyboard behaves like Messages.** Tapping content hides the keyboard; scrolling doesn't
  (`.scrollDismissesKeyboard(.never)` plus a tap gesture). Focusing the field doesn't jump the scroll position.
- **Links open in the app** with `SFSafariViewController` via an `OpenURLAction` in the environment.
- **Zoom transitions** (`matchedTransitionSource` + `.navigationTransition(.zoom(sourceID:in:))`) when opening a
  photo or detail from a thumbnail.

## Color and icons

Full guide: [references/color-and-icons.md](references/color-and-icons.md).

- **System colors first** (`.primary`, `.secondary`, `Color(uiColor: .secondarySystemBackground)`); they adapt to
  Dark Mode and Increase Contrast. Name any custom color by role.
- **Text contrast at least 4.5:1**, or 3:1 at 18 pt and up or 14 pt bold. System orange, green, and blue text on
  white fail this; use darker light-mode variants.
- **Never color alone.** Underline links, pair status colors with a symbol or word.
- **Row icons** are SF Symbols on 26–29 pt continuous-corner tiles (radius ≈ 22.5% of the side), like Settings.
- **Stand out with restraint:** one strong color identity (even just black and white), one accent, a distinctive
  layered app icon made in Icon Composer. Not custom navigation chrome.

## Motion, feedback, and performance

Full guides: [references/accessibility.md](references/accessibility.md),
[references/performance.md](references/performance.md).

- **Animate state, not layout jank.** `.animation(.smooth(duration: 0.2), value:)` scoped to the value that changed;
  `.transition(.move(edge: .bottom).combined(with: .opacity))` for bars appearing.
- **Respect Reduce Motion** for decorative motion: check `accessibilityReduceMotion` and drop or simplify it.
- **Haptics through SwiftUI**: `.sensoryFeedback(.selection, trigger:)` for pickers, `.success` / `.error` for
  results. Sparingly.
- **Long lists** use `LazyVStack` / `List` with stable IDs, no `AnyView` in rows, and no heavy work in `body`.
- **Scroll observation** returns the smallest value you need (`onScrollGeometryChange(for: Bool.self)`) so views
  update only when it flips.
- **Images** are downsampled before display (`preparingThumbnail(of:)`), never decoded full size in a list.
- **Async work** lives in `.task(id:)` so it cancels when the view goes away or the input changes.

## Writing

- Buttons and menu items in title case and as verbs: "Remove Photo", "Clear Chat", "Cancel Reply".
- Descriptions, footers, and alerts in sentence case, short, saying what happens next.
- Accessibility labels say what a control does, not what it looks like ("Scroll to Bottom", not "Chevron").

## What not to do

- Custom tab bars, navigation bars, or back buttons that imitate the system ones.
- Fixed font sizes, fixed text heights, or `minimumScaleFactor` on reading text.
- Glass on content, glass on glass, or blur materials pretending to be glass.
- Gestures with no visible or accessible alternative.
- Styling that differs from screen to screen because each view picked its own values.

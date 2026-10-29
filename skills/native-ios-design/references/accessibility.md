# Accessibility and motion

Native components give you most of this. These are the parts you still own.

## VoiceOver

- **Labels say what it does:** `Button { } label: { Image(systemName: "chevron.down") }` gets
  `.accessibilityLabel("Scroll to Bottom")`.
- **Values say the state:** `.accessibilityValue(Text("\(count) unread"))`; selected items add `.isSelected`.
- **Combine compound rows:** `.accessibilityElement(children: .combine)` on a row with avatar, name, and preview, or
  set one label explicitly.
- **Hidden visual-only info gets a spoken form.** If times appear only on a swipe, read them in the message's
  `accessibilityValue`.
- **Custom pickers** (a carousel of shapes) become one adjustable element: `.accessibilityElement()`,
  `.accessibilityValue`, and `.accessibilityAdjustableAction` for swipe up and down.
- **Gesture-only actions** get `.accessibilityAction(named:)` or live in a menu too.
- **Decorative images** are hidden: `.accessibilityHidden(true)`.

## Dynamic Type

See [typography.md](typography.md). Short version: system text styles, no fixed text heights, rearrange at
accessibility sizes, cap only chrome.

## Contrast and color

See [color-and-icons.md](color-and-icons.md). 4.5:1 for normal text, never color alone.

## Motion

- Read `@Environment(\.accessibilityReduceMotion)` and remove decorative motion (floating, parallax, looping
  animations) when it's on. Keep functional transitions short and simple.

```swift
.animation(reduceMotion ? nil : .easeInOut(duration: 6).repeatForever(), value: isFloating)
```

- System transitions (zoom, sheets, glass) already adapt.

## Other settings to test

- Bold Text (wider text), Increase Contrast, Reduce Transparency, Smart Invert, Button Shapes.
- Full Keyboard Access and pointer on iPad: system controls work; custom tappable views need to be `Button`s, not
  `onTapGesture`.

## Haptics

`.sensoryFeedback` ties feedback to state changes and respects the system's haptics setting:

```swift
.sensoryFeedback(.selection, trigger: selectedShape)
.sensoryFeedback(trigger: saveResult) { _, result in result.map { $0 ? .success : .error } }
```

Use for selection changes, completed actions, and errors. Not for every tap.

# Review checklist

Use this to review a screen or a whole app. Report findings ranked by impact, with the file and line, what a user
would see, and the fix. Only change code when asked to.

## Native structure

- [ ] System components wherever one fits (navigation, lists, forms, menus, sheets, pickers, search).
- [ ] No custom tab bar, navigation bar, or back button imitating the system's.
- [ ] iPad uses a sidebar or split view; content has readable widths.
- [ ] Deep links, notifications, and widgets open the right screen through one router.

## Typography

- [ ] Every font is a role from the typography file; no `.font(.system(size:))` for text in views.
- [ ] No reading text below Caption 1; no Ultralight, Thin, or Light weights.
- [ ] At AX5: nothing clipped, no mid-word breaks, no important text truncated.
- [ ] Rows rearrange at accessibility sizes; `lineLimit`s lift there.
- [ ] Only chrome is capped (bar buttons, badges); content isn't.
- [ ] SF Symbols sized by font, matching nearby text.
- [ ] UIKit text uses `preferredFont(forTextStyle:)` with `adjustsFontForContentSizeCategory`.

## Liquid Glass

- [ ] Glass only on the navigation layer (bars, floating controls, sheets); content is opaque.
- [ ] No glass on glass; nothing faking glass with materials.
- [ ] Neighboring custom glass shapes share a `GlassEffectContainer`; tappable ones are `.interactive()`.
- [ ] No leftover custom bar backgrounds, sheet backgrounds, or button chrome hiding system glass.
- [ ] Bars over scrolling content use `safeAreaBar` (or are system toolbars) so the edge effect applies.
- [ ] Sheets close with `Button(role: .close)`.

## Color

- [ ] Colors are system colors or named roles that adapt to Dark Mode.
- [ ] Text contrast ≥ 4.5:1 (≥ 3:1 for large or bold), checked in both appearances.
- [ ] Meaning never carried by color alone; links underlined.
- [ ] Identity colors stay visible in Dark Mode.

## Interaction

- [ ] Hit targets ≥ 44 × 44 pt.
- [ ] Destructive actions confirm and say what's lost.
- [ ] Gestures have a visible or menu alternative and an accessibility action.
- [ ] Keyboard: tapping content dismisses it, scrolling doesn't, focusing doesn't jump the scroll.
- [ ] Web links open in the app.

## Accessibility

- [ ] Every icon-only control has a label naming its action.
- [ ] Compound rows read as one element with a useful label and value.
- [ ] Custom pickers are adjustable elements.
- [ ] Reduce Motion removes decorative motion.
- [ ] Works with Bold Text, Increase Contrast, Reduce Transparency.

## Performance

- [ ] Long lists are lazy with stable IDs and no `AnyView` rows.
- [ ] No per-frame state updates from scroll or geometry.
- [ ] Images downsampled; attachments stored as files.
- [ ] Async work in `.task(id:)`.
- [ ] Scrolling is smooth on a real device.

## Writing

- [ ] Buttons and menu items are title-case verbs.
- [ ] Footers and alerts are short sentences that say what happens.
- [ ] Empty states say what to do next.

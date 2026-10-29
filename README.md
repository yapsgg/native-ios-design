# native-ios-design

An agent skill for building iOS and iPadOS apps in SwiftUI that feel fully native: they follow Apple's Human
Interface Guidelines, adopt Liquid Glass, stay fast, and keep working at every Dynamic Type size.

It's the exact skill used to build two shipping iPhone apps:

- **[YapsGG Agent](https://github.com/yapsgg)** (a Grok Bot alternative on steroids: a fleet of named AI agents,
  each with its own cloud computer, that browse, sign in to tools, @mention each other, and finish tasks while
  you're away), a SwiftUI chat app for iOS 26 and later.
- **[Slay Camera](https://slaycamera.com)**, an iPhone camera app with 14 composition guides, AI subject tracking,
  and shot reports.

Both were built against the HIG and the Liquid Glass guidance. The rules are the ones that held up in practice,
each with the reason behind it.

## What's inside

```
skills/native-ios-design/
├── SKILL.md                       The rules, short, with links to the details
├── references/
│   ├── typography.md              Text styles, a type file of roles, and fixing large-size layouts
│   ├── liquid-glass.md            Where glass goes, adopting it, custom glass controls
│   ├── layout-and-components.md   Navigation, spacing, menus and sheets, text input, gestures
│   ├── color-and-icons.md         Color roles, contrast, icon tiles, app icons
│   ├── accessibility.md           VoiceOver, motion, haptics, settings to test
│   ├── performance.md             Updates, lists, images, async work, measuring
│   └── review-checklist.md        A checklist for reviewing a screen or an app
└── templates/
    ├── Typography.swift           Font roles built on system text styles
    ├── Colors.swift               Color roles with accessible status colors
    └── Components.swift           AdaptiveStack, GlassCircleLabel, IconTile, CountBadge, BalancedText
```

Highlights:

- **Typography that doesn't break at large sizes:** system text styles only, roles in one file, rows that stack
  vertically at accessibility sizes, and chrome capped while content keeps growing.
- **Liquid Glass done the native way:** glass for the navigation layer only, no glass on glass, grouped custom
  controls, and removing the custom backgrounds that hide system glass.
- **Smooth by default:** scoped updates, lazy lists with stable IDs, downsampled images, and `.task(id:)`.

## Install

### Claude Code

As a plugin:

```
/plugin marketplace add yapsgg/native-ios-design
/plugin install native-ios-design@native-ios-design
```

Or copy the skill into your skills folder:

```sh
git clone https://github.com/yapsgg/native-ios-design
cp -R native-ios-design/skills/native-ios-design ~/.claude/skills/
```

### Other agents

The skill is a plain folder with a `SKILL.md` (the [Agent Skills](https://agentskills.io) format). Copy
`skills/native-ios-design` wherever your agent loads skills from, or point it at `SKILL.md` directly.

## Use

Ask naturally, for example:

- "Set up typography and colors for this SwiftUI app."
- "Review the settings screen against the HIG."
- "This row breaks at the largest text size. Fix it."
- "Adopt Liquid Glass in the chat composer."

## Sources

Apple's [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/) (especially
[Typography](https://developer.apple.com/design/human-interface-guidelines/typography),
[Materials](https://developer.apple.com/design/human-interface-guidelines/materials), and
[Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility)), the
[Adopting Liquid Glass](https://developer.apple.com/documentation/technologyoverviews/adopting-liquid-glass)
documentation, and WWDC25 session 323, "Build a SwiftUI app with the new design". The guidance here is written
from scratch; read Apple's originals for the full picture.

Not affiliated with or endorsed by Apple. Apple, iOS, iPadOS, SwiftUI, and Liquid Glass are trademarks of Apple Inc.

## License

MIT

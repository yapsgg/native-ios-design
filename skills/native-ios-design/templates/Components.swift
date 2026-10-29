import SwiftUI

// Small building blocks shared by several screens. Screen-specific views stay in their screen's file.
// Uses roles from Typography.swift and Colors.swift.

// MARK: - Layout

/// A horizontal stack that turns vertical at accessibility text sizes, so text gets the full width instead of
/// truncating or breaking mid-word.
struct AdaptiveStack<Content: View>: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    var alignment: HorizontalAlignment = .leading
    var spacing: CGFloat?
    @ViewBuilder var content: Content

    var body: some View {
        // AnyLayout keeps the children's identity, so state and animations survive the switch.
        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: alignment, spacing: spacing))
            : AnyLayout(HStackLayout(spacing: spacing))
        layout { content }
    }
}

extension View {
    /// The rounded fill behind inputs.
    func fieldBackground(cornerRadius: CGFloat = 16) -> some View {
        background(Color.fieldFill, in: .rect(cornerRadius: cornerRadius))
    }

    /// Adds the standard Close button to a sheet's toolbar.
    func closeButton(isVisible: Bool = true) -> some View {
        modifier(CloseButtonModifier(isVisible: isVisible))
    }
}

private struct CloseButtonModifier: ViewModifier {
    @Environment(\.dismiss) private var dismiss
    let isVisible: Bool

    func body(content: Content) -> some View {
        content.toolbar {
            if isVisible {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .close) { dismiss() }
                }
            }
        }
    }
}

// MARK: - Controls

/// The label of a round, floating glass control. Apply `.glassEffect(.regular.interactive(), in: .circle)` to the
/// button or menu that contains it, and size it with a capped `@ScaledMetric`:
///
///     @ScaledMetric(relativeTo: .body) private var scaledSize: CGFloat = 48
///     private var size: CGFloat { min(scaledSize, 64) }
struct GlassCircleLabel: View {
    let systemImage: String
    let size: CGFloat
    var font: Font = .symbol

    var body: some View {
        Image(systemName: systemImage)
            .font(font)
            .frame(width: size, height: size)
            .contentShape(.circle)
            // Bar controls stop growing at a point, like the system's own toolbars.
            .dynamicTypeSize(...DynamicTypeSize.accessibility1)
    }
}

/// A symbol on a rounded square, like the icons in the Settings app.
struct IconTile: View {
    enum Style {
        /// A white symbol on the color.
        case filled
        /// The symbol in the color on a near-black square.
        case tinted
    }

    let systemImage: String
    let color: Color
    /// 29 pt matches Settings row icons.
    var size: CGFloat = 29
    /// How much of the tile the symbol fills.
    var symbolScale: CGFloat = 0.55
    var style: Style = .filled

    var body: some View {
        // Continuous corners at about a quarter of the side, the same curve as app icons and system tiles.
        let shape = RoundedRectangle(cornerRadius: size * 0.225, style: .continuous)
        let symbol = Image(systemName: systemImage)
            .font(.system(size: size * symbolScale, weight: .medium))
            .frame(width: size, height: size)

        Group {
            switch style {
            case .filled:
                symbol
                    .foregroundStyle(.white)
                    .background(color.gradient, in: shape)
            case .tinted:
                symbol
                    .foregroundStyle(color)
                    .background(Color.iconTile.gradient, in: shape)
                    .overlay(shape.strokeBorder(Color.iconTileBorder, lineWidth: 0.5))
                    // The square is dark in both appearances, so colors take their brighter Dark Mode shades.
                    .environment(\.colorScheme, .dark)
            }
        }
        .accessibilityHidden(true)
    }
}

/// A count in a capsule. It stops growing at the first accessibility size, since it's secondary to the text beside it.
struct CountBadge: View {
    let count: Int

    var body: some View {
        if count > 0 {
            Text(count, format: .number)
                .font(.badge)
                .monospacedDigit()
                .foregroundStyle(.white)
                .padding(.horizontal, 6)
                .frame(minWidth: 22, minHeight: 22)
                .background(.blue, in: .capsule)
                .dynamicTypeSize(...DynamicTypeSize.accessibility1)
        }
    }
}

// MARK: - Text

/// Wraps text so its lines come out about the same length, like `text-wrap: balance` in CSS.
///
/// It keeps the number of lines normal wrapping would use and finds the narrowest width that still fits them, so a
/// short paragraph doesn't end with a lone word. Meant for short text: each layout measures the text about a dozen
/// times. Don't use it on text that's still streaming in, or the width changes with every word.
///
///     BalancedText { Text(message) }
struct BalancedText: Layout {
    struct Cache {
        var proposedWidth: CGFloat?
        var balancedWidth: CGFloat?
    }

    func makeCache(subviews: Subviews) -> Cache {
        Cache()
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) -> CGSize {
        guard let text = subviews.first else { return .zero }
        return text.sizeThatFits(ProposedViewSize(width: balancedWidth(for: text, proposal: proposal, cache: &cache), height: nil))
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) {
        subviews.first?.place(at: bounds.origin, proposal: ProposedViewSize(width: bounds.width, height: bounds.height))
    }

    private func balancedWidth(for text: LayoutSubview, proposal: ProposedViewSize, cache: inout Cache) -> CGFloat? {
        guard let maxWidth = proposal.width, maxWidth.isFinite else { return proposal.width }
        if cache.proposedWidth == maxWidth { return cache.balancedWidth }

        let wrapped = text.sizeThatFits(ProposedViewSize(width: maxWidth, height: nil))
        let singleLine = text.sizeThatFits(.unspecified)
        var width = wrapped.width
        // A single line has nothing to balance.
        if wrapped.height > singleLine.height * 1.5 {
            // Binary search for the narrowest width that doesn't add a line.
            var low: CGFloat = 1
            var high = wrapped.width
            for _ in 0..<10 {
                let mid = (low + high) / 2
                if text.sizeThatFits(ProposedViewSize(width: mid, height: nil)).height <= wrapped.height {
                    high = mid
                } else {
                    low = mid
                }
            }
            width = high.rounded(.up)
        }

        cache = Cache(proposedWidth: maxWidth, balancedWidth: width)
        return width
    }
}

#Preview("Components") {
    NavigationStack {
        List {
            AdaptiveStack(spacing: 12) {
                IconTile(systemImage: "bell.fill", color: .red)
                Text("Notifications").font(.rowTitle)
                Spacer()
                CountBadge(count: 3)
            }
            AdaptiveStack(spacing: 12) {
                IconTile(systemImage: "lock.fill", color: .blue, style: .tinted)
                Text("Privacy").font(.rowTitle)
            }
            BalancedText {
                Text("Short paragraphs get even lines instead of ending on one lonely word.")
                    .font(.bodyText)
            }
        }
        .navigationTitle("Components")
        .closeButton()
    }
}

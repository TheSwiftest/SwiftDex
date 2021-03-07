//
//  ExpandableBottomSheet.swift
//  Pokedex
//
//  Created by BrianCorbin on 2/3/21.
//

import SwiftUI

struct ExpandableBottomSheet: ViewModifier {
    enum ViewState {
        case full, half
    }

    let containerHeight: CGFloat

    @State private var viewState = ViewState.half

    @Binding var showing: Bool

    @GestureState private var dragTranslation: CGFloat = 0

    @State private var scrollOffset: CGFloat = 0
    @State private var positionOffset: CGFloat = 0

    private var sheetOffset: CGFloat {
        return containerHeight - (viewState == .full ? fullSheetHeight : halfSheetHeight)
    }

    private var fullSheetHeight: CGFloat {
        return containerHeight * 0.85
    }

    private var halfSheetHeight: CGFloat {
        return fullSheetHeight * 0.5
    }

    func body(content: Content) -> some View {
        VStack {
            Spacer()
            HandleBar()
            ScrollView(.vertical) {
                GeometryReader { scrollViewProxy in
                    Color.clear.preference(key: ScrollOffsetKey.self, value: scrollViewProxy.frame(in: .named("scrollview")).minY)
                }
                .frame(height: 0)
                content
                    .offset(y: -scrollOffset)
                    .animation(nil)
            }
            .background(Color(.systemBackground))
            .cornerRadius(10, antialiased: true)
            .coordinateSpace(name: "scrollview")
            .disabled(viewState == .half)
        }
        .frame(height: fullSheetHeight)
        .offset(y: sheetOffset)
        .offset(y: viewState == .half ? dragTranslation : 0)
        .offset(y: scrollOffset)
        .animation(.interpolatingSpring(stiffness: 200.0, damping: 25.0, initialVelocity: 10.0))
        .onPreferenceChange(ScrollOffsetKey.self) { value in
            scrollOffset = value > 0 ? value : 0

            if scrollOffset > containerHeight * 0.1 {
                scrollOffset = 0
                viewState = .half
            }
        }
        .gesture(
            DragGesture()
                .updating($dragTranslation, body: { value, state, _ in
                    state = value.translation.height
                })
                .onEnded({ value in
                    if viewState == .half {
                        if value.translation.height < -containerHeight * 0.25 {
                            positionOffset = -containerHeight / 2 + 50
                            viewState = .full
                        }

                        if value.translation.height > containerHeight * 0.15 {
                            showing = false
                        }
                    }
                })
        )
    }
}

struct HandleBar: View {
    var body: some View {
        Rectangle()
            .frame(width: 50, height: 5)
            .foregroundColor(Color(.systemGray5))
            .cornerRadius(10)
    }
}

struct ScrollOffsetKey: PreferenceKey {
    typealias Value = CGFloat

    static var defaultValue = CGFloat.zero

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct BlankView: View {
    var bgColor: Color

    var body: some View {
        VStack {
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(bgColor)
        .edgesIgnoringSafeArea(.all)
    }
}

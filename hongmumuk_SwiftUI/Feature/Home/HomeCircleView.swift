//
//  HomeCircleView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/13/25.
//

import ComposableArchitecture
import SwiftUI

struct HomeCircleView: View {
    @ObservedObject var viewStore: ViewStoreOf<HomeFeature>

    var body: some View {
        ZStack(alignment: .center) {
            CenterButton(viewStore: viewStore)
            CircleSections(viewStore: viewStore)
        }
        .frame(width: viewStore.diameter, height: viewStore.diameter)
        .gesture(dragGesture)
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged {
                viewStore.send(.dragChanged($0))
            }
            .onEnded { _ in
                viewStore.send(.dragEnded)
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            }
    }
}

private struct CenterButton: View {
    @ObservedObject var viewStore: ViewStoreOf<HomeFeature>
    
    var body: some View {
        Button(action: {}) {
            Image("homeLogo")
        }
    }
}

private struct CircleSections: View {
    @ObservedObject var viewStore: ViewStoreOf<HomeFeature>

    var body: some View {
        ForEach(0 ..< viewStore.categories.count, id: \.self) { i in
            ZStack {
                DonutWedgeShape(viewStore: viewStore)
                    .fill(Colors.Primary.primary5)
                    .stroke(Colors.Border.normal)
                    .rotationEffect(viewStore.state.rotationAngle(i), anchor: .center)

                MenuItemView(category: viewStore.categories[i])
                    .position(viewStore.state.calculatePosition(i))
            }
            .animation(.easeInOut(duration: 0.1))
            .onTapGesture {
                viewStore.send(.categoryItemTapped(viewStore.categories[i]))
            }
        }
    }
}

private struct MenuItemView: View {
    let category: Category
    
    var body: some View {
        VStack(spacing: 4) {
            Image(category.rawValue)
                .resizable()
                .scaledToFit()
                .frame(width: 52, height: 36)
            
            Text(category.displayName)
                .foregroundColor(.black)
        }
    }
}

private struct DonutWedgeShape: Shape {
    @ObservedObject var viewStore: ViewStoreOf<HomeFeature>

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        var path = Path()

        path.move(to: pointOnCircle(center: center, radius: viewStore.outerRadius, angle: .degrees(0)))
        path.addArc(
            center: center,
            radius: viewStore.outerRadius,
            startAngle: .degrees(0),
            endAngle: .degrees(viewStore.effectiveAngle),
            clockwise: false
        )

        path.addLine(to: pointOnCircle(center: center, radius: viewStore.innerRadius, angle: .degrees(viewStore.effectiveAngle)))

        path.addArc(
            center: center,
            radius: viewStore.innerRadius,
            startAngle: .degrees(viewStore.effectiveAngle),
            endAngle: .degrees(0),
            clockwise: true
        )

        path.closeSubpath()
        return path
    }

    private func pointOnCircle(center: CGPoint, radius: CGFloat, angle: Angle) -> CGPoint {
        let rad = angle.radians
        return CGPoint(
            x: center.x + radius * CGFloat(cos(rad)),
            y: center.y + radius * CGFloat(sin(rad))
        )
    }
}

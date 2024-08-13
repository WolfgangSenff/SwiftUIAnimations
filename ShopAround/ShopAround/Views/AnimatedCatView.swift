//
//  AnimatedCatView.swift
//  ShopAround
//
//  Created by Kyle Szklenski on 8/12/24.
//

import SwiftUI

struct AnimatedCatView: View {
    @Environment(\.done) private var done
    
    @State private var xoffset: CGFloat = -125.0
    
    let MinOffset = -125.0
    
    var body: some View {
        Button {
        } label: {
            HStack {
                Text("Checkout")
                    .frame(minWidth: 320.0, minHeight: 40.0) // Not the right way to handle this
            }
        }
        //.offset(x: xoffset)
        .mask(AnimatedImage(filename: "catrun-animation", first: 1, last: 6, currentOffset: xoffset, minOffset: MinOffset).offset(x: xoffset))
        .buttonStyle(.borderedProminent)
        .scaledToFill()
        .padding()
        .tint(.black)
        .background(RoundedRectangle(cornerRadius: 12).fill(.blue))
        .foregroundStyle(.white)
        .onAppear {
            let animation = Animation.easeInOut(duration: 2.5)
            let repeated = animation.repeatCount(5, autoreverses: true).speed(2)
            withAnimation(repeated) {
                xoffset = xoffset == MinOffset ? -MinOffset : MinOffset
            } completion: {
                done?.call()
            }
        }
    }
}

struct AnimatedImage: View {
    @State private var index = 0
    var currentOffset: CGFloat
    var minOffset: CGFloat
    
    var filenames: [String] = []
    
    init(filename: String, first: Int, last: Int, currentOffset: CGFloat, minOffset: CGFloat) {
        for value in first...last {
            filenames.append("\(filename)\(value)")
        }
        self.index = first
        self.currentOffset = currentOffset
        self.minOffset = minOffset
    }
    
    var body: some View {
        PhaseAnimator(filenames) { phase in
            Image(phase)
                .resizable()
                .id(phase)
        } animation: { phase in
            .linear(duration: 0.01)
        }
        .scaledToFit()
        .frame(maxWidth: .infinity)
        .scaleEffect(x: currentOffset > minOffset ? 1.0 : -1.0, y: 1.0)
    }
}

#Preview {
    AnimatedCatView()
}

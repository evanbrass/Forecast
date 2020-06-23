//
//  AnimateTest.swift
//  Forecast-SwiftUI
//
//  Created by Evan Brass on 6/16/20.
//  Copyright © 2020 Evan Brass. All rights reserved.
//

import SwiftUI

struct AnimatableFont: AnimatableModifier {
    var size: CGFloat
    var weight: Font.Weight = .regular
    var design: Font.Design = .default
    
    func body(content: Content) -> some View {
        return content.font(Font.system(size: size, weight: weight, design: design))
    }

    var animatableData: CGFloat {
        get { return size }
        set { size = newValue }
    }
}

extension View {
    func animatableFont(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> some View {
        return self.modifier(AnimatableFont(size: size, weight: weight, design: design))
    }
}

struct AnimateTest: View {
    @State var big = true
    @State var size: CGFloat = 10
    var body: some View {
        VStack {
            HStack {
                Text("Hello, World!")
//                    .font(.system(size: size))
                                    .animatableFont(size: size)
                    //                .lineLimit(1)
                    .minimumScaleFactor(0.2)
//                    .background(Color.red)
                Spacer()
                            Button("Touch") {
                                withAnimation {
                                    self.big.toggle()
                                }
                            }
                                .background(Color.yellow)
            }
            .background(Color.gray)
            .frame(width: 300, height: 50)
            
            Slider(value: $size, in: (10.0...300.0))
        }
    }
}

struct AnimateTest_Previews: PreviewProvider {
    static var previews: some View {
        AnimateTest()
    }
}

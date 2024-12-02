import SwiftUI

struct HexagonWheelView: View {
    let buttonSize: CGFloat = 100
    let radius: CGFloat = 100 * 3 / (2 * sqrt(3))
    
    @State private var clickedIndex = 0
    @State private var btnOffsets:[CGPoint] = (0..<6).map{_ in CGPoint(x: 0, y: 0)}
    @State private var currentAngle = 0
        
    private let animationDuration: Double = 0.3
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Center Hexagon Button
                HexagonBtn(
                    color: .blue,
                    index: -1,
                    text: "GO", action: {_ in
                        print("Center button tapped")
                    }
                )
                .frame(width: buttonSize, height: buttonSize)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2) // Center it in the available space
                
                // Surrounding Hexagon Buttons
                ForEach(0..<6) { index in
                    let offset = btnOffsets[index]
                    let x = offset.x == 0 ? geometry.size.width / 2 : offset.x
                    let y = offset.y == 0 ? geometry.size.height / 2 : offset.y
                    
                    HexagonBtn(
                        color: .green,
                        index: index,
                        text: "\(index)",
                        action: { btnIndex in
                            if (btnIndex == clickedIndex) { return }
                            
                            let centerX = geometry.size.width / 2
                            let targetX = btnOffsets[btnIndex].x
                            let isLeftRotate = centerX - targetX > 0 ? false : true
                            
                            let interval = abs(clickedIndex - btnIndex)
                            let indexInterval = min(interval, 6 - interval)
                            clickedIndex = btnIndex
                            
                            for strideIndex in 0..<indexInterval {
                                var useAngle = strideIndex > 0 ? 60 : 30
                                if (isLeftRotate) {useAngle = -useAngle}
                                DispatchQueue.main.asyncAfter(deadline: .now() + Double(strideIndex) * animationDuration) {
                                    withAnimation(Animation.timingCurve(
                                        0.42, 0,    // Control point 1 (start slow)
                                        0.58, 1,       // Control point 2 (end fast)
                                        duration: animationDuration
                                    )) {
                                        currentAngle += useAngle
                                        btnOffsets = calculatePoint(
                                            size: geometry.size,
                                            degree: Double(currentAngle),
                                            isSlideEdge: true
                                        )
                                    }
                                }
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + Double(indexInterval) * animationDuration) {
                                withAnimation(Animation.timingCurve(
                                    0.42, 0,    // Control point 1 (start slow)
                                    0.58, 1,       // Control point 2 (end fast)
                                    duration: animationDuration
                                )) {
                                    currentAngle = isLeftRotate ? currentAngle - 30 : currentAngle + 30

                                    btnOffsets = calculatePoint(
                                        size: geometry.size,
                                        degree: Double(currentAngle),
                                        isSlideEdge: false
                                    )
                                }
                            }
                            
                            
                        }
                    )
                    .frame(width: buttonSize, height: buttonSize)
                    .position(x: x , y: y)
                }
            }
            .onAppear {
                // Update btnOffsets when the view appears
                btnOffsets = calculatePoint(
                    size: geometry.size,
                    degree: 0,
                    isSlideEdge: false
                )
            }
        }
        .frame(width: 400, height: 400) // Adjust size as needed
    }
    
    private func calculatePoint(size: CGSize, degree: Double, isSlideEdge: Bool) -> [CGPoint] {
        var tmpPointList: [CGPoint] = []
        var useRadius = radius
        let centerX = size.width / 2
        let centerY = size.height / 2
        
        if (isSlideEdge) {
            useRadius = radius * 2 * sqrt(3) / 3
        }
        
        for index in 0..<6 {
            let baseAngle = CGFloat(index) * (.pi / 3)
            let rotationAngle: CGFloat = .pi / 6
            
            // Convert degree to radians
            let additionalRotation = CGFloat(degree).degreesToRadians
            
            let totalAngle = baseAngle + 9 * rotationAngle + additionalRotation
            
            let x = centerX + useRadius * cos(totalAngle)
            let y = centerY + useRadius * sin(totalAngle)
            
            tmpPointList.append(CGPoint(x: x, y: y))
        }
        return tmpPointList
    }
}

extension CGFloat {
    var degreesToRadians: CGFloat {
        return self * .pi / 180
    }
}




#Preview {
    HexagonWheelView()
}

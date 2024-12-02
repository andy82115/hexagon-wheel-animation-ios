import SwiftUI

struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let rotationAngle: CGFloat = .pi / 6  // 60 degrees in radians
        let corners = (0..<6).map { index -> CGPoint in
            let angle = CGFloat(index) * (CGFloat.pi / 3) - CGFloat.pi / 6 + rotationAngle
            return CGPoint(
                x: center.x + radius * cos(angle),
                y: center.y + radius * sin(angle)
            )
        }
        
        var path = Path()
        path.move(to: corners[0])
        corners[1...].forEach { path.addLine(to: $0) }
        path.closeSubpath()
        return path
    }
}

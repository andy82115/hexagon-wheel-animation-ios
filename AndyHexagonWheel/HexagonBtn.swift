import SwiftUI

struct HexagonBtn: View {
    let color: Color
    let index: Int
    var text: String = ""
    let action: (Int) -> Void

    
    @State private var isPressed = false
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                HexagonShape()
                    .fill(isPressed ? color.opacity(0.3) : color)
                    .overlay(HexagonShape().stroke(Color.black, lineWidth: 5))
                    .contentShape(HexagonShape())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let hexagonPath = HexagonShape().path(in: geometry.frame(in: .local))
                                isPressed = hexagonPath.contains(value.location)
                            }
                            .onEnded { value in
                                let hexagonPath = HexagonShape().path(in: geometry.frame(in: .local))
                                if hexagonPath.contains(value.location) {
                                    action(index)
                                }
                                isPressed = false
                            }
                    )
            }
            .aspectRatio(1, contentMode: .fit)
            
            Text(text)
        }
    }
}

#Preview {
    HexagonBtn(color: .blue, index: 0, action:  {index in
        print("Hexagon button tapped!")
    })
    .frame(width: 100, height: 100)
}

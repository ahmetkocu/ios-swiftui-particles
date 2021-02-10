//
//  SwiftUIView.swift
//  
//
//  Created by helloworld on 10.02.2021.
//

import SwiftUI

public struct ParticlesView: View {
    @State private var particles: [Particle] = [Particle]()
    @State private var hasSurface: Bool = false
    @State private var hasSetup: Bool = false
    @State private var path: Path = Path()
    
    // Attribute Defaults
    public var _particleCount = 20
    public var _particleMinRadius = 5
    public var _particleMaxRadius = 10
    public var _particlesBackgroundColor = Color.black
    public var _particleColor = Color.white
    public var _particleLineColor = Color.white
    public var _particleLinesEnabled = true
    
    private let timer = Timer.publish(
        every: 0.09,       // Second
            tolerance: 0.1, // Gives tolerance so that SwiftUI makes optimization
            on: .main,      // Main Thread
            in: .common     // Common Loop
        ).autoconnect()
    
    public var body: some View {
        ZStack(alignment: .top) {
            _particlesBackgroundColor
                .edgesIgnoringSafeArea(.all)
            
            ForEach(particles, id: \.self) { item in
                
                ForEach(particles, id: \.self) { item2 in
                    if item.x != item2.x &&
                        item.y != item2.y {
                        
                        let dx = item.x - item2.x
                        let dy = item.y - item2.y
                        let dist = sqrt(dx * dx + dy * dy)
                        
                        if dist < 120 {
                            let distRatio = (120 - dist) / 120
                            let mm = (min(item.alpha, item2.alpha) * distRatio) / 2
                            
                            Path { path in
                                path.move(to: CGPoint(x: CGFloat(item.x), y: CGFloat(item.y)))
                                path.addLine(to: CGPoint(x: CGFloat(item2.x), y: CGFloat(item2.y)))
                            }
                            //.fill(Color.white)
                            .stroke(Color.white, lineWidth: 2)
                            .opacity(Double(mm))
                        }
                    }
                }
                
                Circle()
                    .fill(_particleColor)
                    .frame(width: 7, height: 7)
                    .position(x: CGFloat(item.x), y: CGFloat(item.y))
                    .opacity(Double(item.alpha))
            }
        }
        .onAppear {
            setupParticles()
        }
        .onReceive(timer) { (_) in
            var pp = [Particle]()
            for item in particles {
                var _item = item
                _item.x += Float(_item.vx)
                _item.y += Float(_item.vy)

                if (item.x < 0) {
                    _item.x = Float(UIScreen.main.bounds.width)
                } else if (item.x > Float(UIScreen.main.bounds.width)) {
                    _item.x = 0.0
                }

                if (item.y < 0) {
                    _item.y = Float(UIScreen.main.bounds.height)
                } else if (item.y > Float(UIScreen.main.bounds.height)) {
                    _item.y = 0.0
                }
                pp.append(_item)
            }
            
            self.particles = pp
        }
    }
    
    private func setupParticles() {
        if !hasSetup {
            hasSetup = true
            self.particles.removeAll()
            for _ in 0..._particleCount {
                particles.append(Particle(radius: Float(Int.random(in: _particleMinRadius..._particleMaxRadius)), x: Float(Int.random(in: 0...Int(UIScreen.main.bounds.width))), y: Float(Int.random(in: 0...Int(UIScreen.main.bounds.height))), vx: Int.random(in: -2...2), vy: Int.random(in: -2...2), alpha: Float.random(in: 0...1)))
            }
        }
    }

}

struct ParticlesView_Previews: PreviewProvider {
    static var previews: some View {
        ParticlesView(_particleCount: 20, _particleMinRadius: 5, _particleMaxRadius: 10, _particlesBackgroundColor: .black, _particleColor: .white, _particleLineColor: .white, _particleLinesEnabled: true)
    }
}

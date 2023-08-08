//
//  HomeView.swift
//  TemanTuli
//
//  Created by Irfan Dary Sujatmiko on 07/08/23.
//

import SwiftUI

struct HomeView: View {
    @State private var overlayPoints: [CGPoint] = []
    var CameraViewFinder : some View{
             CameraView ()
                 .overlay(FingersOverlay(with: overlayPoints)
                     .foregroundColor(.green)
                 )
                 .ignoresSafeArea()
             
         }
        
        var body: some View {
        
            
            ZStack{
                CameraViewFinder
            }
            
        }
}
struct FingersOverlay: Shape {
    let points: [CGPoint]
    private let pointsPath = UIBezierPath()
    
    init(with points: [CGPoint]) {
        self.points = points
    }
    
    func path(in rect: CGRect) -> Path {
        for point in points {
            pointsPath.move(to: point)
            pointsPath.addArc(withCenter: point, radius: 5, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        }
        
        return Path(pointsPath.cgPath)
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

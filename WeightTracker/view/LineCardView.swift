//
//  LineCardView.swift
//  WeightTracker
//
//  Created by Florian Thiévent on 12.07.21.
//

import SwiftUI

struct LineCardView: View {
    
    var title: String
    var subtitle: String!
    var items: [Double]!
    
    var body: some View {
        
  
            ZStack{
                Color.white.cornerRadius(8)
                
                LineView(data: items,
                         title: title,
                         subtitle: subtitle)
                    .padding()
                
                
            }
            .frame(width: UIScreen.main.bounds.size.width - 30)
            .padding()
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 0)
        
        

    }
}

struct LineCardView_Previews: PreviewProvider {
    static var previews: some View {
        LineCardView(title: "Check")
    }
}

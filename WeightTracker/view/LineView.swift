//
//  LineView.swift
//  WeightTracker
//
//  Created by Florian Thiévent on 12.07.21.
//

import SwiftUI

struct LineView: View {
    var data: [(Double)]
        var title: String?
        var subtitle: String?

        public init(data: [Double],
                    title: String? = nil,
                    subtitle: String? = nil) {
            
            self.data = data
            self.title = title
            self.subtitle = subtitle
        }
        
        public var body: some View {
            GeometryReader{ geometry in
                VStack(alignment: .leading, spacing: 8) {
                    Group{
                        if (self.title != nil){
                            Text(self.title!)
                                .font(.title)
                        }
                        if (self.subtitle != nil){
                            Text(self.subtitle!)
                                .font(.body)
                            .offset(x: 5, y: 0)
                        }
                    }.offset(x: 0, y: 0)
                    ZStack{
                        GeometryReader{ reader in
                            Line(data: self.data,
                                 frame: .constant(CGRect(x: 0, y: 0, width: reader.frame(in: .local).width , height: reader.frame(in: .local).height))
                            )
                                .offset(x: 0, y: 0)
                        }
                        .frame(width: geometry.frame(in: .local).size.width, height: 200)
                        .offset(x: 0, y: -100)

                    }
                    .frame(width: geometry.frame(in: .local).size.width, height: 200)
            
                }
            }
        }
}

 

struct LineView_Previews: PreviewProvider {
    static var previews: some View {
        LineView(data: [1.0, 1.1,1.2])
    }
}

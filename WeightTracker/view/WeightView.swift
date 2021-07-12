//
//  WeightView.swift
//  WeightTracker
//
//  Created by Florian Thiévent on 12.07.21.
//

import SwiftUI

struct WeightView: View {
    
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(entity: WeightItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \WeightItem.timestamp, ascending: true)])
    var weightItems: FetchedResults<WeightItem>
    
    @State private var showNewTask = false
    
    
    var body: some View {
        
        ZStack {
            
            
            VStack {
                
                HStack {
                    Text("Messungen")
                        .font(.system(size: 40, weight: .black, design: .rounded))
                    
                    Spacer()
                    
                    Button(action: {
                        self.showNewTask = true
                        
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                
                VStack{
                    if weightItems.count > 0 {
                        
                        
                        List {
                            
                            ForEach(weightItems) { weightItem in
                                
                                let ts = self.formattedDate(timestamp: weightItem.timestamp)
                                let weightRounded = String(format:"%.1f", weightItem.weight)
                                let chestRounded = String(format:"%.f cm", weightItem.chest)
                                let upperbellyRounded = String(format:"%.f cm", weightItem.upperbelly)
                                let lowerbellyRounded = String(format:"%.f cm", weightItem.lowerbelly)
                                
                                HStack{
                                    
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color(.systemGray5))
                                            .frame(width: 80, height: 80, alignment: .center)
                                        
                                        VStack{
                                            Text("\(weightRounded)").font(.title)
                                            Text("kg").font(.caption)
                                        }
                                    }
                                    
                                    
                                    VStack(alignment: .leading){
                                        
                                        Text(ts).font(.title)
                                        
                                        HStack(spacing:15){
                                            
                                            if(weightItem.chest>0){
                                                VStack(alignment: .leading){
                                                    Text(chestRounded)
                                                    Text("Brust").font(.caption)
                                                }
                                            }
                                            
                                            if(weightItem.upperbelly>0){
                                                VStack(alignment: .leading){
                                                    Text(upperbellyRounded)
                                                    Text("Bauch").font(.caption)
                                                }
                                                
                                            }
                                            
                                            if(weightItem.lowerbelly>0){
                                                VStack(alignment: .leading){
                                                    Text(lowerbellyRounded)
                                                    Text("Taille").font(.caption)
                                                }
                                                
                                            }
                                        }
                                    }.padding()
                                }
                            }
                            .onDelete(perform: deleteWeightItem)
                        }
                        
                        
                        ScrollView(.horizontal){
                            
                            
                            HStack(spacing: 15){
                                
                                // Weight
                                let currentWeight = String(format: "%.1f", weightItems.last?.weight ?? 0)
                                LineCardView(title: "Gewicht", subtitle:"Aktuelles Gewicht \(currentWeight) kg", items: self.getChartData(items: weightItems))
                                
                                // Chest
                                let currentChest = String(format: "%.f", weightItems.last?.chest ?? 0)
                                LineCardView(title: "Brustumfang", subtitle: "Aktueller Brustumfang \(currentChest) cm", items: self.getChartData(items: weightItems, type: "chest"))
                                
                                // UpperBelly
                                let currentUpperBelly = String(format: "%.f", weightItems.last?.upperbelly ?? 0)
                                LineCardView(title: "Bauchumfang", subtitle: "Aktueller Bauchumfang \(currentUpperBelly) cm", items: self.getChartData(items: weightItems, type: "upperbelly"))
                                
                                // LowerBelly
                                let currentLowerBelly = String(format: "%.f", weightItems.last?.lowerbelly ?? 0)
                                LineCardView(title: "Taillenumfang",subtitle: "Aktueller Bauchumfang \(currentLowerBelly) cm", items: self.getChartData(items: weightItems, type: "lowerbelly"))
                                
                            }
                            
                        }
                        
                    } else {
                        Spacer()
                    }
                }
                
                
            }
            .rotation3DEffect(Angle(degrees: showNewTask ? 5 : 0), axis: (x: 1, y: 0, z: 0))
            .offset(y: showNewTask ? -50 : 0)
            .animation(.easeOut)
            
            // If there is no data, show an empty view
            if weightItems.count == 0 {
                NoDataView()
            }
            
            // Display the "Add new todo" view
            if showNewTask {
                BlankView(bgColor: .white)
                    .opacity(0.5)
                    .onTapGesture {
                        self.showNewTask = false
                    }
                
                NewWeightItem(isShow: $showNewTask, weight: "", chest: "", upperbelly: "", lowerbelly: "")
                    .transition(.move(edge: .bottom))
                    .animation(.interpolatingSpring(stiffness: 200.0, damping: 25.0, initialVelocity: 10.0))
            }
        }.background(Color.white)
        
    }
    
    private func getChartData(items: FetchedResults<WeightItem>, type: String = "weight") -> [Double] {
        var dta = [Double]()
        
        items.forEach{ item in
            switch (type){
            case "chest":
                if item.chest != 0 {
                    dta.append(item.chest)
                }
                
                break;
            case "upperbelly":
                if item.upperbelly != 0 {
                    dta.append(item.upperbelly)
                }
                break;
            case "lowerbelly":
                if item.lowerbelly != 0 {
                    dta.append(item.lowerbelly)
                }
                break;
            default:
                if item.weight != 0 {
                    dta.append(item.weight)
                }
            }
        }
        
        return dta
    }
    
    private func formattedDate(timestamp: Date) -> String{
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_CH")
        formatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy")
        
        return formatter.string(from: timestamp)
    }
    
    private func getWeeknum(timestamp: Date) -> Int{
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: timestamp) - 1
        return weekOfYear
    }
    
    private func deleteWeightItem(indexSet: IndexSet) {
        for index in indexSet {
            let itemToDelete = weightItems[index]
            context.delete(itemToDelete)
        }
        
        DispatchQueue.main.async {
            do {
                try context.save()
                
            } catch {
                print(error)
            }
        }
    }
}

struct WeightView_Previews: PreviewProvider {
    static var previews: some View {
        WeightView()
    }
}

struct BlankView : View {
    
    var bgColor: Color
    
    var body: some View {
        VStack {
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(bgColor)
        .edgesIgnoringSafeArea(.all)
    }
}

struct NoDataView: View {
    var body: some View {
        Image("welcome")
            .resizable()
            .scaledToFit()
    }
}


extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

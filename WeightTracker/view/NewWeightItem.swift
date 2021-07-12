//
//  NewWeightItem.swift
//  WeightTracker
//
//  Created by Florian Thiévent on 12.07.21.
//

import SwiftUI

struct NewWeightItem: View {
    
    @Environment(\.managedObjectContext) var context
    
    @Binding var isShow: Bool
    
    @State var weight: String
    @State var chest: String
    @State var upperbelly: String
    @State var lowerbelly: String
    @State var timestamp = Date()
    
    @State var isEditing = false
    
    var body: some View {
        
        VStack {
            Spacer()
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Messung hinzufügen")
                        .font(.system(.title, design: .rounded))
                        .bold()
                    
                    Spacer()
                    
                    Button(action: {
                        self.isShow = false
                        
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .font(.headline)
                    }
                }
                
                DatePicker("Datum", selection: $timestamp, displayedComponents: [.date])
                
                TextField("Gewicht eingeben", text: $weight, onEditingChanged: { (editingChanged) in  self.isEditing = editingChanged })
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.bottom)
                    .keyboardType(.decimalPad)
                
                TextField("Brustumfang eingeben", text: $chest, onEditingChanged: { (editingChanged) in  self.isEditing = editingChanged })
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.bottom)
                    .keyboardType(.decimalPad)
                
                TextField("Bauchumfang eingeben", text: $upperbelly, onEditingChanged: { (editingChanged) in  self.isEditing = editingChanged })
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.bottom)
                    .keyboardType(.decimalPad)
                
                TextField("Taillenumfang eingeben", text: $lowerbelly, onEditingChanged: { (editingChanged) in  self.isEditing = editingChanged })
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.bottom)
                    .keyboardType(.decimalPad)
                
                
                
                // Save button for adding the todo item
                Button(action: {
                    
                    if self.weight.trimmingCharacters(in: .whitespaces) == "" {
                        return
                    }
                    
                    self.isShow = false
                    self.addMeasurements(weight: self.weight, chest: self.chest, lowerbelly: self.lowerbelly, upperbelly: self.upperbelly)
                    
                }) {
                    Text("Save")
                        .font(.system(.headline, design: .rounded))
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.bottom)
                
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10, antialiased: true)
            .offset(y: isEditing ? -320 : 0)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private func addMeasurements(weight: String, chest: String, lowerbelly: String, upperbelly: String){
        
        
        let weightItem = WeightItem(context: context)
        weightItem.id = UUID()
        weightItem.timestamp = timestamp
        weightItem.weight = Double(weight) ?? 0.0
        weightItem.chest = Double(chest) ?? 0.0
        weightItem.lowerbelly = Double(lowerbelly) ?? 0.0
        weightItem.upperbelly = Double(upperbelly) ?? 0.0
        
        do {
            try context.save()
        } catch {
            print(error)
        }
        
        
    }
    
    
}


struct NewWeightItem_Previews: PreviewProvider {
    static var previews: some View {
        NewWeightItem(isShow: .constant(true), weight: "", chest: "", upperbelly: "", lowerbelly: "")
    }
}

//
//  WeightItem.swift
//  WeightTracker
//
//  Created by Florian Thiévent on 12.07.21.
//

import Foundation
import CoreData



public class WeightItem: NSManagedObject, Identifiable{
    @NSManaged public var id: UUID
    @NSManaged public var weight: Double
    @NSManaged public var chest: Double
    @NSManaged public var upperbelly: Double
    @NSManaged public var lowerbelly: Double
    @NSManaged public var timestamp: Date
    
}


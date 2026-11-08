//
//  Equipment+PreviewMocks.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 31.10.25.
//

#if DEBUG
extension Equipment {
    @MainActor
    struct Mock {
        static let leverMachine = Equipment(name: "Lever Machine", brand: "Generic", type: EquipmentType.machine.rawValue, notes: "")
        static let kettle = Equipment(name: "Electric Kettle", brand: "Generic", type: EquipmentType.kettle.rawValue, notes: "")
        static let picopresso = Equipment(name: "Picopresso", brand: "Wacaco", type: EquipmentType.machine.rawValue, notes: "")
        static let c40 = Equipment(name: "C40", brand: "Comandante", type: EquipmentType.grinder.rawValue, notes: "")
        
        static let all: [Equipment] = [leverMachine, kettle]
    }
    
}
#endif

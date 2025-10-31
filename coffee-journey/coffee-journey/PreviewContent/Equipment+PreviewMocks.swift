//
//  Equipment+PreviewMocks.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 31.10.25.
//

#if DEBUG
extension Equipment {
    struct Mock {
        static let leverMachine = Equipment(name: "Lever Machine", brand: "Generic", type: EquipmentType.machine.rawValue, notes: "")
        static let kettle = Equipment(name: "Electric Kettle", brand: "Generic", type: EquipmentType.kettle.rawValue, notes: "")

    }
}
#endif

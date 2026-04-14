//
//  UpdateMaintenanceTemplateRequest.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 13.04.26.
//

import Foundation


struct MaintenanceStepData {
    let title: String
    let notes: String
    let sortOrder: Int
}

struct UpdateMaintenanceTemplateRequest {
    let steps: [MaintenanceStepData]
}

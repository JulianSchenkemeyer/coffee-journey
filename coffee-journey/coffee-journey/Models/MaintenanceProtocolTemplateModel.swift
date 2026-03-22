//
//  MaintenanceProtocolTemplateModel.swift
//  coffee-journey
//
//  Created by Julian Schenkemeyer on 22.03.26.
//
import Foundation
import SwiftData


@Model final class MaintenanceTemplate {
    var title: String
    var equipment: Equipment?
    
    @Relationship(deleteRule: .cascade, inverse: \MaintenanceTemplateStep.template) var steps: [MaintenanceTemplateStep]
    @Relationship(deleteRule: .nullify, inverse: \MaintenanceInstance.template)var instances: [MaintenanceInstance]
    
    init(title: String, equipment: Equipment? = nil, steps: [MaintenanceTemplateStep]) {
        self.title = title
        self.equipment = equipment
        self.steps = steps
        self.instances = []
    }
}


@Model final class MaintenanceTemplateStep {
    var title: String
    var notes: String
    var sortOrder: Int
    var isCompleted: Bool
    
    var template: MaintenanceTemplate?
    
    init(title: String, notes: String, sortOrder: Int = 0, isCompleted: Bool = false) {
        self.title = title
        self.notes = notes
        self.sortOrder = sortOrder
        self.isCompleted = isCompleted
    }
}

@Model final class MaintenanceInstance {
    var template: MaintenanceTemplate
    var completedAt: Date
    
    var completedSteps: [String]
    var uncompletedSteps: [String]
    
    
    init(template: MaintenanceTemplate, completedAt: Date, completedSteps: [String], uncompletedSteps: [String]) {
        self.template = template
        self.completedAt = completedAt
        self.completedSteps = completedSteps
        self.uncompletedSteps = uncompletedSteps
    }
    
    init(template: MaintenanceTemplate, completedAt: Date) {
        self.template = template
        self.completedAt = completedAt
        self.completedSteps = []
        self.uncompletedSteps = []
    }
}

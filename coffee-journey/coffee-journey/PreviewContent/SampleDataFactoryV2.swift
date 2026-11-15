//
//  SampleDataFactoryV2.swift
//  coffee-journey
//
//  Generated from default.store (2026-11-15 export) — SchemaV6-native sample data.
//

import Foundation
import SwiftData

#if DEBUG

/// Sample data factory built from the real rows in `default.store`.
/// Dates are reproduced exactly via the Core Data reference epoch so previews
/// and tests are reproducible.
enum SampleDataFactoryV2 {

    // MARK: - Date helper

    /// Core Data reference epoch = 2001-01-01 00:00:00 UTC.
    private static func d(_ ref: Double) -> Date {
        Date(timeIntervalSinceReferenceDate: ref)
    }

    // MARK: - Equipment

    struct EquipmentBundle {
        let picopresso: Equipment  // ZEQUIPMENT pk 1
        let robot: Equipment  // ZEQUIPMENT pk 2
        let c40: Equipment  // ZEQUIPMENT pk 3
        let c40Red: Equipment  // ZEQUIPMENT pk 4
        let lagom: Equipment  // ZEQUIPMENT pk 5

        var all: [Equipment] { [picopresso, robot, c40, c40Red, lagom] }
    }

    static func createEquipment() -> EquipmentBundle {
        let picopresso = Equipment(
            name: "Picopresso", brand: "Wacaco", type: "Espresso Maschine", notes: ""
        )
        picopresso.maintenanceCounter = 0
        picopresso.totalUses = 32
        picopresso.usesSinceLastMaintenance = 32

        let robot = Equipment(
            name: "Robot", brand: "Cafelat", type: "Espresso Maschine", notes: ""
        )
        robot.maintenanceCounter = 2
        robot.totalUses = 256
        robot.usesSinceLastMaintenance = 89
        robot.lastMaintenance = d(811799575.076384)

        let c40 = Equipment(
            name: "C40", brand: "Comandante", type: "grinder", notes: ""
        )
        c40.maintenanceCounter = 0
        c40.totalUses = 32
        c40.usesSinceLastMaintenance = 32

        let c40Red = Equipment(
            name: "C40 + Red Cilx", brand: "Comandante", type: "grinder", notes: ""
        )
        c40Red.maintenanceCounter = 3
        c40Red.totalUses = 178
        c40Red.usesSinceLastMaintenance = 15
        c40Red.lastMaintenance = d(811665220.3087)

        let lagom = Equipment(
            name: "LAGOM Casa", brand: "Option-O", type: "grinder", notes: "",
            grinderOptions: GrinderOptions(isStepless: true, startingPoint: 9.0)
        )
        lagom.maintenanceCounter = 0
        lagom.totalUses = 78
        lagom.usesSinceLastMaintenance = 78

        return EquipmentBundle(
            picopresso: picopresso,
            robot: robot,
            c40: c40,
            c40Red: c40Red,
            lagom: lagom
        )
    }

    // MARK: - Maintenance

    struct MaintenanceBundle {
        let templates: [MaintenanceTemplate]
        let instances: [MaintenanceInstance]
    }

    /// Builds the maintenance templates (with steps) and their completed instances.
    static func createMaintenance(equipment: EquipmentBundle) -> MaintenanceBundle {
        let c40RedTemplate = MaintenanceTemplate(
            title: "C40 + Red Cilx",
            equipment: equipment.c40Red,
            steps: [
                MaintenanceTemplateStep(title: "Take apart", notes: "", sortOrder: 0),
                MaintenanceTemplateStep(title: "Clean Shaft and Parts with Brush", notes: "", sortOrder: 1),
                MaintenanceTemplateStep(title: "Clean Burrs", notes: "", sortOrder: 2),
                MaintenanceTemplateStep(title: "Clean Catch Cup", notes: "", sortOrder: 3)
            ]
        )
        let robotTemplate = MaintenanceTemplate(
            title: "Robot",
            equipment: equipment.robot,
            steps: [
                MaintenanceTemplateStep(title: "Clean Outside", notes: "", sortOrder: 0),
                MaintenanceTemplateStep(title: "Replace O Ring", notes: "", sortOrder: 1)
            ]
        )
        let picopressoTemplate = MaintenanceTemplate(
            title: "Picopresso",
            equipment: equipment.picopresso,
            steps: []
        )

        let instances = [
            MaintenanceInstance(
                template: c40RedTemplate, completedAt: d(809789969.436952),
                completedSteps: ["Clean Catch Cup", "Clean Shaft and Parts with Brush", "Take apart", "Clean Burrs"],
                uncompletedSteps: []
            ),
            MaintenanceInstance(
                template: robotTemplate, completedAt: d(809790035.817853),
                completedSteps: ["Clean Outside"],
                uncompletedSteps: ["Replace O Ring"]
            ),
            MaintenanceInstance(
                template: c40RedTemplate, completedAt: d(810803182.494894),
                completedSteps: ["Clean Burrs", "Take apart", "Clean Shaft and Parts with Brush", "Clean Catch Cup"],
                uncompletedSteps: []
            ),
            MaintenanceInstance(
                template: c40RedTemplate, completedAt: d(811665220.304353),
                completedSteps: ["Clean Burrs", "Take apart", "Clean Shaft and Parts with Brush", "Clean Catch Cup"],
                uncompletedSteps: []
            ),
            MaintenanceInstance(
                template: robotTemplate, completedAt: d(811799575.07165),
                completedSteps: ["Clean Outside"],
                uncompletedSteps: ["Replace O Ring"]
            )
        ]

        return MaintenanceBundle(
            templates: [c40RedTemplate, robotTemplate, picopressoTemplate],
            instances: instances
        )
    }

    // MARK: - Coffees

    struct CoffeeBundle {
        let starlight: Coffee  // ZCOFFEE pk 1
        let viennaCalling: Coffee  // ZCOFFEE pk 2
        let apas: Coffee  // ZCOFFEE pk 3
        let henrique: Coffee  // ZCOFFEE pk 4
        let bergsonne: Coffee  // ZCOFFEE pk 5
        let wildsau: Coffee  // ZCOFFEE pk 6
        let dreispitz: Coffee  // ZCOFFEE pk 7
        let toca: Coffee  // ZCOFFEE pk 8
        let muddyWater: Coffee  // ZCOFFEE pk 9
        let zima: Coffee  // ZCOFFEE pk 10
        let fortuna: Coffee  // ZCOFFEE pk 11
        let outOfTheDark: Coffee  // ZCOFFEE pk 12
        let hausEspresso: Coffee  // ZCOFFEE pk 14
        let compadre: Coffee  // ZCOFFEE pk 15
        let apasDecaf: Coffee  // ZCOFFEE pk 16

        var all: [Coffee] {
            [starlight, viennaCalling, apas, henrique, bergsonne, wildsau, dreispitz, toca, muddyWater, zima, fortuna, outOfTheDark, hausEspresso, compadre, apasDecaf]
        }
    }

    /// Builds the coffees with their full refill history. The designated init
    /// creates the first refill dated `.now`, so its date is overwritten and the
    /// later refills are appended.
    static func createCoffees() -> CoffeeBundle {
        let starlight = Coffee(
            name: "Starlight",
            roaster: "Public Coffee Roasters",
            roastCategory: "medium",
            amount: 250.0,
            amountLeft: 0.0,
            lastRefill: d(793780124.229324),
            brews: [],
            recipes: [],
            totalBrews: 11,
            brewsSinceRefill: 0,
            roastDate: d(791965560),
            rating: 3.5,
            notes: "Cremig mit Noten von Milchschokolade und Haselnuss"
        )
        starlight.refills.first?.date = d(793780124.229621)

        let viennaCalling = Coffee(
            name: "Vienna Calling",
            roaster: "Wildkaffee",
            roastCategory: "dark",
            amount: 350.0,
            amountLeft: 0.0,
            lastRefill: d(796906047.864156),
            brews: [],
            recipes: [],
            totalBrews: 36,
            brewsSinceRefill: 0,
            roastDate: d(796218300),
            rating: 4.0,
            notes: "Schokoladig, Süß, Beerig"
        )
        viennaCalling.refills.first?.date = d(796906047.864223)
        viennaCalling.refills.append(Refill(amount: 350.0, roastDate: d(808138440), date: d(808656875.740606)))

        let apas = Coffee(
            name: "Apas",
            roaster: "Kaffeemacher",
            roastCategory: "medium",
            amount: 250.0,
            amountLeft: 75.8,
            lastRefill: d(793984551.894297),
            brews: [],
            recipes: [],
            totalBrews: 49,
            brewsSinceRefill: 9,
            roastDate: d(791306100),
            rating: 4.0,
            notes: ""
        )
        apas.refills.first?.date = d(793984551.894307)
        apas.refills.append(Refill(amount: 250.0, roastDate: d(797325360), date: d(799226217.51686)))
        apas.refills.append(Refill(amount: 250.0, roastDate: d(810576060), date: d(812131319.07482)))
        apas.refills.append(Refill(amount: 250.0, roastDate: d(814169640), date: d(815987706.601576)))

        let henrique = Coffee(
            name: "Henrique",
            roaster: "Kaffeemacher",
            roastCategory: "medium",
            amount: 250.0,
            amountLeft: 0.0,
            lastRefill: d(794573055.830532),
            brews: [],
            recipes: [],
            totalBrews: 38,
            brewsSinceRefill: 0,
            roastDate: d(792326520),
            rating: 4.5,
            notes: "Schokoladig, nussig, dicht und balanciert"
        )
        henrique.refills.first?.date = d(794573055.830567)
        henrique.refills.append(Refill(amount: 250.0, roastDate: d(798362220), date: d(799226240.312055)))
        henrique.refills.append(Refill(amount: 250.0, roastDate: d(805636740), date: d(806846360.560106)))

        let bergsonne = Coffee(
            name: "Bergsonne",
            roaster: "Wildkaffee",
            roastCategory: "dark",
            amount: 350.0,
            amountLeft: 0.0,
            lastRefill: d(795169853.545399),
            brews: [],
            recipes: [],
            totalBrews: 17,
            brewsSinceRefill: 0,
            roastDate: d(793096140),
            rating: 4.0,
            notes: """
            Vollmundig, Schokolade, Krokant

            Tastes better with shorter extractions
            """
        )
        bergsonne.refills.first?.date = d(795169853.545438)

        let wildsau = Coffee(
            name: "Wildsau",
            roaster: "Wildkaffee",
            roastCategory: "medium",
            amount: 350.0,
            amountLeft: 0.0,
            lastRefill: d(797929517.374242),
            brews: [],
            recipes: [],
            totalBrews: 18,
            brewsSinceRefill: 0,
            roastDate: d(796032180),
            rating: 3.0,
            notes: "Vollmundig, Kakao, floral"
        )
        wildsau.refills.first?.date = d(797929517.374252)

        let dreispitz = Coffee(
            name: "Dreispitz",
            roaster: "Kaffeemacher",
            roastCategory: "medium",
            amount: 250.0,
            amountLeft: 0.0,
            lastRefill: d(801308959.051397),
            brews: [],
            recipes: [],
            totalBrews: 49,
            brewsSinceRefill: 0,
            roastDate: d(799494420),
            rating: 4.0,
            notes: """
            Zartbitterschokolade, Haselnuss, cremig und zitrisch

            Milchschokolade, Kastanie, samtig
            """
        )
        dreispitz.refills.first?.date = d(801308959.051441)
        dreispitz.refills.append(Refill(amount: 250.0, roastDate: d(805713900), date: d(807701205.388847)))
        dreispitz.refills.append(Refill(amount: 500.0, roastDate: d(810662520), date: d(812131355.234812)))

        let toca = Coffee(
            name: "Toca",
            roaster: "Kaffeemacher",
            roastCategory: "medium",
            amount: 250.0,
            amountLeft: 0.0,
            lastRefill: d(801309088.267258),
            brews: [],
            recipes: [],
            totalBrews: 12,
            brewsSinceRefill: 0,
            roastDate: d(799667400),
            rating: 3.0,
            notes: "Dunkle Schokolade, Kandiszucker, zitrisch"
        )
        toca.refills.first?.date = d(801309088.267293)

        let muddyWater = Coffee(
            name: "Muddy Water",
            roaster: "Stockholm Coffee Roasters",
            roastCategory: "medium",
            amount: 250.0,
            amountLeft: 0.0,
            lastRefill: d(802980897.022326),
            brews: [],
            recipes: [],
            totalBrews: 8,
            brewsSinceRefill: 0,
            roastDate: d(797278380),
            rating: 3.0,
            notes: "Nutty, Nougat, Chocolate, Caramel"
        )
        muddyWater.refills.first?.date = d(802980897.022384)

        let zima = Coffee(
            name: "Zima",
            roaster: "Playground Coffee",
            roastCategory: "light",
            amount: 250.0,
            amountLeft: 0.0,
            lastRefill: d(803118423.71917),
            brews: [],
            recipes: [],
            totalBrews: 12,
            brewsSinceRefill: 0,
            roastDate: d(802254300),
            rating: 4.0,
            notes: "Chocolate, Red Berries"
        )
        zima.refills.first?.date = d(803118423.719235)

        let fortuna = Coffee(
            name: "Fortuna",
            roaster: "Black Hat Coffee",
            roastCategory: "medium",
            amount: 250.0,
            amountLeft: 0.0,
            lastRefill: d(804488344.50501),
            brews: [],
            recipes: [],
            totalBrews: 27,
            brewsSinceRefill: 15,
            roastDate: d(803883360),
            rating: 4.0,
            notes: "Chocolate, Honey, Cherry"
        )
        fortuna.refills.first?.date = d(804488344.505021)
        fortuna.refills.append(Refill(amount: 250.0, roastDate: d(803887260), date: d(805269730.809771)))

        let outOfTheDark = Coffee(
            name: "Out of the Dark",
            roaster: "Wildkaffee",
            roastCategory: "dark",
            amount: 350.0,
            amountLeft: 0.0,
            lastRefill: d(808656970.336206),
            brews: [],
            recipes: [],
            totalBrews: 36,
            brewsSinceRefill: 0,
            roastDate: d(808138440),
            rating: 4.0,
            notes: "Dunkle Schokolade, cremig, nussig"
        )
        outOfTheDark.refills.first?.date = d(808656970.336242)
        outOfTheDark.refills.append(Refill(amount: 350.0, roastDate: d(810114660), date: d(810719502.288369)))

        let hausEspresso = Coffee(
            name: "Haus Espresso",
            roaster: "Wildkaffee",
            roastCategory: "dark",
            amount: 350.0,
            amountLeft: 0.0,
            lastRefill: d(810554510.907829),
            brews: [],
            recipes: [],
            totalBrews: 18,
            brewsSinceRefill: 0,
            roastDate: d(809604060),
            rating: 3.5,
            notes: "Würzig, Schokolade, Karamell"
        )
        hausEspresso.refills.first?.date = d(810554510.907863)

        let compadre = Coffee(
            name: "Compadre",
            roaster: "Kaffeemacher",
            roastCategory: "dark",
            amount: 250.0,
            amountLeft: 0.0,
            lastRefill: d(812131430.497581),
            brews: [],
            recipes: [],
            totalBrews: 25,
            brewsSinceRefill: 0,
            roastDate: d(811267320),
            rating: 3.0,
            notes: "Geröstete Nüsse, würzig, dunkle Schokolade"
        )
        compadre.refills.first?.date = d(812131430.497618)
        compadre.refills.append(Refill(amount: 250.0, roastDate: d(814186860), date: d(815227298.220062)))

        let apasDecaf = Coffee(
            name: "Apas Decaf",
            roaster: "Kaffeemacher",
            roastCategory: "medium",
            amount: 250.0,
            amountLeft: 191.9,
            lastRefill: d(815227395.410178),
            brews: [],
            recipes: [],
            totalBrews: 3,
            brewsSinceRefill: 3,
            roastDate: d(814186860),
            rating: 3.0,
            notes: "Nougat, geröstete Nüsse, Schokoladig"
        )
        apasDecaf.refills.first?.date = d(815227395.41023)

        return CoffeeBundle(
            starlight: starlight,
            viennaCalling: viennaCalling,
            apas: apas,
            henrique: henrique,
            bergsonne: bergsonne,
            wildsau: wildsau,
            dreispitz: dreispitz,
            toca: toca,
            muddyWater: muddyWater,
            zima: zima,
            fortuna: fortuna,
            outOfTheDark: outOfTheDark,
            hausEspresso: hausEspresso,
            compadre: compadre,
            apasDecaf: apasDecaf
        )
    }

    // MARK: - Recipes

    struct RecipeBundle {
        let starlightRobotC40Red: Recipe  // ZRECIPE pk 6
        let viennaCallingRobotC40Red: Recipe  // ZRECIPE pk 4
        let viennaCallingPicopressoC40: Recipe  // ZRECIPE pk 7
        let apasPicopressoC40: Recipe  // ZRECIPE pk 8
        let apasRobotC40Red: Recipe  // ZRECIPE pk 10
        let apasRobotLagom: Recipe  // ZRECIPE pk 24
        let henriquePicopressoC40: Recipe  // ZRECIPE pk 2
        let henriqueRobotC40Red: Recipe  // ZRECIPE pk 3
        let bergsonneRobotC40Red: Recipe  // ZRECIPE pk 5
        let wildsauRobotC40Red: Recipe  // ZRECIPE pk 9
        let dreispitzPicopressoC40: Recipe  // ZRECIPE pk 11
        let dreispitzRobotC40Red: Recipe  // ZRECIPE pk 13
        let dreispitzRobotLagom: Recipe  // ZRECIPE pk 25
        let tocaRobotC40Red: Recipe  // ZRECIPE pk 12
        let muddyWaterRobotC40Red: Recipe  // ZRECIPE pk 14
        let zimaRobotC40Red: Recipe  // ZRECIPE pk 15
        let zimaPicopressoC40: Recipe  // ZRECIPE pk 16
        let fortunaRobotC40Red: Recipe  // ZRECIPE pk 17
        let fortunaPicopressoC40: Recipe  // ZRECIPE pk 18
        let outOfTheDarkRobotC40Red: Recipe  // ZRECIPE pk 19
        let outOfTheDarkRobotLagom: Recipe  // ZRECIPE pk 23
        let hausEspressoRobotC40Red: Recipe  // ZRECIPE pk 21
        let compadreRobotLagom: Recipe  // ZRECIPE pk 22
        let apasDecafRobotLagom: Recipe  // ZRECIPE pk 26

        var all: [Recipe] {
            [
                starlightRobotC40Red,
                viennaCallingRobotC40Red,
                viennaCallingPicopressoC40,
                apasPicopressoC40,
                apasRobotC40Red,
                apasRobotLagom,
                henriquePicopressoC40,
                henriqueRobotC40Red,
                bergsonneRobotC40Red,
                wildsauRobotC40Red,
                dreispitzPicopressoC40,
                dreispitzRobotC40Red,
                dreispitzRobotLagom,
                tocaRobotC40Red,
                muddyWaterRobotC40Red,
                zimaRobotC40Red,
                zimaPicopressoC40,
                fortunaRobotC40Red,
                fortunaPicopressoC40,
                outOfTheDarkRobotC40Red,
                outOfTheDarkRobotLagom,
                hausEspressoRobotC40Red,
                compadreRobotLagom,
                apasDecafRobotLagom
            ]
        }
    }

    static func createRecipes(coffees: CoffeeBundle, equipment: EquipmentBundle) -> RecipeBundle {
        func make(
            coffee: Coffee,
            brewer: Equipment,
            grinder: Equipment,
            minT: Int, maxT: Int,
            minG: Double, maxG: Double,
            minExt: Int, maxExt: Int,
            minB: Double, maxB: Double,
            minO: Double, maxO: Double,
            lastUsed: Double
        ) -> Recipe {
            let r = Recipe(
                minTemperature: minT, maxTemperature: maxT,
                minGrindSetting: minG, maxGrindSetting: maxG,
                minExtractionTime: minExt, maxExtractionTime: maxExt,
                minBeans: minB, maxBeans: maxB,
                minOutput: minO, maxOutput: maxO,
                brewer: brewer,
                grinder: grinder
            )
            r.coffee = coffee
            r.lastUsed = d(lastUsed)
            return r
        }

        return RecipeBundle(
            starlightRobotC40Red: make(
                coffee: coffees.starlight,
                brewer: equipment.robot, grinder: equipment.c40Red,
                minT: 95, maxT: 95, minG: 13.0, maxG: 13.0,
                minExt: 26, maxExt: 36, minB: 19.6, maxB: 20.6,
                minO: 37.9, maxO: 39.0, lastUsed: 796488955.473844
            ),
            viennaCallingRobotC40Red: make(
                coffee: coffees.viennaCalling,
                brewer: equipment.robot, grinder: equipment.c40Red,
                minT: 92, maxT: 92, minG: 12.0, maxG: 13.0,
                minExt: 26, maxExt: 36, minB: 18.8, maxB: 19.7,
                minO: 36.8, maxO: 39.3, lastUsed: 809705559.845257
            ),
            viennaCallingPicopressoC40: make(
                coffee: coffees.viennaCalling,
                brewer: equipment.picopresso, grinder: equipment.c40,
                minT: 94, maxT: 94, minG: 8.0, maxG: 8.0,
                minExt: 41, maxExt: 45, minB: 18.0, maxB: 18.3,
                minO: 37.2, maxO: 39.3, lastUsed: 797176311.493362
            ),
            apasPicopressoC40: make(
                coffee: coffees.apas,
                brewer: equipment.picopresso, grinder: equipment.c40,
                minT: 96, maxT: 96, minG: 8.0, maxG: 10.0,
                minExt: 30, maxExt: 43, minB: 18.0, maxB: 18.8,
                minO: 36.0, maxO: 40.2, lastUsed: 800721887.378707
            ),
            apasRobotC40Red: make(
                coffee: coffees.apas,
                brewer: equipment.robot, grinder: equipment.c40Red,
                minT: 94, maxT: 95, minG: 12.0, maxG: 13.0,
                minExt: 27, maxExt: 31, minB: 18.4, maxB: 18.6,
                minO: 36.0, maxO: 40.3, lastUsed: 812373921.166465
            ),
            apasRobotLagom: make(
                coffee: coffees.apas,
                brewer: equipment.robot, grinder: equipment.lagom,
                minT: 95, maxT: 95, minG: 9.0, maxG: 9.8,
                minExt: 29, maxExt: 36, minB: 18.4, maxB: 19.5,
                minO: 37.1, maxO: 40.2, lastUsed: 816436199.907011
            ),
            henriquePicopressoC40: make(
                coffee: coffees.henrique,
                brewer: equipment.picopresso, grinder: equipment.c40,
                minT: 96, maxT: 96, minG: 9.0, maxG: 12.0,
                minExt: 30, maxExt: 38, minB: 18.0, maxB: 18.7,
                minO: 36.0, maxO: 38.9, lastUsed: 794673684.718758
            ),
            henriqueRobotC40Red: make(
                coffee: coffees.henrique,
                brewer: equipment.robot, grinder: equipment.c40Red,
                minT: 94, maxT: 95, minG: 13.0, maxG: 14.0,
                minExt: 27, maxExt: 37, minB: 18.7, maxB: 19.5,
                minO: 36.1, maxO: 38.8, lastUsed: 807621128.262781
            ),
            bergsonneRobotC40Red: make(
                coffee: coffees.bergsonne,
                brewer: equipment.robot, grinder: equipment.c40Red,
                minT: 92, maxT: 92, minG: 14.0, maxG: 14.0,
                minExt: 27, maxExt: 28, minB: 20.5, maxB: 20.7,
                minO: 38.3, maxO: 39.7, lastUsed: 796288912.216993
            ),
            wildsauRobotC40Red: make(
                coffee: coffees.wildsau,
                brewer: equipment.robot, grinder: equipment.c40Red,
                minT: 95, maxT: 95, minG: 12.0, maxG: 13.0,
                minExt: 27, maxExt: 35, minB: 18.1, maxB: 19.7,
                minO: 35.9, maxO: 39.1, lastUsed: 799589299.999943
            ),
            dreispitzPicopressoC40: make(
                coffee: coffees.dreispitz,
                brewer: equipment.picopresso, grinder: equipment.c40,
                minT: 95, maxT: 96, minG: 7.0, maxG: 8.0,
                minExt: 34, maxExt: 44, minB: 18.1, maxB: 18.8,
                minO: 36.2, maxO: 41.5, lastUsed: 802538631.112383
            ),
            dreispitzRobotC40Red: make(
                coffee: coffees.dreispitz,
                brewer: equipment.robot, grinder: equipment.c40Red,
                minT: 95, maxT: 96, minG: 10.0, maxG: 12.0,
                minExt: 27, maxExt: 43, minB: 18.5, maxB: 19.9,
                minO: 36.7, maxO: 39.6, lastUsed: 808402952.950648
            ),
            dreispitzRobotLagom: make(
                coffee: coffees.dreispitz,
                brewer: equipment.robot, grinder: equipment.lagom,
                minT: 95, maxT: 95, minG: 9.2, maxG: 9.2,
                minExt: 30, maxExt: 38, minB: 19.2, maxB: 19.5,
                minO: 38.4, maxO: 41.6, lastUsed: 814191889.10987
            ),
            tocaRobotC40Red: make(
                coffee: coffees.toca,
                brewer: equipment.robot, grinder: equipment.c40Red,
                minT: 94, maxT: 95, minG: 10.0, maxG: 11.0,
                minExt: 26, maxExt: 37, minB: 19.1, maxB: 19.7,
                minO: 37.1, maxO: 40.1, lastUsed: 802334522.937543
            ),
            muddyWaterRobotC40Red: make(
                coffee: coffees.muddyWater,
                brewer: equipment.robot, grinder: equipment.c40Red,
                minT: 96, maxT: 96, minG: 9.0, maxG: 10.0,
                minExt: 36, maxExt: 38, minB: 19.8, maxB: 19.9,
                minO: 37.7, maxO: 38.5, lastUsed: 803457861.48825
            ),
            zimaRobotC40Red: make(
                coffee: coffees.zima,
                brewer: equipment.robot, grinder: equipment.c40Red,
                minT: 98, maxT: 98, minG: 11.0, maxG: 11.0,
                minExt: 30, maxExt: 37, minB: 18.7, maxB: 19.7,
                minO: 37.6, maxO: 39.0, lastUsed: 804417779.443324
            ),
            zimaPicopressoC40: make(
                coffee: coffees.zima,
                brewer: equipment.picopresso, grinder: equipment.c40,
                minT: 98, maxT: 98, minG: 7.0, maxG: 7.0,
                minExt: 33, maxExt: 38, minB: 18.1, maxB: 18.3,
                minO: 38.3, maxO: 43.3, lastUsed: 804318793.619492
            ),
            fortunaRobotC40Red: make(
                coffee: coffees.fortuna,
                brewer: equipment.robot, grinder: equipment.c40Red,
                minT: 94, maxT: 94, minG: 8.0, maxG: 9.0,
                minExt: 30, maxExt: 41, minB: 18.4, maxB: 19.3,
                minO: 36.5, maxO: 41.3, lastUsed: 806681568.159859
            ),
            fortunaPicopressoC40: make(
                coffee: coffees.fortuna,
                brewer: equipment.picopresso, grinder: equipment.c40,
                minT: 94, maxT: 96, minG: 7.0, maxG: 7.0,
                minExt: 30, maxExt: 45, minB: 18.0, maxB: 19.5,
                minO: 36.0, maxO: 40.3, lastUsed: 805563250.79298
            ),
            outOfTheDarkRobotC40Red: make(
                coffee: coffees.outOfTheDark,
                brewer: equipment.robot, grinder: equipment.c40Red,
                minT: 92, maxT: 92, minG: 12.0, maxG: 14.0,
                minExt: 26, maxExt: 37, minB: 18.5, maxB: 19.7,
                minO: 35.9, maxO: 40.2, lastUsed: 812279588.484435
            ),
            outOfTheDarkRobotLagom: make(
                coffee: coffees.outOfTheDark,
                brewer: equipment.robot, grinder: equipment.lagom,
                minT: 92, maxT: 92, minG: 9.0, maxG: 10.0,
                minExt: 30, maxExt: 38, minB: 19.2, maxB: 19.5,
                minO: 36.0, maxO: 38.7, lastUsed: 812292190.434126
            ),
            hausEspressoRobotC40Red: make(
                coffee: coffees.hausEspresso,
                brewer: equipment.robot, grinder: equipment.c40Red,
                minT: 92, maxT: 92, minG: 13.0, maxG: 13.0,
                minExt: 30, maxExt: 34, minB: 19.1, maxB: 19.6,
                minO: 37.6, maxO: 38.7, lastUsed: 811610535.309032
            ),
            compadreRobotLagom: make(
                coffee: coffees.compadre,
                brewer: equipment.robot, grinder: equipment.lagom,
                minT: 92, maxT: 92, minG: 9.2, maxG: 9.7,
                minExt: 29, maxExt: 36, minB: 18.5, maxB: 19.6,
                minO: 36.0, maxO: 40.7, lastUsed: 815920534.328602
            ),
            apasDecafRobotLagom: make(
                coffee: coffees.apasDecaf,
                brewer: equipment.robot, grinder: equipment.lagom,
                minT: 95, maxT: 96, minG: 9.4, maxG: 9.7,
                minExt: 25, maxExt: 30, minB: 18.0, maxB: 19.4,
                minO: 36.0, maxO: 39.1, lastUsed: 815843447.082032
            )
        )
    }

    // MARK: - Brews

    /// Builds all 358 brews from ZBREW in date order, wired to their coffee and recipe.
    static func createBrews(coffees: CoffeeBundle, recipes: RecipeBundle) -> [Brew] {
        func mk(
            _ date: Double, _ coffee: Coffee, _ recipe: Recipe?, _ beanAge: Int?,
            _ amountCoffee: Double, _ grind: Double, _ temp: Int,
            _ extTime: Int, _ taste: Int, _ clarity: Int?, _ output: Double, _ rating: BrewRating
        ) -> Brew {
            let b = Brew(
                date: d(date),
                beanAge: beanAge,
                amountCoffee: amountCoffee,
                grindSetting: grind,
                temperature: temp,
                extractionTime: extTime,
                taste: taste,
                output: output,
                rating: rating,
                clarity: clarity
            )
            b.coffee = coffee
            b.recipe = recipe
            return b
        }

        let c = coffees
        let r = recipes

        return [
            mk(793780278.102888, c.starlight, r.starlightRobotC40Red, nil, 18.8, 11.0, 96, 41, 5, nil, 38.2, .thumbsUp),
            mk(793780311.049872, c.starlight, r.starlightRobotC40Red, nil, 19.7, 12.0, 96, 34, 2, nil, 34.1, .thumbsUp),
            mk(793780339.499468, c.starlight, r.starlightRobotC40Red, nil, 19.7, 13.0, 97, 31, 4, nil, 36.5, .thumbsUp),
            mk(793781079.547786, c.starlight, r.starlightRobotC40Red, nil, 19.4, 13.0, 96, 31, 4, nil, 36.4, .thumbsUp),
            mk(793870646.696097, c.starlight, r.starlightRobotC40Red, nil, 18.9, 13.0, 96, 28, 4, nil, 36.4, .thumbsUp),
            mk(793890885.493548, c.starlight, r.starlightRobotC40Red, nil, 19.6, 13.0, 95, 36, 3, nil, 39.0, .thumbsUp),
            mk(793985769.949498, c.apas, r.apasPicopressoC40, nil, 18.2, 9.0, 96, 38, 3, nil, 39.0, .thumbsUp),
            mk(794072148.524402, c.apas, r.apasPicopressoC40, nil, 18.3, 9.0, 96, 36, 3, nil, 37.5, .thumbsUp),
            mk(794151805.810234, c.apas, r.apasPicopressoC40, nil, 18.0, 9.0, 96, 43, 3, nil, 38.9, .thumbsUp),
            mk(794161469.754336, c.apas, r.apasPicopressoC40, nil, 18.5, 9.0, 96, 36, 4, nil, 39.7, .thumbsUp),
            mk(794230392.710901, c.apas, nil, nil, 18.4, 9.0, 96, 39, 3, nil, 36.4, .thumbsUp),
            mk(794318027.798836, c.apas, r.apasPicopressoC40, nil, 18.8, 9.0, 96, 36, 3, nil, 37.2, .thumbsUp),
            mk(794327452.534548, c.apas, r.apasPicopressoC40, nil, 18.7, 9.0, 96, 40, 3, nil, 38.6, .thumbsUp),
            mk(794328465.74897, c.apas, nil, nil, 18.5, 9.0, 96, 40, 4, nil, 38.6, .thumbsUp),
            mk(794400869.696601, c.apas, nil, nil, 18.8, 9.0, 96, 41, 3, nil, 38.3, .thumbsUp),
            mk(794416581.081029, c.apas, nil, nil, 18.7, 9.0, 96, 40, 3, nil, 38.7, .thumbsUp),
            mk(794478786.874329, c.apas, nil, nil, 18.4, 9.0, 94, 38, 3, nil, 37.4, .thumbsDown),
            mk(794494276.405926, c.apas, r.apasPicopressoC40, nil, 18.7, 9.0, 96, 40, 3, nil, 37.9, .thumbsUp),
            mk(794572963.828006, c.apas, r.apasPicopressoC40, nil, 18.5, 9.0, 96, 38, 3, nil, 38.1, .thumbsUp),
            mk(794652890.208834, c.henrique, r.henriquePicopressoC40, nil, 18.5, 9.0, 96, 35, 3, nil, 38.2, .thumbsUp),
            mk(794671497.929506, c.henrique, r.henriquePicopressoC40, nil, 18.0, 9.0, 96, 38, 3, nil, 37.8, .thumbsUp),
            mk(794672467.961998, c.henrique, r.henriquePicopressoC40, nil, 18.2, 9.0, 96, 38, 3, nil, 38.9, .thumbsUp),
            mk(794673684.718712, c.henrique, r.henriquePicopressoC40, nil, 18.7, 9.0, 96, 38, 3, nil, 38.5, .thumbsUp),
            mk(794674315.894158, c.apas, r.apasPicopressoC40, nil, 18.4, 9.0, 96, 36, 3, nil, 37.9, .thumbsDown),
            mk(794732865.644815, c.henrique, r.henriqueRobotC40Red, nil, 19.4, 12.0, 94, 45, 5, nil, 36.2, .thumbsDown),
            mk(794753183.636013, c.henrique, r.henriqueRobotC40Red, nil, 19.6, 13.0, 96, 36, 4, nil, 37.9, .thumbsUp),
            mk(794820052.269582, c.henrique, r.henriqueRobotC40Red, nil, 19.3, 13.0, 95, 36, 4, nil, 39.4, .thumbsUp),
            mk(794906236.419708, c.henrique, r.henriqueRobotC40Red, nil, 19.4, 14.0, 94, 31, 2, nil, 38.6, .thumbsUp),
            mk(794992452.371193, c.henrique, r.henriqueRobotC40Red, nil, 19.3, 14.0, 95, 29, 2, nil, 36.9, .thumbsUp),
            mk(795082748.228643, c.henrique, r.henriqueRobotC40Red, nil, 18.3, 13.0, 95, 35, 4, nil, 39.1, .thumbsDown),
            mk(795097582.250237, c.henrique, r.henriqueRobotC40Red, nil, 18.6, 13.0, 95, 33, 3, nil, 38.4, .thumbsUp),
            mk(795103417.120541, c.henrique, r.henriqueRobotC40Red, nil, 18.5, 13.0, 95, 34, 3, nil, 36.9, .thumbsUp),
            mk(795169745.283316, c.henrique, r.henriqueRobotC40Red, nil, 18.5, 13.0, 95, 33, 3, nil, 38.1, .thumbsUp),
            mk(795194928.720114, c.henrique, r.henriqueRobotC40Red, nil, 18.5, 13.0, 95, 31, 3, nil, 37.8, .thumbsUp),
            mk(795218565.068406, c.bergsonne, r.bergsonneRobotC40Red, nil, 19.3, 14.0, 93, 25, 3, nil, 40.3, .thumbsUp),
            mk(795252489.907753, c.bergsonne, r.bergsonneRobotC40Red, nil, 19.7, 13.0, 93, 38, 5, nil, 38.4, .thumbsUp),
            mk(795275402.80757, c.bergsonne, r.bergsonneRobotC40Red, nil, 18.7, 13.0, 92, 30, 4, nil, 39.2, .thumbsUp),
            mk(795338850.83666, c.bergsonne, r.bergsonneRobotC40Red, nil, 18.6, 13.0, 92, 30, 5, nil, 39.5, .thumbsDown),
            mk(795425634.460686, c.bergsonne, r.bergsonneRobotC40Red, nil, 18.7, 13.0, 92, 31, 4, nil, 37.4, .thumbsDown),
            mk(795511900.8641, c.bergsonne, r.bergsonneRobotC40Red, nil, 19.9, 14.0, 92, 26, 3, nil, 39.9, .thumbsUp),
            mk(795598453.580999, c.bergsonne, r.bergsonneRobotC40Red, nil, 19.7, 14.0, 92, 26, 3, nil, 39.6, .thumbsUp),
            mk(795686399.559896, c.bergsonne, r.bergsonneRobotC40Red, nil, 20.0, 14.0, 92, 29, 4, nil, 39.3, .thumbsUp),
            mk(795707903.593266, c.bergsonne, r.bergsonneRobotC40Red, nil, 20.1, 14.0, 92, 32, 3, nil, 38.4, .thumbsUp),
            mk(795777999.680872, c.bergsonne, r.bergsonneRobotC40Red, nil, 20.3, 14.0, 92, 28, 3, nil, 40.5, .thumbsUp),
            mk(795802205.79559, c.bergsonne, r.bergsonneRobotC40Red, nil, 20.7, 14.0, 92, 28, 3, nil, 39.7, .thumbsUp),
            mk(795858318.416245, c.bergsonne, r.bergsonneRobotC40Red, nil, 20.5, 14.0, 92, 32, 4, nil, 38.4, .thumbsUp),
            mk(795886031.126981, c.bergsonne, r.bergsonneRobotC40Red, nil, 20.4, 14.0, 92, 31, 4, nil, 41.0, .thumbsUp),
            mk(795944262.279894, c.bergsonne, r.bergsonneRobotC40Red, nil, 20.4, 14.0, 92, 27, 5, nil, 40.1, .thumbsDown),
            mk(796030885.669371, c.bergsonne, r.bergsonneRobotC40Red, nil, 19.6, 14.0, 92, 27, 5, nil, 39.4, .thumbsDown),
            mk(796203519.790268, c.bergsonne, r.bergsonneRobotC40Red, nil, 20.7, 14.0, 92, 28, 3, nil, 40.5, .thumbsDown),
            mk(796288912.215333, c.bergsonne, r.bergsonneRobotC40Red, nil, 20.5, 14.0, 92, 27, 3, nil, 38.3, .thumbsUp),
            mk(796381548.284444, c.starlight, r.starlightRobotC40Red, nil, 20.6, 13.0, 95, 30, 3, nil, 38.2, .thumbsUp),
            mk(796403418.207227, c.starlight, r.starlightRobotC40Red, nil, 20.4, 13.0, 95, 27, 4, nil, 38.7, .thumbsUp),
            mk(796463686.8664, c.starlight, r.starlightRobotC40Red, nil, 19.7, 13.0, 95, 26, 3, nil, 37.9, .thumbsUp),
            mk(796488955.473646, c.starlight, r.starlightRobotC40Red, nil, 20.1, 13.0, 95, 27, 3, nil, 38.5, .thumbsUp),
            mk(796804979.376845, c.starlight, r.starlightRobotC40Red, nil, 21.0, 13.0, 95, 29, 3, nil, 38.6, .thumbsDown),
            mk(796918739.936701, c.viennaCalling, r.viennaCallingPicopressoC40, nil, 18.2, 9.0, 92, 35, 3, nil, 38.1, .thumbsUp),
            mk(796993438.781292, c.viennaCalling, r.viennaCallingPicopressoC40, nil, 18.3, 9.0, 94, 38, 3, nil, 38.4, .thumbsUp),
            mk(797091266.274416, c.viennaCalling, r.viennaCallingPicopressoC40, nil, 18.0, 8.0, 94, 41, 3, nil, 38.4, .thumbsUp),
            mk(797157743.98391, c.viennaCalling, r.viennaCallingPicopressoC40, nil, 18.2, 8.0, 94, 45, 3, nil, 39.3, .thumbsUp),
            mk(797176311.493244, c.viennaCalling, r.viennaCallingPicopressoC40, nil, 18.3, 8.0, 94, 45, 3, nil, 37.2, .thumbsUp),
            mk(797239720.447684, c.viennaCalling, r.viennaCallingRobotC40Red, nil, 20.0, 14.0, 92, 24, 5, nil, 42.5, .thumbsDown),
            mk(797254675.25613, c.viennaCalling, r.viennaCallingRobotC40Red, nil, 20.2, 13.0, 92, 31, 3, nil, 39.7, .thumbsUp),
            mk(797322624.133775, c.viennaCalling, r.viennaCallingRobotC40Red, nil, 19.1, 13.0, 92, 26, 4, nil, 38.0, .thumbsUp),
            mk(797409495.407071, c.viennaCalling, r.viennaCallingRobotC40Red, nil, 19.4, 13.0, 91, 29, 3, nil, 39.4, .thumbsDown),
            mk(797591001.806092, c.viennaCalling, r.viennaCallingRobotC40Red, nil, 18.8, 12.0, 92, 33, 3, nil, 39.0, .thumbsUp),
            mk(797613912.199967, c.viennaCalling, r.viennaCallingRobotC40Red, nil, 18.9, 12.0, 92, 32, 3, nil, 39.7, .thumbsUp),
            mk(797685367.559337, c.viennaCalling, r.viennaCallingRobotC40Red, nil, 18.3, 12.0, 92, 30, 4, nil, 39.9, .thumbsUp),
            mk(797700735.408332, c.viennaCalling, r.viennaCallingRobotC40Red, nil, 18.3, 12.0, 92, 32, 3, nil, 38.7, .thumbsUp),
            mk(797758087.695209, c.viennaCalling, r.viennaCallingRobotC40Red, nil, 18.4, 12.0, 92, 32, 4, nil, 38.5, .thumbsUp),
            mk(797772838.041547, c.viennaCalling, r.viennaCallingRobotC40Red, nil, 18.4, 12.0, 92, 35, 3, nil, 43.3, .thumbsUp),
            mk(797888335.683238, c.viennaCalling, r.viennaCallingRobotC40Red, nil, 18.7, 12.0, 92, 35, 3, nil, 38.8, .thumbsUp),
            mk(797888354.395662, c.viennaCalling, r.viennaCallingRobotC40Red, nil, 18.4, 12.0, 92, 29, 3, nil, 39.8, .thumbsUp),
            mk(797929427.660467, c.viennaCalling, r.viennaCallingRobotC40Red, nil, 19.2, 12.0, 92, 28, 4, nil, 39.3, .thumbsUp),
            mk(798015099.381748, c.wildsau, r.wildsauRobotC40Red, nil, 18.8, 12.0, 95, 34, 3, nil, 37.2, .thumbsDown),
            mk(798102095.668985, c.wildsau, r.wildsauRobotC40Red, nil, 18.9, 12.0, 94, 42, 4, nil, 37.3, .thumbsDown),
            mk(798123535.747662, c.wildsau, r.wildsauRobotC40Red, nil, 19.2, 13.0, 96, 31, 3, nil, 38.1, .thumbsUp),
            mk(798192373.219607, c.wildsau, r.wildsauRobotC40Red, nil, 19.8, 13.0, 96, 30, 3, nil, 39.1, .thumbsUp),
            mk(798217378.352566, c.wildsau, r.wildsauRobotC40Red, nil, 19.2, 13.0, 95, 34, 3, nil, 38.2, .thumbsUp),
            mk(798277652.021828, c.wildsau, r.wildsauRobotC40Red, nil, 19.2, 13.0, 95, 32, 3, nil, 38.7, .thumbsUp),
            mk(798302741.157767, c.wildsau, r.wildsauRobotC40Red, nil, 19.4, 13.0, 95, 30, 3, nil, 38.4, .thumbsUp),
            mk(798362831.915413, c.wildsau, r.wildsauRobotC40Red, nil, 19.7, 13.0, 95, 35, 3, nil, 38.4, .thumbsUp),
            mk(798377635.355129, c.wildsau, r.wildsauRobotC40Red, nil, 19.6, 13.0, 95, 31, 3, nil, 39.1, .thumbsUp),
            mk(798708831.847005, c.wildsau, r.wildsauRobotC40Red, nil, 19.7, 13.0, 95, 34, 4, nil, 39.1, .thumbsDown),
            mk(798724883.70258, c.wildsau, r.wildsauRobotC40Red, nil, 19.7, 13.0, 95, 32, 3, nil, 38.0, .thumbsUp),
            mk(798804713.699236, c.wildsau, r.wildsauRobotC40Red, nil, 19.5, 12.0, 95, 34, 5, nil, 37.8, .thumbsDown),
            mk(798883405.200746, c.wildsau, r.wildsauRobotC40Red, nil, 19.6, 12.0, 95, 34, 5, nil, 37.7, .thumbsDown),
            mk(798906597.328772, c.wildsau, r.wildsauRobotC40Red, nil, 19.3, 13.0, 95, 29, 3, nil, 39.1, .thumbsDown),
            mk(799051800.300714, c.wildsau, r.wildsauRobotC40Red, nil, 19.1, 13.0, 95, 28, 5, nil, 39.3, .thumbsDown),
            mk(799135760.088949, c.wildsau, r.wildsauRobotC40Red, nil, 19.3, 13.0, 94, 28, 5, nil, 37.8, .thumbsDown),
            mk(799330470.321234, c.apas, r.apasPicopressoC40, nil, 18.0, 9.0, 96, 40, 3, nil, 40.2, .thumbsUp),
            mk(799408674.186497, c.apas, r.apasPicopressoC40, nil, 18.4, 9.0, 96, 38, 3, nil, 37.6, .thumbsUp),
            mk(799425927.321845, c.apas, r.apasPicopressoC40, nil, 18.6, 10.0, 96, 37, 3, nil, 39.6, .thumbsUp),
            mk(799494812.626594, c.apas, r.apasPicopressoC40, nil, 18.7, 9.0, 96, 38, 3, nil, 37.4, .thumbsUp),
            mk(799507887.428392, c.apas, r.apasPicopressoC40, nil, 18.7, 10.0, 96, 36, 3, nil, 36.8, .thumbsUp),
            mk(799571011.047725, c.wildsau, r.wildsauRobotC40Red, nil, 18.1, 13.0, 95, 27, 2, nil, 35.9, .thumbsUp),
            mk(799589299.999654, c.wildsau, r.wildsauRobotC40Red, nil, 18.2, 12.0, 95, 35, 3, nil, 37.9, .thumbsUp),
            mk(799657482.962409, c.henrique, r.henriqueRobotC40Red, 14, 18.9, 14.0, 95, 31, 2, nil, 38.0, .thumbsUp),
            mk(799672730.707487, c.henrique, r.henriqueRobotC40Red, 15, 18.5, 14.0, 96, 35, 4, nil, 39.2, .thumbsUp),
            mk(799745304.951192, c.henrique, r.henriqueRobotC40Red, 16, 18.6, 14.0, 96, 32, 3, nil, 37.9, .thumbsUp),
            mk(799760714.725614, c.henrique, r.henriqueRobotC40Red, 16, 18.4, 15.0, 96, 28, 3, nil, 42.5, .thumbsDown),
            mk(799830211.423836, c.henrique, r.henriqueRobotC40Red, 16, 18.4, 14.0, 95, 32, 4, nil, 37.8, .thumbsUp),
            mk(799846009.20657, c.henrique, r.henriqueRobotC40Red, 17, 19.1, 14.0, 95, 31, 3, nil, 40.3, .thumbsUp),
            mk(799921979.717282, c.henrique, r.henriqueRobotC40Red, 18, 19.3, 14.0, 95, 30, 3, nil, 38.0, .thumbsUp),
            mk(799936073.606954, c.henrique, r.henriqueRobotC40Red, 18, 19.3, 14.0, 96, 34, 3, nil, 36.8, .thumbsUp),
            mk(800097877.084422, c.apas, r.apasPicopressoC40, 32, 18.4, 9.0, 96, 39, 3, nil, 39.5, .thumbsUp),
            mk(800132439.931557, c.apas, r.apasPicopressoC40, 32, 18.4, 9.0, 96, 36, 3, nil, 38.1, .thumbsUp),
            mk(800179213.33896, c.henrique, r.henriqueRobotC40Red, 21, 19.3, 14.0, 95, 29, 3, nil, 38.8, .thumbsDown),
            mk(800196819.889717, c.henrique, r.henriqueRobotC40Red, 21, 19.3, 13.0, 95, 42, 3, nil, 39.1, .thumbsUp),
            mk(800265636.883865, c.henrique, r.henriqueRobotC40Red, 22, 19.3, 13.0, 96, 37, 5, nil, 37.4, .thumbsDown),
            mk(800350566.486243, c.henrique, r.henriqueRobotC40Red, 23, 19.2, 13.0, 95, 42, 2, nil, 38.5, .thumbsUp),
            mk(800366691.816473, c.henrique, r.henriqueRobotC40Red, 23, 19.6, 13.0, 95, 43, 4, nil, 37.8, .thumbsUp),
            mk(800540052.050433, c.apas, r.apasPicopressoC40, 37, 18.4, 9.0, 96, 40, 3, nil, 38.6, .thumbsUp),
            mk(800627866.837757, c.apas, r.apasPicopressoC40, 38, 18.4, 9.0, 96, 40, 3, nil, 39.2, .thumbsUp),
            mk(800707572.258095, c.apas, r.apasPicopressoC40, 39, 18.4, 8.0, 96, 40, 3, nil, 39.0, .thumbsUp),
            mk(800721887.374702, c.apas, r.apasPicopressoC40, 39, 18.4, 8.0, 96, 36, 3, nil, 38.2, .thumbsUp),
            mk(800865029.358375, c.apas, nil, 40, 18.5, 11.0, 95, 53, 4, nil, 35.1, .thumbsDown),
            mk(801127365.431225, c.apas, r.apasRobotC40Red, 44, 18.6, 13.0, 94, 27, 4, nil, 40.3, .thumbsUp),
            mk(801325705.423228, c.dreispitz, r.dreispitzPicopressoC40, 21, 18.0, 8.0, 96, 30, 3, nil, 36.0, .thumbsUp),
            mk(801326525.006402, c.dreispitz, r.dreispitzPicopressoC40, 21, 18.8, 8.0, 96, 40, 3, nil, 36.2, .thumbsUp),
            mk(801398877.754655, c.dreispitz, r.dreispitzPicopressoC40, 22, 18.6, 7.0, 96, 44, 3, nil, 37.3, .thumbsUp),
            mk(801413210.147184, c.dreispitz, r.dreispitzPicopressoC40, 22, 18.3, 7.0, 95, 42, 3, nil, 37.4, .thumbsUp),
            mk(801472804.60129, c.toca, r.tocaRobotC40Red, 20, 18.9, 13.0, 94, 17, 1, nil, 39.2, .thumbsDown),
            mk(801487826.161021, c.toca, r.tocaRobotC40Red, 21, 19.4, 11.0, 94, 30, 3, nil, 39.0, .thumbsUp),
            mk(801643341.626019, c.toca, r.tocaRobotC40Red, 22, 19.1, 11.0, 94, 28, 4, nil, 39.9, .thumbsDown),
            mk(801733931.463111, c.toca, r.tocaRobotC40Red, 23, 19.5, 11.0, 95, 26, 2, nil, 37.4, .thumbsUp),
            mk(801749256.130674, c.toca, r.tocaRobotC40Red, 24, 19.4, 10.0, 95, 33, 4, nil, 37.1, .thumbsUp),
            mk(801827171.486812, c.toca, r.tocaRobotC40Red, 24, 19.6, 10.0, 95, 32, 3, nil, 37.6, .thumbsUp),
            mk(801913833.965782, c.toca, r.tocaRobotC40Red, 26, 19.7, 10.0, 94, 33, 3, nil, 38.2, .thumbsUp),
            mk(801930665.36821, c.toca, r.tocaRobotC40Red, 26, 19.5, 10.0, 94, 33, 3, nil, 38.3, .thumbsUp),
            mk(801999837.628683, c.toca, r.tocaRobotC40Red, 26, 19.7, 10.0, 95, 37, 3, nil, 40.1, .thumbsUp),
            mk(802015668.371813, c.toca, r.tocaRobotC40Red, 27, 19.7, 10.0, 94, 32, 3, nil, 37.7, .thumbsUp),
            mk(802070115.768482, c.toca, r.tocaRobotC40Red, 27, 19.6, 10.0, 94, 34, 3, nil, 38.9, .thumbsUp),
            mk(802334522.935807, c.toca, r.tocaRobotC40Red, 30, 19.1, 10.0, 94, 32, 2, nil, 38.6, .thumbsUp),
            mk(802446706.545736, c.dreispitz, r.dreispitzPicopressoC40, 34, 18.1, 8.0, 95, 34, 3, nil, 41.5, .thumbsUp),
            mk(802519458.125576, c.dreispitz, r.dreispitzPicopressoC40, 35, 18.2, 8.0, 95, 38, 3, nil, 37.4, .thumbsUp),
            mk(802538631.110392, c.dreispitz, r.dreispitzPicopressoC40, 35, 18.2, 7.0, 95, 37, 3, nil, 38.9, .thumbsUp),
            mk(802617325.927187, c.dreispitz, r.dreispitzRobotC40Red, 36, 19.8, 10.0, 95, 32, 3, nil, 38.6, .thumbsUp),
            mk(802682293.546999, c.dreispitz, r.dreispitzRobotC40Red, 36, 19.4, 10.0, 95, 42, 3, nil, 37.9, .thumbsUp),
            mk(802766727.05431, c.dreispitz, r.dreispitzRobotC40Red, 37, 19.4, 11.0, 95, 32, 3, nil, 42.5, .thumbsDown),
            mk(802851737.44208, c.dreispitz, r.dreispitzRobotC40Red, 38, 19.3, 10.0, 95, 34, 3, nil, 38.1, .thumbsUp),
            mk(802941327.353371, c.dreispitz, r.dreispitzRobotC40Red, 39, 19.1, 10.0, 95, 29, 3, nil, 39.6, .thumbsUp),
            mk(803030581.836119, c.muddyWater, r.muddyWaterRobotC40Red, 66, 19.3, 10.0, 96, 29, 3, nil, 36.3, .thumbsUp),
            mk(803042499.975061, c.muddyWater, r.muddyWaterRobotC40Red, 66, 19.5, 10.0, 95, 32, 3, nil, 38.4, .thumbsDown),
            mk(803135207.699617, c.muddyWater, r.muddyWaterRobotC40Red, 67, 19.8, 10.0, 96, 36, 3, nil, 37.7, .thumbsUp),
            mk(803142639.192939, c.muddyWater, r.muddyWaterRobotC40Red, 67, 19.9, 10.0, 96, 35, 3, nil, 39.0, .thumbsUp),
            mk(803199714.016221, c.muddyWater, r.muddyWaterRobotC40Red, 68, 19.9, 10.0, 96, 34, 4, nil, 39.6, .thumbsUp),
            mk(803285680.346031, c.muddyWater, r.muddyWaterRobotC40Red, 69, 20.3, 10.0, 96, 34, 4, nil, 38.7, .thumbsUp),
            mk(803371369.444315, c.muddyWater, r.muddyWaterRobotC40Red, 70, 19.9, 10.0, 96, 33, 4, nil, 38.1, .thumbsUp),
            mk(803457861.475298, c.muddyWater, r.muddyWaterRobotC40Red, 71, 19.9, 9.0, 96, 38, 3, 3, 38.5, .thumbsUp),
            mk(803547590.813791, c.zima, r.zimaRobotC40Red, 14, 19.7, 12.0, 96, 35, 2, 2, 37.5, .thumbsUp),
            mk(803563054.924874, c.zima, r.zimaRobotC40Red, 15, 19.7, 12.0, 98, 31, 3, 3, 37.6, .thumbsUp),
            mk(803658828.640617, c.zima, r.zimaPicopressoC40, 16, 18.3, 8.0, 98, 36, 3, 3, 40.5, .thumbsUp),
            mk(803716183.023839, c.zima, r.zimaPicopressoC40, 16, 18.3, 7.0, 98, 38, 3, 3, 39.8, .thumbsUp),
            mk(803739850.075441, c.zima, r.zimaPicopressoC40, 17, 18.3, 7.0, 98, 37, 3, 3, 39.2, .thumbsUp),
            mk(803974534.68024, c.zima, r.zimaRobotC40Red, 19, 19.5, 12.0, 97, 28, 2, 4, 38.4, .thumbsDown),
            mk(804060821.049598, c.zima, r.zimaRobotC40Red, 20, 19.5, 11.0, 98, 37, 3, 3, 38.0, .thumbsUp),
            mk(804148600.713849, c.zima, r.zimaRobotC40Red, 21, 19.4, 11.0, 98, 37, 4, 3, 38.4, .thumbsDown),
            mk(804166020.67254, c.zima, r.zimaRobotC40Red, 22, 18.9, 11.0, 98, 30, 3, 3, 38.6, .thumbsUp),
            mk(804256912.280108, c.zima, r.zimaPicopressoC40, 23, 18.1, 7.0, 98, 35, 4, 3, 43.3, .thumbsUp),
            mk(804318793.615327, c.zima, r.zimaPicopressoC40, 23, 18.3, 7.0, 98, 35, 3, 3, 39.5, .thumbsUp),
            mk(804417779.438618, c.zima, r.zimaRobotC40Red, 25, 18.7, 11.0, 98, 31, 2, 3, 39.0, .thumbsUp),
            mk(804579517.975782, c.fortuna, r.fortunaRobotC40Red, 8, 19.2, 12.0, 96, 17, 4, 3, 40.0, .thumbsDown),
            mk(804667761.450527, c.fortuna, r.fortunaRobotC40Red, 9, 19.4, 11.0, 96, 22, 1, 3, 39.3, .thumbsDown),
            mk(804756022.631364, c.fortuna, r.fortunaRobotC40Red, 10, 19.3, 9.0, 96, 37, 3, 4, 37.2, .thumbsUp),
            mk(804770408.733058, c.fortuna, r.fortunaRobotC40Red, 10, 19.3, 9.0, 94, 37, 3, 3, 38.1, .thumbsUp),
            mk(804941090.88685, c.fortuna, r.fortunaPicopressoC40, 12, 18.7, 7.0, 94, 45, 3, 3, 40.3, .thumbsUp),
            mk(804951386.684371, c.fortuna, r.fortunaPicopressoC40, 12, 18.5, 7.0, 94, 45, 3, 3, 38.1, .thumbsUp),
            mk(805015600.855109, c.fortuna, r.fortunaPicopressoC40, 13, 19.5, 7.0, 94, 38, 3, 3, 36.8, .thumbsUp),
            mk(805100150.351197, c.fortuna, r.fortunaRobotC40Red, 14, 18.4, 9.0, 94, 33, 4, 2, 38.9, .thumbsUp),
            mk(805101076.94233, c.fortuna, r.fortunaRobotC40Red, 14, 18.6, 9.0, 94, 33, 3, 3, 37.5, .thumbsUp),
            mk(805115858.557367, c.fortuna, r.fortunaRobotC40Red, 14, 18.8, 9.0, 94, 33, 3, 3, 37.4, .thumbsUp),
            mk(805185472.262172, c.fortuna, r.fortunaRobotC40Red, 15, 18.7, 9.0, 94, 30, 3, 3, 41.3, .thumbsUp),
            mk(805273545.453293, c.fortuna, r.fortunaRobotC40Red, 16, 18.4, 8.0, 94, 43, 5, 3, 37.0, .thumbsDown),
            mk(805359400.255563, c.fortuna, r.fortunaRobotC40Red, 17, 19.0, 9.0, 94, 37, 4, 3, 37.2, .thumbsUp),
            mk(805386799.706263, c.fortuna, r.fortunaRobotC40Red, 17, 18.7, 9.0, 94, 35, 3, 3, 37.4, .thumbsUp),
            mk(805454879.693628, c.fortuna, r.fortunaPicopressoC40, 18, 18.2, 7.0, 94, 37, 3, 3, 39.7, .thumbsUp),
            mk(805476485.287659, c.fortuna, r.fortunaPicopressoC40, 18, 18.3, 7.0, 95, 39, 3, 3, 38.6, .thumbsUp),
            mk(805541000.614673, c.fortuna, r.fortunaPicopressoC40, 19, 18.3, 7.0, 94, 37, 3, 3, 36.8, .thumbsUp),
            mk(805563250.78303, c.fortuna, r.fortunaPicopressoC40, 19, 18.1, 7.0, 94, 34, 3, 3, 38.0, .thumbsUp),
            mk(805617219.202574, c.fortuna, r.fortunaRobotC40Red, 20, 18.8, 9.0, 94, 33, 4, 3, 38.1, .thumbsUp),
            mk(805791078.099185, c.fortuna, r.fortunaRobotC40Red, 22, 18.6, 9.0, 94, 30, 3, 3, 38.3, .thumbsUp),
            mk(806225815.576236, c.fortuna, r.fortunaRobotC40Red, 27, 18.7, 9.0, 94, 24, 5, 3, 40.8, .thumbsDown),
            mk(806253604.545724, c.fortuna, r.fortunaRobotC40Red, 27, 18.7, 8.0, 94, 39, 4, 3, 37.8, .thumbsUp),
            mk(806315751.255101, c.fortuna, r.fortunaRobotC40Red, 28, 18.6, 8.0, 94, 38, 4, 3, 37.9, .thumbsUp),
            mk(806406021.297357, c.fortuna, r.fortunaRobotC40Red, 29, 18.5, 8.0, 94, 35, 3, 3, 39.4, .thumbsUp),
            mk(806577035.087735, c.fortuna, r.fortunaRobotC40Red, 31, 18.5, 8.0, 94, 37, 3, 3, 40.0, .thumbsUp),
            mk(806681568.153616, c.fortuna, r.fortunaRobotC40Red, 32, 18.9, 8.0, 94, 41, 3, 3, 36.5, .thumbsUp),
            mk(806847496.269378, c.henrique, r.henriqueRobotC40Red, 14, 19.6, 13.0, 95, 45, 4, 4, 38.2, .thumbsUp),
            mk(807008866.191549, c.henrique, r.henriqueRobotC40Red, 15, 19.4, 14.0, 94, 27, 2, 2, 38.4, .thumbsUp),
            mk(807027184.693541, c.henrique, r.henriqueRobotC40Red, 16, 19.2, 13.0, 94, 34, 3, 3, 37.2, .thumbsUp),
            mk(807267803.616366, c.henrique, r.henriqueRobotC40Red, 18, 19.5, 13.0, 95, 31, 3, 3, 37.8, .thumbsUp),
            mk(807370997.120055, c.henrique, r.henriqueRobotC40Red, 20, 19.4, 13.0, 95, 37, 3, 3, 38.4, .thumbsUp),
            mk(807432368.1494, c.henrique, r.henriqueRobotC40Red, 20, 19.4, 13.0, 95, 35, 4, 3, 36.8, .thumbsUp),
            mk(807449222.843672, c.henrique, r.henriqueRobotC40Red, 20, 18.9, 13.0, 95, 29, 3, 3, 37.8, .thumbsUp),
            mk(807518977.530995, c.henrique, r.henriqueRobotC40Red, 21, 18.9, 13.0, 95, 30, 3, 3, 38.4, .thumbsUp),
            mk(807534585.413985, c.henrique, r.henriqueRobotC40Red, 21, 18.7, 13.0, 94, 29, 3, 3, 38.8, .thumbsUp),
            mk(807605276.185038, c.henrique, r.henriqueRobotC40Red, 22, 18.5, 13.0, 94, 33, 4, 2, 38.8, .thumbsDown),
            mk(807621128.255442, c.henrique, r.henriqueRobotC40Red, 22, 19.3, 13.0, 95, 33, 3, 3, 36.1, .thumbsUp),
            mk(807781752.234936, c.dreispitz, r.dreispitzRobotC40Red, 23, 19.3, 10.0, 96, 39, 3, 4, 37.2, .thumbsUp),
            mk(807796615.272588, c.dreispitz, r.dreispitzRobotC40Red, 24, 19.3, 11.0, 95, 32, 3, 3, 38.4, .thumbsUp),
            mk(807892466.784859, c.dreispitz, r.dreispitzRobotC40Red, 25, 19.4, 12.0, 95, 29, 3, 3, 39.4, .thumbsUp),
            mk(807965111.626831, c.dreispitz, r.dreispitzRobotC40Red, 26, 19.4, 12.0, 95, 28, 3, 3, 39.2, .thumbsUp),
            mk(808037773.824203, c.dreispitz, r.dreispitzRobotC40Red, 26, 19.4, 12.0, 95, 31, 4, 3, 37.7, .thumbsUp),
            mk(808054761.388531, c.dreispitz, r.dreispitzRobotC40Red, 27, 19.9, 12.0, 95, 28, 3, 3, 38.1, .thumbsUp),
            mk(808125128.147657, c.dreispitz, r.dreispitzRobotC40Red, 27, 19.9, 12.0, 95, 28, 4, 2, 37.8, .thumbsDown),
            mk(808140658.112972, c.dreispitz, r.dreispitzRobotC40Red, 28, 18.5, 11.0, 95, 27, 3, 3, 38.4, .thumbsUp),
            mk(808297865.403486, c.dreispitz, r.dreispitzRobotC40Red, 29, 19.5, 11.0, 95, 29, 2, 3, 37.4, .thumbsDown),
            mk(808312986.093656, c.dreispitz, r.dreispitzRobotC40Red, 30, 19.2, 10.0, 95, 43, 4, 3, 36.7, .thumbsUp),
            mk(808385933.141606, c.dreispitz, r.dreispitzRobotC40Red, 30, 18.7, 10.0, 95, 34, 3, 4, 37.1, .thumbsDown),
            mk(808402952.944812, c.dreispitz, r.dreispitzRobotC40Red, 31, 19.9, 11.0, 95, 32, 3, 3, 39.2, .thumbsUp),
            mk(808731919.891011, c.viennaCalling, r.viennaCallingRobotC40Red, 6, 18.5, 12.0, 92, 33, 4, 3, 38.0, .thumbsUp),
            mk(808746361.283002, c.viennaCalling, r.viennaCallingRobotC40Red, 7, 18.9, 13.0, 92, 31, 3, 3, 37.0, .thumbsUp),
            mk(808814642.030937, c.viennaCalling, r.viennaCallingRobotC40Red, 7, 19.1, 13.0, 92, 32, 3, 3, 37.0, .thumbsUp),
            mk(808904132.682993, c.viennaCalling, r.viennaCallingRobotC40Red, 8, 19.0, 13.0, 92, 32, 3, 3, 38.0, .thumbsUp),
            mk(808919773.694549, c.viennaCalling, r.viennaCallingRobotC40Red, 9, 19.0, 13.0, 92, 32, 3, 3, 37.0, .thumbsUp),
            mk(808990267.948798, c.viennaCalling, r.viennaCallingRobotC40Red, 9, 19.2, 13.0, 92, 30, 4, 3, 38.8, .thumbsDown),
            mk(809001980.622046, c.viennaCalling, r.viennaCallingRobotC40Red, 9, 18.8, 13.0, 92, 26, 3, 3, 38.3, .thumbsUp),
            mk(809189478.654093, c.viennaCalling, r.viennaCallingRobotC40Red, 12, 18.8, 12.0, 92, 28, 3, 3, 37.5, .thumbsUp),
            mk(809189528.024448, c.viennaCalling, r.viennaCallingRobotC40Red, 12, 18.8, 12.0, 92, 28, 3, 3, 37.5, .thumbsUp),
            mk(809249940.527848, c.viennaCalling, r.viennaCallingRobotC40Red, 12, 18.9, 12.0, 92, 30, 4, 3, 38.5, .thumbsUp),
            mk(809268329.529744, c.viennaCalling, r.viennaCallingRobotC40Red, 13, 19.3, 12.0, 92, 36, 3, 3, 38.1, .thumbsUp),
            mk(809335803.634426, c.viennaCalling, r.viennaCallingRobotC40Red, 13, 18.7, 12.0, 92, 31, 4, 4, 36.7, .thumbsDown),
            mk(809351886.192763, c.viennaCalling, r.viennaCallingRobotC40Red, 14, 19.2, 13.0, 92, 34, 3, 3, 39.3, .thumbsUp),
            mk(809423064.187807, c.viennaCalling, r.viennaCallingRobotC40Red, 14, 19.2, 13.0, 92, 33, 3, 3, 38.5, .thumbsUp),
            mk(809441092.466666, c.viennaCalling, r.viennaCallingRobotC40Red, 15, 19.6, 13.0, 92, 28, 3, 3, 38.2, .thumbsUp),
            mk(809595365.931275, c.viennaCalling, r.viennaCallingRobotC40Red, 16, 19.3, 13.0, 92, 28, 3, 3, 38.7, .thumbsUp),
            mk(809612264.970767, c.viennaCalling, r.viennaCallingRobotC40Red, 17, 19.4, 12.0, 92, 33, 3, 3, 36.8, .thumbsUp),
            mk(809705559.836078, c.viennaCalling, r.viennaCallingRobotC40Red, 18, 19.7, 12.0, 92, 34, 3, 3, 38.5, .thumbsUp),
            mk(809785864.690494, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 19, 19.1, 12.0, 92, 35, 3, 3, 37.8, .thumbsUp),
            mk(809852714.370197, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 19, 19.3, 13.0, 92, 31, 3, 3, 37.8, .thumbsUp),
            mk(809867985.147028, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 20, 19.3, 13.0, 92, 26, 3, 3, 38.9, .thumbsUp),
            mk(809939362.013012, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 20, 19.6, 13.0, 92, 29, 3, 3, 37.5, .thumbsUp),
            mk(809958108.166228, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 21, 19.4, 13.0, 92, 28, 3, 3, 37.5, .thumbsUp),
            mk(810025408.65107, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 21, 19.4, 13.0, 92, 29, 3, 3, 37.7, .thumbsUp),
            mk(810042986.902086, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 22, 19.4, 13.0, 92, 29, 3, 3, 37.8, .thumbsUp),
            mk(810111458.836964, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 22, 19.6, 13.0, 92, 29, 4, 3, 38.7, .thumbsUp),
            mk(810127741.171104, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 23, 19.3, 13.0, 92, 28, 3, 3, 37.8, .thumbsUp),
            mk(810197377.67215, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 23, 19.5, 13.0, 92, 29, 3, 3, 37.8, .thumbsUp),
            mk(810213894.433361, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 24, 18.6, 12.0, 92, 28, 4, 3, 40.1, .thumbsDown),
            mk(810287494.08536, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 24, 18.5, 12.0, 92, 33, 3, 3, 36.7, .thumbsUp),
            mk(810307385.082537, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 25, 18.7, 12.0, 92, 37, 3, 3, 35.9, .thumbsUp),
            mk(810458248.464842, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 26, 18.6, 12.0, 92, 41, 4, 3, 36.4, .thumbsDown),
            mk(810476165.433771, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 27, 18.9, 13.0, 92, 35, 4, 3, 36.7, .thumbsDown),
            mk(810544664.369843, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 27, 19.5, 13.0, 92, 42, 3, 2, 37.4, .thumbsDown),
            mk(810560948.662422, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 28, 19.4, 14.0, 92, 32, 3, 3, 37.2, .thumbsUp),
            mk(810717959.197155, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 29, 19.4, 14.0, 92, 27, 3, 3, 39.1, .thumbsUp),
            mk(810804435.74935, c.hausEspresso, r.hausEspressoRobotC40Red, 13, 19.0, 12.0, 92, 39, 4, 3, 37.0, .thumbsDown),
            mk(810819775.522467, c.hausEspresso, r.hausEspressoRobotC40Red, 14, 19.3, 13.0, 92, 30, 4, 3, 39.6, .thumbsUp),
            mk(810920402.915886, c.hausEspresso, r.hausEspressoRobotC40Red, 15, 19.6, 13.0, 92, 32, 3, 3, 37.2, .thumbsUp),
            mk(810985865.491618, c.hausEspresso, r.hausEspressoRobotC40Red, 15, 19.5, 13.0, 92, 34, 3, 3, 37.3, .thumbsUp),
            mk(811063555.603354, c.hausEspresso, r.hausEspressoRobotC40Red, 16, 19.3, 13.0, 92, 32, 3, 3, 37.0, .thumbsUp),
            mk(811078076.899782, c.hausEspresso, r.hausEspressoRobotC40Red, 17, 19.3, 14.0, 92, 29, 3, 3, 38.5, .thumbsUp),
            mk(811147299.026766, c.hausEspresso, r.hausEspressoRobotC40Red, 17, 18.7, 13.0, 92, 33, 4, 2, 39.1, .thumbsDown),
            mk(811164352.996104, c.hausEspresso, r.hausEspressoRobotC40Red, 18, 18.4, 13.0, 92, 35, 3, 3, 39.0, .thumbsUp),
            mk(811233174.240349, c.hausEspresso, r.hausEspressoRobotC40Red, 18, 18.5, 13.0, 92, 34, 5, 3, 38.1, .thumbsDown),
            mk(811251313.596164, c.hausEspresso, r.hausEspressoRobotC40Red, 19, 19.8, 13.0, 92, 38, 3, 3, 37.7, .thumbsUp),
            mk(811320645.454544, c.hausEspresso, r.hausEspressoRobotC40Red, 19, 19.6, 14.0, 92, 32, 3, 2, 38.0, .thumbsDown),
            mk(811336255.331619, c.hausEspresso, r.hausEspressoRobotC40Red, 20, 19.2, 13.0, 92, 39, 3, 3, 36.8, .thumbsUp),
            mk(811409282.848101, c.hausEspresso, r.hausEspressoRobotC40Red, 20, 19.3, 13.0, 92, 32, 3, 3, 38.5, .thumbsUp),
            mk(811423716.292031, c.hausEspresso, r.hausEspressoRobotC40Red, 21, 19.2, 13.0, 92, 31, 3, 3, 37.6, .thumbsUp),
            mk(811505622.66761, c.hausEspresso, r.hausEspressoRobotC40Red, 22, 19.3, 13.0, 92, 30, 3, 3, 38.6, .thumbsUp),
            mk(811519294.285525, c.hausEspresso, r.hausEspressoRobotC40Red, 22, 19.6, 13.0, 92, 33, 3, 3, 38.7, .thumbsUp),
            mk(811587862.308557, c.hausEspresso, r.hausEspressoRobotC40Red, 22, 19.4, 13.0, 92, 30, 3, 3, 38.5, .thumbsUp),
            mk(811610535.306068, c.hausEspresso, r.hausEspressoRobotC40Red, 23, 19.6, 13.0, 92, 30, 3, 3, 37.9, .thumbsUp),
            mk(811666853.813642, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 17, 19.5, 14.0, 92, 26, 4, 3, 39.0, .thumbsUp),
            mk(811683593.985508, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 18, 19.6, 13.0, 92, 34, 3, 3, 38.2, .thumbsUp),
            mk(811753501.95245, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 18, 19.3, 13.0, 92, 29, 4, 3, 40.2, .thumbsUp),
            mk(811768989.321926, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 19, 19.1, 13.0, 92, 28, 3, 3, 36.4, .thumbsUp),
            mk(811842335.181414, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 19, 19.4, 13.0, 92, 28, 3, 3, 38.0, .thumbsUp),
            mk(811856760.931809, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 20, 18.9, 12.0, 92, 33, 4, 3, 36.6, .thumbsUp),
            mk(811926945.977243, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 20, 19.1, 13.0, 92, 33, 3, 3, 36.9, .thumbsUp),
            mk(811941902.076155, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 21, 19.3, 13.0, 92, 29, 3, 3, 37.8, .thumbsUp),
            mk(812015327.765111, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 21, 19.3, 13.0, 92, 33, 3, 3, 37.4, .thumbsUp),
            mk(812033759.73354, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 22, 19.2, 13.0, 92, 32, 3, 3, 38.2, .thumbsUp),
            mk(812118328.399218, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 23, 19.6, 13.0, 92, 32, 3, 3, 38.2, .thumbsUp),
            mk(812199360.009973, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 24, 19.5, 13.0, 92, 34, 3, 3, 37.5, .thumbsUp),
            mk(812213160.646493, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 24, 19.6, 13.0, 92, 32, 3, 3, 39.0, .thumbsUp),
            mk(812279588.480662, c.outOfTheDark, r.outOfTheDarkRobotC40Red, 25, 19.7, 13.0, 92, 31, 3, 3, 39.2, .thumbsUp),
            mk(812291762.946988, c.outOfTheDark, r.outOfTheDarkRobotLagom, 25, 19.2, 10.0, 92, 27, 4, 2, 38.9, .thumbsDown),
            mk(812292190.431396, c.outOfTheDark, r.outOfTheDarkRobotLagom, 25, 19.5, 9.0, 92, 38, 4, 3, 38.7, .thumbsUp),
            mk(812359022.78834, c.outOfTheDark, r.outOfTheDarkRobotLagom, 25, 19.5, 9.5, 92, 29, 4, 2, 38.8, .thumbsDown),
            mk(812360002.99219, c.outOfTheDark, r.outOfTheDarkRobotLagom, 25, 19.5, 9.3, 92, 39, 5, 3, 38.5, .thumbsDown),
            mk(812373921.162895, c.apas, r.apasRobotC40Red, 20, 18.5, 13.0, 94, 31, 4, 3, 38.3, .thumbsUp),
            mk(812532526.5851, c.apas, r.apasRobotLagom, 22, 18.7, 9.4, 95, 33, 4, 3, 38.1, .thumbsUp),
            mk(812548494.232993, c.apas, r.apasRobotLagom, 22, 18.5, 9.4, 95, 32, 3, 3, 38.0, .thumbsUp),
            mk(812554863.050015, c.apas, r.apasRobotLagom, 22, 18.3, 9.4, 95, 31, 3, 3, 38.0, .thumbsUp),
            mk(812620373.124867, c.apas, r.apasRobotLagom, 23, 18.5, 9.4, 95, 30, 3, 3, 38.6, .thumbsUp),
            mk(812633656.685036, c.apas, r.apasRobotLagom, 23, 18.4, 9.4, 95, 32, 3, 3, 39.4, .thumbsUp),
            mk(812706848.268143, c.apas, r.apasRobotLagom, 24, 18.5, 9.4, 95, 30, 2, 4, 38.8, .thumbsDown),
            mk(812788604.182904, c.apas, r.apasRobotLagom, 25, 18.7, 9.4, 95, 32, 5, 3, 39.6, .thumbsDown),
            mk(812808370.28685, c.apas, r.apasRobotLagom, 25, 18.4, 9.4, 95, 32, 3, 3, 38.6, .thumbsUp),
            mk(812878516.696192, c.apas, r.apasRobotLagom, 26, 19.0, 9.4, 95, 34, 3, 2, 38.5, .thumbsUp),
            mk(812895310.85589, c.apas, r.apasRobotLagom, 26, 19.4, 9.4, 95, 29, 3, 3, 38.8, .thumbsUp),
            mk(812966751.095193, c.apas, r.apasRobotLagom, 27, 18.5, 9.3, 95, 31, 4, 3, 39.4, .thumbsUp),
            mk(812978429.045134, c.apas, r.apasRobotLagom, 27, 18.5, 9.3, 95, 31, 3, 3, 38.7, .thumbsUp),
            mk(813333934.954181, c.dreispitz, r.dreispitzRobotLagom, 30, 19.1, 9.4, 95, 29, 3, 2, 38.5, .thumbsUp),
            mk(813333963.497029, c.dreispitz, r.dreispitzRobotLagom, 30, 19.1, 9.3, 95, 20, 3, 3, 37.3, .thumbsDown),
            mk(813333985.121055, c.dreispitz, r.dreispitzRobotLagom, 30, 19.0, 9.3, 95, 30, 4, 4, 38.9, .thumbsDown),
            mk(813334017.866651, c.dreispitz, r.dreispitzRobotLagom, 30, 19.1, 9.2, 95, 31, 3, 3, 39.3, .thumbsUp),
            mk(813334055.856738, c.dreispitz, r.dreispitzRobotLagom, 30, 19.0, 9.2, 95, 32, 3, 3, 39.2, .thumbsUp),
            mk(813337636.68744, c.dreispitz, r.dreispitzRobotLagom, 30, 19.2, 9.2, 95, 34, 3, 3, 39.2, .thumbsUp),
            mk(813400624.34293, c.dreispitz, r.dreispitzRobotLagom, 31, 19.3, 9.2, 95, 31, 3, 2, 37.2, .thumbsUp),
            mk(813418976.926643, c.dreispitz, r.dreispitzRobotLagom, 31, 19.3, 9.2, 95, 32, 4, 3, 39.7, .thumbsUp),
            mk(813484734.584103, c.dreispitz, r.dreispitzRobotLagom, 32, 19.2, 9.3, 95, 35, 3, 2, 38.3, .thumbsUp),
            mk(813499601.8072, c.dreispitz, r.dreispitzRobotLagom, 32, 19.3, 9.2, 95, 31, 3, 3, 40.5, .thumbsUp),
            mk(813570002.260539, c.dreispitz, r.dreispitzRobotLagom, 33, 19.3, 9.2, 96, 35, 4, 3, 40.0, .thumbsUp),
            mk(813584020.921614, c.dreispitz, r.dreispitzRobotLagom, 33, 19.6, 9.2, 96, 34, 3, 4, 40.3, .thumbsUp),
            mk(813589641.313785, c.dreispitz, r.dreispitzRobotLagom, 33, 19.3, 9.2, 95, 34, 3, 3, 40.7, .thumbsUp),
            mk(813656713.420209, c.dreispitz, r.dreispitzRobotLagom, 34, 19.5, 9.2, 95, 32, 2, 3, 40.3, .thumbsDown),
            mk(813676166.664202, c.dreispitz, r.dreispitzRobotLagom, 34, 19.3, 9.2, 95, 37, 3, 3, 40.4, .thumbsUp),
            mk(813826596.914816, c.dreispitz, r.dreispitzRobotLagom, 36, 19.1, 9.2, 95, 32, 2, 3, 38.9, .thumbsDown),
            mk(813832398.780765, c.dreispitz, r.dreispitzRobotLagom, 36, 19.4, 9.2, 95, 38, 3, 3, 41.0, .thumbsUp),
            mk(813848548.476244, c.dreispitz, r.dreispitzRobotLagom, 36, 19.2, 9.2, 95, 32, 3, 3, 39.6, .thumbsUp),
            mk(813938421.078031, c.dreispitz, r.dreispitzRobotLagom, 37, 19.5, 9.2, 95, 33, 3, 3, 40.0, .thumbsUp),
            mk(814012127.327889, c.dreispitz, r.dreispitzRobotLagom, 38, 19.4, 9.2, 95, 31, 3, 3, 41.6, .thumbsUp),
            mk(814028721.957803, c.dreispitz, r.dreispitzRobotLagom, 38, 19.4, 9.2, 95, 32, 3, 3, 40.8, .thumbsUp),
            mk(814088968.7234, c.dreispitz, r.dreispitzRobotLagom, 39, 19.2, 9.2, 95, 34, 3, 3, 39.9, .thumbsUp),
            mk(814101633.304166, c.dreispitz, r.dreispitzRobotLagom, 39, 19.4, 9.2, 95, 34, 4, 3, 40.5, .thumbsUp),
            mk(814174555.666907, c.dreispitz, r.dreispitzRobotLagom, 40, 19.2, 9.2, 95, 32, 4, 4, 42.3, .thumbsDown),
            mk(814191889.107534, c.dreispitz, r.dreispitzRobotLagom, 40, 19.4, 9.2, 95, 30, 3, 3, 40.2, .thumbsUp),
            mk(814348762.038477, c.compadre, r.compadreRobotLagom, 35, 19.3, 9.3, 92, 36, 4, 3, 38.7, .thumbsUp),
            mk(814364644.425427, c.compadre, r.compadreRobotLagom, 35, 19.0, 9.4, 92, 34, 3, 3, 39.5, .thumbsUp),
            mk(814434260.708759, c.compadre, r.compadreRobotLagom, 36, 18.9, 9.5, 92, 32, 3, 3, 38.7, .thumbsUp),
            mk(814446853.025222, c.compadre, r.compadreRobotLagom, 36, 19.0, 9.5, 92, 36, 3, 3, 39.2, .thumbsUp),
            mk(814696069.573477, c.compadre, r.compadreRobotLagom, 39, 19.3, 9.5, 92, 31, 3, 3, 39.2, .thumbsUp),
            mk(814783908.484338, c.compadre, r.compadreRobotLagom, 40, 19.3, 9.4, 92, 30, 3, 3, 38.7, .thumbsUp),
            mk(814894749.760025, c.compadre, r.compadreRobotLagom, 41, 19.3, 9.4, 92, 31, 4, 3, 39.2, .thumbsUp),
            mk(814956746.69527, c.compadre, r.compadreRobotLagom, 42, 19.4, 9.5, 92, 31, 3, 3, 39.0, .thumbsUp),
            mk(815057201.529276, c.compadre, r.compadreRobotLagom, 43, 19.5, 9.5, 92, 29, 3, 3, 39.5, .thumbsUp),
            mk(815062677.308019, c.compadre, r.compadreRobotLagom, 43, 19.2, 9.5, 92, 32, 3, 3, 39.5, .thumbsDown),
            mk(815138414.688007, c.compadre, r.compadreRobotLagom, 44, 19.5, 9.5, 92, 33, 3, 3, 37.5, .thumbsUp),
            mk(815217444.586734, c.compadre, r.compadreRobotLagom, 45, 19.5, 9.5, 92, 33, 3, 3, 38.5, .thumbsUp),
            mk(815310590.667347, c.compadre, r.compadreRobotLagom, 12, 19.3, 9.5, 92, 31, 3, 3, 38.8, .thumbsUp),
            mk(815321998.852874, c.compadre, r.compadreRobotLagom, 13, 19.2, 9.6, 92, 32, 3, 3, 39.2, .thumbsUp),
            mk(815399739.28823, c.compadre, r.compadreRobotLagom, 13, 19.6, 9.6, 92, 35, 4, 3, 40.0, .thumbsUp),
            mk(815406767.819505, c.compadre, r.compadreRobotLagom, 14, 19.4, 9.7, 92, 32, 3, 3, 38.3, .thumbsUp),
            mk(815474584.914208, c.compadre, r.compadreRobotLagom, 14, 19.6, 9.7, 92, 32, 3, 3, 38.5, .thumbsUp),
            mk(815488463.136613, c.compadre, r.compadreRobotLagom, 15, 19.3, 9.7, 92, 34, 4, 3, 39.4, .thumbsUp),
            mk(815560877.227006, c.compadre, r.compadreRobotLagom, 15, 19.3, 9.7, 92, 29, 4, 3, 40.7, .thumbsUp),
            mk(815575642.444167, c.compadre, r.compadreRobotLagom, 16, 19.3, 9.7, 92, 32, 3, 3, 39.6, .thumbsUp),
            mk(815647010.176605, c.compadre, r.compadreRobotLagom, 16, 19.4, 9.7, 92, 31, 3, 3, 39.1, .thumbsUp),
            mk(815661169.746318, c.apasDecaf, r.apasDecafRobotLagom, 17, 19.4, 9.7, 95, 25, 3, 3, 37.6, .thumbsUp),
            mk(815741422.927079, c.compadre, r.compadreRobotLagom, 17, 19.1, 9.7, 92, 32, 3, 3, 39.6, .thumbsUp),
            mk(815759515.30593, c.apasDecaf, r.apasDecafRobotLagom, 18, 19.4, 9.5, 95, 29, 3, 3, 36.8, .thumbsUp),
            mk(815829117.592419, c.compadre, r.compadreRobotLagom, 18, 19.2, 9.7, 92, 30, 3, 3, 38.1, .thumbsUp),
            mk(815843447.077715, c.apasDecaf, r.apasDecafRobotLagom, 19, 19.3, 9.4, 95, 27, 3, 3, 39.1, .thumbsUp),
            mk(815902905.082565, c.compadre, r.compadreRobotLagom, 19, 19.4, 9.7, 92, 34, 4, 3, 41.1, .thumbsDown),
            mk(815920534.322801, c.compadre, r.compadreRobotLagom, 20, 19.4, 9.6, 92, 31, 3, 3, 39.1, .thumbsUp),
            mk(815989207.514796, c.apas, r.apasRobotLagom, 21, 19.3, 9.4, 95, 35, 2, 3, 38.7, .thumbsUp),
            mk(816007582.491437, c.apas, r.apasRobotLagom, 21, 19.1, 9.5, 95, 36, 3, 3, 40.2, .thumbsUp),
            mk(816163114.080156, c.apas, r.apasRobotLagom, 23, 19.4, 9.5, 95, 32, 5, 3, 37.8, .thumbsDown),
            mk(816182827.22563, c.apas, r.apasRobotLagom, 23, 19.4, 9.4, 95, 37, 5, 3, 41.5, .thumbsDown),
            mk(816247645.34702, c.apas, r.apasRobotLagom, 24, 19.3, 9.6, 95, 34, 4, 3, 38.8, .thumbsUp),
            mk(816283891.001738, c.apas, r.apasRobotLagom, 24, 19.5, 9.7, 95, 31, 4, 4, 38.5, .thumbsUp),
            mk(816348866.332999, c.apas, r.apasRobotLagom, 25, 19.4, 9.7, 95, 32, 4, 3, 39.4, .thumbsUp),
            mk(816360921.492838, c.apas, r.apasRobotLagom, 25, 19.4, 9.8, 95, 30, 3, 3, 40.1, .thumbsUp),
            mk(816436199.904561, c.apas, r.apasRobotLagom, 26, 19.4, 9.8, 95, 30, 3, 3, 39.3, .thumbsUp)
        ]
    }

    // MARK: - Complete Sample Data

    /// Seeds a `ModelContext` with the full sample set built from `default.store`
    /// (15 coffees, 5 equipment, 24 recipes, 26 refills, 358 brews,
    /// 3 maintenance templates with 5 completed instances).
    static func seedContext(_ context: ModelContext) throws {
        let equipment = createEquipment()
        let maintenance = createMaintenance(equipment: equipment)
        let coffees = createCoffees()
        let recipes = createRecipes(coffees: coffees, equipment: equipment)
        let brews = createBrews(coffees: coffees, recipes: recipes)

        for item in equipment.all { context.insert(item) }
        for template in maintenance.templates { context.insert(template) }
        for instance in maintenance.instances { context.insert(instance) }
        for coffee in coffees.all { context.insert(coffee) }
        for recipe in recipes.all { context.insert(recipe) }
        for brew in brews { context.insert(brew) }

        try context.save()
    }
}

#endif

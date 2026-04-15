//
//  SampleDataFactoryV2.swift
//  coffee-journey
//
//  Generated from default.store — SchemaV2-native sample data.
//

import Foundation
import SwiftData

#if DEBUG

/// Sample data factory for `SchemaV2`, built from the real rows in
/// `default.store`. Dates are reproduced exactly via the Core Data reference
/// epoch so previews and tests are reproducible.
enum SampleDataFactoryV2 {

    // MARK: - Date helper

    /// Core Data reference epoch = 2001-01-01 00:00:00 UTC.
    private static func d(_ ref: Double) -> Date {
        Date(timeIntervalSinceReferenceDate: ref)
    }

    // MARK: - Equipment

    struct EquipmentBundle {
        let robot: Equipment       // ZEQUIPMENT pk 1
        let c40red: Equipment      // ZEQUIPMENT pk 2
        let picopresso: Equipment  // ZEQUIPMENT pk 3
        let c40: Equipment         // ZEQUIPMENT pk 4

        var all: [Equipment] { [robot, c40red, picopresso, c40] }
    }

    static func createEquipment() -> EquipmentBundle {
        EquipmentBundle(
            robot: Equipment(name: "Robot", brand: "Cafelat", type: "Espresso Maschine", notes: ""),
            c40red: Equipment(name: "C40 + Red Cilx", brand: "Comandante", type: "grinder", notes: ""),
            picopresso: Equipment(name: "Picopresso", brand: "Wacaco", type: "Espresso Maschine", notes: ""),
            c40: Equipment(name: "C40", brand: "Comandante", type: "grinder", notes: "")
        )
    }

    // MARK: - Coffees

    struct CoffeeBundle {
        let starlight: Coffee  // ZCOFFEE pk 1
        let apas: Coffee       // ZCOFFEE pk 2
        let henrique: Coffee   // ZCOFFEE pk 3
        let bergsonne: Coffee  // ZCOFFEE pk 4
        let vienna: Coffee     // ZCOFFEE pk 6

        var all: [Coffee] { [starlight, apas, henrique, bergsonne, vienna] }
    }

    /// Builds the five coffees and overwrites each designated-init refill
    /// with the exact date from the store (amount / roastDate already match).
    static func createCoffees() -> CoffeeBundle {
        let starlight = Coffee(
            name: "Starlight",
            roaster: "Public Coffee Roasters",
            roastCategory: "medium",
            amount: 250,
            amountLeft: 0,
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

        let apas = Coffee(
            name: "Apas",
            roaster: "Kaffeemacher",
            roastCategory: "medium",
            amount: 250,
            amountLeft: 0,
            lastRefill: d(793984551.894297),
            brews: [],
            recipes: [],
            totalBrews: 14,
            brewsSinceRefill: 14,
            roastDate: d(791306100),
            rating: 4.0,
            notes: ""
        )
        apas.refills.first?.date = d(793984551.894307)

        let henrique = Coffee(
            name: "Henrique",
            roaster: "Kaffeemacher",
            roastCategory: "medium",
            amount: 250,
            amountLeft: 0,
            lastRefill: d(794573055.830532),
            brews: [],
            recipes: [],
            totalBrews: 14,
            brewsSinceRefill: 14,
            roastDate: d(792326520),
            rating: 4.5,
            notes: "Schokoladig, nussig, dicht und balanciert"
        )
        henrique.refills.first?.date = d(794573055.830567)

        let bergsonne = Coffee(
            name: "Bergsonne",
            roaster: "Wildkaffee",
            roastCategory: "dark",
            amount: 350,
            amountLeft: 0,
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

        let vienna = Coffee(
            name: "Vienna Calling",
            roaster: "Wildkaffee",
            roastCategory: "dark",
            amount: 350,
            amountLeft: 69.2,
            lastRefill: d(796906047.864156),
            brews: [],
            recipes: [],
            totalBrews: 15,
            brewsSinceRefill: 15,
            roastDate: d(796218300),
            rating: 3.0,
            notes: "Schokoladig, Süß, Beerig"
        )
        vienna.refills.first?.date = d(796906047.864223)

        return CoffeeBundle(
            starlight: starlight,
            apas: apas,
            henrique: henrique,
            bergsonne: bergsonne,
            vienna: vienna
        )
    }

    // MARK: - Recipes

    struct RecipeBundle {
        let starlightEspresso: Recipe      // ZRECIPE pk 1
        let apasFlatWhite: Recipe          // ZRECIPE pk 2
        let apasEspresso: Recipe           // ZRECIPE pk 3
        let henriqueEspresso: Recipe       // ZRECIPE pk 4
        let henriqueEspressoRobot: Recipe  // ZRECIPE pk 5
        let bergsonneEspresso: Recipe      // ZRECIPE pk 6
        let viennaFlatWhiteTravel: Recipe  // ZRECIPE pk 7
        let viennaEspresso: Recipe         // ZRECIPE pk 8

        var all: [Recipe] {
            [starlightEspresso, apasFlatWhite, apasEspresso, henriqueEspresso,
             henriqueEspressoRobot, bergsonneEspresso, viennaFlatWhiteTravel, viennaEspresso]
        }
    }

    static func createRecipes(coffees: CoffeeBundle, equipment: EquipmentBundle) -> RecipeBundle {
        func make(
            name: String,
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
                name: name,
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
            starlightEspresso: make(
                name: "Espresso", coffee: coffees.starlight,
                brewer: equipment.robot, grinder: equipment.c40red,
                minT: 95, maxT: 95, minG: 13.0, maxG: 13.0,
                minExt: 26, maxExt: 36, minB: 19.6, maxB: 20.6,
                minO: 37.9, maxO: 39.0, lastUsed: 796488955.473844
            ),
            apasFlatWhite: make(
                name: "Flat White", coffee: coffees.apas,
                brewer: equipment.picopresso, grinder: equipment.c40,
                minT: 96, maxT: 96, minG: 8.0, maxG: 9.0,
                minExt: 30, maxExt: 43, minB: 18.0, maxB: 18.8,
                minO: 36.0, maxO: 39.7, lastUsed: 794572963.828307
            ),
            apasEspresso: make(
                name: "Espresso", coffee: coffees.apas,
                brewer: equipment.picopresso, grinder: equipment.c40,
                minT: 96, maxT: 96, minG: 9.0, maxG: 9.0,
                minExt: 35, maxExt: 35, minB: 18.4, maxB: 18.4,
                minO: 37.4, maxO: 37.4, lastUsed: 794416581.081216
            ),
            henriqueEspresso: make(
                name: "Espresso", coffee: coffees.henrique,
                brewer: equipment.picopresso, grinder: equipment.c40,
                minT: 96, maxT: 96, minG: 9.0, maxG: 12.0,
                minExt: 30, maxExt: 38, minB: 18.0, maxB: 18.7,
                minO: 36.0, maxO: 38.9, lastUsed: 794673684.718758
            ),
            henriqueEspressoRobot: make(
                name: "Espresso Robot", coffee: coffees.henrique,
                brewer: equipment.robot, grinder: equipment.c40red,
                minT: 94, maxT: 95, minG: 13.0, maxG: 14.0,
                minExt: 29, maxExt: 34, minB: 18.5, maxB: 19.5,
                minO: 36.9, maxO: 38.6, lastUsed: 795194928.720388
            ),
            bergsonneEspresso: make(
                name: "Espresso", coffee: coffees.bergsonne,
                brewer: equipment.robot, grinder: equipment.c40red,
                minT: 92, maxT: 92, minG: 14.0, maxG: 14.0,
                minExt: 27, maxExt: 28, minB: 20.5, maxB: 20.7,
                minO: 38.3, maxO: 39.7, lastUsed: 796288912.216993
            ),
            viennaFlatWhiteTravel: make(
                name: "Flat White travel", coffee: coffees.vienna,
                brewer: equipment.picopresso, grinder: equipment.c40,
                minT: 94, maxT: 94, minG: 8.0, maxG: 8.0,
                minExt: 41, maxExt: 45, minB: 18.0, maxB: 18.3,
                minO: 37.2, maxO: 39.3, lastUsed: 797176311.493362
            ),
            viennaEspresso: make(
                name: "Espresso", coffee: coffees.vienna,
                brewer: equipment.robot, grinder: equipment.c40red,
                minT: 92, maxT: 92, minG: 12.0, maxG: 12.0,
                minExt: 30, maxExt: 35, minB: 18.3, maxB: 18.9,
                minO: 38.5, maxO: 43.3000000000001, lastUsed: 797772838.041738
            )
        )
    }

    // MARK: - Brews

    /// Builds all 71 brews from ZBREW, wired to their coffee and recipe.
    static func createBrews(coffees: CoffeeBundle, recipes: RecipeBundle) -> [Brew] {
        func mk(
            _ date: Double, _ coffee: Coffee, _ recipe: Recipe,
            _ amountCoffee: Double, _ grind: Double, _ temp: Int,
            _ extTime: Int, _ taste: Int, _ output: Double, _ rating: BrewRating
        ) -> Brew {
            let b = Brew(
                date: d(date),
                amountCoffee: amountCoffee,
                grindSetting: grind,
                temperature: temp,
                extractionTime: extTime,
                taste: taste,
                output: output,
                rating: rating
            )
            b.coffee = coffee
            b.recipe = recipe
            return b
        }

        let c = coffees
        let r = recipes

        return [
            // Starlight / Espresso (pk 1..6)
            mk(793780278.102888, c.starlight, r.starlightEspresso, 18.8, 11.0, 96, 41, 5, 38.2, .thumbsUp),
            mk(793780311.049872, c.starlight, r.starlightEspresso, 19.7, 12.0, 96, 34, 2, 34.1, .thumbsUp),
            mk(793780339.499468, c.starlight, r.starlightEspresso, 19.7, 13.0, 97, 31, 4, 36.5, .thumbsUp),
            mk(793781079.547786, c.starlight, r.starlightEspresso, 19.4, 13.0, 96, 31, 4, 36.4, .thumbsUp),
            mk(793870646.696097, c.starlight, r.starlightEspresso, 18.9, 13.0, 96, 28, 4, 36.4, .thumbsUp),
            mk(793890885.493548, c.starlight, r.starlightEspresso, 19.6, 13.0, 95, 36, 3, 39.0, .thumbsUp),

            // Apas / Flat White + Espresso (pk 7..19, 24)
            mk(793985769.949498, c.apas, r.apasFlatWhite, 18.2, 9.0, 96, 38, 3, 39.0, .thumbsUp),
            mk(794072148.524402, c.apas, r.apasFlatWhite, 18.3, 9.0, 96, 36, 3, 37.5, .thumbsUp),
            mk(794151805.810234, c.apas, r.apasFlatWhite, 18.0, 9.0, 96, 43, 3, 38.9, .thumbsUp),
            mk(794161469.754336, c.apas, r.apasFlatWhite, 18.5, 9.0, 96, 36, 4, 39.7, .thumbsUp),
            mk(794230392.710901, c.apas, r.apasEspresso,  18.4, 9.0, 96, 39, 3, 36.4, .thumbsUp),
            mk(794318027.798836, c.apas, r.apasFlatWhite, 18.8, 9.0, 96, 36, 3, 37.2, .thumbsUp),
            mk(794327452.534548, c.apas, r.apasFlatWhite, 18.7, 9.0, 96, 40, 3, 38.6, .thumbsUp),
            mk(794328465.748970, c.apas, r.apasEspresso,  18.5, 9.0, 96, 40, 4, 38.6, .thumbsUp),
            mk(794400869.696601, c.apas, r.apasEspresso,  18.8, 9.0, 96, 41, 3, 38.3, .thumbsUp),
            mk(794416581.081029, c.apas, r.apasEspresso,  18.7, 9.0, 96, 40, 3, 38.7, .thumbsUp),
            mk(794478786.874329, c.apas, r.apasEspresso,  18.4, 9.0, 94, 38, 3, 37.4, .thumbsDown),
            mk(794494276.405926, c.apas, r.apasFlatWhite, 18.7, 9.0, 96, 40, 3, 37.9, .thumbsUp),
            mk(794572963.828006, c.apas, r.apasFlatWhite, 18.5, 9.0, 96, 38, 3, 38.1, .thumbsUp),
            mk(794674315.894158, c.apas, r.apasFlatWhite, 18.4, 9.0, 96, 36, 3, 37.9, .thumbsDown),

            // Henrique / Espresso picopresso (pk 20..23)
            mk(794652890.208834, c.henrique, r.henriqueEspresso, 18.5, 9.0, 96, 35, 3, 38.2, .thumbsUp),
            mk(794671497.929506, c.henrique, r.henriqueEspresso, 18.0, 9.0, 96, 38, 3, 37.8, .thumbsUp),
            mk(794672467.961998, c.henrique, r.henriqueEspresso, 18.2, 9.0, 96, 38, 3, 38.9, .thumbsUp),
            mk(794673684.718712, c.henrique, r.henriqueEspresso, 18.7, 9.0, 96, 38, 3, 38.5, .thumbsUp),

            // Henrique / Espresso Robot (pk 25..34)
            mk(794732865.644815, c.henrique, r.henriqueEspressoRobot, 19.4, 12.0, 94, 45, 5, 36.2, .thumbsDown),
            mk(794753183.636013, c.henrique, r.henriqueEspressoRobot, 19.6, 13.0, 96, 36, 4, 37.9, .thumbsUp),
            mk(794820052.269582, c.henrique, r.henriqueEspressoRobot, 19.3, 13.0, 95, 36, 4, 39.4, .thumbsUp),
            mk(794906236.419708, c.henrique, r.henriqueEspressoRobot, 19.4, 14.0, 94, 31, 2, 38.6, .thumbsUp),
            mk(794992452.371193, c.henrique, r.henriqueEspressoRobot, 19.3, 14.0, 95, 29, 2, 36.9, .thumbsUp),
            mk(795082748.228643, c.henrique, r.henriqueEspressoRobot, 18.3, 13.0, 95, 35, 4, 39.1, .thumbsDown),
            mk(795097582.250237, c.henrique, r.henriqueEspressoRobot, 18.6, 13.0, 95, 33, 3, 38.4, .thumbsUp),
            mk(795103417.120541, c.henrique, r.henriqueEspressoRobot, 18.5, 13.0, 95, 34, 3, 36.9, .thumbsUp),
            mk(795169745.283316, c.henrique, r.henriqueEspressoRobot, 18.5, 13.0, 95, 33, 3, 38.1, .thumbsUp),
            mk(795194928.720114, c.henrique, r.henriqueEspressoRobot, 18.5, 13.0, 95, 31, 3, 37.8, .thumbsUp),

            // Bergsonne / Espresso (pk 35..51)
            mk(795218565.068406, c.bergsonne, r.bergsonneEspresso, 19.3, 14.0, 93, 25, 3, 40.3000000000001, .thumbsUp),
            mk(795252489.907753, c.bergsonne, r.bergsonneEspresso, 19.7, 13.0, 93, 38, 5, 38.4, .thumbsUp),
            mk(795275402.807570, c.bergsonne, r.bergsonneEspresso, 18.7, 13.0, 92, 30, 4, 39.2, .thumbsUp),
            mk(795338850.836660, c.bergsonne, r.bergsonneEspresso, 18.6, 13.0, 92, 30, 5, 39.5, .thumbsDown),
            mk(795425634.460686, c.bergsonne, r.bergsonneEspresso, 18.7, 13.0, 92, 31, 4, 37.4, .thumbsDown),
            mk(795511900.864100, c.bergsonne, r.bergsonneEspresso, 19.9, 14.0, 92, 26, 3, 39.9, .thumbsUp),
            mk(795598453.580999, c.bergsonne, r.bergsonneEspresso, 19.7, 14.0, 92, 26, 3, 39.6, .thumbsUp),
            mk(795686399.559896, c.bergsonne, r.bergsonneEspresso, 20.0, 14.0, 92, 29, 4, 39.3, .thumbsUp),
            mk(795707903.593266, c.bergsonne, r.bergsonneEspresso, 20.1, 14.0, 92, 32, 3, 38.4, .thumbsUp),
            mk(795777999.680872, c.bergsonne, r.bergsonneEspresso, 20.3, 14.0, 92, 28, 3, 40.5, .thumbsUp),
            mk(795802205.795590, c.bergsonne, r.bergsonneEspresso, 20.7, 14.0, 92, 28, 3, 39.7, .thumbsUp),
            mk(795858318.416245, c.bergsonne, r.bergsonneEspresso, 20.5, 14.0, 92, 32, 4, 38.4, .thumbsUp),
            mk(795886031.126981, c.bergsonne, r.bergsonneEspresso, 20.4, 14.0, 92, 31, 4, 41.0, .thumbsUp),
            mk(795944262.279894, c.bergsonne, r.bergsonneEspresso, 20.4, 14.0, 92, 27, 5, 40.1, .thumbsDown),
            mk(796030885.669371, c.bergsonne, r.bergsonneEspresso, 19.6, 14.0, 92, 27, 5, 39.4, .thumbsDown),
            mk(796203519.790268, c.bergsonne, r.bergsonneEspresso, 20.7, 14.0, 92, 28, 3, 40.5, .thumbsDown),
            mk(796288912.215333, c.bergsonne, r.bergsonneEspresso, 20.5, 14.0, 92, 27, 3, 38.3, .thumbsUp),

            // Starlight / Espresso (pk 52..56, late refill cycle)
            mk(796381548.284444, c.starlight, r.starlightEspresso, 20.6, 13.0, 95, 30, 3, 38.2, .thumbsUp),
            mk(796403418.207227, c.starlight, r.starlightEspresso, 20.4, 13.0, 95, 27, 4, 38.7, .thumbsUp),
            mk(796463686.866400, c.starlight, r.starlightEspresso, 19.7, 13.0, 95, 26, 3, 37.9, .thumbsUp),
            mk(796488955.473646, c.starlight, r.starlightEspresso, 20.1, 13.0, 95, 27, 3, 38.5, .thumbsUp),
            mk(796804979.376845, c.starlight, r.starlightEspresso, 21.0, 13.0, 95, 29, 3, 38.6, .thumbsDown),

            // Vienna Calling / Flat White travel (pk 57..61)
            mk(796918739.936701, c.vienna, r.viennaFlatWhiteTravel, 18.2, 9.0, 92, 35, 3, 38.1, .thumbsUp),
            mk(796993438.781292, c.vienna, r.viennaFlatWhiteTravel, 18.3, 9.0, 94, 38, 3, 38.4, .thumbsUp),
            mk(797091266.274416, c.vienna, r.viennaFlatWhiteTravel, 18.0, 8.0, 94, 41, 3, 38.4, .thumbsUp),
            mk(797157743.983910, c.vienna, r.viennaFlatWhiteTravel, 18.2, 8.0, 94, 45, 3, 39.3, .thumbsUp),
            mk(797176311.493244, c.vienna, r.viennaFlatWhiteTravel, 18.3, 8.0, 94, 45, 3, 37.2, .thumbsUp),

            // Vienna Calling / Espresso (pk 62..71)
            mk(797239720.447684, c.vienna, r.viennaEspresso, 20.0, 14.0, 92, 24, 5, 42.5000000000001, .thumbsDown),
            mk(797254675.256130, c.vienna, r.viennaEspresso, 20.2, 13.0, 92, 31, 3, 39.7, .thumbsUp),
            mk(797322624.133775, c.vienna, r.viennaEspresso, 19.1, 13.0, 92, 26, 4, 38.0, .thumbsUp),
            mk(797409495.407071, c.vienna, r.viennaEspresso, 19.4, 13.0, 91, 29, 3, 39.4, .thumbsDown),
            mk(797591001.806092, c.vienna, r.viennaEspresso, 18.8, 12.0, 92, 33, 3, 39.0, .thumbsUp),
            mk(797613912.199967, c.vienna, r.viennaEspresso, 18.9, 12.0, 92, 32, 3, 39.7, .thumbsUp),
            mk(797685367.559337, c.vienna, r.viennaEspresso, 18.3, 12.0, 92, 30, 4, 39.9, .thumbsUp),
            mk(797700735.408332, c.vienna, r.viennaEspresso, 18.3, 12.0, 92, 32, 3, 38.7, .thumbsUp),
            mk(797758087.695209, c.vienna, r.viennaEspresso, 18.4, 12.0, 92, 32, 4, 38.5, .thumbsUp),
            mk(797772838.041547, c.vienna, r.viennaEspresso, 18.4, 12.0, 92, 35, 3, 43.3000000000001, .thumbsUp),
        ]
    }

    // MARK: - Complete Sample Data

    /// Seeds a `ModelContext` with the full SchemaV2 sample set built from
    /// `default.store` (5 coffees, 4 equipment, 8 recipes, 5 refills, 71 brews).
    static func seedContext(_ context: ModelContext) throws {
        let equipment = createEquipment()
        let coffees = createCoffees()
        let recipes = createRecipes(coffees: coffees, equipment: equipment)
        let brews = createBrews(coffees: coffees, recipes: recipes)

        for item in equipment.all { context.insert(item) }
        for coffee in coffees.all { context.insert(coffee) }
        for recipe in recipes.all { context.insert(recipe) }
        for brew in brews { context.insert(brew) }

        try context.save()
    }
}

#endif

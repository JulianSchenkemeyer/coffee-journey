# Recipe Name Deprecation

Recipes are identified by their **brewer + grinder** combination instead of a free-text name. A recipe becomes "the parameter ranges for this equipment pair on this coffee."

The phases are ordered so the app keeps compiling and working after each one. The `name` field can stay in the model until Phase 4.

## Open Decisions

Resolve these before starting Phase 2:

- [ ] **Uniqueness:** must each brewer + grinder pair be unique per coffee? Without names, two recipes with the same pair can't be told apart. If yes, `CreateRecipe` / `UpdateRecipe` should reject duplicates, and the form should warn like the coffee duplicate check does.
- [ ] **Equipment deletion:** `Recipe.brewer` and `Recipe.grinder` use `deleteRule: .nullify`. Deleting equipment leaves recipes with no identity. Options: cascade-delete those recipes, block deleting equipment that recipes use, or keep the recipes and show "Unknown brewer/grinder".
- [ ] **Existing data:** what happens to recipes that have no brewer or grinder, or that share a pair with another recipe on the same coffee? Merge them, keep them, or delete them in the migration?

## Phase 1: Display the equipment pair instead of the name

- [x] Add a shared view-layer way to show a recipe's equipment pair (e.g. "Flair 58 · Comandante"), with a fallback when one or both are missing. Keep it out of `Models/Projections/` (formatting belongs to the view).
- [x] `Views/Coffee/Details/RecipeCardView.swift:40-56`: show the pair as the card heading (`.headline`) instead of the `.caption2` capsules.
- [x] `Views/Coffee/Details/RecipeCardView.swift:110`: delete alert says "Delete this recipe?" and puts the pair in the message.
- [x] `Views/Coffee/BrewParameterFormView.swift:29`: recipe picker rows show the pair.
- [x] `Views/Coffee/Details/BrewHistoryView.swift:28`: subtitle uses the pair.
- [x] `Views/Coffee/Details/BrewHistoryView.swift:37`: filter menu items use the pair.
- [x] `Views/Coffee/Details/BrewHistoryView.swift:86`: row title uses the pair; replace the "Unknown Recipe" fallback.
- [x] `Views/Coffee/Details/CoffeeDetailsView.swift:62`: "Filtered by …" uses the pair.
- [x] `Views/Coffee/ConfirmCalibrationModalView.swift:23`: sheet heading uses the pair.

**Verify:** build, then render previews of the recipe card, brew history, brew modal and calibration sheet. No view should read `recipe.name`; check with `grep -rn "recipe.*\.name\|\$0\.name" coffee-journey/Views`.

## Phase 2: Forms and validation

- [ ] `Views/Coffee/Details/RecipeFormContent.swift:33`: remove the "Recipe Name" text field and the `name` binding.
- [ ] `Views/Coffee/Details/RecipeFormView.swift`: remove `name` state and loading; base `isFormValid` on brewer and grinder being selected (plus uniqueness, if decided).
- [ ] `Views/Coffee/Shelf/SetupRecipeView.swift`: same validation change. This also fixes the bug at line 66, where Done is enabled but `submit()` silently returns when no brewer or grinder is selected.
- [ ] Give the brewer and grinder Pickers a matching tag for the initial `nil` value (a "Select…" placeholder), so the selection is valid before the user picks.
- [ ] When no brewers or grinders exist, show a way to add equipment instead of an empty picker.

**Verify:** creating a recipe without equipment is impossible. Done is disabled until both are picked, and saving with both works from both the New Recipe and Set Up Recipe screens.

## Phase 3: Domain layer

- [ ] `Models/DTOs/CreateRecipeRequest.swift`: remove `name`. Make `brewer` and `grinder` non-optional if Phase 2 requires them.
- [ ] `Models/DTOs/UpdateRecipeRequest.swift`: remove `name`; same optionality change.
- [ ] `UseCases/Recipe/CreateRecipe.swift:17`: stop passing `name`; add the duplicate-pair check if decided.
- [ ] `UseCases/Recipe/UpdateRecipe.swift:16`: stop setting `name`; add the duplicate-pair check if decided.
- [ ] `Models/RecipeModel.swift:39,49`: remove `name` from the convenience initializer.
- [ ] Update preview data: `PreviewContent/Recipe+PreviewMocks.swift`, `SampleDataFactory.swift`, `SampleDataFactoryV2.swift`. Give the mocks equipment so previews show real card headings.
- [ ] Update tests that build recipes or requests with `name`: `coffee-journey-tests/UseCases/RecipeUseCasesTests.swift`, `BrewUseCasesTests.swift`, `EquipmentUseCasesTests.swift`, `CoffeeUseCasesTests.swift`, `coffee-journey-tests/Persistence/RecipeRepositoryTests.swift`, `CoffeeRepositoryTests.swift`, `PersistenceTransactionTests.swift`.
- [ ] Add tests for the duplicate-pair rule, if decided.

**Verify:** run `BuildProject` and `XcodeListNavigatorIssues` filtered to test files before trusting test results (see the stale-test-build note in `CLAUDE.md`), then run all tests.

## Phase 4: Schema

- [ ] Add `Persistence/Schema/SchemaV6.swift` with `Recipe` without `name`.
- [ ] Add a V5 → V6 migration stage to `CoffeeJourneyMigrationPlan`, applying the "Existing data" decision above.
- [ ] Point the model typealiases at `SchemaV6`.
- [ ] Add a migration test: a V5 store with named recipes opens under V6 and keeps all parameters, brews and equipment links.

**Verify:** run the app against a V5 store seeded with sample data; recipes and brews are all still there.

## Phase 5: Docs

- [ ] Update `CLAUDE.md`: the schema version list (currently `SchemaV1`–`V3`) and a note that recipes are identified by their equipment pair.

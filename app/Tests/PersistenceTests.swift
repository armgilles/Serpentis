import Foundation

struct PersistenceTests {
    private func withSettings(_ test: (AppDelegate, UserDefaults) throws -> Void) throws {
        let suite = "com.davewoods.serpentis.tests.\(UUID().uuidString)"
        let defaults = try require(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }
        let app = AppDelegate()
        app.settingsDefaults = defaults
        try test(app, defaults)
    }

    func existingLayoutsLoadWithoutMigration() throws {
        try withSettings { app, defaults in
            let data = Data(#"{"Existing":[[1,64,0,2,1,0,30,0,0,0],[1,3,0,1,1,3,0,0,0,0]]}"#.utf8)
            defaults.set(data, forKey: app.layoutsKey)
            let layouts = app.loadLayouts()
            try expect(layouts["Existing"] == [
                RazerMouse.defaultArgs(0), RazerMouse.otherButtons[0].factory,
            ])
            try expect(defaults.data(forKey: app.layoutsKey) == data)
        }
    }

    func layoutsPreserveAllButtonsAndFixedModifiers() throws {
        try withSettings { app, defaults in
            let assignments = SerpentisModel.slots.map {
                RazerMouse.keyArgs($0.id, mod: 3, key: 0x1E)
            }
            let layouts = ["Default": SerpentisModel.slots.map(\.factory), "Custom": assignments]
            app.storeLayouts(layouts)
            try expect(app.loadLayouts() == layouts)
            let stored = try require(defaults.data(forKey: app.layoutsKey))
            let decoded = try JSONDecoder().decode([String: [[UInt8]]].self, from: stored)
            try expect(decoded == layouts)
        }
    }

    func legacyProfilesAllowAbsentOptionalFields() throws {
        try withSettings { app, defaults in
            let data = Data(#"{"Legacy":{"lights":{}}}"#.utf8)
            defaults.set(data, forKey: app.profilesKey)
            let profile = try require(app.loadProfiles()["Legacy"])
            try expect(profile.stages == nil)
            try expect(profile.pollingRate == nil)
            try expect(profile.lights.isEmpty)
            try expect(defaults.data(forKey: app.profilesKey) == data)
        }
    }

    func profilesPreserveDPIAndRawLightingData() throws {
        try withSettings { app, _ in
            let stages = DPIStageSet(active: 2, stages: [DPIStage(x: 800, y: 900), DPIStage(x: 1600, y: 1700)])
            let light = ZoneLight(effect: [1, 4, 1, 0, 0, 1, 100, 150, 200, 0, 0, 0], brightness: 128)
            app.storeProfiles(["Custom": Profile(stages: stages, pollingRate: 500, lights: ["4": light])])
            let restored = try require(app.loadProfiles()["Custom"])
            try expect(restored.stages == stages)
            try expect(restored.pollingRate == 500)
            try expect(restored.lights["4"] == light)
        }
    }
}

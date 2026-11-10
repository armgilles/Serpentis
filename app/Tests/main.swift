import Foundation

let hardware = HardwareRemappingTests()
let assignments = AssignmentTests()
let persistence = PersistenceTests()
let tests: [(String, () throws -> Void)] = [
    ("keyboard writes require an exact echo", hardware.keyboardAssignmentsRequireAnExactEcho),
    ("factory assignments can be restored", hardware.factoryAssignmentsCanBeRestored),
    ("mouse assignments are sent unchanged", hardware.mouseAssignmentsAreSentUnchanged),
    ("button reads return the requested assignment", hardware.buttonReadsReturnTheRequestedAssignment),
    ("busy and unrelated replies do not resend writes", hardware.busyAndUnrelatedRepliesDoNotResendTheWrite),
    ("retries are bounded", hardware.retriesAreBounded),
    ("device failures are not successful writes", hardware.deviceFailuresAreNotSuccessfulWrites),
    ("invalid assignment lengths are not sent", hardware.invalidAssignmentLengthsAreNotSent),
    ("commands have a valid checksum and no extra payload", hardware.commandsHaveAValidChecksumAndNoExtraPayload),
    ("key capture stores explicit modifiers", assignments.keyCaptureStoresExplicitModifiers),
    ("descriptions distinguish bare keys and shortcuts", assignments.descriptionsDistinguishBareKeysAndShortcuts),
    ("defaults accept both keyboard length encodings", assignments.defaultsAcceptBothKeyboardLengthEncodings),
    ("non-keyboard defaults remain distinct", assignments.nonKeyboardDefaultsRemainDistinct),
    ("existing layouts load without migration", persistence.existingLayoutsLoadWithoutMigration),
    ("layouts preserve all buttons and fixed modifiers", persistence.layoutsPreserveAllButtonsAndFixedModifiers),
    ("legacy profiles allow absent optional fields", persistence.legacyProfilesAllowAbsentOptionalFields),
    ("profiles preserve DPI and raw lighting data", persistence.profilesPreserveDPIAndRawLightingData),
]

var failures = 0
for (name, test) in tests {
    do {
        try test()
        print("PASS \(name)")
    } catch {
        failures += 1
        fputs("FAIL \(name): \(error)\n", stderr)
    }
}
print("\(tests.count - failures)/\(tests.count) tests passed")
exit(failures == 0 ? 0 : 1)

import Foundation

let hardware = HardwareRemappingTests()
let assignments = AssignmentTests()
let persistence = PersistenceTests()
let modifiers = PhysicalModifierTests()
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
    ("all physical modifier combinations", modifiers.allPhysicalModifierCombinations),
    ("fixed and physical modifiers are united", modifiers.fixedAndPhysicalModifiersAreUnited),
    ("initial held modifiers affect the first press", modifiers.initialHeldModifiersAffectTheFirstPress),
    ("changes during hold preserve repeats and releases", modifiers.changesDuringHoldPreserveRepeatAndReleaseEvents),
    ("left and right modifiers have independent lifetimes", modifiers.leftAndRightModifiersHaveIndependentLifetimes),
    ("simultaneous buttons preserve shared physical modifiers", modifiers.simultaneousButtonsDoNotReleaseSharedPhysicalModifiers),
    ("mouse and synthetic modifiers are not physical state", modifiers.mouseAndSyntheticModifiersAreNotPhysicalState),
    ("synthetic keyboard events are untouched", modifiers.syntheticKeyboardEventsAreUntouched),
    ("physical keyboards and other devices are untouched", modifiers.physicalKeyboardAndOtherDevicesAreUntouchedEvenForTheSameKey),
    ("unconfigured mouse keys keep fixed behavior", modifiers.unconfiguredMouseKeysKeepTheirFixedBehavior),
    ("all remappable categories use the same filter", modifiers.allRemappableCategoriesUseTheSameFilter),
    ("ambiguous hardware outputs are rejected", modifiers.ambiguousHardwareOutputsAreRejected),
    ("left click and non-keyboard actions cannot opt in", modifiers.leftClickAndNonKeyboardActionsCannotEnableTheOption),
    ("missing identity never becomes global interception", modifiers.missingIdentityDoesNotBecomeGlobalInterception),
    ("mouse modifier releases preserve physical holds", modifiers.mouseModifierReleaseDoesNotClearAPhysicallyHeldModifier),
    ("keyboard disconnection only removes that keyboard", modifiers.keyboardDisconnectionOnlyRemovesThatKeyboard),
    ("stopping during a hold invents no releases", modifiers.stoppingDuringHoldDoesNotInventKeyOrModifierReleases),
    ("legacy settings default to fixed shortcuts", persistence.legacySettingsDefaultToFixedShortcutsWithoutRewritingData),
    ("modifier options round trip separately", persistence.modifierOptionsRoundTripSeparatelyFromHardwareAssignments),
    ("corrupted modifier settings report an error", persistence.corruptedModifierSettingsReportADecodingError),
    ("loading a legacy layout disables the option", persistence.loadingALegacyLayoutDisablesTheOptInMode),
    ("disabling does not rewrite hardware bindings", persistence.disablingDoesNotRewriteHardwareBindings),
    ("ambiguous options fail before hardware writes", persistence.ambiguousOptionsFailBeforeWritingHardwareOrPreferences),
    ("rejected writes restore the previous assignment", persistence.rejectedWritesRestoreThePreviousHardwareAssignment),
    ("shared outputs can be explicitly disabled together", persistence.sharedOutputsCanBeExplicitlyDisabledTogether),
    ("profile storage does not change modifier options", persistence.profileStorageDoesNotChangeModifierOptions),
    ("mouse and scroll actions are not transformed", modifiers.mouseAndScrollActionsAreNotTransformed),
    ("dynamic options customize only software state", assignments.dynamicOptionsMarkTheAssignmentAsCustomizedWithoutChangingHardwareData),
    ("captured assignments are not known factory defaults", assignments.capturedAssignmentsAreNotTreatedAsKnownFactoryDefaults),
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

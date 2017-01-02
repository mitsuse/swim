import Carbon

func listRawInputSources() -> [TISInputSource] {
    let list =  TISCreateInputSourceList(nil, false)
        .takeRetainedValue()
        as! [TISInputSource]

    return list.filter { source in
        let category = extractCategory(of: source)
        let keyboardInputSource = kTISCategoryKeyboardInputSource as String
        return category == keyboardInputSource && isSelectable(source)
    }
}

var currentRawInputSource: TISInputSource {
    return TISCopyCurrentKeyboardInputSource().takeRetainedValue()
}

func extractRawIdentifier(of rawInputSource: TISInputSource) -> String {
    return Unmanaged<NSString>
        .fromOpaque(TISGetInputSourceProperty(rawInputSource, kTISPropertyBundleID))
        .takeUnretainedValue()
        as String
}

func extractName(of rawInputSource: TISInputSource) -> String {
    return Unmanaged<NSString>
        .fromOpaque(TISGetInputSourceProperty(rawInputSource, kTISPropertyLocalizedName))
        .takeUnretainedValue()
        as String
}

func extractCategory(of rawInputSource: TISInputSource) -> String {
    return Unmanaged<NSString>
        .fromOpaque(TISGetInputSourceProperty(rawInputSource, kTISPropertyInputSourceCategory))
        .takeUnretainedValue()
        as String
}

func isSelectable(_ rawInputSource: TISInputSource) -> Bool {
    return Unmanaged<NSNumber>
        .fromOpaque(TISGetInputSourceProperty(
            rawInputSource,
            kTISPropertyInputSourceIsSelectCapable)
        )
        .takeUnretainedValue()
        .boolValue
}

func selectRawInputSource(_ rawInputSource: TISInputSource) -> Bool {
    return TISSelectInputSource(rawInputSource) == Carbon.noErr
}

//
//  Haptics.swift
//  Luga
//
//  Created by Murray Buchanan on 03/07/2023.
//  Copyright © 2023 Murray Buchanan. All rights reserved.
//

import CoreHaptics

class HapticManager {
    let hapticEngine: CHHapticEngine
    init?() {
        let hapticCapability = CHHapticEngine.capabilitiesForHardware()
        guard hapticCapability.supportsHaptics else {
            return nil
        }

        do {
            hapticEngine = try CHHapticEngine()
        } catch let error {
            print("Haptic engine Creation Error: \(error)")
            return nil
        }
    }
    
    func playHaptic() {
        do {
            let pattern = try hapticPattern()
            try hapticEngine.start()
            let player = try hapticEngine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
            hapticEngine.notifyWhenPlayersFinished { _ in
                return .stopEngine
            }
        } catch {
            print("Failed to play slice: \(error)")
        }
    }
}

extension HapticManager {
  private func hapticPattern() throws -> CHHapticPattern {
    let haptic1 = CHHapticEvent(
      eventType: .hapticContinuous,
      parameters: [
        CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.2),
        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
      ],
      relativeTime: 0,
      duration: 0.25)

    let haptic2 = CHHapticEvent(
      eventType: .hapticTransient,
      parameters: [
        CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.2),
        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
      ],
      relativeTime: 0,
      duration: 0.25
    )
      
    return try CHHapticPattern(events: [haptic1, haptic2], parameters: [])
  }
}

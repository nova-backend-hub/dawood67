import Foundation
import MediaPlayer
import AVFoundation

final class VolumeButtonHandler: ObservableObject {
    private var audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    private var volumeObserver: NSKeyValueObservation?
    private var hiddenVolumeView: MPVolumeView?
    private var initialVolume: Float = 0.5
    private var isSuppressingFeedback = false
    
    var onVolumeUp: (() -> Void)?
    var onVolumeDown: (() -> Void)?
    
    init() {
        setupAudioSession()
    }
    
    deinit {
        volumeObserver?.invalidate()
    }
    
    func startListening() {
        setupAudioSession()
        attachVolumeObserver()
    }
    
    func stopListening() {
        volumeObserver?.invalidate()
        volumeObserver = nil
    }
    
    private func setupAudioSession() {
        do {
            try audioSession.setCategory(.ambient, options: [.mixWithOthers])
            try audioSession.setActive(true)
            initialVolume = audioSession.outputVolume
        } catch {
            print("Failed to activate audio session: \(error)")
        }
        
        if hiddenVolumeView == nil {
            let volumeView = MPVolumeView(frame: CGRect(x: -200, y: -200, width: 1, height: 1))
            volumeView.clipsToBounds = true
            volumeView.alpha = 0.001
            hiddenVolumeView = volumeView
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.addSubview(volumeView)
            }
        }
    }
    
    private func attachVolumeObserver() {
        volumeObserver?.invalidate()
        volumeObserver = audioSession.observe(\.outputVolume, options: [.new, .old]) { [weak self] session, change in
            guard let self = self else { return }
            guard !self.isSuppressingFeedback else { return }
            
            guard let newVol = change.newValue, let oldVol = change.oldValue else { return }
            
            if newVol > oldVol {
                DispatchQueue.main.async {
                    self.onVolumeUp?()
                }
            } else if newVol < oldVol {
                DispatchQueue.main.async {
                    self.onVolumeDown?()
                }
            } else {
                // If maxed out (1.0) or minimum (0.0), still trigger based on boundary hit
                if newVol >= 0.99 {
                    DispatchQueue.main.async { self.onVolumeUp?() }
                } else if newVol <= 0.01 {
                    DispatchQueue.main.async { self.onVolumeDown?() }
                }
            }
            
            // Keep volume around middle (0.5) so user can press up or down repeatedly without hitting system limits
            self.resetVolumeToMiddle()
        }
    }
    
    private func resetVolumeToMiddle() {
        guard let slider = hiddenVolumeView?.subviews.first(where: { $0 is UISlider }) as? UISlider else { return }
        isSuppressingFeedback = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            slider.setValue(0.5, animated: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.isSuppressingFeedback = false
            }
        }
    }
}

//
//  ReplayKitViewController.swift
//  ProjDemo
//
//  Created by MAC on 12/11/24.
//

import ReplayKit

class ReplayKitViewController: UIViewController, RPScreenRecorderDelegate, RPPreviewViewControllerDelegate {
    func startRecording() {
        let recorder = RPScreenRecorder.shared()
        recorder.delegate = self
        recorder.startRecording { (error) in
            if let error = error {
                print("Error starting recording: \(error.localizedDescription)")
            } else {
                print("Recording started successfully.")
            }
        }
    }

    func stopRecording() {
        if RPScreenRecorder.shared().isRecording {
            RPScreenRecorder.shared().stopRecording { [weak self] (previewVC, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error stopping recording: \(error.localizedDescription)")
                    return
                }
                
                if let previewVC = previewVC {
                    previewVC.previewControllerDelegate = self
                    
                    // Export the video to a file in the app's Documents directory
                    if let movieURL = previewVC.value(forKey: "_movieURL") as? URL {
                        self.saveRecordingToDocumentsDirectory(movieURL)
                    } else {
                        print("Failed to retrieve recording URL.")
                    }
                }
            }
        } else {
            print("Recording is not in progress.")
        }
    }

    private func saveRecordingToDocumentsDirectory(_ movieURL: URL) {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let outputURL = documentsDirectory.appendingPathComponent("ScreenRecording.mp4")
        
        do {
            if fileManager.fileExists(atPath: outputURL.path) {
                try fileManager.removeItem(at: outputURL)
            }
            try fileManager.copyItem(at: movieURL, to: outputURL)
            print("Recording saved successfully at: \(outputURL)")
        } catch {
            print("Error saving recording: \(error.localizedDescription)")
        }
    }
}

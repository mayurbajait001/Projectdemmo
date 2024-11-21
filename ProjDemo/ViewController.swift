//
//  ViewController.swift
//  ProjDemo
//
//  Created by MAC on 12/11/24.
//

import AVKit
import AVFoundation

class ViewController: UIViewController {
    private var videoPlayer: AVPlayer?
    private var playerLayer: AVPlayerLayer!
    private let captureSession = AVCaptureSession()
    private var cameraLayer: AVCaptureVideoPreviewLayer!
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var videoView: UIView!
    
    var isRecording = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playVideo()
        setupCamera()
    }
    
    func playVideo() {
        guard let url = Bundle.main.url(forResource: "SampleVideo", withExtension: "mp4") else { return }
        videoPlayer = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: videoPlayer)
        playerLayer.frame = videoView.bounds
        videoView.layer.addSublayer(playerLayer)
        videoPlayer?.play()
    }
    
    func setupCamera() {
        captureSession.sessionPreset = .photo
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: frontCamera) else { return }
        captureSession.addInput(input)
        
        cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraLayer.frame = cameraView.bounds
        cameraLayer.videoGravity = .resizeAspectFill
        cameraView.layer.addSublayer(cameraLayer)
        
        captureSession.startRunning()
    }
    
    @IBAction func onClickPlayStopReco(_ sender: UIButton) {
        if isRecording {
            ReplayKitViewController().stopRecording()
        } else {
            ReplayKitViewController().startRecording()
        }
        self.isRecording.toggle()
    }
}

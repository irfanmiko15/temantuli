//
//  FrameViewModel.swift
//  TemanTuli
//
//  Created by Irfan Dary Sujatmiko on 07/08/23.
//

import Foundation
import AVFoundation
import SwiftUI

class FrameViewModel: NSObject, ObservableObject {
    // 2
    @EnvironmentObject var classificationViewModel : ClassificationViewModel
    
    static let shared = FrameViewModel()
    // 3
    @Published var current: CVPixelBuffer?
    // 4
    let videoOutputQueue = DispatchQueue(
        label: "com.raywenderlich.VideoOutputQ",
        qos: .userInitiated,
        attributes: [],
        autoreleaseFrequency: .workItem)
    // 5
    private override init() {
        super.init()
        CameraViewModel.shared.set(self, queue: videoOutputQueue)
    }
}

extension FrameViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        if let buffer = sampleBuffer.imageBuffer {
            DispatchQueue.main.async {
                self.current = buffer
            }
        }
    }
}

//
//  CameraPreview.swift
//  TemanTuli
//
//  Created by Irfan Dary Sujatmiko on 07/08/23.
//

import Foundation
import UIKit
import AVFoundation

final class CameraPreview: UIView{
    
    var previewLayer : AVCaptureVideoPreviewLayer{
        layer as! AVCaptureVideoPreviewLayer
    }
    
    override class var layerClass: AnyClass{
        AVCaptureVideoPreviewLayer.self
    }
}

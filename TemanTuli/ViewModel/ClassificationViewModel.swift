//
//  ClassificationViewModel.swift
//  TemanTuli
//
//  Created by Irfan Dary Sujatmiko on 07/08/23.
//
import Foundation
import UIKit
import CoreML
import Vision
import SwiftUI


class ClassificationViewModel: ObservableObject {
    
    private var model = ContentViewModel()
    
    
    @Published var classificationLabel: String = ""
    @Published var name: String = ""
    @Published var text: String = ""
    var onLoop = false
    let mlmodel = TuliHand()
    
    @Published private var image: UIImage? = UIImage(named: "prova")
    @Published private var shouldPresentImagePicker = false
    @Published private var shouldPresentActionScheet = false
    @Published private var shouldPresentCamera = false
    private var handPoseRequest = VNDetectHumanHandPoseRequest()
    
    func classifyImage(tmpImage: UIImage) {
        var newShape = [NSNumber(value: 60),NSNumber(value: 3),NSNumber(value: 21)]
        let image = tmpImage
        let resizedImage = image.resizeImageTo(size: CGSize(width: 224, height: 224))
        let buffer = resizedImage?.convertToBuffer()
        if buffer == nil {
            print("Buffer is empty")
            return
        }
        //How many hands to detect
        handPoseRequest.maximumHandCount = 1
        guard let imageData = image.jpegData(compressionQuality: 0) else {
            return
        }
        let handler = VNImageRequestHandler(data: imageData, options: [:])
        
        
        do {
            // Perform VNDetectHumanHandPoseRequest
            try handler.perform([handPoseRequest])
            // Continue only when a hand was detected in the frame.
            // Since we set the maximumHandCount property of the request to 1, there will be at most one observation.
            var prediction: String = ""
            let observation = handPoseRequest.results?.first
            if observation == nil {name = "The selected picture is not valid"
                classificationLabel = ""
                
            }
            guard let keypointsMultiArray = try? observation?.keypointsMultiArray() else {
                name = "The slected picture is not valid"
                classificationLabel =  ""
                return }
            var newMLMultiArray = try? MLMultiArray(shape: newShape, dataType: keypointsMultiArray.dataType)
            for i in 0..<Int(keypointsMultiArray.count) {
                newMLMultiArray?[i] = keypointsMultiArray[i]
            }
            
            let handPosePrediction = try mlmodel.prediction(poses: newMLMultiArray!)
            let confidence = handPosePrediction.labelProbabilities[handPosePrediction.label]!
            prediction = handPosePrediction.label
            let shortConfidence = confidence.format(f: ".3")
            classificationLabel = "\(shortConfidence)"
            name = "\(prediction)"
            print(prediction)
            print(confidence)
            if confidence > 0.8 {
                text=prediction
                print (text)
            }
            
            
        } catch {
            print("Error")
        }
    }
    
    func callFunc() {
        if onLoop {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
                if model.frame != nil {
                    classifyImage(tmpImage: UIImage(cgImage: model.frame!))
                    if onLoop {callFunc()}
                }
            }
            print("DENTRO")
        } else {
            return
        }
    }
    
    
}

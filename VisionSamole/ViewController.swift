//
//  ViewController.swift
//  VisionSamole
//
//  Created by Harada Hiroaki on 2019/03/24.
//  Copyright © 2019 Harada Hiroaki. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {
    
    @IBOutlet weak var sampleImage: UIImageView!
    
    
    @IBOutlet weak var resultImage: UIImageView!
    
    //private let originalImage = UIImage(named: "sample2.jpg")
    //private let originalImage = UIImage(named: "sample6.jpg")
    //private let originalImage = UIImage(named: "sample8.jpg")
    private let originalImage = UIImage(named: "sampleText.jpg")

    override func viewDidLoad() {
        sampleImage.image = originalImage
        //顔検出の場合、下記関数を実行
        //faceDetection()
        
        //文字検出の場合、下記関数を実行
        textDetection()
    }
    
    //顔検出
    func faceDetection() {
            let request = VNDetectFaceRectanglesRequest { (request, error) in
                var image = self.originalImage
                for observation in request.results as! [VNFaceObservation] {
                    //結果をコマンドプロンプトへ
                    print(observation)
                    
                    //結果を画面下部に表示
                    image = self.drawFaceRectangle(image: image, observation: observation)
                }
                self.resultImage.image = image
            }
        if let cgImage = self.originalImage?.cgImage {
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try? handler.perform([request])
        }
    }
    
    //文字検出
    func textDetection() {
        let request = VNDetectTextRectanglesRequest { (request, error) in
            var image = self.originalImage
            for observation in request.results as! [VNTextObservation] {
                print(observation)
                
                //結果を画面下部に表示
                image = self.drawFaceRectangle(image: image, observation: observation)
            }
            self.resultImage.image = image
        }
        if let cgImage = self.originalImage?.cgImage {
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try? handler.perform([request])
        }
    }
    
    
    //顔検出の際に矩形で囲む
    private func drawFaceRectangle(image: UIImage?, observation: VNFaceObservation) -> UIImage? {
        let imageSize = image!.size
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        image?.draw(in: CGRect(origin: .zero, size: imageSize))
        context?.setLineWidth(4.0)
        context?.setStrokeColor(UIColor.green.cgColor)
        context?.stroke(observation.boundingBox.converted(to: imageSize))
        let drawnImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return drawnImage
    }
    
    //文字検出の際に矩形で囲む
    private func drawFaceRectangle(image: UIImage?, observation: VNTextObservation) -> UIImage? {
        let imageSize = image!.size
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        image?.draw(in: CGRect(origin: .zero, size: imageSize))
        context?.setLineWidth(4.0)
        context?.setStrokeColor(UIColor.green.cgColor)
        context?.stroke(observation.boundingBox.converted(to: imageSize))
        let drawnImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return drawnImage
    }
    
    
}

extension CGRect {
    func converted(to size: CGSize) -> CGRect {
        return CGRect(x: self.minX * size.width,
                      y: (1 - self.maxY) * size.height,
                      width: self.width * size.width,
                      height: self.height * size.height)
    }
}


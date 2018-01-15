//
//  CompileViewController.swift
//  CoreMLCompileSample
//
//  Created by Yusuke Taniguchi on 2017/10/06.
//  Copyright © 2017年 Yusuke Taniguchi. All rights reserved.
//

import UIKit
import CoreML

class CompileViewController: UIViewController {
    
    let totalCalculatedTimes = 100
    
    enum ModelName: String {
        case GoogLeNetPlaces
        case MobileNet
        case Resnet50
        case SqueezeNet
        case VGG16
    }
    
    var modelName: ModelName!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var indicatorParentView: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var indicatorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = modelName.rawValue
        showIndicatorView()
        
        let dispatchQueue = DispatchQueue(label: "compile", qos: .background)
        dispatchQueue.async { [weak self] in
            guard let strongSelf = self else { return }
            
            var allCalculatedResult: [TimeInterval] = []
            for i in 0..<strongSelf.totalCalculatedTimes {
                let startedDate = Date()
                guard let url = Bundle.main.url(forResource: strongSelf.modelName.rawValue, withExtension: "bin") else { fatalError("url not found") }
                let modelcURL: URL
                do {
                    modelcURL = try MLModel.compileModel(at: url)
                } catch let error {
                    fatalError("model compile error: \(error)")
                }
                
                let endedDate = Date()
                let result = endedDate.timeIntervalSince1970 - startedDate.timeIntervalSince1970
                allCalculatedResult.append(result)
                
                try? FileManager.default.removeItem(at: modelcURL)
                
                DispatchQueue.main.async {
                    self?.setIndicatorLabel(time: i + 1)
                }
            }
            
            let totalCalculatedSeconds = allCalculatedResult.reduce(0.0, { (total, seconds) -> TimeInterval in
                return total + seconds
            })
            let time = totalCalculatedSeconds / Double(strongSelf.totalCalculatedTimes)
            
            DispatchQueue.main.async {
                self?.hideIndicatorView()
                self?.label.text = "\(String(time)) seconds."
            }
        }
    }
    
    private func showIndicatorView() {
        indicatorParentView.isHidden = false
        indicatorView.startAnimating()
        setIndicatorLabel(time: 0)
    }
    
    private func setIndicatorLabel(time: Int) {
        indicatorLabel.text = "\(time) / \(totalCalculatedTimes)"
    }
    
    private func hideIndicatorView() {
        indicatorView.stopAnimating()
        indicatorParentView.isHidden = true
    }
}

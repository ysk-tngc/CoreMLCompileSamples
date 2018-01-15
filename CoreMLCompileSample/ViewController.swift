//
//  ViewController.swift
//  CoreMLCompileSample
//
//  Created by Yusuke Taniguchi on 2017/10/06.
//  Copyright © 2017年 Yusuke Taniguchi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var model: CompileViewController.ModelName?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard "compile" == segue.identifier else {
            return
        }
        
        let dest = segue.destination as! CompileViewController
        dest.modelName = self.model
    }
    
    private func didPushButton(model: CompileViewController.ModelName) {
        self.model = model
        performSegue(withIdentifier: "compile", sender: nil)
    }

    @IBAction func googLeNetButton(_ sender: Any) {
        didPushButton(model: .GoogLeNetPlaces)
    }
    
    @IBAction func mobileNet(_ sender: Any) {
        didPushButton(model: .MobileNet)
    }
    
    @IBAction func resnet(_ sender: Any) {
        didPushButton(model: .Resnet50)
    }
    
    @IBAction func squeeze(_ sender: Any) {
        didPushButton(model: .SqueezeNet)
    }
    
    @IBAction func vgg(_ sender: Any) {
        didPushButton(model: .VGG16)
    }
}


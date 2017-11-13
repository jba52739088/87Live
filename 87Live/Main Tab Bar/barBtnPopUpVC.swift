//
//  barBtnPopUpVC.swift
//  customAlert
//
//  Created by 黃恩祐 on 2017/11/2.
//  Copyright © 2017年 ENYUHUANG. All rights reserved.
//

import UIKit

class barBtnPopUpVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var btnVideo: UIButton!
    @IBOutlet weak var btnLive: UIButton!
    @IBOutlet weak var btnWolf: UIButton!
    
    var completionHandler: ((UIImage) -> Void)?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        completionHandler = { image in
            let popOverVC = UIStoryboard(name: "Firebase", bundle: nil).instantiateViewController(withIdentifier: "postVC") as! postVC
            self.parent?.addChildViewController(popOverVC)
            self.appDelegate.postImage = image
            popOverVC.view.frame = (self.parent?.view.frame)!
            self.parent?.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParentViewController: self.parent)
        }
        
        let imageArray = ["doCamera", "doVideo", "doLive", "doWolf"]
        let tempImage1 = UIImage(named: imageArray[0])?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        let tempImage2 = UIImage(named: imageArray[1])?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        let tempImage3 = UIImage(named: imageArray[2])?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        let tempImage4 = UIImage(named: imageArray[3])?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        let imgCamera = UIImageView()
        imgCamera.image = tempImage1
        imgCamera.tintColor = UIColor.white
        let imgVideo = UIImageView()
        imgVideo.image = tempImage2
        imgVideo.tintColor = UIColor.white
        let imgLive = UIImageView()
        imgLive.image = tempImage3
        imgLive.tintColor = UIColor.white
        let imgWolf = UIImageView()
        imgWolf.image = tempImage4
        imgWolf.tintColor = UIColor.white
        
        self.btnCamera.setImage(imgCamera.image, for: .normal)
        self.btnCamera.tintColor = UIColor.white
        self.btnCamera.setTitle("", for: .normal)
        self.btnVideo.setImage(imgVideo.image, for: .normal)
        self.btnVideo.tintColor = UIColor.white
        self.btnVideo.setTitle("", for: .normal)
        self.btnLive.setImage(imgLive.image, for: .normal)
        self.btnLive.tintColor = UIColor.white
        self.btnLive.setTitle("", for: .normal)
        self.btnWolf.setImage(imgWolf.image, for: .normal)
        self.btnWolf.tintColor = UIColor.white
        self.btnWolf.setTitle("", for: .normal)
        
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        showAnimate()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(quit)))
    }
    
    @objc func quit() {
        self.removeAnimate()
    }
    


    
    @IBAction func doCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.presentImagePickerController(with: .camera, from: self)
        }
        self.view.removeFromSuperview()
    }
    
    @IBAction func doVideo(_ sender: Any) {
    }
    
    @IBAction func doLive(_ sender: Any) {
        self.performSegue(withIdentifier: "PushV", sender: self)
    }
    
    @IBAction func doWolf(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.presentImagePickerController(with: .photoLibrary, from: self)
            }
         self.view.removeFromSuperview()
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.btnCamera.frame.origin.y = self.btnCamera.frame.origin.y + self.view.frame.height
        self.btnVideo.frame.origin.y = self.btnVideo.frame.origin.y + self.view.frame.height
        self.btnLive.frame.origin.y = self.btnLive.frame.origin.y + self.view.frame.height
        self.btnWolf.frame.origin.y = self.btnWolf.frame.origin.y + self.view.frame.height
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
        
        UIView.animate(withDuration: 0.25) {
            self.btnCamera.frame.origin.y = self.btnCamera.frame.origin.y - self.view.frame.height
            self.btnVideo.frame.origin.y = self.btnVideo.frame.origin.y - self.view.frame.height
        }
        
        UIView.animate(withDuration: TimeInterval(0.8), delay: 0,
                       usingSpringWithDamping: 0.45,
                       initialSpringVelocity: 0.05, options: .curveLinear, animations: {
                        self.btnLive.frame.origin.y = self.btnLive.frame.origin.y - self.view.frame.height
                        self.btnWolf.frame.origin.y = self.btnWolf.frame.origin.y - self.view.frame.height
        }, completion: nil)
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.btnCamera.frame.origin.y = self.btnCamera.frame.origin.y + self.view.frame.height
            self.btnVideo.frame.origin.y = self.btnVideo.frame.origin.y + self.view.frame.height
            self.btnLive.frame.origin.y = self.btnLive.frame.origin.y + self.view.frame.height
            self.btnWolf.frame.origin.y = self.btnWolf.frame.origin.y + self.view.frame.height
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    /////
    func presentImagePickerController(with sourceType: UIImagePickerControllerSourceType, from viewController: UIViewController) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        
        viewController.present(imagePickerController, animated: true)
        
    }
    
    //ImagePickerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            completionHandler?(selectedImage)
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

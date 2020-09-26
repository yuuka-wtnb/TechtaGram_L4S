//
//  ViewController.swift
//  Techtagram_L4S
//
//  Created by Yuuka Watanabe on 2020/09/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var cameraImageView: UIImageView!
    
    var originalImage: UIImage!
    var filter: CIFilter!
    
    var imagenameArray: [String] = ["hana", "onpu"]
    var imageIndex: Int = 0
    
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func camera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            
            picker.allowsEditing = true
            
            present(picker, animated: true, completion: nil)
            
        }else{
            print("error")
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        cameraImageView.image = info[.editedImage] as? UIImage
        originalImage = cameraImageView.image
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func album(){
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            
            picker.allowsEditing = true
            
            present(picker, animated: true, completion: nil)
            
        }
    }
    
    
    @IBAction func filterImage(){
        let filterImage = CIImage(image: originalImage)!
        
        //        フィルターの設定
        filter = CIFilter(name: "CIColorControls")!
        filter.setValue(filterImage, forKey: kCIInputImageKey)
        
        //        彩度の調整
        filter.setValue(1.0, forKey: "inputSaturation")
        
        //        明度の調整
        filter.setValue(0.5, forKey: "inputBrightness")
        
        //        コントラストの調整
        filter.setValue(2.5, forKey: "inputContrast")
        
        let ctx = CIContext(options: nil)
        let cgImage = ctx.createCGImage(filter.outputImage!, from: filter.outputImage!.extent)
        cameraImageView.image = UIImage(cgImage: cgImage!)
        
    }
    
    @IBAction func save(){
        
        let rect:CGRect = cameraImageView.frame
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.translateBy(x: -rect.minX, y: -rect.minY)
        self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let capture = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(capture!, nil, nil, nil)
        
    }
    
    @IBAction func share(){
        
        let shareText = "コメント"
        
        //        投稿する画像の選択
        let shareImage = cameraImageView.image!
        
        //        投稿するコメントと画像の準備
        let activityItems: [Any] = [shareText, shareImage]
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        let excludedActivityTypes = [UIActivity.ActivityType.postToWeibo, .saveToCameraRoll, .print]
        
        activityViewController.excludedActivityTypes = excludedActivityTypes
        
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func selectedFirst(){
        imageIndex = 1
        
    }
    
    @IBAction func selectedSecond(){
        imageIndex = 2
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.location(in: self.view)
        
        if imageIndex != 0{
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            
            let image: UIImage = UIImage(named: imagenameArray [imageIndex - 1])!
            imageView.image = image
            
            imageView.center = CGPoint(x: location.x, y: location.y)
            
            self.view.addSubview(imageView)
            
        }
    }
    
}


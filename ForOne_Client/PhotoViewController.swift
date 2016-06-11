//
//  PhotoViewController.swift
//  ForOne_Client
//
//  Created by ganyi on 16/6/3.
//  Copyright © 2016年 gan. All rights reserved.
//

import UIKit

@IBDesignable
class PhotoViewController: UIViewController {

    @IBOutlet var backgroundView: UIView!
    @IBInspectable @IBOutlet weak var photoImageView: UIImageView!
    
    @IBInspectable @IBOutlet weak var finishButton: UIButton!
    
    @IBOutlet weak var skipButton: UIButton!
    
    var photoImage:UIImage?
    
    var circleLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //修正颜色
        backgroundView.backgroundColor = lightColor
        finishButton.backgroundColor = darkColor
        
        //完成按钮
        finishButton.layer.cornerRadius = finishButton.frame.size.width / 2
        
        //头像
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(ovalInRect: photoImageView.bounds).CGPath
        photoImageView.layer.mask = maskLayer
        
        //绘制圆环
        circleLayer.path = maskLayer.path
        circleLayer.strokeColor = darkColor!.CGColor
        circleLayer.lineWidth = 12
        circleLayer.fillColor = UIColor.clearColor().CGColor
        photoImageView.layer.addSublayer(circleLayer)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //修正颜色
        backgroundView.backgroundColor = lightColor
        finishButton.backgroundColor = darkColor
        circleLayer.strokeColor = darkColor!.CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    
    //MARK:点击头像，选择获取图片方式
    @IBAction func tapToSetImage(sender: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: nil, message: "获取头像", preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel){
            action in
        }
        alertController.addAction(cancelAction)
        let libraryAction = UIAlertAction(title: "相册", style: .Default){
            action in
            self.selectPhotoFromLibrary()
        }
        alertController.addAction(libraryAction)
        let cameraAction = UIAlertAction(title: "摄像头", style: .Default){
            action in
            self.selectPhotoFromCamera()
        }
        alertController.addAction(cameraAction)
        presentViewController(alertController, animated: true){}
    }
    
    //MARK:从照片库中挑选图片
    private func selectPhotoFromLibrary(){
        guard UIImagePickerController.isSourceTypeAvailable(.Camera) else{
            let alertController = UIAlertController(title: "选择头像", message: "相机获取图片失效", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "我知道了", style: .Cancel){
                action in
                print(action)
            }
            alertController.addAction(cancelAction)
            presentViewController(alertController, animated: true){}
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.allowsEditing = true
        imagePicker.modalPresentationStyle = .CurrentContext
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //MARK:从相机中拍摄图片
    private func selectPhotoFromCamera(){
        
        guard UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum) else{
            let alertController = UIAlertController(title: "选择头像", message: "获取相册图片失效", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "我知道了", style: .Cancel){
                action in
                print(action)
            }
            alertController.addAction(cancelAction)
            presentViewController(alertController, animated: true){}
            return
        }
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = UIImagePickerControllerSourceType.Camera
        cameraPicker.modalPresentationStyle = .CurrentContext
        cameraPicker.allowsEditing = true
//        cameraPicker.cameraOverlayView = ? 覆盖在相机上
        cameraPicker.showsCameraControls = true
        cameraPicker.cameraDevice = .Front
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    //MARK:完成照片选择
    @IBAction func finished(sender: UIButton) {
        guard let image:UIImage = photoImage else{
            
            let alertController = UIAlertController(title: "上传照片", message: "如果未选择头像，系统将使用默认头像，稍后可以在个人设置中修改", preferredStyle: .Alert)
            let backAction = UIAlertAction(title: "返回选择照片", style: .Default){
                action in
                //返回选择照片

            }
            alertController.addAction(backAction)
            let skipAction = UIAlertAction(title: "使用默认照片", style: .Default){
                action in
                //跳过，并使用默认头像
                self.next()
            }
            alertController.addAction(skipAction)
            presentViewController(alertController, animated: true){}
            return
        }
        
        //上传头像
        Session.upload(image){
            success in
            if success{
                //上传成功
                self.next()
            }else{
                //上传失败
                let alertController = UIAlertController(title: "未完成", message: "上传照片出错", preferredStyle: .Alert)
                let backAction = UIAlertAction(title: "我知道了", style: .Default){
                    action in
                }
                alertController.addAction(backAction)
                self.presentViewController(alertController, animated: true){
                    self.skipButton.hidden = false
                }
                
            }
        }
    }
    
    //MARK:跳过照片选择
    @IBAction func skip(sender: UIButton) {
        next()
    }
    
    //MARK:载入信息填写
    private func next(){
        let infoTableViewController = mainStoryboard.instantiateViewControllerWithIdentifier("infotableviewcontroller")
        navigationController?.pushViewController(infoTableViewController, animated: true)    
    }
}

//MARK:照片库delegate
extension PhotoViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        photoImage = image
        photoImageView.layer.contents = image.CGImage
        picker.dismissViewControllerAnimated(true){}
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true){}
    }
}
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

    @IBInspectable @IBOutlet weak var photoImageView: UIImageView!
    
    @IBInspectable @IBOutlet weak var finishButton: UIButton!
    
    @IBOutlet weak var skipButton: UIButton!
    var photoImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoImageView.layer.cornerRadius = photoImageView.frame.size.width / 2
        finishButton.layer.cornerRadius = finishButton.frame.size.width / 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    
    //MARK:完成照片选择
    @IBAction func finished(sender: UIButton) {
        guard let image:UIImage = photoImage else{
            let alertView = UIAlertView(title: "上传照片", message: "如果未选择头像，系统将使用默认头像，稍后可以在个人设置中修改", delegate: self, cancelButtonTitle: "返回选择照片", otherButtonTitles: "使用默认照片")
            alertView.show()
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
                let alertView = UIAlertView(title: "未完成", message: "上传照片出错", delegate: nil, cancelButtonTitle: "我知道了")
                alertView.show()
                
                self.skipButton.hidden = false
            }
        }
    }
    
    //MARK:跳过照片选择
    @IBAction func skip(sender: UIButton) {
        next()
    }
    
    private func next(){
        print("next")
    }
}

extension PhotoViewController:UIAlertViewDelegate{
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        //跳过，并使用默认头像
    }
    
    func alertViewCancel(alertView: UIAlertView) {
        //返回选择照片
    }
}
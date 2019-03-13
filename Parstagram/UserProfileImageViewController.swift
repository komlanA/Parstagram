//
//  UserProfileImageViewController.swift
//  Parstagram
//
//  Created by Komlan Attiogbe on 3/12/19.
//  Copyright © 2019 Komlan Attiogbe. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class UserProfileImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = PFUser.current()!
        if (user["profile_image"] != nil) {
        let imageFile = user["profile_image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
            
        profileImageView.af_setImage(withURL: url)
        profileImageView.layer.borderWidth = 0
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        }
        
    }
    
    @IBAction func onChangeProfileButton(_ sender: Any) {
        let user = PFUser.current()!
        let imageData = profileImageView.image!.pngData()
        let file = PFFileObject(data: imageData!)
        
        user["profile_image"] = file
        user.saveInBackground { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("Saved!")
            } else {
                print("Error!")
            }
        }
        
        
        
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageAspectScaled(toFill: size)
        
        profileImageView.image = scaledImage
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

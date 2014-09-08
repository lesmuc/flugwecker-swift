//
//  ImageUploadViewController.swift
//  flugwecker
//
//  Created by Udo von Eynern on 06.09.14.
//  Copyright (c) 2014 Udo von Eynern. All rights reserved.
//

import UIKit

class ImageUploadViewController : KeyboardInputViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate {
    
    var selectedImage: UIImage!
    
    @IBOutlet weak var buttonTakePicture: UIButton!
    
    @IBAction func takePictureAction(sender: UIButton) {
        
        let title = NSLocalizedString("Where?", comment: "")
        let cancelButtonTitle = NSLocalizedString("Cancel", comment: "")
        let cameraButtonTitle = NSLocalizedString("Camera", comment: "")
        let photoLibraryButtonTitle = NSLocalizedString("Photo Library", comment: "")
        
        var popupQuery:UIActionSheet = UIActionSheet(title: title, delegate: self, cancelButtonTitle: cancelButtonTitle, destructiveButtonTitle: nil, otherButtonTitles: cameraButtonTitle, photoLibraryButtonTitle)
        popupQuery.actionSheetStyle = UIActionSheetStyle.BlackOpaque
        popupQuery.showInView(self.view)
    }
    
    func actionSheet(myActionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int){
        
        var imagePicker:UIImagePickerController = UIImagePickerController()
        
        if buttonIndex == 0 { // camera
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            } else {
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            }
            
        } else if buttonIndex == 1 {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        
        self.selectedImage = info[UIImagePickerControllerEditedImage] as UIImage!
        
        if self.selectedImage == nil {
            self.selectedImage = info[UIImagePickerControllerOriginalImage] as UIImage!
        }
        
        var cropped:UIImage = VEResizeImage(self.selectedImage, CGSizeMake(self.buttonTakePicture.frame.size.width, self.buttonTakePicture.frame.size.height))
        self.buttonTakePicture.setImage(cropped, forState: UIControlState.Normal)
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

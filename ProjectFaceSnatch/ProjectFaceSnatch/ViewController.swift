//
//  ViewController.swift
//  ProjectFaceSnatch
//
//  Created by John Stanford on 10/12/16.
//  Copyright © 2016 Khelion. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var pickedImage: UIImageView!
    
    weak var prepedImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        if (pickedImage.image == nil) {
            failNotice()
        }
        else {
            let imageData = UIImageJPEGRepresentation(pickedImage.image!, 0.9)
            let strBase64:String = imageData!.base64EncodedString(options: .lineLength64Characters)
            let params = ["image":[ "content_type": "image/jpeg", "filename":"test.jpg", "file_data": strBase64]]
            var request = URLRequest(url: URL(string: "http://10.171.102.188:5000/todo/api/v1.0/tasks")!)
            do{
                try request.httpBody = JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions() )
            }
            catch{
                print("didnt work")
            }
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let postString = "{\"title\":\"Success\",\"description\":\" \"}"
            print(postString)
            request.httpBody = postString.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(responseString)")
                print(request)
            }
            task.resume()
        }
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        if (pickedImage.image == nil) {
            failNotice()
        }
        else{
            let imageData = UIImageJPEGRepresentation(pickedImage.image!, 0.6)
            let compressedJPEGImage = UIImage(data: imageData!)
            UIImageWriteToSavedPhotosAlbum(compressedJPEGImage!, nil, nil, nil)
            saveNotice()
        }
    }

    @IBAction func cameraButtonAction(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func libraryButtonAction(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        pickedImage.image = image
        self.dismiss(animated: true, completion: nil);
    }
    
    func saveNotice() {
        let alertController = UIAlertController(title: "Imaged Saved", message: "Saved to Camera Roll!", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func failNotice() {
        let alertController = UIAlertController(title: "Error", message: "You need to select an image!", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func jsonSuccess(mes: String) {
        let alertController = UIAlertController(title: "Success!!", message: "You have succeeded!!" + mes, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func clearButtonAction(_ sender: UIButton) {
        if (pickedImage.image != nil) {
            pickedImage.image = nil
        }
        else {
            return
        }
    }
    

}


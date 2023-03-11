//
//  UploadViewController.swift
//  InstaCloneFirebase
//
//  Created by Muhammet Kadir on 5.03.2023.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore

class UploadViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var uploadBtnC: UIButton!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var imageVC: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(addImage))
        imageVC.addGestureRecognizer(imageGesture)
        imageVC.isUserInteractionEnabled = true

    }
    
    @objc func addImage(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage{
            imageVC.image = selectedImage
        }
        picker.dismiss(animated: true)
    }
    
    
    @IBAction func uploadBtn(_ sender: Any) {
        let storage = Storage.storage()
        let storageReferance = storage.reference()
        
        let mediaFolder = storageReferance.child("media")
        let uuid = UUID().uuidString
        if let data = imageVC.image?.jpegData(compressionQuality: 0.5){
            let mediaReference = mediaFolder.child("\(uuid).jpg")
            mediaReference.putData(data,metadata: nil) { metadata, error in
                if error !=  nil {
                    self.makeAlert(titleInput: "error", messageInput: error?.localizedDescription ?? "Error")
                }else{
                    mediaReference.downloadURL { url, error in
                        if error == nil{
                            let imageUrl = url?.absoluteString
                            print(imageUrl ?? "")
                            
                            
                            let firestoreDatabase = FirebaseFirestore.Firestore.firestore()
                            var firestoreReference : DocumentReference? = nil
                            
                            let firestorePost = ["imageUrl" : imageUrl!, "postedBy" : Auth.auth().currentUser!.email!,"postComment" : self.commentText.text,"date":FieldValue.serverTimestamp(),"likes" : 0] as [String : Any]
                            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost,completion: { error in
                                if error != nil{
                                    self.makeAlert(titleInput: "errorx", messageInput: error?.localizedDescription ?? "Error")
                                }else{
                                    self.imageVC.image = UIImage(named: "tapme")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                        }
                    }
                }
            }
        }
        
        
    }
    func makeAlert(titleInput:String, messageInput:String){
        let aler = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        aler.addAction(okButton)
        self.present(aler, animated: true)
    }
}

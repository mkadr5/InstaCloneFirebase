//
//  FeedViewController.swift
//  InstaCloneFirebase
//
//  Created by Muhammet Kadir on 5.03.2023.
//

import UIKit
import FirebaseFirestore
import SDWebImage
class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
   
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var userEmailArray = [String]();
    var userCommentArray = [String]();
    var likeArray = [Int]();
    var userImageArray = [String]();
    var documentIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        getDataFromFirestore()
    }
    
    
    func getDataFromFirestore(){
        let fireStoreDatabase = Firestore.firestore()
        
        
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil{
                print(error!.localizedDescription)
            }else{
                if snapshot?.isEmpty != true && snapshot != nil{
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents{
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        if let postedBy = document.get("postedBy") as? String{
                            self.userEmailArray.append(postedBy)
                        }
                        if let postedComment = document.get("postComment") as? String{
                            self.userCommentArray.append(postedComment)
                        }
                        if let likes = document.get("likes") as? Int{
                            self.likeArray.append(likes)
                        }
                        if let imageUrl = document.get("imageUrl") as? String{
                            self.userImageArray.append(imageUrl)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.emailText.text = userEmailArray[indexPath.row]
        cell.commentText.text = userCommentArray[indexPath.row]
        cell.likeText.text = String(likeArray[indexPath.row])
        cell.documentId.text = documentIdArray[indexPath.row]
        let transformer = SDImageResizingTransformer(size: CGSize(width: 300, height: 190), scaleMode: .fill)

        cell.imageView?.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]), placeholderImage: nil,context: [.imageTransformer: transformer])
        cell.imageView?.contentMode = .scaleAspectFit
        
        return cell
    }
}

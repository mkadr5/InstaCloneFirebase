//
//  FeedCell.swift
//  InstaCloneFirebase
//
//  Created by Muhammet Kadir on 10.03.2023.
//

import UIKit
import FirebaseFirestore

class FeedCell: UITableViewCell {

    @IBOutlet weak var documentId: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var likeText: UILabel!
    @IBOutlet weak var commentText: UILabel!
    @IBOutlet weak var emailText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @IBAction func likeBtn(_ sender: Any) {
        let fireStoreDataBase = Firestore.firestore()
        
        if let likeCount = Int(likeText.text!){
            let likeStore = ["likes" : likeCount + 1] as [String : Any]
            
            fireStoreDataBase.collection("Posts").document(documentId.text!).setData(likeStore,merge: true)
        }
    }
}

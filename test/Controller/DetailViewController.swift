//
//  DetailViewController.swift
//  test
//
//  Created by Frank Liu on 2022/8/14.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var login: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var blog: UILabel!

    var username:String = ""

    let service = RequestCommunicator<DownloadNews>()
    var newsHandlers: [DownloadSingleUserHandler] = []
    let downloadImageQueue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareRequest(with: username)
    }
    
    func prepareRequest(with username: String) {
        service.request(type: .downloadSingleUser(username: username)) { [weak self] (result) in
            switch result {
            case .success(let response):
                if let user = DownloadSingleUserHandler.updateSearcSingleUserhResults(response.data, section: 0) {
                    self?.newsHandlers.append(contentsOf: user)
                    self?.updateUI()
                }
                
            case .failure(let error):
                print("Network error: \(error.localizedDescription)")
            }
        }
    }
    
    func updateUI() {
        guard newsHandlers.count > 0 else {
            return
        }
        getImage(url: self.newsHandlers[0].avatar_url)
        name.text = self.newsHandlers[0].name
        bio.text = self.newsHandlers[0].bio
        login.text = self.newsHandlers[0].login
        location.text = self.newsHandlers[0].location
        blog.text = self.newsHandlers[0].blog
    }

    func getImage(url: String) {
        guard let url = URL(string: url) else { return }
        downloadImageQueue.addOperation {
           do {
               let data = try Data(contentsOf: url)
               let image = UIImage(data: data)
               DispatchQueue.main.async {
                   self.imageView.image = image
                   self.imageView.layer.borderWidth = 1
                   self.imageView.layer.masksToBounds = false
                   self.imageView.layer.borderColor = UIColor.black.cgColor
                   self.imageView.layer.cornerRadius = self.imageView.frame.height/2
                   self.imageView.clipsToBounds = true
               }
               
           } catch _ {
               
           }
        }
    }
}

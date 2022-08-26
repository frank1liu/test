//
//  ViewController.swift
//  test
//
//  Created by Frank Liu on 2022/8/14.
//


import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    
    let service = RequestCommunicator<DownloadNews>()
    var newsHandlers: [DownloadHandler] = []
    let downloadImageQueue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func initView() {
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .none
        prepareRequest(with: "")
    }
    
    func prepareRequest(with name: String) {
        service.request(type: .downloadUsers(since: "0", per_page: "20")) { [weak self] (result) in
            switch result {
            case .success(let response):
                if let users = DownloadHandler.updateSearchResults(response.data, section: 0) {
                    self?.newsHandlers.append(contentsOf: users)
                    self?.myTableView.reloadData()
                }
                
            case .failure(let error):
                print("Network error: \(error.localizedDescription)")
            }
        }
    }
    
    func getImage(string: String, at indexPath: IndexPath, cell: UITableViewCell) {
        guard let url = URL(string: string) else { return }
        downloadImageQueue.addOperation {
           do {
               let data = try Data(contentsOf: url)
               let image = UIImage(data: data)
               DispatchQueue.main.async {
                    guard let listCell = cell as? ListCell else { return }
                    listCell.albumImageView.image = image
                    listCell.albumImageView.layer.borderWidth = 1
                    listCell.albumImageView.layer.masksToBounds = false
                    listCell.albumImageView.layer.borderColor = UIColor.black.cgColor
                    listCell.albumImageView.layer.cornerRadius = listCell.albumImageView.frame.height/2
                    listCell.albumImageView.clipsToBounds = true
                    listCell.setNeedsLayout()
               }
               
           } catch _ {
               
           }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as? ListCell else { return UITableViewCell() }
        
        let handler = newsHandlers[indexPath.row]
        cell.titleLabel.text = handler.login
        getImage(string: handler.avatar_url, at: indexPath, cell: cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        let handler = newsHandlers[indexPath.row]
        vc.username = handler.login
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsHandlers.count
    }
    
}

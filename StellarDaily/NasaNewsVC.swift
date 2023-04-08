//
//  NasaNewsVC.swift
//  StellarDaily
//
//  Created by Irodakhon Umurzakova on 22/03/23.
//

import UIKit
import Alamofire
import SwiftyJSON


struct sharedData {
    
    static var id: String = ""
    static var title: String = ""
    static var url: String = ""
    static var imageUrl: String = ""
    static var newsSite: String = ""
    static var summary: String = ""

}

class NasaNewsVC: UIViewController{
    
     var tableViews = UITableView()

    struct NewsArticle {
        let id: String
        let title: String
        var url: URL?
        var imageUrl: URL?
        var newsSite: String
        var summary: String


            init(json: JSON) {
                id = json["id"].stringValue
                title = json["title"].stringValue
                url = URL(string: json["url"].stringValue)
                newsSite = json["newsSite"].stringValue
                summary = json["summary"].stringValue
                
                if let imageUrl = json["imageUrl"].string {
                    self.imageUrl = URL(string: imageUrl)
                } else {
                    self.imageUrl = nil
                }

                imageUrl = URL(string: json["imageUrl"].stringValue)
                
                sharedData.id = id
                sharedData.title = title
                sharedData.url = json["url"].stringValue
                sharedData.imageUrl = json["imageUrl"].stringValue
                sharedData.newsSite = json["newsSite"].stringValue
                sharedData.summary = json["summary"].stringValue
                       
                newsSite = json["newsSite"].stringValue
                summary = json["summary"].stringValue
              
            }
    
        }

        @IBOutlet weak var tableView: UITableView!

        var articles: [NewsArticle] = []
    
      
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self

//MARK: Populating data from network request
        getNasaNewsArticles { articles, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let articles = articles {
                self.articles = articles
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

        func getNasaNewsArticles(completion: @escaping ([NewsArticle]?, Error?) -> Void) {
            guard let url = URL(string: "https://api.spaceflightnewsapi.net/v3/articles?_limit=70") else {
                completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
                return
            }

//MARK: Networking
            
            AF.request(url).validate().responseJSON { response in
                switch response.result {
                case .success(let value):

                    let json = JSON(value)
                    let articles = json.arrayValue.map { NewsArticle(json: $0) }
                    completion(articles, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }

//MARK: Protocols

    extension NasaNewsVC: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return articles.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NewsCell
            let title = articles[indexPath.row]
            cell.configure(with:title)
            return cell
        }
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            let article = articles[indexPath.row]
            sharedData.id = articles[indexPath.row].id
            sharedData.imageUrl = articles[indexPath.row].imageUrl?.absoluteString ?? ""
            sharedData.newsSite = articles[indexPath.row].newsSite
            sharedData.summary = articles[indexPath.row].summary
        
            performSegue(withIdentifier: "ToNewsDetailVC", sender: self)
        }
    }

extension NasaNewsVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToNewsDetailVC" {
            if let row = sender as? Int,
                let detailVC = segue.destination as? NasaNewsDetailVC {
                detailVC.article = articles[row]
               
                    
                    navigationController?.pushViewController(detailVC, animated: true)
                        
            }
        }
    }
}


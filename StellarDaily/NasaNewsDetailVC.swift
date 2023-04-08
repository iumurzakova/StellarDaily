//
//  NewsDetailVC.swift
//  StellarDaily
//
//  Created by Irodakhon Umurzakova on 22/03/23.
//

import UIKit
import WebKit

class NasaNewsDetailVC: UIViewController {
    
    var article: NasaNewsVC.NewsArticle?
    var newsImageView: UIImageView!
    var titleLabel: UILabel!
    var summaryLabel: UILabel!
    var newsSiteLabel: UILabel!
   // weak var delegate: NasaNewsDelegate?

        var imageUrl: URL?
        var summary: String?
        var newsSite: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
                
                // Load article data into UI elements
                if let article = article {
                    titleLabel.text = article.title
                    summaryLabel.text = article.summary ?? "Summary not available"
                    newsSiteLabel.text = article.newsSite ?? "News site not available"
                    if let imageUrl = article.imageUrl {
                        loadImageFromUrl(imageUrl: imageUrl)
                    } else {
                        newsImageView.image = UIImage(systemName: "news")
                    }
                }
            }
        // Create the news image view

        func setUpViews() {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor)

        ])
        newsImageView = imageView

        // Create the title label
        let label = UILabel()
        label.numberOfLines = 0
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 16)
        ])
        titleLabel = label
        // Create the summary label
               let summaryLabel = UILabel()
               summaryLabel.numberOfLines = 0
               view.addSubview(summaryLabel)
               summaryLabel.translatesAutoresizingMaskIntoConstraints = false
               NSLayoutConstraint.activate([
                   summaryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                   summaryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                   summaryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16)
               ])
               self.summaryLabel = summaryLabel

               // Create the news site label
               let newsSiteLabel = UILabel()
               view.addSubview(newsSiteLabel)
               newsSiteLabel.translatesAutoresizingMaskIntoConstraints = false
               NSLayoutConstraint.activate([
                   newsSiteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                   newsSiteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                   newsSiteLabel.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 16),
                   newsSiteLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
               ])
               self.newsSiteLabel = newsSiteLabel



        
        // Load the article data into the UI elements
        if let article = article {
            titleLabel.text = article.title
            if let imageUrl = article.imageUrl {
                loadImageFromUrl(imageUrl: imageUrl)
            } else {
                newsImageView.image = nil
            }
        }
    }
    
    func loadImageFromUrl(imageUrl: URL) {
        DispatchQueue.global().async { [weak self] in
            if let imageData = try? Data(contentsOf: imageUrl),
               let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self?.newsImageView.image = image
                }
            }
        }
    }
}

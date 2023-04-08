//
//  NewsCell.swift
//  StellarDaily
//
//  Created by Irodakhon Umurzakova on 07/04/23.
//

import UIKit

class NewsCell: UITableViewCell {

   
    @IBOutlet weak var newsImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
            
    func getImageFromURL(url: URL?) -> UIImage? {
            guard let safeURL = url else {
              print("Invalid URL")
              return nil
            }

            do {
              let data = try Data(contentsOf: safeURL)
              if let downloadedImage = UIImage(data: data) {
                  return downloadedImage
              } else {
                print("Unable to create UIImage from data")
                
              }
            } catch {
              print("Error downloading image: \(error.localizedDescription)")
            }
        
            return nil
        }

    func configure(with title : NasaNewsVC.NewsArticle){
        titleLabel.text = title.title
        if let imageUrl = title.imageUrl {
            loadImage(from: imageUrl)
        } else {
            newsImageView.image = UIImage(systemName: "photo")
        }
    }
    

           
    func loadImage(from url: URL?) {
        guard let imageUrl = url else {
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let data = try Data(contentsOf: imageUrl)
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.newsImageView.image = image
                }
            } catch {
                print("Error loading image from URL: \(error.localizedDescription)")
                
            }
        }
    }
}
   



//
//  ViewController.swift
//  CWWRSS
//
//  Created by Richard Martin on 2016-12-06.
//  Copyright © 2016 richard martin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FeedModelDelegate, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var tableView: UITableView!
    
    var model = FeedModel()
    var articles = [Article]()
    var selectedArticle:Article?

    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        model.getArticles()
        tableView.delegate = self
        tableView.dataSource = self
        
        // create a UIImageView and add it to the navigation bar
        createTitleIcon()
    
    }
    
    func createTitleIcon() {
        // create the UIImageView
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // create constraints
        let heightConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 33)
        let widthConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 41)
        
        // add constratints to the imageView
        imageView.addConstraints([heightConstraint, widthConstraint])
        
        // set the image
        imageView.image = UIImage(named: "vergeicon")
        
        // add to navigation bar
        navigationItem.titleView = imageView
        
    }

    // implement FeedModelDelegate protocol functions
    
    func articlesReady() {
        // get articles from the FeedModel model
        articles = model.articles
    }
    
    // implement tableview protocols
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "theVergeCell")!
        
        // get article for this row
        let article = articles[indexPath.row]
        
        // get text label
        let label = cell.viewWithTag(1) as? UILabel
        
        if let actualLabel = label {
            actualLabel.text = article.articleTitle
        }
        
        if article.articleUmageUrl != "" {
            // get imageview
            let imageview = cell.viewWithTag(2) as? UIImageView
            
            if let actualImageView = imageview {
                // found the image view, now download the image
                
                // create the url object
                let url = URL(string: article.articleUmageUrl)
                
                if let actualURL = url {
                    
                    // create URLRequest object
                    let request = URLRequest(url: actualURL)
                    
                    // grab the current URLSession
                    let session = URLSession.shared
                    
                    // create a URLSession data task
                    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
                        
                        // fire off this work to update the UI to the main thread
                        DispatchQueue.main.async {
                            // data has been downloaded. create a UIImage object and assign it to the imageview
                            if let actualData = data {
                                actualImageView.image = UIImage(data: actualData)
                            }
                        }
                    })
                    
                    // fire off the data task
                    dataTask.resume()
                }
            }
        }
        else {
            // article has no image url ; set the imageview to nil image
            let imageview = cell.viewWithTag(2) as? UIImageView
            
            if let actualImageView = imageview {
                actualImageView.image = nil
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedArticle = articles[indexPath.row]
        
        // user has tapped on a row and trigger segue to DetailViewController
        performSegue(withIdentifier: "goToDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // segue to DetailViewController
        
        let dvc = segue.destination as! DetailViewController
        dvc.articleToDisplay = selectedArticle
    }

}


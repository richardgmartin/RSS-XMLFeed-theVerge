//
//  FeedModel.swift
//  CWWRSS
//
//  Created by Richard Martin on 2016-12-06.
//  Copyright © 2016 richard martin. All rights reserved.
//

import UIKit

protocol FeedModelDelegate {
    func articlesReady()
}

class FeedModel: NSObject, XMLParserDelegate {
    
    var url = "https://www.theverge.com/rss/index.xml"
    var articles = [Article]()
    
    var delegate:FeedModelDelegate?
    
    // parsing variables
    var constructingArticle: Article?
    var constructingString = ""
    var linkAttributes = [String:String]()
    
    func getArticles() {
        let articles = [Article]()
        
        // download the RSS feed
        let feedURL = URL(string: url)
        
        if let actualFeedURL = feedURL {
            let parser = XMLParser(contentsOf: actualFeedURL)
            
            if let actualParser = parser {
                // parse object exists
                actualParser.delegate = self
                actualParser.parse()
            }
        }
    }
    
    // this func called when parser finds a new starting tag
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        // monitor for Entry, Title, Content, and Link tags
        if elementName == "entry" {
            constructingArticle = Article()
        } else if elementName == "link" {
            linkAttributes = attributeDict
        }
    }
    
    // this func called when parser finds characters between two tags
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        // save characters if tag is Title or Content
        if constructingArticle != nil {
            constructingString += string
        }
    }
    
    // this func called when parser finds an ending tag
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        // terminate if tag is Entry, Title, Content and Link closing tags
        if elementName == "title" {
            // save the constructingString as the Title for our constructingArticle
            let title = constructingString.trimmingCharacters(in: .whitespacesAndNewlines)
            constructingArticle?.articleTitle = title
        }
        else if elementName == "content" {
            // save the constructingString as the Content for our constructingArticle
            constructingArticle?.articleBody = constructingString
            
            // search for http
            if let startingRange = constructingString.range(of: "http") {
                // found http. now look for jpg
                if let endRange = constructingString.range(of: ".jpg") {
                    // found .jpg. now get substring
                    let substring = constructingString.substring(with: startingRange.lowerBound ..< endRange.upperBound)
                    constructingArticle?.articleUmageUrl = substring
                }
                else if let endRange = constructingString.range(of: ".png") {
                    // found .png. now get substring
                    let substring = constructingString.substring(with: startingRange.lowerBound ..< endRange.upperBound)
                    constructingArticle?.articleUmageUrl = substring

                }
            }
        }
        else if elementName == "link" {
            // save the href attribute as the article url for constructingArticle
            if let href = linkAttributes["href"] {
                constructingArticle?.articleLink = href
            }
        }
        else if elementName == "entry" {
            // save the constructionArticle into articles array
            if let theArticle = constructingArticle {
                articles.append(theArticle)
            }
            // reset the constructingArticle
            constructingArticle = nil
        }
        // reset the constructing String
        constructingString = ""
    }
    
    // this func called when parser finishes parsing the feed
    func parserDidEndDocument(_ parser: XMLParser) {
        // when feed is parsed, notify the delegate
        // check if delegate property is nil; if not call the articlesReady func
        
        if let actualDelegate = delegate {
            actualDelegate.articlesReady()
        }
    }
}

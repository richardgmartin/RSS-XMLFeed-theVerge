##RSS XML Feed of The Verge##
This is an iOS project, written in Swift 3 and targeted at the iPhone, that accesses the XML-formatted RSS feed of the online magazine, The Verge. The feed is used to populate a table view on the root view controller. The user can tap on a cell and a segue presents a detail view controller with a web view that presents the article.

##Dependencies##

The following dependencies are used in the distributed code:

* XMLParser

* UITableView

* UIWebView

* Custom Delegation (to alert the table view on the root view controller that the feed has been terminated and the table view load can start)

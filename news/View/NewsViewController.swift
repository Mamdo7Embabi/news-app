//
//  ViewController.swift
//  news
//
//  Created by Mamdouh Embabi on 3/27/18.
//  Copyright © 2018 ios. All rights reserved.
import UIKit
import Reachability
import Moya
import Moya_ObjectMapper
import Windless
import DGElasticPullToRefresh
import CDAlertView
import RealmSwift
class NewsViewController:  UIViewController ,refreshNetworkDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var noNetworkView: NoNetworkView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var newsTable: UITableView!
    
    var newsArr = [SingleNewsObject]()
    var pagingNumber = 1
    let newsPresenter = NewsPresenter(newsService: NewsService())
    
    var reachability: Reachability?
    let hostNames = [nil, "google.com", "invalidhost"]
    var hostIndex = 0
    
    var isDataLoading = false
    
    var cellHeights: [IndexPath : CGFloat] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.noNetworkView.delegate = self
        loading.hidesWhenStopped = true
        newsTable.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")

        newsTable.rowHeight = UITableViewAutomaticDimension
        
        self.newsTable.windless
            .apply {
                $0.beginTime = 0
                $0.pauseDuration = 1
                $0.duration = 3
                $0.animationLayerOpacity = 0.8
            }
            .start()
        
        newsPresenter.attachView(view: self)
        self.getNews()
        self.pullToRefreshConfiguration()
        self.printRealmFileLocation()
        
    }

 
    
    deinit {
        stopNotifier()
        newsTable.dg_removePullToRefresh()
    }
    
    func printRealmFileLocation(){
        print("-----------------realm file-----------------------------------------")
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        print("----------------------------------------------------------")
    }
    
    func pullToRefreshConfiguration(){
        
        // Initialize tableView
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        newsTable.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // Add your logic here
     
            self?.refreshAction()
            
            // Do not forget to call dg_stopLoading() at the end
            self?.newsTable.dg_stopLoading()
            }, loadingView: loadingView)
        newsTable.dg_setPullToRefreshFillColor(#colorLiteral(red: 0.2819149196, green: 0.7462226748, blue: 0.6821211576, alpha: 1))
        newsTable.dg_setPullToRefreshBackgroundColor(newsTable.backgroundColor!)
       
    }

    func refreshNetwork() {
        self.refreshAction()
    }
    
    func refreshAction(){
        self.newsArr.removeAll()
        self.isDataLoading = false
        self.pagingNumber = 1
        self.getNews()
    }
   
    
    func getNews(){
        print("page number = \(self.pagingNumber)")
        print("country code = \(APIConstants.CountryCode)")
        self.newsPresenter.getnews(countryCode: APIConstants.CountryCode, pageSize: 10, pageNum: self.pagingNumber)
    }
    
    
    func startHost(at index: Int) {
        stopNotifier()
        setupReachability(hostNames[index], useClosures: true)
        startNotifier()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.startHost(at: (index + 1) % 3)
        }
    }
    
    func setupReachability(_ hostName: String?, useClosures: Bool) {
        let reachability: Reachability?
        var hostNameStatus = ""
        if let hostName = hostName {
            reachability = Reachability(hostname: hostName)
            hostNameStatus = hostName
        } else {
            reachability = Reachability()
            hostNameStatus = "No host name"
        }
        self.reachability = reachability
        print("--- set up with host name: \(hostNameStatus)")
        
            reachability?.whenReachable = { reachability in
           
                //if data is not loaded
                if !self.isDataLoading {
                    self.isDataLoading = true
                    self.getNews()
                }
                
            }
            reachability?.whenUnreachable = { reachability in
               
            }
       
    }
    
    func startNotifier() {
        print("--- start notifier")
        do {
            try reachability?.startNotifier()
        } catch {
          
            return
        }
    }
    
    func stopNotifier() {
        print("--- stop notifier")
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
        reachability = nil
    }

}

extension NewsViewController:NewsView{
    
    func startLoading() {
        
        if self.pagingNumber == 1 { // first page load
            self.newsTable.windless.start()
            self.loading.alpha = 0
        }else {
            DispatchQueue.main.async {
                self.loading.alpha = 1
                self.loading.startAnimating()
            }
        }
    }
    
    func finishLoading() {
        self.loading.stopAnimating()
        self.newsTable.windless.end()
        self.newsTable.dg_stopLoading()
        
    }
    
    func setNews(news: [SingleNewsObject]) {
        
        newsArr.append(contentsOf: news)
        self.noNetworkView.alpha = 0
        self.emptyView.alpha = 0
        self.newsTable.alpha = 1
        self.pagingNumber += 1
        isDataLoading = true
        self.newsTable.reloadData()

        
    }
    
    func setEmptyNews() {
        
        if self.pagingNumber == 1 {
            //in the first page && no data found
            //if there is no headlines for the current country we will  set US as default country
            if APIConstants.CountryCode != "US" {
                APIConstants.CountryCode = "US"
                //load data from begining
                self.refreshAction()
            }else {
                //no data for US itself
                self.newsTable.alpha = 0
                self.noNetworkView.alpha = 0
                self.emptyView.alpha = 1
            }
            
        }else {
            //in next pages && no data found
            self.finishLoading()
            ViewControllerUtils().showToast(uView:self.view , msg: "No more News Feed", position:.bottom )
            
        }
  }
    
    func showServerErrorAlert(isNetwork :Bool) {
        if isNetwork {
            //network error
            
            if self.pagingNumber == 1 {
                //in first page no cached data found
                self.newsTable.alpha = 0
                self.emptyView.alpha = 0
                self.noNetworkView.alpha = 1
                
                
            }else {
                //other pages
                DispatchQueue.main.async {
                    ViewControllerUtils().showAlert(controller: self, title: "Uh oh", message: "there looks like there was some problem with your network, try again")
                }
                self.startHost(at: 0)
            }
        }else {
            //server error
            DispatchQueue.main.async {
                ViewControllerUtils().showAlert(controller: self, title: "Uh oh", message: "something wrong happened , try agian later")
            }
            self.startHost(at: 0)
        }
    }
}


// MARK: - UITableViewDataSource
extension NewsViewController :UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var num = 30
        if newsArr.count > 0 {
            num = newsArr.count
        }
        
        return num
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell

        if newsArr.count > 0 {
            let newsObj = newsArr[indexPath.row]
            cell.newsObj_ = newsObj
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cellHeights[indexPath] = cell.frame.size.height
        
        let totalRow = self.newsTable.numberOfRows(inSection: 0)
        
        
        if(indexPath.row == totalRow - 1) && isDataLoading{
            //this is the last row in section.
            print("isDataLoading = \(self.isDataLoading)")
            print("last Cell  = \(indexPath.row)")
         
            self.loadMoreItemsForList()
            
        }
    }
    
    func loadMoreItemsForList(){
        print("loadMoreItemsForList")
        self.isDataLoading = false
        self.getNews()
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if newsArr.count > 0 {
            let selectedObj = newsArr[indexPath.row]
            //dialog will appear contain description only (custom dialog)
            
            var authorName = ""
            if let author = selectedObj.author{
                authorName = author
            }
            
            if let desc = selectedObj.newsDescription , desc != "" {
                
                let alert = CDAlertView(title: authorName, message: desc, type: .custom(image: UIImage(named:"News-Mic-iPhone-icon")!))
                
                alert.messageFont = UIFont(name: "HacenTunisiaLt", size: 17)!
                alert.titleFont = UIFont(name: "HacenTunisiaLt", size: 20)!
                alert.messageTextColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                alert.titleTextColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                let doneAction = CDAlertViewAction(title: "DONE")
                alert.add(action: doneAction)
                
                alert.show()
            }else {
                ViewControllerUtils().showToast(uView:self.view , msg: "No Description found for this headline", position:.bottom )
            }
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = cellHeights[indexPath] else { return 100.0 }
        return height
    }
}




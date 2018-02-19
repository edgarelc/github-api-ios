//
//  RepoTableViewController.swift
//  github-api
//
//  Created by Emiro on 16/2/18.
//  Copyright © 2018 Emiro. All rights reserved.
//

import UIKit
import os.log

class RepoTableViewController: UITableViewController {
    
    //MARK - Properties
    var repos = [Repo]()
    
    //MARK: Private Methods
    private func getRepos(reloadRepos: Bool) {
        if !reloadRepos, let storedRepos = loadRepos() {
            os_log("Using stored repos", log: OSLog.default, type: .debug)
            repos += storedRepos
        } else {
            let restAPI = RemoteRepo()
            restAPI.get(completion: updateRepos)
        }
    }
    
    // Update Repos locally and then in the DB
    private func updateRepos(repos: [Repo]?) -> Void {
        self.repos = repos!
        saveRepos()
    }
    
    // Save Repos to DB
    private func saveRepos() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(repos, toFile: Repo.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Repos successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save repos...", log: OSLog.default, type: .error)
        }
        
        // Finish refreshing
        self.refreshControl?.endRefreshing()
    }
    
    // Get Repos from DB
    private func loadRepos() -> [Repo]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Repo.ArchiveURL.path) as? [Repo]
    }
    
    // Open a URL in a browser
    @IBAction func launchURL(_ sender: UIButton) {
        if let url = URL(string: (sender.titleLabel?.text)!) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    // Reload Repos
    @IBAction func reloadRepos(_ sender: UIRefreshControl) {
        self.getRepos(reloadRepos: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get repos
        getRepos(reloadRepos: false)
        
        // Set pull down to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.reloadRepos(_:)), for: UIControlEvents.valueChanged)
        self.refreshControl = refreshControl
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "RepoTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RepoTableViewCell  else {
            fatalError("The dequeued cell is not an instance of RepoTableViewCell.")
        }
        
        // Fetches the repo
        let repo = repos[indexPath.row]
        
        // Setting valuex
        cell.nameLabel.text = repo.name
        cell.isForkLabel.text = repo.getIsForkText()
        cell.stargazersLabel.text = String(repo.stargazers)
        cell.lastTimeLabel.text = repo.lastTime
        
        //Set link
        cell.linkButton.setTitle(repo.link, for: UIControlState.normal)
        cell.linkButton.addTarget(self, action: #selector(self.launchURL(_:)), for: UIControlEvents.touchUpInside)
        
        return cell
    }
}

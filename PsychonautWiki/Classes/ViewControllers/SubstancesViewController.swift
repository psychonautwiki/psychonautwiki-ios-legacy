//
//  SubstancesTableViewController.swift
//  PsychonautWiki
//
//  Created by Waldemar Barbe on 20.02.17.
//  Copyright © 2017 Waldemar Barbe. All rights reserved.
//

import UIKit
import Apollo

class SubstancesViewController: UITableViewController, UISearchResultsUpdating {

    var watcher: GraphQLQueryWatcher<SubstancesQuery>?
    var searchController: UISearchController?
    
    var filteredSubstancesDictionary: SubstancesDictionary?
    
    var rawSubstances: [Substance]? {
        didSet {
            if let rawSubstances = rawSubstances {
                self.substancesDictionary = self.calculateSubstancesDictionary(substances: rawSubstances)
            } else {
                self.substancesDictionary = nil
            }
            tableView.reloadData()
        }
    }
    
    typealias SubstancesDictionary = [String : [Substance]]
    var substancesDictionary: SubstancesDictionary?
    
    func calculateSubstancesDictionary(substances: [Substance]) -> SubstancesDictionary {
        var resultDictionary = SubstancesDictionary()
        for substance in substances {
            guard let substanceClass = substance.class,
                let psychoactiveClasses = substanceClass.psychoactive else { continue }
            for psychoactiveClass in psychoactiveClasses {
                if let psychoactiveClass = psychoactiveClass {
                    if var existingSubstances = resultDictionary[psychoactiveClass] {
                        existingSubstances.append(substance)
                        resultDictionary[psychoactiveClass] = existingSubstances
                    } else {
                        resultDictionary[psychoactiveClass] = [substance]
                    }
                }
            }
        }
        return resultDictionary
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSearchBar()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60
        
        watcher = SubstancesService.createWatcher(resultHandler: self.substancesResultHandler)
    }
    
    func configureSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        self.searchController = searchController
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        
        self.tableView.tableHeaderView = searchController.searchBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Tracker.Screens.substancesList.track()
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        watcher?.cancel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func substancesResultHandler(result: GraphQLResult<SubstancesQuery.Data>?, error: Error?) {
        if let error = error { NSLog("##### Error while fetching query: \(error.localizedDescription)"); return }
        guard let result = result else {
            NSLog("##### No query result");
            self.showErrorMessage(title: "Error", message: "No result.")
            return
        }
        
        if let errors = result.errors {
            NSLog("##### \(errors.count) Errors in query result.")
            for error in errors {
                NSLog(error.description)
            }
        }
        
        guard let data = result.data else {
            NSLog("##### No query result data");
            self.showErrorMessage(title: "Error", message: "No query result data")
            return
        }
        
        guard let substances = data.substances else {
            NSLog("##### No query result data");
            self.showErrorMessage(title: "Error", message: "No query result data")
            return
        }
        
        self.rawSubstances = substances.flatMap { $0 }
        NSLog("Got \(self.rawSubstances?.count ?? 0) substances")
    }
    
    func substanceFor(indexPath: IndexPath) -> Substance? {
        guard let substancesDictionary = self.substancesDictionary else { return nil }
        
        if let searchController = self.searchController,
            searchController.isActive && searchController.searchBar.text != "",
            let filteredSubstancesDictionary = self.filteredSubstancesDictionary {
            let key = Array(filteredSubstancesDictionary.keys).sorted()[indexPath.section]
            return filteredSubstancesDictionary[key]?.element(atIndex: indexPath.row)
        }
        
        let key = Array(substancesDictionary.keys).sorted()[indexPath.section]
        return substancesDictionary[key]?.element(atIndex: indexPath.row)
    }
    
    func filterSubstancesDictionary(searchText: String) {
        guard let substancesDictionary = self.substancesDictionary else {
        	self.filteredSubstancesDictionary = nil
            return
        }
        
        self.filteredSubstancesDictionary = substancesDictionary.reduce(SubstancesDictionary(), { dict, pair in
            let filteredSubstances = pair.value.filter { substance in
                guard let name = substance.name else { return false }
                return name.containsFuzzy(searchText)
            }
            if filteredSubstances.count > 0 {
                var newDict = dict
                newDict[pair.key] = filteredSubstances
                return newDict
            }
            return dict
        })
        
        tableView.reloadData()
    }
    
    // MARK: - Search Result Updater
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        self.filterSubstancesDictionary(searchText: searchController.searchBar.text!)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                guard let substance = self.substanceFor(indexPath: indexPath) else { return }
                let controller = (segue.destination as! UINavigationController).topViewController as! SubstanceDetailViewController
                controller.substance = substance
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let substancesDictionary = self.substancesDictionary else {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            self.tableView.backgroundView = activityIndicator
            activityIndicator.startAnimating()
            return 0
        }
        self.tableView.backgroundView = nil
        
        if let searchController = self.searchController,
           searchController.isActive && searchController.searchBar.text != "",
           let filteredSubstancesDictionary = self.filteredSubstancesDictionary {
            return filteredSubstancesDictionary.keys.count
        }
        
        return substancesDictionary.keys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let substancesDictionary = self.substancesDictionary else { return 0 }
        
        if let searchController = self.searchController,
            searchController.isActive && searchController.searchBar.text != "",
            let filteredSubstancesDictionary = self.filteredSubstancesDictionary {
            let key = Array(filteredSubstancesDictionary.keys).sorted()[section]
            return filteredSubstancesDictionary[key]?.count ?? 0
        }
        
        let key = Array(substancesDictionary.keys).sorted()[section]
        return substancesDictionary[key]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let substancesDictionary = self.substancesDictionary else { return nil }
        
        if let searchController = self.searchController,
            searchController.isActive && searchController.searchBar.text != "",
            let filteredSubstancesDictionary = self.filteredSubstancesDictionary {
            return Array(filteredSubstancesDictionary.keys).sorted()[section]
        }
        
        return Array(substancesDictionary.keys).sorted()[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubstanceCell", for: indexPath)
        guard let substance = self.substanceFor(indexPath: indexPath) else { return cell }
        
        cell.textLabel?.text = substance.name ?? "- no name -"
        if let addictionPotential = substance.addictionPotential {
            cell.detailTextLabel?.text = "Addiction potential:\n\(addictionPotential)"
        } else {
            cell.detailTextLabel?.text = "No information about addictive potential."
        }
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.lineBreakMode = .byTruncatingTail

        return cell
    }
    
}

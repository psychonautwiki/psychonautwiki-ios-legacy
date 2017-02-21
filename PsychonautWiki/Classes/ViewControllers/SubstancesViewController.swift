//
//  SubstancesTableViewController.swift
//  PsychonautWiki
//
//  Created by Waldemar Barbe on 20.02.17.
//  Copyright © 2017 Waldemar Barbe. All rights reserved.
//

import UIKit
import Apollo

class SubstancesViewController: UITableViewController {

    var watcher: GraphQLQueryWatcher<SubstancesQuery>?
    
    var rawSubstances: [SubstancesQuery.Data.Substance]? {
        didSet {
            if let rawSubstances = rawSubstances {
                self.substancesDictionary = self.calculateSubstancesDictionary(substances: rawSubstances)
            } else {
                self.substancesDictionary = nil
            }
            tableView.reloadData()
        }
    }
    
    typealias SubstancesDictionary = [String : [SubstancesQuery.Data.Substance]]
    var substancesDictionary: SubstancesDictionary?
    
    func calculateSubstancesDictionary(substances: [SubstancesQuery.Data.Substance]) -> SubstancesDictionary {
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
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60
        
        watcher = SubstancesService.createWatcher(resultHandler: self.substancesResultHandler)
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let substancesDictionary = self.substancesDictionary else {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            self.tableView.backgroundView = activityIndicator
            activityIndicator.startAnimating()
            return 0
        }
        
        self.tableView.backgroundView = nil
        return substancesDictionary.keys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let substancesDictionary = self.substancesDictionary else { return 0 }
        
        let key = Array(substancesDictionary.keys).sorted()[section]
        return substancesDictionary[key]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let substancesDictionary = self.substancesDictionary else { return nil }
        return Array(substancesDictionary.keys).sorted()[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubstanceCell", for: indexPath)
        
        guard let substancesDictionary = self.substancesDictionary else { return cell }
        let key = Array(substancesDictionary.keys).sorted()[indexPath.section]
        
        if let substance = substancesDictionary[key]?.element(atIndex: indexPath.row) {
            cell.textLabel?.text = substance.name ?? "- no name -"
            if let addictionPotential = substance.addictionPotential {
                cell.detailTextLabel?.text = "Addiction potential:\n\(addictionPotential)"
            } else {
                cell.detailTextLabel?.text = "No information about addictive potential."
            }
            cell.detailTextLabel?.numberOfLines = 0
            cell.detailTextLabel?.lineBreakMode = .byTruncatingTail
        } else {
            NSLog("Could not get a subtance for row: \(indexPath.row)")
        }

        return cell
    }
    
}

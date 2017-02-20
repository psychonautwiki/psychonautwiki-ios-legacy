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
    var substances: [SubstancesQuery.Data.Substance]? {
        didSet {
            self.tableView.reloadData()
        }
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
        
        self.substances = substances.flatMap { $0 }
        NSLog("Got \(self.substances?.count ?? 0) substances")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.substances.isNil() {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            self.tableView.backgroundView = activityIndicator
            activityIndicator.startAnimating()
            return 0
        } else {
            self.tableView.backgroundView = nil
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.substances?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubstanceCell", for: indexPath)

        if let substance = self.substances?.element(atIndex: indexPath.row) {
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

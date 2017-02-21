//
//  DetailViewController.swift
//  PsychonautWiki
//
//  Created by Waldemar Barbe on 20.02.17.
//  Copyright © 2017 Waldemar Barbe. All rights reserved.
//

import UIKit

class SubstanceDetailViewController: UITableViewController {

    var substance: SubstancesQuery.Data.Substance? {
        didSet {
            self.configureView()
        }
    }
    
    func configureView() {
        guard let substance = substance else { return }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


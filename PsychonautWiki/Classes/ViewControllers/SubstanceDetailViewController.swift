//
//  DetailViewController.swift
//  PsychonautWiki
//
//  Created by Waldemar Barbe on 20.02.17.
//  Copyright © 2017 Waldemar Barbe. All rights reserved.
//

import UIKit
import AlamofireImage
import AutoLayoutHelperSwift

class SubstanceDetailViewController: UITableViewController {
    
    var tableHeaderView: UIView?
    var tableHeaderImageWebView: UIWebView?
    
    enum Sections: Int {
        case links = 0
        case addicationPotential
        case crossTolerance
        case dangerousInteraction
        case substanceClass
        case tolerance
        case effects
    }
    
    var substance: Substance? {
        didSet {
            self.configureView()
        }
    }
    
    func configureView() {
        guard let substance = substance else { return }
        self.navigationItem.title = substance.name
        
        guard let substanceImages = substance.images else { 
            Logger.logWarn("Could not unwrap substance.images")
            return 
        }
        guard let firstImage = substanceImages.element(atIndex: 0) else { 
            Logger.logWarn("Could not unwrap substanceImages.element(atIndex: 0)")
            return 
        }
        guard let imageUrlString = firstImage?.image else { 
            Logger.logWarn("Could not unwrap firstImage?.image")
            return 
        }
        guard let imageUrl = URL(string: imageUrlString) else { 
            Logger.logWarn("Could not unwrap URL(string: imageUrlString)")
            return 
        }
        
        if self.tableHeaderView == nil {
            self.tableHeaderView = UIView()
            self.tableHeaderImageWebView = UIWebView()
            
            self.tableHeaderView?.addSubview(tableHeaderImageWebView!)
            
            let edgeInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            self.tableHeaderImageWebView?.fillSuperView(edgeInset)
            self.tableHeaderImageWebView?.contentMode = .scaleAspectFit
            self.tableHeaderImageWebView?.backgroundColor = UIColor.white
            self.tableHeaderImageWebView?.layer.borderWidth = 1
            self.tableHeaderImageWebView?.layer.borderColor = UIColor.darkGray.cgColor
            
            self.tableView.tableHeaderView = self.tableHeaderView
            self.tableView.tableHeaderView?.frame.size.height = 250
        }
        
        self.tableHeaderImageWebView?.loadRequest(URLRequest(url: imageUrl))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MultiLineTableViewCell.self, forCellReuseIdentifier: "EffectCell")
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let indexPath = indexPath.section == Sections.effects.rawValue ? IndexPath(row: 0, section: indexPath.section) : indexPath
        return super.tableView(tableView, heightForRowAt: indexPath) + 20
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        let indexPath = indexPath.section == Sections.effects.rawValue ? IndexPath(row: 0, section: indexPath.section) : indexPath
		return super.tableView(tableView, indentationLevelForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Sections.effects.rawValue {
        	return substance?.effects?.count ?? 1
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let section = Sections(rawValue: indexPath.section) else { return }
    	
        switch section {
        case .links:
            guard let urlString = self.substance?.url else { return }
            self.open(urlString: urlString)
        case .effects:
            guard let effects = substance?.effects,
                effects.count > indexPath.row,
                let effect = effects[indexPath.row],
            	let urlString = effect.url else { return }
            
            self.open(urlString: urlString)
        default:
            break
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            if indexPath.section == Sections.effects.rawValue {
                return tableView.dequeueReusableCell(withIdentifier: "EffectCell")!
            } else {
            	return super.tableView(tableView, cellForRowAt: indexPath)
            }
        }()
        guard let section = Sections(rawValue: indexPath.section) else { return cell }
        
        cell.selectionStyle = .none
        cell.accessoryType = .none
        
        switch section {
            case .links:
                let linkAvailable = substance?.url != nil
                cell.textLabel?.text = linkAvailable ? "Wiki page" : "Unkown"
                cell.accessoryType = linkAvailable ? .disclosureIndicator : .none
                cell.selectionStyle = linkAvailable ? .default : .none
            case .addicationPotential:
                cell.textLabel?.text = substance?.addictionPotential ?? "Unknown"
            case .crossTolerance:
                if let crossTolerance = substance?.crossTolerances {
                    cell.textLabel?.text = crossTolerance.flatMap({ $0 }).joined(separator: "\n")
                } else {
                    cell.textLabel?.text = "Unknown"
                }
            case .dangerousInteraction:
                if let dangerousInteraction = substance?.dangerousInteractions {
                    cell.textLabel?.text = dangerousInteraction.flatMap({ $0?.name }).joined(separator: "\n")
                } else {
                    cell.textLabel?.text = "Unknown"
                }
            case .substanceClass:
                if indexPath.row == 0 {
                    if let psychoactive = substance?.class?.psychoactive {
                        cell.detailTextLabel?.text = psychoactive.flatMap({ $0 }).joined(separator: "\n")
                    } else {
                        cell.detailTextLabel?.text = "Unknown"
                    }
                } else if indexPath.row == 1 {
                    if let chemical = substance?.class?.chemical {
                        cell.detailTextLabel?.text = chemical.flatMap({ $0 }).joined(separator: "\n")
                    } else {
                        cell.detailTextLabel?.text = "Unknown"
                    }
            	}
            case .tolerance:
                if indexPath.row == 0 {
                    cell.detailTextLabel?.text = substance?.tolerance?.full ?? "Unknown"
                } else if indexPath.row == 1 {
                    cell.detailTextLabel?.text = substance?.tolerance?.half ?? "Unknown"
                } else if indexPath.row == 2 {
                    cell.detailTextLabel?.text = substance?.tolerance?.zero ?? "Unknown"
                }
            case .effects:
                if let effects = substance?.effects,
                    effects.count > indexPath.row,
                    let effect = effects[indexPath.row] {
                    cell.textLabel?.text = effect.name ?? "Unknown"
                    
                    let linkAvailable = effect.url != nil
                    cell.selectionStyle = linkAvailable ? .default : .none
                    cell.accessoryType =  linkAvailable ? .disclosureIndicator : .none
                } else {
                    cell.textLabel?.text = "Unknown"
                }
        }
        
        return cell
    }
    
}


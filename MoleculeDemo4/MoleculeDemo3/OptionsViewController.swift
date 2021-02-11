//
//  OptionsViewController.swift
//  MoleculeDemo4
//
//  Created by Gabriel Reed on 11/17/20.
//  Copyright © 2020 Gabriel Reed. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

class OptionsViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var index = 2
    
    override func viewDidLoad() {
        segmentedControl.selectedSegmentIndex = index
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! MoleculeViewController
        let atomRadius = segmentedControl.selectedSegmentIndex
        destVC.selectedAtomRadius = atomRadius
        destVC.updateRadii()
    }
}

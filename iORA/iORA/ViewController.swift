//
//  ViewController.swift
//  iORA
//
//  Created by Gabriel Reed on 1/4/21.
//

import UIKit
import SceneKit

let scene = SCNScene()

let masterAtom = SCNNode()
let masterBond = SCNNode()

var atoms: [SCNNode] = []
var atomActions: [SCNNode: AtomInfo] = [:]
var bonds: [SCNNode] = []

var stepDuration = 0.02
var step = 0
let scaleFactor = 1.0

var maxX = 0.0
var maxY = 0.0
var maxZ = 0.0

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: SCNView!
    let cameraNode = SCNNode()
    var timer = Timer()

    @IBOutlet weak var stepSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseXYZ(inputFile: "SN2")
//        parseXYZ(inputFile: "Single")
        sortAtoms()
        makeBonds()
        
        drawBond(atom1: atoms[0], atom2: atoms[9], givenDist: 1.0)
        
        sceneSetup()
        
        // Animation timer 
        if atomActions[atoms[0]]?.actions.count ?? 0 > 0 {
            weak var pass = self
            timer = Timer.scheduledTimer(timeInterval: stepDuration, target: pass as Any, selector: #selector(animate), userInfo: nil, repeats: true)
        }
    }
    
    
    func sceneSetup() {
        stepSlider.maximumValue = Float(atomActions[atoms[0]]?.actions.count ?? 1)
        
        scene.isPaused = true // FIXME: Delete
        
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: getCameraPosition(maxX: maxX, maxY: maxY, maxZ: maxZ))
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        print(cameraNode.position)
        scene.rootNode.addChildNode(cameraNode)
        
        // Scene light
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: -40, y: 40, z: 35)
        scene.rootNode.addChildNode(lightNode)
        
        // Ambient light
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.color = UIColor.darkGray
        ambientLightNode.position = SCNVector3(0.0, 0.0, -20.0)
        ambientLightNode.light?.intensity = 600 // Default 3500
        scene.rootNode.addChildNode(ambientLightNode)
        
        sceneView.backgroundColor = UIColor(red: 0.09, green: 0.28, blue: 0.59, alpha: 1.00) // Dark blue
        sceneView.allowsCameraControl = true
        
        scene.rootNode.addChildNode(masterAtom)
        scene.rootNode.addChildNode(masterBond)
        
        sceneView.scene = scene
    }
    
    @objc func animate() {
        if(!scene.isPaused) {
            for atom in atoms {
                atom.runAction(atomActions[atom]!.actions[step])
            }
            step += 1
            
            stepSlider.value = Float(step)
        }
        else {
            for atom in atoms {
                atom.position = atomActions[atom]?.positions[step] ?? SCNVector3(0, 0, 0)
            }
            
        }
        
        if step >= atomActions[atoms[0]]?.actions.count ?? 0 {
            step = 0
        }
        
        
        
        
        
        updateBonds()
    }
    
    @IBAction func stepSliderChanged(_ sender: Any) {
        step = Int(stepSlider.value)
    }
    
    func getCameraPosition(maxX: Double, maxY: Double, maxZ: Double) -> Float {
        let finalX = 3 * maxX + 11
        let finalY = 3 * maxY + 11
        let finalZ = maxZ + 11
        
        return Float(max(finalX, finalY, finalZ))
    }

    func sortAtoms() {
        atoms = atoms.sorted(by: { $0.name ?? "He" < $1.name ?? "He" })
        
        // Could I make it so that you could have a lookup hash map that will be sorted, then just run them off of that?
    }
}


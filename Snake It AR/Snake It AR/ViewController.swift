//
//  ViewController.swift
//  Snake It AR
//
//  Created by Jonathan Hallén on 2019-04-11.
//  Copyright © 2019 snake-group. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import GameplayKit

enum GameState {
    case noSnakePresent, snakeMoving, gameOver
}

enum VectorAxis {
    case x, z
}

class ViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var sceneView: ARSCNView!
    
    var gameState = GameState.noSnakePresent
    var snakeArray = [SCNNode]()
    var snakeVectorAxis = VectorAxis.z
    var timer: Timer?
    var GAME_SPEED_IN_SEC: Float = 0.01
    let MOVEMENTFACTOR: Float = 0.015
    var snakeVector: Float = 0
    var snakeHasMoved: Bool = false
    var planeHasBeenSet: Bool = false
    var snakeHasBeenCreated: Bool = false
    var planeScene = SCNScene(named: "art.scnassets/worldScene.scn")!
    var planeElevation: Float?
    var gridNode: SCNNode?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameState = GameState.noSnakePresent
        
        snakeVector = 0.001
       
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.scene.physicsWorld.contactDelegate = self
        
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        
        // Show debug options
        //sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        // Auto enable lighting
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Determine the orientaiton of the detection
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchGameState(touches)
    }
    
    func touchGameState(_ touches: Set<UITouch>) {
        switch gameState {
        case GameState.noSnakePresent:
            setupSnake(touches)
            break
        case GameState.snakeMoving:
            break
        case GameState.gameOver:
            break
        }
    }
    
    func respondToGestures(){
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if !planeHasBeenSet {
            let grid = Plane(anchor as! ARPlaneAnchor)
            node.addChildNode(grid)
            gridNode = grid
        }
    }
    
    func removeGrid() {
        if gridNode != nil {
            DispatchQueue.main.async {
                self.gridNode?.removeFromParentNode()
            }
        }
    }
    
    func addPlane(node: SCNNode, position: SCNVector3) {
        DispatchQueue.main.async {
            if let planeNode = self.planeScene.rootNode.childNode(withName: "worldScene", recursively: true) {
                planeNode.position = position
                planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: planeNode.physicsBody?.physicsShape)
                planeNode.physicsBody?.categoryBitMask = CollisionCategory.deathCategory.rawValue
                planeNode.physicsBody?.contactTestBitMask = CollisionCategory.snakeHeadCategory.rawValue
                planeNode.physicsBody?.isAffectedByGravity = false
                self.sceneView.scene.rootNode.addChildNode(planeNode)
                self.planeElevation = planeNode.position.y
                print("The plane has been set with height: \(planeNode.position.y)")
            }
            self.planeHasBeenSet = true
            self.spawnApple()
            self.removeGrid()
        }
    }
    
    func constructBodyPart(_ position: SCNVector3, _ name: String) {
        
        let snakeScene = SCNScene(named: "art.scnassets/\(name).scn")!
        if let snakeNode = snakeScene.rootNode.childNode(withName: name, recursively: true) {
            snakeNode.position = position
            if name == "snakeHead" {
                snakeNode.physicsBody = SCNPhysicsBody(type: .static, shape: snakeNode.physicsBody?.physicsShape)
                snakeNode.physicsBody?.categoryBitMask = CollisionCategory.snakeHeadCategory.rawValue
                snakeNode.physicsBody?.collisionBitMask = CollisionCategory.deathCategory.rawValue
                snakeNode.physicsBody?.isAffectedByGravity = false
            }
            
            sceneView.scene.rootNode.addChildNode(snakeNode)
            
            if !snakeHasBeenCreated {
                snakeArray.append(snakeNode)
            } else {
                snakeArray[snakeArray.count - 1].removeFromParentNode()
                snakeArray[snakeArray.count - 1] = snakeNode
                snakeNode.position.z = snakeArray[snakeArray.count - 1].position.z * snakeVector
                addTail(position)
            }
        }
    }
    
    func addTail(_ position: SCNVector3) {
        let name = "snakeTail"
        let snakeScene = SCNScene(named: "art.scnassets/\(name).scn")!
        if let snakeNode = snakeScene.rootNode.childNode(withName: name, recursively: true) {
            snakeNode.position = position
        
            sceneView.scene.rootNode.addChildNode(snakeNode)
            snakeArray.append(snakeNode)
        }
    }
    
    func eatApple(_ position: SCNVector3) {
        
        
        
        // constructBodyPart(<#T##position: SCNVector3##SCNVector3#>, <#T##name: String##String#>)
    }
    
    func setupSnake(_ touches: Set<UITouch>) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            if let hitResult = results.first {
                
                var position = SCNVector3(
                    x: hitResult.worldTransform.columns.3.x,
                    y: self.gridNode?.worldPosition.y ?? hitResult.worldTransform.columns.3.y,
                    z: hitResult.worldTransform.columns.3.z
                )
                addPlane(node: self.sceneView.scene.rootNode, position: position)
                
                constructBodyPart(position, "snakeHead")
                
                for count in 1...10 {
                    position.z = hitResult.worldTransform.columns.3.z - snakeVector * Float(count)
                    constructBodyPart(position, "snakeBody")
                }
                
                position.z = hitResult.worldTransform.columns.3.z - snakeVector * 11
                constructBodyPart(position, "snakeTail")
                snakeHasBeenCreated = true
                
                startSnakeMovement(position)
            }
        }
    }
    
    
    @IBAction func swipeLeft(_ sender: Any) {
        if (gameState == GameState.snakeMoving){
            let rotation = SCNAction.rotateBy(x: 0, y: CGFloat(0.5 * Double.pi), z: 0, duration: 0.1)
            snakeArray[0].runAction(rotation)
            switch snakeVectorAxis {
                case VectorAxis.x:
                    snakeVectorAxis = VectorAxis.z
                    snakeVector = snakeVector * -1
                break
                case VectorAxis.z:
                    snakeVectorAxis = VectorAxis.x
                break
            }
        }
    }
    
    @IBAction func swipeRight(_ sender: Any) {
        if (gameState == GameState.snakeMoving){
            let rotation = SCNAction.rotateBy(x: 0, y: CGFloat(0.5 * Double.pi) * -1, z: 0, duration: 0.1)
            snakeArray[0].runAction(rotation)
            switch snakeVectorAxis {
            case VectorAxis.x:
                snakeVectorAxis = VectorAxis.z
                break
            case VectorAxis.z:
                snakeVectorAxis = VectorAxis.x
                snakeVector = snakeVector * -1
                break
            }
        }
    }
    
    func startSnakeMovement(_ position: SCNVector3) {
        gameState = GameState.snakeMoving
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(GAME_SPEED_IN_SEC), target: self, selector: #selector(snakeWalk), userInfo: nil, repeats: true)
        }
    }
    
    func stopSnakeMovement() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
        gameState = GameState.gameOver
    }
    
    @objc func snakeWalk(){
        
        var oldSnakePositionArray = [SCNVector3?](repeating: nil, count: snakeArray.count)
        var oldSnakeRotationArray = [SCNVector4?](repeating: nil, count: snakeArray.count)
        
        for index in 0..<snakeArray.count {
            oldSnakePositionArray[index] = snakeArray[index].position
            oldSnakeRotationArray[index] = snakeArray[index].rotation
        }

        for index in 0..<snakeArray.count where index != 0{
            snakeArray[index].position = oldSnakePositionArray[index - 1]!
            snakeArray[index].rotation = oldSnakeRotationArray[index - 1]!
        }
        
        if (snakeVectorAxis == VectorAxis.z){
            snakeArray[0].position.z += snakeVector
        } else {
            snakeArray[0].position.x += snakeVector
        }
    }
    
    func spawnApple() {
        let appleScene = SCNScene(named: "art.scnassets/apple.scn")!
        if let appleNode = appleScene.rootNode.childNode(withName: "apple", recursively: true){
            appleNode.physicsBody = SCNPhysicsBody(type: .static, shape: appleNode.physicsBody?.physicsShape)
            appleNode.position = SCNVector3 (
                x: Float.random(in: -0.2...0.2),
                y: planeElevation ?? 0.01,
                z: Float.random(in: -0.2...0.2)
            )
            appleNode.physicsBody?.categoryBitMask = CollisionCategory.appleCategory.rawValue
            appleNode.physicsBody?.contactTestBitMask = CollisionCategory.snakeHeadCategory.rawValue
            appleNode.physicsBody?.isAffectedByGravity = false
            sceneView.scene.rootNode.addChildNode(appleNode)
            print("Spawned an apple at position (x: \(appleNode.position.x), z: \(appleNode.position.z))")
        }
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        print("** Collision!! " + contact.nodeA.name! + " hit " + contact.nodeB.name!)
        
        if contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.deathCategory.rawValue
            || contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.deathCategory.rawValue {
            print ("YOU FUCKING DEAD M8")
            stopSnakeMovement()
            DispatchQueue.main.async {
                
                //self.scoreLabel.text = String(self.score)
            }
        }
        
        if contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.appleCategory.rawValue
            || contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.appleCategory.rawValue {
            DispatchQueue.main.async {
                if contact.nodeA.name == "apple" {
                    contact.nodeA.removeFromParentNode()
                } else {
                    contact.nodeB.removeFromParentNode()
                }
                print ("MMM YUMMY")
                
                self.spawnApple()
                self.constructBodyPart(self.snakeArray[self.snakeArray.count - 1].position, "snakeBody")
                //self.scoreLabel.text = String(self.score)
            }
        }
    }
}

struct CollisionCategory: OptionSet {
    let rawValue: Int
    static let snakeHeadCategory = CollisionCategory(rawValue: 1 << 0)
    static let deathCategory = CollisionCategory(rawValue: 1 << 1)
    static let appleCategory = CollisionCategory(rawValue: 1 << 2)
}

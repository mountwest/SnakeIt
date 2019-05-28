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
    var GAME_SPEED_IN_SEC: Float = 0.2
    let MOVEMENTFACTOR: Float = 0.015
    var snakeVector: Float = 0
    var snakeHasMoved: Bool = false
    var planeHasBeenSet: Bool = false
    
    
    
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
            DispatchQueue.main.async {
                if let planeAnchor = anchor as? ARPlaneAnchor {
                    self.addPlane(node: node, anchor: planeAnchor)
                }
            }
        }
    }
    
    func addPlane(node: SCNNode, anchor: ARPlaneAnchor) {
        let plane = Plane(anchor)
        node.addChildNode(plane)
        print("The plane has been set with width: \(plane.GetGridGeometryProps().debugDescription)")
        let planeScene = SCNScene(named: "art.scnassets/worldScene.scn")!
        if let planeNode = planeScene.rootNode.childNode(withName: "worldScene", recursively: true) {
            planeNode.position = node.position
            sceneView.scene.rootNode.addChildNode(planeNode)
        }
    }
    
    func constructBodyPart(_ position: SCNVector3, _ name: String) {
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
    
    func spawnApple(_ position: SCNVector3) {
        let appleScene = SCNScene(named: "art.scnassets/apple.scn")!
        if let appleNode = appleScene.rootNode.childNode(withName: "apple", recursively: true){
            appleNode.position = position
            sceneView.scene.rootNode.addChildNode(appleNode)
        }
    }
    
    func setupSnake(_ touches: Set<UITouch>) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            if let hitResult = results.first {
                
                planeHasBeenSet = true
                
                var position = SCNVector3(
                    x: hitResult.worldTransform.columns.3.x,
                    y: hitResult.worldTransform.columns.3.y,
                    z: hitResult.worldTransform.columns.3.z
                )
                
                constructBodyPart(position, "snakeHead")
                
                position.z = hitResult.worldTransform.columns.3.z - MOVEMENTFACTOR
                constructBodyPart(position, "snakeBody")
                
                position.z = hitResult.worldTransform.columns.3.z - MOVEMENTFACTOR * 2
                constructBodyPart(position, "snakeTail")

                startSnakeMovement(position)
                
                spawnApple(position)
                
                for index in 0..<snakeArray.count {
                    print("index:\(index)   x:\(snakeArray[index].position.x)  y:\(snakeArray[index].position.y)  z:\(snakeArray[index].position.z)")
                    
                }
                print("---------")
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
    
    func CreateSnake() {
        
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
        
        for index in 0..<snakeArray.count where index != 0 {
            if (snakeArray[0].position.x == snakeArray[index].position.x && snakeArray[0].position.z == snakeArray[index].position.z) {
                stopSnakeMovement()
            }
        }
        
        if (snakeArray[0].position.x != nil && snakeArray[0].position.z != nil) {
            
        }
    }
}

extension ViewController: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let mask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        print(mask)
        
        switch mask {
        case 1 | 2:
            print("HIT!!!")
        default:
            break
        }
    }
}

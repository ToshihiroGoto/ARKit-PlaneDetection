//
//  ViewController.swift
//  PlaneDetection
//
//  Created by Toshihiro Goto on 2018/01/25.
//  Copyright © 2018年 Toshihiro Goto. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // デバッグ用に特徴点を表示
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // 水平と垂直で平面を認識
        configuration.planeDetection = [.vertical, .horizontal]
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    // アンカーが更新された時
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        DispatchQueue.main.async {
        
            // 平面を調べる
            if let planeAnchor = anchor as? ARPlaneAnchor {
                // Metal のデフォルトデバイスを設定する
                let device: MTLDevice = MTLCreateSystemDefaultDevice()!
                // ポリゴンを描画するジオメトリが生成される
                let plane = ARSCNPlaneGeometry.init(device: device)
                // ポリゴンを描画を更新
                plane?.update(from: planeAnchor.geometry)
                
                // 60%半透明の赤でマテリアルを着色
                plane?.firstMaterial?.diffuse.contents = UIColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.6)
                
                // アンカーのノードにジオメトリを適応
                node.geometry = plane
            }
            
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

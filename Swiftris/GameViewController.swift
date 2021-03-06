//
//  GameViewController.swift
//  Swiftris
//
//  Created by Darren Cheng on 11/27/14.
//  Copyright (c) 2014 SanguineRane. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, SwiftrisDelegate, UIGestureRecognizerDelegate {

  var scene: GameScene!
  var swiftris: Swiftris!

  override func viewDidLoad() {
    super.viewDidLoad()

    // Configure the view
    let skView = view as SKView
    skView.multipleTouchEnabled = false

    // Create and configure the scene
    scene = GameScene(size: skView.bounds.size)
    scene.scaleMode = .AspectFill

    scene.tick = didTick

    swiftris = Swiftris()
    swiftris.delegate = self
    swiftris.beginGame()

    // Present the scene
    skView.presentScene(scene)
  }

  override func prefersStatusBarHidden() -> Bool {
    return true
  }

  func didTick() {
    swiftris.letShapeFall()
  }

  func nextShape() {
    let newShapes = swiftris.newShape()
    if let fallingShape = newShapes.fallingShape {
      self.scene.addPreviewShapeToScene(newShapes.nextShape!) {}
      self.scene.movePreviewShape(fallingShape) {
        self.view.userInteractionEnabled = true
        self.scene.startTicking()
      }
    }
  }

  func gameDidBegin(swiftris: Swiftris) {
    if swiftris.nextShape != nil && swiftris.nextShape!.blocks[0].sprite == nil {
      scene.addPreviewShapeToScene(swiftris.nextShape!) {
        self.nextShape()
      }
    }
    else {
      nextShape()
    }
  }

  func gameDidEnd(swiftris: Swiftris) {
    view.userInteractionEnabled = false
    scene.stopTicking()
  }

  func gameDidLevelUp(swiftris: Swiftris) {

  }

  func gameShapeDidDrop(swiftris: Swiftris) {

  }

  func gameShapeDidLand(swiftris: Swiftris) {
    scene.stopTicking()
    nextShape()
  }

  func gameShapeDidMove(swiftris: Swiftris) {
    scene.redrawShape(swiftris.fallingShape!) {}
  }

  @IBAction func didTap(sender: UITapGestureRecognizer) {
    swiftris.rotateShape()
  }

}

//
//  ViewController.swift
//  Memory Puzzle
//
//  Created by Livia Carvalho Keller on 04/10/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var gameWonLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var gameMode: Int = 4
    var tileSize: CGFloat!
    
    var tilesArray: Array <MyImage> = []
    var centersArray: Array <CGPoint> = []
    
    var gameTime: Int = 0
    var gameTimer: Timer!
    
    var firstTile: MyImage!
    var secondTile: MyImage!
    var compareNow = false
    
    var foundTilesArray: Array <MyImage> = []
    
    var aTileIsAnimating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeTiles()
        randomize()
        updateTime()
        
        gameWonLabel.isHidden = true
 
    }
    
    @IBAction func resetAction(_ sender: UIButton) {
        resetActionFunction()
    }
    
    @IBAction func gameModelAction(_ sender: UISegmentedControl) {
        
        let index = sender.selectedSegmentIndex
        
        switch index {
        case 0:
            gameMode = 4
        case 1:
            gameMode = 6
        case 2:
            gameMode = 8
        default:
            break
        }
        
        resetActionFunction()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if (aTileIsAnimating) {
            return
        }
        
        let myTouch = touches.first
        
        if let tappedTile = myTouch?.view as? MyImage {
            
            if (foundTilesArray.contains(tappedTile)) {
                return
            }
            
            aTileIsAnimating = true
            
            if (compareNow) {
                if (tappedTile == firstTile) {
                    aTileIsAnimating = false
                    return
                }
                secondTile = tappedTile
                revealAndCompare(inpTile: tappedTile)
            } else {
                firstTile = tappedTile
                flipToReveal(inpTile: tappedTile)
            }
            compareNow = !compareNow
        }
    }
}

//MARK: - Timer Function

extension ViewController {
    
    @objc func timerFunction () {
        gameTime += 1
        
        let timeMin = String(format: "%02d", gameTime / 60)
        let timeSec = String(format: "%02d", gameTime % 60)
        timeLabel.text = "\(timeMin) : \(timeSec)"
    }
}

//MARK: - Make Tiles

extension ViewController {
    
    func makeTiles () {
        
        tilesArray = []
        centersArray = []
        
        // dividindo a UIView de acordo com o modo do jogo
        tileSize = gameView.frame.size.width / CGFloat (gameMode)
        // - 5 para dar um espaço entre as cartas
        let tileCgSize = CGSize(width: tileSize - 5, height: tileSize - 5)
        
        var xCen = tileSize / 2.0
        var yCen = tileSize / 2.0
        var counter = 0
        
        for _ in 0..<gameMode {
            // for que vai adicionando as cartas na horizontal
            for _ in 0..<gameMode {
                
                let tile = MyImage (frame: CGRect(origin: CGPoint.zero, size: tileCgSize))
                
                let tileCen = CGPoint(x: xCen, y: yCen)
                
                if (counter == gameMode * gameMode / 2) {
                    counter = 0
                }
                
                tile.isUserInteractionEnabled = true
                tile.internalNum = counter
                
                let imgName = String(format: "img_%02d.jpg", counter)
                tile.internalImage = UIImage (named: imgName)
                
                tile.image = MyImage.question

                
                tilesArray.append(tile)
                centersArray.append(tileCen)
                
                counter += 1
                
                tile.center = tileCen
                xCen += tileSize
                
                gameView.addSubview(tile)
            }
            
            xCen = tileSize / 2
            yCen += tileSize
        }
    }
}

//MARK: - Random

extension ViewController {
    
    func randomize () {
        
        var tempCenArray = centersArray
        for anyTiles in tilesArray {
            
            let ranIndex: Int = Int(arc4random_uniform(UInt32(tempCenArray.count)))
            let randomCenter = tempCenArray[ranIndex]
            anyTiles.center = randomCenter
            tempCenArray.remove(at: ranIndex)
        }
    }
}

//MARK: - Update Time

extension ViewController {
    
    func updateTime() {
        if (gameTimer != nil) {
            gameTimer.invalidate()
            timeLabel.text = "00 : 00"
        }
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
    }
}

//MARK: - Flipping a Tile

extension ViewController {
    
    func flipToReveal (inpTile: MyImage) {
        UIView.transition(with: inpTile, duration: 0.6, options: UIView.AnimationOptions.transitionFlipFromLeft, animations: {
//            inpTile.backgroundColor = UIColor.green
            inpTile.image = inpTile.internalImage
//            inpTile.text = "\(inpTile.internalNum!)"
        }, completion: {(res) in
            self.aTileIsAnimating = false
        })
    }
    
    func revealAndCompare (inpTile: MyImage) {
        UIView.transition(with: inpTile, duration: 0.6, options: UIView.AnimationOptions.transitionFlipFromLeft, animations: {
//            inpTile.backgroundColor = UIColor.green
            inpTile.image = inpTile.internalImage
//            inpTile.text = "\(inpTile.internalNum!)"
        }, completion: {(res) in
            self.compare()
            self.aTileIsAnimating = true
        })
    }
    
    func compare () {
        if (firstTile.internalNum == secondTile.internalNum) {
            
            flipToSmile(inpTile: firstTile)
            flipToSmile(inpTile: secondTile)
            
            foundTilesArray.append(firstTile)
            foundTilesArray.append(secondTile)
            
            didWeWin()
            
        } else {
            
            flipBack(inpTile: firstTile)
            flipBack(inpTile: secondTile)
        }
    }
}

//MARK: - Smile and Back

extension ViewController {
    
    func flipBack (inpTile: MyImage) {
        UIView.transition(with: inpTile, duration: 0.6, options: UIView.AnimationOptions.transitionFlipFromRight, animations: {
//            inpTile.backgroundColor = UIColor.blue
            inpTile.image = MyImage.question
//            inpTile.text = "\(MyImage.question)"
        }, completion: {(res) in
            self.aTileIsAnimating = false
        })
    }
    
    func flipToSmile (inpTile: MyImage) {
        UIView.transition(with: inpTile, duration: 0.6, options: UIView.AnimationOptions.transitionFlipFromLeft, animations: {
            inpTile.backgroundColor = UIColor.cyan
            inpTile.image = MyImage.check
//            inpTile.text = "\(MyImage.check)"
        }, completion: {(res) in
            self.aTileIsAnimating = false
        })
    }
}

//MARK: - Won State

extension ViewController {
    
    func didWeWin () {
        
        if (foundTilesArray.count == tilesArray.count) {
            gameTimer.invalidate()
            
            let txt = "You won in \(gameTime / 60) : \(gameTime % 60)"
            gameWonLabel.isHidden = false
            gameWonLabel.text = txt
        }
    }
}

//MARK: - Reset Action

extension ViewController {
    
    func resetActionFunction () {
        gameTime = 0
        foundTilesArray = []
        
        firstTile = nil
        secondTile = nil
        compareNow = false
        
        for a in tilesArray {
            a.removeFromSuperview()
        }
        
        makeTiles()
        randomize()
        updateTime()
    }
}

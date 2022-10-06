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
    
    var tilesArray: Array <MyLabel> = []
    var centersArray: Array <CGPoint> = []
    
    var gameTime: Int = 0
    var gameTimer: Timer!
    
    var firstTile: MyLabel!
    var secondTile: MyLabel!
    var compareNow = false
    
    var foundTilesArray: Array <MyLabel> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeTiles()
        randomize()
        updateTime()
        gameWonLabel.isHidden = true
    }
    
    @IBAction func resetAction(_ sender: UIButton) {
        
        gameTime = 0
        foundTilesArray = []
        
        for a in tilesArray {
            a.removeFromSuperview()
        }
        makeTiles()
        randomize()
        updateTime()
    }
    
    @IBAction func gameModelAction(_ sender: UISegmentedControl) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let myTouch = touches.first
        
        if let tappedTile = myTouch?.view as? MyLabel {
            
            if (compareNow) {
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
                
                let tile = MyLabel (frame: CGRect(origin: CGPoint.zero, size: tileCgSize))
                
                tile.font = UIFont.systemFont(ofSize: 50, weight: UIFont.Weight.bold)
                tile.textAlignment = NSTextAlignment.center
                
                let tileCen = CGPoint(x: xCen, y: yCen)
                
                if (counter == gameMode * gameMode / 2) {
                    counter = 0
                }
                
                tile.isUserInteractionEnabled = true
                tile.internalNum = counter
                tile.text = "\(MyLabel.question)"
                
                tilesArray.append(tile)
                centersArray.append(tileCen)
                
                counter += 1
                
                tile.center = tileCen
                xCen += tileSize
                
                tile.backgroundColor = UIColor.blue
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
    
    func flipToReveal (inpTile: MyLabel) {
        UIView.transition(with: inpTile, duration: 0.5, options: UIView.AnimationOptions.transitionFlipFromLeft, animations: {
            inpTile.backgroundColor = UIColor.green
            inpTile.text = "\(inpTile.internalNum!)"
        }, completion: nil)
    }
    
    func revealAndCompare (inpTile: MyLabel) {
        UIView.transition(with: inpTile, duration: 0.5, options: UIView.AnimationOptions.transitionFlipFromLeft, animations: {
            inpTile.backgroundColor = UIColor.green
            inpTile.text = "\(inpTile.internalNum!)"
        }, completion: {(res) in
            self.compare()
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
    
    func flipBack (inpTile: MyLabel) {
        UIView.transition(with: inpTile, duration: 0.5, options: UIView.AnimationOptions.transitionFlipFromRight, animations: {
            inpTile.backgroundColor = UIColor.blue
            inpTile.text = "\(MyLabel.question)"
        }, completion: nil)
    }
    
    func flipToSmile (inpTile: MyLabel) {
        UIView.transition(with: inpTile, duration: 0.5, options: UIView.AnimationOptions.transitionFlipFromLeft, animations: {
            inpTile.backgroundColor = UIColor.cyan
            inpTile.text = "\(MyLabel.smile)"
        }, completion: nil)
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

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeTiles()
        randomize()
    }
    
    func randomize () {
        
        var tempCenArray = centersArray
        for anyTiles in tilesArray {
            
            let ranIndex: Int = Int(arc4random_uniform(UInt32(tempCenArray.count)))
            let randomCenter = tempCenArray[ranIndex]
            anyTiles.center = randomCenter
            tempCenArray.remove(at: ranIndex)
        }
    }
    
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
                
                tile.internalNum = counter
                tile.text = "\(tile.internalNum!)"
                
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


    @IBAction func resetAction(_ sender: UIButton) {
        
    }
    
    @IBAction func gameModelAction(_ sender: UISegmentedControl) {
        
    }
    
}


//
//  MyLabel.swift
//  Memory Puzzle
//
//  Created by Livia Carvalho Keller on 06/10/22.
//

import UIKit

class MyLabel: UILabel {

    var internalNum: Int!
    
    static var question = "?"
    static var smile = "☺️"
}

class MyImage: UIImageView {

    var internalNum: Int!
    var internalImage: UIImage!
    
    static var question = UIImage (named: "question.png")
    static var check = UIImage (named: "check.png")
}

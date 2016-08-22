//
//  JLColorTheme.swift
//  Chromatism
//
//  Created by Johannes Lund on 2014-07-18.
//  Copyright (c) 2014 anviking. All rights reserved.
//

import UIKit

func UIColorRGB(_ r:Int, g:Int, b:Int) -> UIColor {
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
}

public enum ColorTheme {
    case `default`, dusk, civicModified, other([TokenType: UIColor])
    
    public subscript(type: TokenType) -> UIColor? {
        return dictionary[type]
    }
    
    private static let defaultTheme: [TokenType: UIColor] = [
        .text:                         UIColor.black,
        .background:                   UIColorRGB(255, g: 255, b: 255),
        .comment:                      UIColorRGB(0, g: 131, b: 39),
        .documentationComment:         UIColorRGB(0, g: 131, b: 39),
        .documentationCommentKeyword:  UIColorRGB(0, g: 76, b: 29),
        .string:                       UIColorRGB(211, g: 45, b: 38),
        .character:                    UIColorRGB(40, g: 52, b: 206),
        .number:                       UIColorRGB(40, g: 52, b: 206),
        .keyword:                      UIColorRGB(188, g: 49, b: 156),
        .preprocessor:                 UIColorRGB(120, g: 72, b: 48),
        .url:                          UIColorRGB(21, g: 67, b: 244),
        .otherClassNames:              UIColorRGB(92, g: 38, b: 153),
        .otherProperties:              UIColorRGB(92, g: 38, b: 153),
        .otherMethodNames:             UIColorRGB(46, g: 13, b: 110),
        .otherConstants:               UIColorRGB(46, g: 13, b: 110),
        .projectClassNames:            UIColorRGB(63, g: 110, b: 116),
        .projectProperties:            UIColorRGB(63, g: 110, b: 116),
        .projectConstants:             UIColorRGB(38, g: 71, b: 75),
        .projectMethodNames:           UIColorRGB(38, g: 71, b: 75)
    ]
    
    private static let duskTheme: [TokenType: UIColor] = [
        .text:                         UIColor.white,
        .background:                   UIColorRGB(30, g: 32, b: 40),
        .comment:                      UIColorRGB(72, g: 190, b: 102),
        .documentationComment:         UIColorRGB(72, g: 190, b: 102),
        .documentationCommentKeyword:  UIColorRGB(72, g: 190, b: 102),
        .string:                       UIColorRGB(230, g: 66, b: 75),
        .character:                    UIColorRGB(139, g: 134, b: 201),
        .number:                       UIColorRGB(139, g: 134, b: 201),
        .keyword:                      UIColorRGB(195, g: 55, b: 149),
        .preprocessor:                 UIColorRGB(198, g: 124, b: 72),
        .url:                          UIColorRGB(35, g: 63, b: 208),
        .otherClassNames:              UIColorRGB(4, g: 175, b: 200),
        .otherMethodNames:             UIColorRGB(4, g: 175, b: 200),
        .otherConstants:               UIColorRGB(4, g: 175, b: 200),
        .otherProperties:              UIColorRGB(4, g: 175, b: 200),
        .projectMethodNames:           UIColorRGB(131, g: 192, b: 87),
        .projectClassNames:            UIColorRGB(131, g: 192, b: 87),
        .projectConstants:             UIColorRGB(131, g: 192, b: 87),
        .projectProperties:            UIColorRGB(131, g: 192, b: 87)
        
    ]
    
    private static let civicModifiedTheme: [TokenType: UIColor] = [
        .text:                         UIColor.white,
        .background:                   UIColorRGB(31, g: 32, b: 41),
        .comment:                      UIColorRGB(69, g: 187, b: 62),
        .documentationComment:         UIColorRGB(34, g: 160, b: 85),
        .documentationCommentKeyword:  UIColorRGB(50, g: 207, b: 114),
        .string:                       UIColorRGB(211, g: 35, b: 46),
        .character:                    UIColorRGB(116, g: 109, b: 176),
        .number:                       UIColorRGB(20, g: 156, b: 146),
        .keyword:                      UIColorRGB(215, g: 0, b: 143),
        .preprocessor:                 UIColorRGB(199, g: 122, b: 75),
        .url:                          UIColorRGB(81, g: 36, b: 227),
        .otherClassNames:              UIColorRGB(37, g: 144, b: 141),
        .otherMethodNames:             UIColorRGB(37, g: 144, b: 141),
        .otherConstants:               UIColorRGB(37, g: 144, b: 141),
        .otherProperties:              UIColorRGB(37, g: 144, b: 141),
        .projectMethodNames:           UIColorRGB(31, g: 155, b: 113),
        .projectClassNames:            UIColorRGB(31, g: 155, b: 113),
        .projectConstants:             UIColorRGB(31, g: 155, b: 113),
        .projectProperties:            UIColorRGB(31, g: 155, b: 113),
        
    ]
    
    var dictionary: [TokenType: UIColor] {
        switch self {
        case .default:
            return ColorTheme.defaultTheme
        case .dusk:
            return ColorTheme.duskTheme
        case .civicModified:
            return ColorTheme.civicModifiedTheme
        case .other(let dictionary):
            return dictionary
        }
    }
}

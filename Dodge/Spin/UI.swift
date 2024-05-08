//
//  Labels.swift
//  Luga
//
//  Created by Murray Buchanan on 03/07/2023.
//  Copyright © 2023 Murray Buchanan. All rights reserved.
//
//
//public struct UI {
//
//    static func createLargeLabel(fontNamed: String) -> SKLabelNode {
//        let label = SKLabelNode(fontNamed: fontNamed)
//        label.fontSize = GameMetrics.SMALL_FONT
//        label.fontColor = GameColours.LABEL_COLOUR
//        label.zPosition = 5
//        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
//        return label
//    }
//    
//    static func createSmallLabel(name: String) -> SKLabelNode {
//        let label = SKLabelNode()
//        label.name = name
//        label.fontName = GameMetrics.SECONDARY_FONT
//        label.fontSize = GameMetrics.TINY_FONT
//        label.fontColor = GameColours.MENU_SECONDARY_COLOUR
//        label.zPosition = 5
//        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
//        label.isHidden = true
//        return label
//    }
//    
//    static func createIcon(imageNamed: String) -> SKSpriteNode {
//        let icon = SKSpriteNode(imageNamed: imageNamed)
//        icon.size = CGSize(width: GameMetrics.PLAYER_WIDTH / 2, height: GameMetrics.PLAYER_HEIGHT / 2)
//        icon.zPosition = 4
//        icon.isHidden = true
//        return icon
//    }
//    
//    static func createItemBackground(fill: UIColor) -> SKShapeNode {
//        let border = SKShapeNode()
//        border.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: GameMetrics.PLAYER_WIDTH * 1.5, height: GameMetrics.PLAYER_HEIGHT), cornerRadius: 10).cgPath
//        border.fillColor = fill
//        border.zPosition = 8
//        border.strokeColor = fill
//        border.lineWidth = GameMetrics.MENU_LINEWIDTH
//        border.isHidden = true
//        return border
//    }
//    
//    static func selectedShopItem() -> SKShapeNode {
//        let border = SKShapeNode()
//        border.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: GameMetrics.PLAYER_WIDTH * 1.5, height: GameMetrics.PLAYER_HEIGHT), cornerRadius: 10).cgPath
//        border.fillColor = .clear
//        border.strokeColor = GameColours.MENU_SECONDARY_COLOUR
//        border.lineWidth = GameMetrics.MENU_LINEWIDTH
//        border.zPosition = 9
//        border.isHidden = true
//        return border
//    }
//}

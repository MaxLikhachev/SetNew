//
//  SetCardDeck.swift
//  Set
//
//  Created by Максим Лихачев on 20/01/2019.
//  Copyright © 2019 Максим Лихачев. All rights reserved.
//

import Foundation

struct SetCardDeck {
    private(set) var cards = [SetCard]()

    init() {
        for number in SetCard.Variant.allCases {
            for color in SetCard.Variant.allCases {
                for shape in SetCard.Variant.allCases {
                    for fill in SetCard.Variant.allCases {
                        cards.append(SetCard(number: number, color: color, shape: shape, fill: fill))
                    }
                }
            }
        }
    }

    mutating func draw() -> SetCard? {
        if cards.count > 0 {
            return cards.remove(at: Int.random(in: 0..<cards.count))
        } else {
            return nil
        }
    }
}

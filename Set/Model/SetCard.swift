//
//  SetCard.swift
//  Set
//
//  Created by Максим Лихачев on 20/01/2019.
//  Copyright © 2019 Максим Лихачев. All rights reserved.
//

import Foundation

struct SetCard: Equatable, CustomStringConvertible {

    let number: Variant // count of figures
    let color: Variant  // number of color
    let shape: Variant  // number of figure
    let fill: Variant   // number of filling

    var description: String {return "\(number)-\(color)-\(shape)-\(fill)"}

    enum Variant: Int, CaseIterable, CustomStringConvertible  {
        case v1 = 1
        case v2 = 2
        case v3 = 3

        var description: String {return String(self.rawValue)}
        var idx: Int {return (self.rawValue - 1)}
    }

    static func isSet(cards: [SetCard]) -> Bool {
        guard cards.count == 3 else {return false} // guard проверяет условие, и если оно не выполнилось — требует выйти из текущего блока
        let sum = [
            cards.reduce(0, { $0 + $1.number.rawValue}),
            cards.reduce(0, { $0 + $1.color.rawValue}),
            cards.reduce(0, { $0 + $1.shape.rawValue}),
            cards.reduce(0, { $0 + $1.fill.rawValue})
        ]
        return sum.reduce(true, { $0 && ($1 % 3 == 0) })
    }
}

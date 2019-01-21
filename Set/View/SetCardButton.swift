//
//  SetCardButton.swift
//  Set
//
//  Created by Максим Лихачев on 20/01/2019.
//  Copyright © 2019 Максим Лихачев. All rights reserved.
//

//import Foundation
import UIKit

@IBDesignable class SetCardButton: BorderButton {

    //  Constants
    private struct Constants {
        static let cornerRadius: CGFloat = 8.0
        static let borderWidth: CGFloat = 5.0
        static let borderColor: UIColor   = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }

    var colors = [#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)]
    var alphas:[CGFloat] = [1.0, 0.40, 0.15]
    var strokeWidths:[CGFloat] = [ -8, 8, -8]
    var symbols = ["●", "▲", "■"]

    var setCard: SetCard? = SetCard(number: SetCard.Variant.v1,
                                    color: SetCard.Variant.v1,
                                    shape: SetCard.Variant.v1,
                                    fill: SetCard.Variant.v1) { didSet{updateButton()}}

    // Control type of landscape
    var verticalSizeClass: UIUserInterfaceSizeClass {return UIScreen.main.traitCollection.verticalSizeClass}

    // Update button
    private func updateButton () { // set-button
        if let card = setCard {
            let attributedString = setAttributedString(card: card)
            setAttributedTitle(attributedString, for: .normal)
            backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            isEnabled = true
        } else { // hidden button
            setAttributedTitle(nil, for: .normal)
            setTitle(nil, for: .normal)
            backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0)
            borderColor =   #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            isEnabled = false
        }
    }

    // Generate content on the button
    private func setAttributedString(card: SetCard) -> NSAttributedString{
        //  symbols: number & shape
        let symbol = symbols [card.shape.idx]
        let separator = verticalSizeClass == .regular ? "\n" : " "
        let symbolsString = symbol.join(n: card.number.rawValue, with: separator)
        //  attributes: color & fill
        let attributes:[NSAttributedString.Key : Any] = [
            .strokeColor: colors[card.color.idx],
            .strokeWidth: strokeWidths[card.fill.idx],
            .foregroundColor: colors[card.color.idx].withAlphaComponent(alphas[card.fill.idx])
        ]
        return NSAttributedString(string: symbolsString, attributes: attributes)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateButton()
    }

    // Sel color button when: select card, set card, notset card
    func setBorderColor (color: UIColor) {
        borderColor =  color
        borderWidth = Constants.borderWidth
    }
}

extension String {
    func join(n: Int, with separator:String )-> String{
        guard n > 1 else {return self}
        var symbols = [String] ()
        for _ in 0..<n {
            symbols += [self]
        }
        return symbols.joined(separator: separator)
    }
}

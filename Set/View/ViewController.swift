//
//  ViewController.swift
//  Set
//
//  Created by Максим Лихачев on 20/01/2019.
//  Copyright © 2019 Максим Лихачев. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var game = SetGame()
    var colors = [#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)]
    var strokeWidths:[CGFloat] = [ -10, 10, -10]
    var alphas:[CGFloat] = [1.0, 0.6, 0.15]

    @IBOutlet var cardButtons: [SetCardButton]! {
        didSet {
            for button in cardButtons{
                button.strokeWidths = strokeWidths
                button.colors = colors
                button.alphas = alphas
            }
        }
    }
    
    // Labels
    @IBOutlet weak var deckCountLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!

    //  Buttons
    @IBOutlet weak var dealButton: BorderButton!
    @IBOutlet weak var newButton: BorderButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel();
    }

    @IBAction func touchCard(_ sender: SetCardButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Choosen card not in cardButtons")
        }
    }

    @IBAction func deal3() {
        if (game.cardsOnTable.count + 3) <= cardButtons.count {
            game.deal3()
            updateViewFromModel()
        }
    }

    @IBAction func NewGame() {
        game = SetGame()
        updateViewFromModel()
    }

    private func updateButtonsFromModel() {
        messageLabel.text = ""

        for index in cardButtons.indices {
            let button = cardButtons[index]
            if index < game.cardsOnTable.count {
                //
                let card = game.cardsOnTable[index]
                button.setCard = card
                //  Selected
                button.setBorderColor(color: game.cardsSelected.contains(card) ? Colors.selected : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0))
                //  TryMatched
                if let itIsSet = game.isSet {
                    if game.cardsTryMatched.contains(card) {
                        button.setBorderColor(color: itIsSet ? Colors.matched: Colors.misMatched)
                    }
                    messageLabel.text = itIsSet ? "👍🏻" :"👎🏻"
                }
                //
            } else {
                button.setCard = nil
            }
        }
    }

    private func updateViewFromModel() {
        updateButtonsFromModel()
        deckCountLabel.text = "Deck: \(game.deckCount )"
        scoreLabel.text = "Score: \(game.score) | \(game.numberSets)"

        dealButton.disable = (game.cardsOnTable.count) >= cardButtons.count || game.deckCount == 0
    }
}

extension ViewController {
    //  Constants
    private struct Colors {
        static let hint = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        static let selected = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        static let matched = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        static var misMatched = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
    }
}

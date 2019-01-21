//
//  SetGame.swift
//  Set
//
//  Created by Максим Лихачев on 20/01/2019.
//  Copyright © 2019 Максим Лихачев. All rights reserved.
//

import Foundation

struct SetGame {

    private(set) var cardsOnTable = [SetCard]() // cards on table
    private(set) var cardsSelected = [SetCard]() // selected cards
    private(set) var cardsTryMatched = [SetCard]() // 3 cards for test on Set
    private(set) var cardsRemoved = [SetCard]() // Cards on Set and removed from game

    private var deck = SetCardDeck() // deck with 81 cards
    var deckCount: Int {return deck.cards.count} // count of cards in deck

    private(set) var flipCount = 0
    private(set) var score = 0
    private(set) var numberSets = 0

    //  Checked, are 3 cards in set, or not
    var isSet: Bool? {
        get {
            guard cardsTryMatched.count == 3 else {return nil}
            return SetCard.isSet(cards: cardsTryMatched)
        }
        set {
            if newValue != nil {
                if newValue! {          //cards matchs
                    score += Points.matchBonus
                    numberSets += 1
                } else {               //cards didn't match
                    score -= Points.missMatchPenalty
                }
                cardsTryMatched = cardsSelected
                cardsSelected.removeAll()
            } else {
                cardsTryMatched.removeAll()
            }
        }
    }

    // Taking 3 new random cards, if they exist
    private mutating func take3FromDeck() -> [SetCard]?{
        var threeCards = [SetCard]()
        for _ in 0...2 {
            if let card = deck.draw() {
                threeCards += [card]
            } else {
                return nil
            }
        }
        return threeCards
    }

    // Deal 3 new cards on table
    mutating func deal3() {
        if let deal3Cards =  take3FromDeck() {
            cardsOnTable += deal3Cards
        }
    }

    // Choose 3 cards for check set
    mutating func chooseCard(at index: Int) {
        let cardChoosen = cardsOnTable[index]
        if !cardsRemoved.contains(cardChoosen) && !cardsTryMatched.contains(cardChoosen) {
            if  isSet != nil{
                if isSet! { replaceOrRemove3Cards()}
                isSet = nil
            }
            if cardsSelected.count == 2, !cardsSelected.contains(cardChoosen){
                cardsSelected += [cardChoosen]
                isSet = SetCard.isSet(cards: cardsSelected)
            } else {
                cardsSelected.inOut(element: cardChoosen)
            }
            flipCount += 1
            score -= Points.flipOverPenalty
        }
    }

    //  New cards from deck after removing
    private mutating func replaceOrRemove3Cards(){
        if cardsOnTable.count == Constants.startNumberCards,
            let take3Cards =  take3FromDeck() {
            cardsOnTable.replace(elements: cardsTryMatched, with: take3Cards)
        } else {
            cardsOnTable.remove(elements: cardsTryMatched)
        }
        cardsRemoved += cardsTryMatched
        cardsTryMatched.removeAll()
    }

    init() {
        for _ in 1...Constants.startNumberCards {
            if let card = deck.draw() {
                cardsOnTable += [card]
            }
        }
    }

    //  Constants
    private struct Points {
        static let matchBonus = 20
        static let missMatchPenalty = 10
        static var maxTimePenalty = 10
        static var flipOverPenalty = 1
        static var deal3Penalty = 5
    }

    private struct Constants {
        static let startNumberCards = 12
    }
}

extension Array where Element : Equatable {
    /// переключаем присутствие элемента в массиве:
    /// если нет - включаем, если есть - удаляем
    mutating func inOut(element: Element){
        if let from = self.index(of:element)  {
            self.remove(at: from)
        } else {
            self.append(element)
        }
    }

    mutating func remove(elements: [Element]){
        /// Удаляем массив элементов из массива
        self = self.filter { !elements.contains($0) }
    }

    mutating func replace(elements: [Element], with new: [Element] ){
        /// Заменяем элементы массива на новые
        guard elements.count == new.count else {return}
        for idx in 0..<new.count {
            if let indexMatched = self.index(of: elements[idx]){
                self [indexMatched ] = new[idx]
            }
        }
    }

    func indices(of elements: [Element]) ->[Int]{
        guard self.count >= elements.count, elements.count > 0 else {return []}
        /// Ищем индексы элементов elements у себя - self
        return elements.map{self.index(of: $0)}.compactMap{$0}
    }
}

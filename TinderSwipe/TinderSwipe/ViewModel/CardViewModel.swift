//
//  CardViewModel.swift
//  TinderSwipe
//
//  Created by Shi Pra on 04/10/22.
//

import Foundation

struct CardViewModel {
    var title: String
    var subTitle: String
    var imgStr: String
}

class CardData {
    var data: [CardViewModel] = []
    
    func getInitialData() {
        data.append(CardViewModel(title: "First", subTitle: "First Subtitle", imgStr: "1"))
        data.append(CardViewModel(title: "Second", subTitle: "First Subtitle", imgStr: "2"))
        data.append(CardViewModel(title: "Third", subTitle: "First Subtitle", imgStr: "3"))
        data.append(CardViewModel(title: "Forth", subTitle: "First Subtitle", imgStr: "4"))
        data.append(CardViewModel(title: "Fifth", subTitle: "First Subtitle", imgStr: "5"))
        data.append(CardViewModel(title: "Sixth", subTitle: "First Subtitle", imgStr: "6"))
        data.append(CardViewModel(title: "Seventh", subTitle: "First Subtitle", imgStr: "7"))
        data.append(CardViewModel(title: "Eighth", subTitle: "First Subtitle", imgStr: "8"))
        data.append(CardViewModel(title: "Ninth", subTitle: "First Subtitle", imgStr: "9"))
        data.append(CardViewModel(title: "Tenth", subTitle: "First Subtitle", imgStr: "10"))
    }
}

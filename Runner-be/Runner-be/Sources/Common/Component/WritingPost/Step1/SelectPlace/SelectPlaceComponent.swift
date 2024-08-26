//
//  SelectPlaceComponent.swift
//  Runner-be
//
//  Created by 김창규 on 8/20/24.
//

import UIKit

final class SelectPlaceComponent {
    var scene: (VC: UIViewController, VM: SelectPlaceViewModel) {
        let viewModel = viewModel
        return (SelectPlaceViewController(viewModel: viewModel),
                viewModel)
    }

    private var viewModel: SelectPlaceViewModel {
        return SelectPlaceViewModel(timeString: timeString)
    }

    private var timeString: String

    init(timeString: String) {
        self.timeString = timeString
    }

    func detailSelectPlaceComponent(placeInfo: PlaceInfo) -> DetailSelectPlaceComponent {
        return DetailSelectPlaceComponent(placeInfo: placeInfo)
    }
}

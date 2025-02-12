//
//  UIColor+Zeplin.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import UIKit

extension UIColor {
    @nonobjc class var primarydark: UIColor {
        // 254 207 108
        return UIColor(red: 254.0 / 255.0, green: 207.0 / 255.0, blue: 108.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var primaryBestDark: UIColor {
        return UIColor(red: 68.0 / 255.0, green: 63.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var primary: UIColor {
        // 255, 221, 98
        return UIColor(red: 1.0, green: 221.0 / 255.0, blue: 98.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var primarydarker: UIColor {
        return UIColor(red: 238.0 / 255.0, green: 212.0 / 255.0, blue: 132.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var darkBlack: UIColor {
        return UIColor(white: 0.0, alpha: 1.0)
    }

    @nonobjc class var error: UIColor {
        return UIColor(red: 167.0 / 255.0, green: 0.0, blue: 7.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var errorlight: UIColor {
        return UIColor(red: 245.0 / 255.0, green: 155.0 / 255.0, blue: 146.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var darkG7: UIColor {
        return UIColor(white: 20.0 / 255.0, alpha: 1.0)
    }

    /// #292929
    @nonobjc class var darkG6: UIColor {
        return UIColor(white: 41.0 / 255.0, alpha: 1.0)
    }

    /// #363636
    @nonobjc class var darkG55: UIColor {
        return UIColor(white: 54.0 / 255.0, alpha: 1.0)
    }

    /// #414141
    @nonobjc class var darkG5: UIColor {
        return UIColor(white: 65.0 / 255.0, alpha: 1.0)
    }

    /// #595959
    @nonobjc class var darkG45: UIColor {
        return UIColor(white: 89.0 / 255.0, alpha: 1.0)
    }

    /// #6F6F6F
    @nonobjc class var darkG4: UIColor {
        return UIColor(white: 111.0 / 255.0, alpha: 1.0)
    }

    /// #8D8D8D
    @nonobjc class var darkG35: UIColor {
        return UIColor(white: 141.0 / 255.0, alpha: 1.0)
    }

    /// #A8A8A8
    @nonobjc class var darkG3: UIColor {
        return UIColor(white: 168.0 / 255.0, alpha: 1.0)
    }

    /// #BDBDBD
    @nonobjc class var darkG25: UIColor {
        return UIColor(white: 189.0 / 255.0, alpha: 1.0)
    }

    /// #CDCDCD
    @nonobjc class var darkG2: UIColor {
        return UIColor(white: 205.0 / 255.0, alpha: 1.0)
    }

    /// #F5F5F5
    @nonobjc class var darkG1: UIColor {
        return UIColor(white: 245.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var darkWhite100: UIColor {
        return UIColor(white: 1.0, alpha: 1.0)
    }

    // +
    @nonobjc class var bgTop: UIColor {
        return UIColor(red: 18.0 / 255.0, green: 18.0 / 255.0, blue: 18.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var bgBottom: UIColor {
        return UIColor(red: 27.0 / 255.0, green: 26.0 / 255.0, blue: 23.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var bgSheet: UIColor {
        return UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    }

    @nonobjc class var sliderBgBot: UIColor {
        return UIColor(red: 239.0 / 255.0, green: 182.0 / 255.0, blue: 97.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var sliderBgTop: UIColor {
        return .primarydark
    }

    @nonobjc class var segmentBgBot: UIColor {
        return UIColor(red: 220.0 / 255.0, green: 173.0 / 255.0, blue: 102.0 / 255.0, alpha: 1)
    }

    @nonobjc class var segmentBgTop: UIColor {
        return UIColor(red: 233.0 / 255.0, green: 207.0 / 255.0, blue: 130.0 / 255.0, alpha: 1)
    }
}

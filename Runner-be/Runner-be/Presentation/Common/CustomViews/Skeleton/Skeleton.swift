
import MapKit
import UIKit

// 1
protocol SkeletonDisplayable {
    func showSkeleton()
    func hideSkeleton()
}

// 2
extension SkeletonDisplayable where Self: UIViewController {
    // 3
    private var skeletonLayerName: String {
        return "skeletonLayerName"
    }

    private var skeletonGradientName: String {
        return "skeletonGradientName"
    }

    // 4
    private func skeletonViews(in view: UIView) -> [UIView] {
        var results = [UIView]()
        for subview in view.subviews as [UIView] {
            switch subview {
            case _ where subview.isKind(of: RunnerbeNavBar.self):
                break
            case _ where subview.isKind(of: BadgeLabel.self):
                results += [subview]
            case _ where subview.isKind(of: UITextView.self):
                results += [subview]
            case _ where subview.isKind(of: MKMapView.self):
                results += [subview]
            case _ where subview.isKind(of: UILabel.self):
                results += [subview]
            case _ where subview.isKind(of: UIImageView.self):
                results += [subview]
            case _ where subview.isKind(of: UIButton.self):
                results += [subview]
            default: results += skeletonViews(in: subview)
            }
        }
        return results
    }

    // 5
    func showSkeleton() {
        let skeletons = skeletonViews(in: view)
        let backgroundColor = UIColor.darkG6.cgColor
        let highlightColor = UIColor.darkG55.cgColor

        let skeletonLayer = CALayer()
        skeletonLayer.backgroundColor = backgroundColor
        skeletonLayer.name = skeletonLayerName
        skeletonLayer.anchorPoint = .zero
        skeletonLayer.frame.size = UIScreen.main.bounds.size

        skeletons.forEach {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [backgroundColor, highlightColor, backgroundColor]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.frame = UIScreen.main.bounds
            gradientLayer.frame.size = CGSize(width: UIScreen.main.bounds.width * 2, height: UIScreen.main.bounds.height)
            gradientLayer.name = skeletonGradientName

            $0.layer.mask = skeletonLayer
            $0.layer.addSublayer(skeletonLayer)
            $0.layer.addSublayer(gradientLayer)
            $0.clipsToBounds = true
            let widht = UIScreen.main.bounds.width

            let animation = CABasicAnimation(keyPath: "transform.translation.x")
            animation.duration = 3
            animation.fromValue = -widht
            animation.toValue = 0
            animation.repeatCount = .infinity
            animation.autoreverses = false
            animation.fillMode = CAMediaTimingFillMode.forwards

            gradientLayer.add(animation, forKey: "gradientLayerShimmerAnimation")
        }
    }

    // 6
    func hideSkeleton() {
        skeletonViews(in: view).forEach {
            $0.layer.sublayers?.removeAll {
                $0.name == skeletonLayerName || $0.name == skeletonGradientName
            }
        }
    }
}

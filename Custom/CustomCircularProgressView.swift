//
//  CustomCircularProgressView.swift
//  WellnexApp
//
//  Created by MacBook on 29.05.2025.
//

import UIKit

@IBDesignable
class CustomCircularProgressView: UIView {

    private let trackLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let percentageLabel = UILabel()

    @IBInspectable var lineWidth: CGFloat = 10
    @IBInspectable var trackColor: UIColor = UIColor.systemGray5
    @IBInspectable var progressColor: UIColor = UIColor.systemGreen

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        layer.addSublayer(trackLayer)
        layer.addSublayer(progressLayer)

        percentageLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        percentageLabel.textAlignment = .center
        percentageLabel.textColor = .black
        addSubview(percentageLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - lineWidth / 2

        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -CGFloat.pi / 2,
            endAngle: 1.5 * .pi,
            clockwise: true
        )

        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = lineWidth
        trackLayer.fillColor = UIColor.clear.cgColor

        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeEnd = 0
        progressLayer.lineCap = .round

        percentageLabel.frame = bounds
    }

    /// Oranı 0.0 - 1.0 arasında ayarla
    func setProgress(to progress: CGFloat,fontSize: Double = 18, animated: Bool = true) {
        let clampedProgress = max(0, min(progress, 1))
        let percent = Int(clampedProgress * 100)
        percentageLabel.text = "\(percent)%"
        percentageLabel.font = .systemFont(ofSize: fontSize, weight: .semibold)

        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.toValue = clampedProgress
            animation.duration = 0.5
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            progressLayer.add(animation, forKey: "progressAnim")
        } else {
            progressLayer.strokeEnd = clampedProgress
        }
    }
}

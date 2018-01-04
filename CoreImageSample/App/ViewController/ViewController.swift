//
//  ViewController.swift
//  CoreImageSample
//
//  Created by はるふ on 2017/12/11.
//  Copyright © 2017年 ha1f. All rights reserved.
//

import UIKit
import EasyImagy

extension UIView {
    func constraintTo(centerOf view: UIView, width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerYAnchor.constraint(equalTo: view.centerYAnchor),
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalToConstant: height)
            ])
    }
    
    func constraintTo(frameOf view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor),
            leftAnchor.constraint(equalTo: view.leftAnchor),
            rightAnchor.constraint(equalTo: view.rightAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}

class ViewController: UIViewController {
    
    let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        imageView.constraintTo(centerOf: view, width: 256, height: 256)
        
        imageView.image = #imageLiteral(resourceName: "sample.PNG")
        
        self.fillImage(point: PixelPoint(x: 350, y: 220), color: .green) {
            self.fillImage(point: PixelPoint(x: 750, y: 320), color: .red) {
                self.fillImage(point: PixelPoint(x: 230, y: 720), color: .blue) {
                    self.fillImage(point: PixelPoint(x: 10, y: 10), color: .black) {
                        print("complete")
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.present(CanvasViewController(), animated: true, completion: nil)
    }
    
    private func fillImage(point: PixelPoint, color: RGBA<UInt8>, completion: (() -> Void)? = nil) {
        guard let image = self.imageView.image.map({ Image<RGBA<UInt8>>(uiImage: $0) }) else {
            return
        }
        DispatchQueue.global(qos: .default).async { [weak self] in
            let image = image.filled(from: point, color: color)
            DispatchQueue.main.async {
                self?.imageView.image = image?.uiImage
                completion?()
            }
        }
    }
}

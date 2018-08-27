//
//  SavedPageTVCell.swift
//  WyQi
//
//  Created by Shantanu Dutta on 8/27/18.
//  Copyright © 2018 Shantanu Dutta. All rights reserved.
//

import UIKit
import ChameleonFramework

class SavedPageTVCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var viewModel: SavedViewCellModel! {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        viewModel.title.bind { [weak self] (value) in
            OperationQueue.main.addOperation {
                self?.title.text = value
            }
        }
        
        viewModel.body.bind { [weak self] (value) in
            OperationQueue.main.addOperation {
                self?.descLabel.text = value ?? nil
            }
        }
        
        viewModel.thumbnail.bind { [weak self] (imageName) in
            OperationQueue.main.addOperation {
                if let name = imageName
                {
                    let imagePath = FileHelper.imageDirectory.appendingPathComponent(name)
                    if FileManager.default.fileExists(atPath: imagePath.path) {
                        if let image = UIImage(contentsOfFile: imagePath.path) {
                            self?.thumbImage.image = image
                        }
                        
                    }
                    
                }
            }
        }
        formatImageView()
        updateCellView()
    }
    
    private func formatImageView(){
        thumbImage.layer.cornerRadius = 6.0
        thumbImage.layer.masksToBounds = true
        thumbImage.clipsToBounds = true
        
        thumbImage.layer.borderWidth = 1.0
        thumbImage.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    private func updateCellView() {
        let color = GradientColor(.diagonal, frame: containerView.frame, colors: [FlatWhite(),FlatWhiteDark()])
        containerView.backgroundColor = color
        containerView.alpha = 0.8
        title.textColor = ContrastColorOf(color, returnFlat: true)
        descLabel.textColor = ContrastColorOf(color, returnFlat: true)
        containerView.layer.cornerRadius = 5.0
        containerView.layer.masksToBounds = false
        containerView.clipsToBounds = true
        containerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowOpacity = 0.8
    }
}

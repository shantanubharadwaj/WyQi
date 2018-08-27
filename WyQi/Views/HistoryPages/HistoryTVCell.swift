//
//  HistoryTVCell.swift
//  WyQi
//
//  Created by Shantanu Dutta on 27/08/18.
//  Copyright © 2018 Shantanu Dutta. All rights reserved.
//

import UIKit

class HistoryTVCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var viewModel: HistoryViewCellModel! {
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
                var didDisplay = false
                self?.thumbImage.isHidden = false
                if let name = imageName
                {
                    let imagePath = FileHelper.imageDirectory.appendingPathComponent(name)
                    if FileManager.default.fileExists(atPath: imagePath.path) {
                        if let image = UIImage(contentsOfFile: imagePath.path) {
                            self?.thumbImage.image = image
                            didDisplay = true
                        }
                    }
                }
                if !didDisplay {
                    self?.thumbImage.isHidden = true
                }
            }
        }
        formatImageView()
    }
    
    private func formatImageView(){
        thumbImage.layer.cornerRadius = 6.0
        thumbImage.layer.masksToBounds = true
        thumbImage.clipsToBounds = true
        
        thumbImage.layer.borderWidth = 1.0
        thumbImage.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
}

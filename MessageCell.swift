//
//  MessageCell.swift
//  Novagraph1
//
//  Created by Sophie on 12/17/18.
//  Copyright © 2018 Sophie Zhou. All rights reserved.
//

import UIKit

protocol MessageCellDelegate: class {

    func messageCellDidTapDuplicate(cell: MessageCell)
    func messageCellDidTapDelete(cell: MessageCell)

}

class MessageCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var duplicateButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!

    weak var delegate: MessageCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.label.numberOfLines = 0
        self.duplicateButton.addTarget(self, action: #selector(duplicateButtonPressed), for: .touchUpInside)
        self.deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
    }

    @objc func duplicateButtonPressed() {
        self.delegate?.messageCellDidTapDuplicate(cell: self)
    }

    @objc func deleteButtonPressed() {
        self.delegate?.messageCellDidTapDelete(cell: self)
    }
    
}

//
//  MainTableViewCell.swift
//  DripHeart
//
//  Created by おいちいたまご on 2021/06/29.
//

import UIKit


class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var value: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
       super.prepareForReuse()
        // TableViewのセルを再利用される時に以前の値が入らないようにクリアする
        // 詳細は以下を確認
        // https://note.com/iga34engineer/n/n3ae6a085f5ab
        self.title?.text = ""
        self.value?.text = ""
        self.accessoryType = UITableViewCell.AccessoryType.none
        self.accessoryView = nil
    }
    
}

//
//  MainDropTableViewCell.swift
//  DripHeart
//
//  Created by おいちいたまご on 2021/07/02.
//

import UIKit


class MainDropTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var value: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        //
    }
    
    override func prepareForReuse() {
       super.prepareForReuse()
       // TableViewのセルを再利用される時に以前の値が入らないようにクリアする
        self.title?.text = ""
        self.value?.text = ""
    }
    
}

//
//  JQPictureView.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/17.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

private let cellID = "JQPictureViewCellId"


class JQPictureView: UICollectionView {
    
    var pictureInfo: [JQStatusPictureInfo]? {
        didSet {
            self.textLabel.text = "\(pictureInfo?.count ?? 0)张"
            
            reloadData()
        }
    }
    
    override func awakeFromNib() {
        
        self.backgroundColor = UIColor.randomColor()
        
        self.dataSource = self
        self.delegate = self
        
        addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
        self.register(JQPictureCell.self, forCellWithReuseIdentifier: cellID)
        
    }
    
    private lazy var textLabel: UILabel = {
        let l = UILabel(title: "11", textColor: UIColor.darkGray, fontSize: 14)
        
        return l
    }()

}

extension JQPictureView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.pictureInfo?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! JQPictureCell
        
        cell.backgroundColor = UIColor.randomColor()
        
        cell.picture = pictureInfo![indexPath.row]
        
        return cell
    }
    
}

class JQPictureCell: UICollectionViewCell {
    
    var picture: JQStatusPictureInfo? {
        didSet {
            let url = URL(string: picture?.wap_pic ?? "")
            imageView.sd_setImage(with: url)
            
            //根据数据来设置是否显示gif的图片
            gificon.isHidden = !url!.absoluteString.hasSuffix(".gif")
        
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
        
        contentView.addSubview(gificon)
        
        gificon.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(self.contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private lazy var imageView:UIImageView = {
        
        let iv = UIImageView()
        
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    private lazy var gificon: UIImageView = UIImageView(image: #imageLiteral(resourceName: "timeline_image_gif"))

    
}

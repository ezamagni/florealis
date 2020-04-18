//
//  LocationPanelView.swift
//  FitoMap
//
//  Created by Enrico Zamagni on 04/02/2020.
//  Copyright © 2020 Enrico Zamagni. All rights reserved.
//

import UIKit
import CoreLocation

class LocationPanelView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet var cfceLabel: UILabel!
    @IBOutlet var gpsLabel: UILabel!
    @IBOutlet var grdLabel: UILabel!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("LocationPanelView", owner: self, options: nil)
        view.frame = bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowOpacity = 0.24
        
        setupWith(cfceCoordinate: nil, gpsCoordinate: nil, grdCoordinate: nil)
    }
    
    func setupWith(cfceCoordinate: CfceCoordinate?, gpsCoordinate: CLLocationCoordinate2D?, grdCoordinate: GradCoordinate?) {
        cfceLabel.text = cfceCoordinate?.toString()
        gpsLabel.text = gpsCoordinate?.toString()
        grdLabel.text = grdCoordinate?.toString()
        [cfceLabel, gpsLabel, grdLabel].forEach({ $0?.isHidden = $0?.text == nil })
    }
}

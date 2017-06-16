//
//  CompetitionsCollectionViewController.swift
//  Trafi
//
//  Created by Joppe Geluykens on 2017-06-12.
//  Copyright © 2017 Young Wolves. All rights reserved.
//

import Alamofire
import Pastel
import SwiftyJSON
import UIKit
import UPCarouselFlowLayout

private let reuseIdentifier = "CompetitionCell"

class CompetitionsCollectionViewController: UICollectionViewController {

    var competitions = [Int: [Competition]]()
    
    fileprivate var orientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }
    
    fileprivate var currentPage: Int = 0
    
    fileprivate var pageSize: CGSize {
        let layout = self.collectionView?.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        self.currentPage = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(CompetitionsCollectionViewController.rotationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        downloadCompetitions()
    }
    
    fileprivate func setupLayout() {
        let layout = self.collectionView?.collectionViewLayout as! UPCarouselFlowLayout
        let screenSize = UIScreen.main.bounds
        layout.itemSize = CGSize(width: screenSize.width*0.8, height: screenSize.height*0.7)
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 30)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        guard let layout = self.collectionView?.collectionViewLayout as? UPCarouselFlowLayout else {
            return
        }
        layout.itemSize = CGSize(width: size.width*0.8, height: size.height*0.7)
        layout.invalidateLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Make status bar have a white background
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = .white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        // Default gives black status bar text
        return .default
    }
    
    // MARK: - Download competitions
    
    /// Reads competition data from Trafi API and stores them in a Competition list.
    private func downloadCompetitions() {
        
        // Send get request to Trafi API for competitions
        Alamofire.request("https://api.trafi.be/competitions").validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                // Create SwiftyJSON object from response result
                let json = JSON(value)
                // Create Competition object from each subJson in the json array
                for (_,subJson):(String, JSON) in json {
                    self.addToCompetitions(Competition(subJson)!)
                }
                // Competition array now has elements 🎉
                self.collectionView!.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /// Adds given competition to the appropriate array in the competitions dictionary, based on the year of the competition.
    private func addToCompetitions(_ comp: Competition) {
        let currentCompYear = Calendar.current.dateComponents([.year], from: comp.date).year!
        // Only keep this year's competitions
        if currentCompYear != Calendar.current.component(.year, from: Date()) {
            return
        }
        // If year array existent,
        if competitions[currentCompYear] != nil {
            // addd to year array
            competitions[currentCompYear]?.append(comp)
        } else {
            // create new one.
            competitions[currentCompYear] = [comp]
        }
    }
    
    @objc fileprivate func rotationDidChange() {
        guard !orientation.isFlat else { return }
        let layout = self.collectionView?.collectionViewLayout as! UPCarouselFlowLayout
        let direction: UICollectionViewScrollDirection = UIDeviceOrientationIsPortrait(orientation) ? .horizontal : .vertical
        layout.scrollDirection = direction
        if currentPage > 0 {
            let indexPath = IndexPath(item: currentPage, section: 0)
            let scrollPosition: UICollectionViewScrollPosition = UIDeviceOrientationIsPortrait(orientation) ? .centeredHorizontally : .centeredVertically
            self.collectionView?.scrollToItem(at: indexPath, at: scrollPosition, animated: false)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if competitions.count == 0 {
            return 1
        }
        return competitions.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if competitions.count == 0 {
            return 3
        }
        let dictKeys = Array(competitions.keys)
        let currentCompYear = dictKeys[section]
        return competitions[currentCompYear]!.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CompetitionsCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of CompetitionsCollectionViewCell.")
        }
        
        if competitions.count == 0 {
            return cell
        }
        
        // Get competition for current cell
        let dictKeys = Array(competitions.keys)
        let currentCompYear = dictKeys[indexPath.section]
        let competition = competitions[currentCompYear]![indexPath.item]
        
        // Show name, ...
        cell.nameLabel.text = competition.name
        // ...date, ...
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM"
        cell.dateLabel.text = dateFormatter.string(from: competition.date)
        // ...and location!
        cell.locationLabel.text = competition.location
        
        // Add shadow to cardView...
        cell.cardView.layer.masksToBounds = false
        cell.cardView.layer.shadowRadius = 10.0
        cell.cardView.layer.shadowOpacity = 0.2
        cell.cardView.layer.shadowOffset = CGSize(width: 0, height: 10)
        cell.cardView.layer.shadowColor = UIColor.black.cgColor
        
        // ...and corners!
        cell.cardView.layer.cornerRadius = 10.0
        
        // Configure pastel view for gradient background
        cell.pastelView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleRightMargin, .flexibleBottomMargin]
        cell.pastelView.layer.cornerRadius = 10.0
        
        cell.pastelView.startPastelPoint = .topLeft
        cell.pastelView.endPastelPoint = .bottomRight
        
        cell.pastelView.animationDuration = 3.0
        
        cell.pastelView.setColors([#colorLiteral(red: 0.983635366, green: 0.8747070432, blue: 0.5316541195, alpha: 1), #colorLiteral(red: 0.9531937242, green: 0.5111558437, blue: 0.4972118139, alpha: 1)])
        
        cell.pastelView.startAnimation()
        
        // Give the "see more" button some nice curves 🍑...
        cell.moreButton.layer.cornerRadius = 12
        
        // ...and a blurry background
        let blurEffect = UIBlurEffect(style: .light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.clipsToBounds = true
        blurredEffectView.frame = cell.moreButton.bounds
        blurredEffectView.layer.cornerRadius = 12
        blurredEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.clipsToBounds = true
        vibrancyEffectView.frame = cell.moreButton.bounds
        blurredEffectView.layer.cornerRadius = 12
        vibrancyEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        blurredEffectView.contentView.addSubview(vibrancyEffectView)
        
        cell.moreButton.addSubview(blurredEffectView)
        cell.moreButton.sendSubview(toBack: blurredEffectView)
        
        return cell
    }
    
    // MARK: - UIScrollViewDelegate
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.collectionView?.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
}


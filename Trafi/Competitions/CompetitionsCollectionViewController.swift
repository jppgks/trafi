//
//  CompetitionsCollectionViewController.swift
//  Trafi
//
//  Created by Joppe Geluykens on 2017-06-12.
//  Copyright © 2017 Young Wolves. All rights reserved.
//

import Alamofire
import AnimatedCollectionViewLayout
import ChameleonFramework
import Pastel
import SwiftyJSON
import UIKit

private let reuseIdentifier = "CompetitionCell"

class CompetitionsCollectionViewController: UICollectionViewController {

    var competitions = [Int: [Competition]]()
    
    var animator = (LinearCardAttributesAnimator(), false, 1, 1)
    var direction: UICollectionViewScrollDirection {
        return UIDeviceOrientationIsPortrait(UIDevice.current.orientation) ? .vertical : .horizontal
    }
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.isPagingEnabled = true
        let layout = AnimatedCollectionViewLayout()
        layout.animator = LinearCardAttributesAnimator(minAlpha: 0.5, itemSpacing: 0.2, scaleRate: 0.8)
        layout.scrollDirection = direction
        
        layout.itemSize = UIScreen.main.bounds.size
        layout.sectionInset = .zero
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView?.collectionViewLayout = layout
        
        downloadCompetitions()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Make sure we have a layout object
        guard let layout = collectionView?.collectionViewLayout as? AnimatedCollectionViewLayout else {
            return
        }
        // Get smallest side
        let side = view.bounds.width < view.bounds.height ? view.bounds.width : view.bounds.height
        layout.itemSize = CGSize(width: side, height: side)
        
        // Get direction based on size
        layout.scrollDirection = view.bounds.width < view.bounds.height ? .horizontal : .vertical
        
        layout.sectionInset = .zero
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Make status bar have a white background
//        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
//        statusBar.backgroundColor = .white
        
        self.setStatusBarStyle(UIStatusBarStyleContrast)
        
        // Hide navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show navigation bar again
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
        self.pageControl.numberOfPages = competitions[currentCompYear]!.count
        return competitions[currentCompYear]!.count
    }
    
    // Pagecontrol
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
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
        
        // Add shadow and corners to cardView...
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 10.0)
        cell.layer.shadowRadius = 10.0
        cell.layer.shadowOpacity = 0.2
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
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
        blurredEffectView.isUserInteractionEnabled = false
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.clipsToBounds = true
        vibrancyEffectView.frame = cell.moreButton.bounds
        vibrancyEffectView.layer.cornerRadius = 12
        vibrancyEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vibrancyEffectView.isUserInteractionEnabled = false
        
        blurredEffectView.contentView.addSubview(vibrancyEffectView)
        
        cell.moreButton.addSubview(blurredEffectView)
        cell.moreButton.sendSubview(toBack: blurredEffectView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//
//        // Create an instance of PlayerTableViewController and pass the variable
//        let destinationVC = CompetitionDetailTableViewController()
//        destinationVC.competitionId = competition.id
//
//        print(competition.id)
//
//        destinationVC.performSegue(withIdentifier: "seeMore", sender: self)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {        
        if let indexPath = self.collectionView?.indexPath(for: sender as! CompetitionsCollectionViewCell) {
            if segue.identifier == "seeMore" {
                // Get competition for current cell
                let dictKeys = Array(competitions.keys)
                let currentCompYear = dictKeys[indexPath.section]
                let competition = competitions[currentCompYear]![indexPath.item]
                
                let detailVC: CompetitionDetailTableViewController = segue.destination as! CompetitionDetailTableViewController
                detailVC.competitionId = competition.id
            }
        }
    }
}


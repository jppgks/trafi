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

private let reuseIdentifier = "CompetitionCell"

class CompetitionsCollectionViewController: UICollectionViewController {

    var competitions = [Int: [Competition]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        self.collectionView!.reloadData()
        Loader.addLoaderTo(self.collectionView!)
        downloadCompetitions()
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
                Loader.removeLoaderFrom(self.collectionView!)
                self.collectionView!.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /// Adds given competition to the appropriate array in the competitions dictionary, based on the year of the competition.
    private func addToCompetitions(_ comp: Competition) {
        let currentCompYear = Calendar.current.dateComponents([.year], from: comp.date).year!
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
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView()
//
//        if competitions.count == 0 {
//            return view
//        }
//
//        // Configure blur and vibrancy background
//        let blurEffect = UIBlurEffect(style: .light)
//        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
//        blurredEffectView.frame = view.bounds
//        blurredEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
//        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
//        vibrancyEffectView.frame = view.bounds
//        vibrancyEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//        blurredEffectView.contentView.addSubview(vibrancyEffectView)
//
//        view.addSubview(blurredEffectView)
//        view.sendSubview(toBack: blurredEffectView)
//
//        // Set header title to year
//        let dictKeys = Array(competitions.keys)
//        let currentCompYear = dictKeys[section]
//
//        // we need this class to inset text in a UILabel...
//        class InsetLabel: UILabel {
//            let topInset = CGFloat(10)
//            let bottomInset = CGFloat(10)
//            let leftInset = CGFloat(10)
//            let rightInset = CGFloat(0)
//
//            override func drawText(in rect: CGRect) {
//                let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
//                super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
//            }
//
//            override public var intrinsicContentSize: CGSize {
//                var intrinsicSuperViewContentSize = super.intrinsicContentSize
//                intrinsicSuperViewContentSize.height += topInset + bottomInset
//                intrinsicSuperViewContentSize.width += leftInset + rightInset
//                return intrinsicSuperViewContentSize
//            }
//        }
//        let yearLabel = InsetLabel()
//        yearLabel.frame = CGRect(x: 0, y: 0, width: 250, height: 40)
//        yearLabel.text = "\(currentCompYear)"
//        yearLabel.textColor = UIColor(red: 240/255, green: 110/255, blue: 110/255, alpha: 1.0)
//        yearLabel.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.heavy)
//        yearLabel.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(yearLabel)
//        yearLabel.centerYAnchor.constraint(equalTo: yearLabel.superview!.centerYAnchor).isActive = true
//
//        return view
//    }

}

extension CompetitionsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = 300
        return CGSize(width: collectionView.bounds.size.width, height: CGFloat(height))
    }
}

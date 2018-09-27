//
//  ViewController.swift
//  GATA
//
//  Created by jwan on 2018. 8. 21..
//  Copyright © 2018년 jwan. All rights reserved.
//

import UIKit
import ImageSlideshow


class ViewController: UIViewController, UIScrollViewDelegate {
    
    struct TalentRecommand {
        var talent: String
        var image: UIImage
    }
    
    struct InitData {
        var myInfo: MyInformation
        var userRecommand: UserInformation
        var talentRecommand: TalentRecommand
        var popularTalent: [String]
        var aroundPoplularTalent: [String]
    }
    
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var viewSlideOverlay: UIView!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var slideview: ImageSlideshow!
    @IBOutlet weak var viewNeedRecommand: UIView!
    
    @IBOutlet weak var labelNeedTitle: UILabel!
    @IBOutlet weak var labelRecentTitle: UILabel!
    @IBOutlet weak var buttonImgTitle: UIButton!
    @IBOutlet weak var textfieldSearch: UITextField!
    
    @IBOutlet weak var constraintSlideOverlayTop: NSLayoutConstraint!
    @IBOutlet weak var constraintImgTitleCenterX: NSLayoutConstraint!
    
    var searchValue: String = ""
    var beforeScrollPosition: CGFloat = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        let imgTitle = ["사진찍기", "바이올린", "글쓰기", "포토샵"]
        let imgSource = [ImageSource(image: #imageLiteral(resourceName: "camera")), ImageSource(image: #imageLiteral(resourceName: "violin")), ImageSource(image: #imageLiteral(resourceName: "writer")), ImageSource(image: #imageLiteral(resourceName: "photoshop"))]
        slideview.slideshowInterval = 5.0
        slideview.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        self.buttonImgTitle.setTitle(imgTitle[0] + " 잘하는 사람", for: .normal)
        slideview.currentPageChanged = { page in
            self.buttonImgTitle.setTitle(imgTitle[page] + " 잘하는 사람", for: .normal)
            self.buttonImgTitle.alpha = 0
            self.constraintImgTitleCenterX.constant = 30
            self.view.layoutIfNeeded()
            self.constraintImgTitleCenterX.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                self.buttonImgTitle.alpha = 1
            })
        }
        slideview.setImageInputs(imgSource)
        
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        viewStatus.layer.addBorder([.bottom], color: ThemaColor.gray, width: 0.5)
        
        constraintSlideOverlayTop.constant = -viewStatus.frame.height
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        scrollview.delegate = self
        
        addNaviBarAlertCountButton(1)
        
    }
    
    func addNaviBarAlertCountButton(_ count: Int) {
        let btn = AlertButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        if count > 0 {
            btn.setTitle(count >= 100 ? "99" : String(count), for: .normal)
            btn.setBackgroundImage(#imageLiteral(resourceName: "circler"), for: .normal)
            btn.titleLabel?.font = customFont(weight: .bold, size: 15)
        } else {
            btn.backgroundInsets = UIEdgeInsets(top: 4, left: 15, bottom: 14, right: 3)
            btn.setBackgroundImage(#imageLiteral(resourceName: "ring"), for: .normal)
        }
        btn.addTarget(self, action: #selector(self.presentAlertViewController), for: .touchUpInside)
        navigationItem.rightBarButtonItem?.customView = btn
    }
    
    @objc func presentAlertViewController() {
        performSegue(withIdentifier: "AlertSeg", sender: self)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPosY = scrollView.contentOffset.y
        
        if  scrollPosY <= viewSlideOverlay.frame.height / 2 {
            let overlayHeight = (viewSlideOverlay.frame.height - viewStatus.frame.height) / 3
            let overlayAlpha = (scrollPosY - 25) / overlayHeight
            viewStatus.alpha = overlayAlpha
            
            if scrollPosY - beforeScrollPosition > 0 {
                navigationController?.navigationBar.barStyle = .default
            } else {
                navigationController?.navigationBar.barStyle = .black
            }
        }
        beforeScrollPosition = scrollPosY
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func showSearchViewController(value: String) {
        if let vc = tabBarController?.viewControllers![1] as? SearchViewController, value != "" {
            var searchValue = value
            if let idx = value.index(of: "#") {
                searchValue.remove(at: idx)
            }
            vc.searchType = typeOfSearch.talent
            tabBarController?.selectedIndex = 1
            vc.textfieldSearchValue.text = searchValue
            vc.appendFileData(searchValue)
        }
    }
    
    @IBAction func pressSearch(_ sender: Any) {
        showSearchViewController(value: textfieldSearch.text!)
        textfieldSearch.text = ""
        textfieldSearch.resignFirstResponder()
    }
    
    @IBAction func pressSearchMoreNeedRecommand(_ sender: Any) {
        showSearchViewController(value: labelNeedTitle.text!)
    }
    
    @IBAction func pressSearchRecentValueInMyLocation(_ sender: Any) {
        showSearchViewController(value: labelRecentTitle.text!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}


//
//  OnboardingViewController.swift
//  Notes
//
//  Created by Mohit Gupta on 25/03/21.
//
import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var slides: [OnboardingSlide] = []
    
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                
                nextBtn.setTitle("Get Started", for: .normal)
            } else{
                nextBtn.setTitle("Next", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slides = [OnboardingSlide(title:"Take Notes", description: "Take notes and access them from Anywhere.Anytime", image: #imageLiteral(resourceName: "first")),
                  OnboardingSlide(title:"Stay Organised", description: "Group your notes and keep them organised", image: #imageLiteral(resourceName: "second")),
                  OnboardingSlide(title:"Access from Anywhere", description: "Access and edit your notes from anywhere using website", image: #imageLiteral(resourceName: "third"))]

    }
    
    @IBAction func nextBtnClicked(_ sender: UIButton) {
       
        if currentPage == slides.count - 1 {
            UserDefaults.standard.set(true, forKey: "didSeeOnboard")
            let controller = storyboard?.instantiateViewController(identifier: "passwordVC") as! PasswordVC
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .flipHorizontal
            present(controller, animated: true, completion: nil)
            
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
        }
        
    }
    
    @IBAction func Skip(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "didSeeOnboard")
        let controller = storyboard?.instantiateViewController(identifier: "passwordVC") as! PasswordVC
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .flipHorizontal
        present(controller, animated: true, completion: nil)
    }
    
}
extension OnboardingViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
                            collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let  width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        
    }
    
    
}

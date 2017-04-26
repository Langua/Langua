//
//  SpanishCourseViewController.swift
//  Langua
//
//  Created by Steven Hurtado on 4/22/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit

class SpanishCourseViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    var currentLesson = 0
    var currentQuestion = 0
    var currentTag = 0
    let lessonTitle = ["Beginners", "Common Phrases", "Verbs", "Tenses"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var effectView: UIVisualEffectView!
    
    @IBOutlet weak var uhOhView: UIView!
    
    @IBOutlet weak var correctView: UIView!
    
    let lessonQuestions = [["Which is \"the girl\"?",
                            "Which is \"the woman\"?",
                            "Which is \"the boy\"?",
                            "Which is \"the man\"?",
                            "Which is \"water\"?"],
                           
                           ["Which is \"the girl\"?",
                            "Which is \"the girl\"?",
                            "Which is \"the girl\"?",
                            "Which is \"the girl\"?",
                            "Which is \"the girl\"?"],
                           
                           ["Which is \"the girl\"?",
                            "Which is \"the girl\"?",
                            "Which is \"the girl\"?",
                            "Which is \"the girl\"?",
                            "Which is \"the girl\"?"],
                           
                           ["Which is \"the girl\"?",
                            "Which is \"the girl\"?",
                            "Which is \"the girl\"?",
                            "Which is \"the girl\"?",
                            "Which is \"the girl\"?"]]
    
    //array to keep size of current questions
    var indeceArr : [Int] = []
    
    //lesson answers with correct answer being the first
    let lessonAnswers = [[["la niña", "la mujer","el niño", "el agua"],
                         ["la mujer", "la niña", "la mano", "el hombre"],
                         ["el niño", "el queso", "la niña", "el hombre"],
                         ["el hombre", "el niño", "la mujer", "la mano"],
                         ["el agua", "la niña","la mano", "el niño"]],
                        
                         [["la niña", "la mujer","el niño", "el agua"],
                          ["la mujer", "la niña", "la mano", "el hombre"],
                          ["el niño", "el queso", "la niña", "el hombre"],
                          ["el hombre", "el niño", "la mujer", "la mano"],
                          ["el agua", "la niña","la mano", "el niño"]],
                        
                         [["la niña", "la mujer","el niño", "el agua"],
                          ["la mujer", "la niña", "la mano", "el hombre"],
                          ["el niño", "el queso", "la niña", "el hombre"],
                          ["el hombre", "el niño", "la mujer", "la mano"],
                          ["el agua", "la niña","la mano", "el niño"]],
                        
                         [["la niña", "la mujer","el niño", "el agua"],
                          ["la mujer", "la niña", "la mano", "el hombre"],
                          ["el niño", "el queso", "la niña", "el hombre"],
                          ["el hombre", "el niño", "la mujer", "la mano"],
                          ["el agua", "la niña","la mano", "el niño"]]]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.progressLabel.text = "\(self.currentQuestion+1)/\(self.lessonQuestions[self.currentLesson].count)"
        self.title = self.lessonTitle[self.currentLesson]
        
        self.effectView.isHidden = true
        self.uhOhView.isHidden = true
        self.correctView.isHidden = true

        self.checkBtn.isEnabled = false
        self.checkBtn.backgroundColor = UIColor.myOnyxGray
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        load()
    }
    
    func load()
    {
        self.questionLabel.text = self.lessonQuestions[self.currentLesson][self.currentQuestion]
        
        let maxVal = 3
        
        self.indeceArr = uniqueRandoms(numberOfRandoms: 4, minNum: 0, maxNum: UInt32(maxVal))
        
        self.collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.lessonAnswers[self.currentLesson][self.currentQuestion].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "choiceCell", for: indexPath) as! AnswerChoiceCell
        
         let currentLessArr = self.lessonAnswers[self.currentLesson]
        
        let currentQuesArr = currentLessArr[self.currentQuestion]
        
        print("Row: \(indexPath.row)")
        print("Indece: \(self.indeceArr[indexPath.row])")
    
        let currentChoice = currentQuesArr[self.indeceArr[indexPath.row]]
        
        cell.choiceLabel.text = currentChoice
        
        cell.tag = self.indeceArr[indexPath.row]
        
        //assign "origin"
        
        let attributes = collectionView.layoutAttributesForItem(at: indexPath)
        let cellRect = attributes?.frame
        let cellFrameInSuperView = collectionView.convert(cellRect!, to: collectionView.superview)
        
        print("Cell \(indexPath.row): \(cellFrameInSuperView.origin)")
        cell.origin = cellFrameInSuperView.origin
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let cell = collectionView.cellForItem(at: indexPath) as! AnswerChoiceCell
        cell.choiceView.layer.borderColor = UIColor.myLightBambooGreen.cgColor
        
        switch((cell.tag))
        {
            case 0:
                print("Correct")
                break
            default:
                print("Incorrect")
                break
        }
        
        self.currentTag = cell.tag
        
        for otherCell in self.collectionView.visibleCells as! [AnswerChoiceCell]
        {
            UIView.animate(withDuration: 0.3)
            {
                otherCell.transform = CGAffineTransform(scaleX: 1, y: 1)
                
//                otherCell.center = otherCell.origin
                otherCell.choiceView.layer.borderWidth = 0
                otherCell.layer.shadowColor = UIColor.black.cgColor
                otherCell.layer.shadowOpacity = 0.0
                otherCell.layer.shadowOffset = CGSize.zero
                otherCell.layer.shadowRadius = 5
                
                
            }
            
            if(otherCell != cell)
            {
                otherCell.toggled = !otherCell.toggled
            }
        }
        
        if(!(cell.toggled))
        {
            UIView.animate(withDuration: 0.3)
            {
                cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                
                print("Center: \(cell.accessibilityFrame)")
                print("Screen center: \(self.collectionView.center)")
                print("Applied center: \(CGPoint(x: self.collectionView.center.x/2, y: self.collectionView.center.y/2))")
              
                cell.choiceView.layer.borderWidth = 2
                cell.layer.shadowColor = UIColor.black.cgColor
                cell.layer.shadowOpacity = 1.0
                cell.layer.shadowOffset = CGSize.zero
                cell.layer.shadowRadius = 5
                self.view.bringSubview(toFront: cell.contentView)
            }
            
            self.checkBtn.isEnabled = true
            self.checkBtn.backgroundColor = UIColor.myLightBambooGreen
        }
        else
        {
            self.checkBtn.isEnabled = false
            self.checkBtn.backgroundColor = UIColor.myOnyxGray
        }
        
        cell.toggled = !cell.toggled
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func checkPressed(_ sender: Any)
    {
        self.effectView.isHidden = false
        
        for otherCell in self.collectionView.visibleCells as! [AnswerChoiceCell]
        {
            UIView.animate(withDuration: 0.3)
            {
                otherCell.transform = CGAffineTransform(scaleX: 1, y: 1)
                
                //                otherCell.center = otherCell.origin
                otherCell.choiceView.layer.borderWidth = 0
                otherCell.layer.shadowColor = UIColor.black.cgColor
                otherCell.layer.shadowOpacity = 0.0
                otherCell.layer.shadowOffset = CGSize.zero
                otherCell.layer.shadowRadius = 5
                
                
            }
            
            otherCell.toggled = !otherCell.toggled
        }
        
        if(self.checkBtn.isEnabled && currentTag == 0)
        {
            //APPEAR CORRECT TEXT
            self.correctView.isHidden = false
            
        }
        else
        {
            //APPEAR INCORRECT TEXT
            self.uhOhView.isHidden = false
        }
    }
    
    @IBAction func surePressed(_ sender: Any)
    {
        self.viewDidLoad()
    }
    
    @IBAction func yupPressed(_ sender: Any)
    {
        self.currentQuestion += 1
        
        if(self.currentQuestion >= self.lessonQuestions[self.currentLesson].count)
        {
            print("Congrats on finishing this lesson!")
            
            self.currentQuestion = 0
        }
        
        self.viewDidLoad()
    }
    
    
    
    ////////
    //Unique Randoms
    ///////
    func uniqueRandoms(numberOfRandoms: Int, minNum: Int, maxNum: UInt32) -> [Int]
    {
        var uniqueNumbers = Set<Int>()
        while uniqueNumbers.count < numberOfRandoms
        {
            uniqueNumbers.insert(Int(arc4random_uniform(maxNum + 1)) + minNum)
        }
        return Array(uniqueNumbers).shuffle
    }
    
    func uniqueRandoms(numberOfRandoms: Int, minNum: Int, maxNum: UInt32, blackList: Int?) -> [Int]
    {
        var uniqueNumbers = Set<Int>()
        while uniqueNumbers.count < numberOfRandoms
        {
            uniqueNumbers.insert(Int(arc4random_uniform(maxNum + 1)) + minNum)
        }
        
        if let blackList = blackList
        {
            if uniqueNumbers.contains(blackList) {
                while uniqueNumbers.count < numberOfRandoms+1
                {
                    uniqueNumbers.insert(Int(arc4random_uniform(maxNum + 1)) + minNum)
                }
                uniqueNumbers.remove(blackList)
            }
        }
        return Array(uniqueNumbers).shuffle
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  HomeScene.swift
//  CocosSwift
//
//  Created by Thales Toniolo on 10/09/14.
//  Copyright (c) 2014 Flameworks. All rights reserved.
//
import Foundation

// MARK: - Class Definition
class HomeScene : CCScene {
	// MARK: - Public Objects

	// MARK: - Private Objects
	private let screenSize:CGSize = CCDirector.sharedDirector().viewSize()

	// MARK: - Life Cycle
	override init() {
		super.init()
        
        // Preload do arquivo de audio
        OALSimpleAudio.sharedInstance().preloadBg("MusicInGame.mp3")
        
        adicionarImagens()
        adicionarLabels()
        adicionarBotoes()

	}

	override func onEnter() {
		// Chamado apos o init quando entra no director
		super.onEnter()
	}

	// MARK: - Private Methods
//	func startTap(sender:AnyObject) {
//		StateMachine.sharedInstance.changeScene(StateMachine.StateMachineScenes.GameScene, isFade:true)
//	}
    
	// MARK: - Public Methods
    func adicionarImagens () {
        
        //imgBackground
        let bg: CCSprite = CCSprite(imageNamed: "bgCenario-ipad.png")
        bg.anchorPoint = CGPointMake(0.0, 0.0)
        bg.position = CGPointMake(0.0, 0.0)
        self.addChild(bg)
        
        //imgPlayer
        let imgPlayerIpad: CCSprite = CCSprite(imageNamed: "playerBig-hd.png")
        imgPlayerIpad.anchorPoint = CGPointMake(0.0, 0.0)
        imgPlayerIpad.position = CGPointMake(self.screenSize.width/2 - 450, self.screenSize.height/2 - 200)
        imgPlayerIpad.scale = 3.0
        self.addChild(imgPlayerIpad)
        
        //imgPirataPerneta
        CCSpriteFrameCache.sharedSpriteFrameCache().addSpriteFramesWithFile("PirataPerneta-ipad.plist", textureFilename:"PirataPerneta-ipad.png")
        let ccFrameNamePirataPerneta:CCSpriteFrame = CCSpriteFrame.frameWithImageNamed("Pirata8.png") as! CCSpriteFrame
        let spritePirataPerneta:CCSprite = CCSprite.spriteWithSpriteFrame(ccFrameNamePirataPerneta) as! CCSprite;
        spritePirataPerneta.anchorPoint = CGPointMake(0.0, 0.0)
        spritePirataPerneta.position = CGPointMake(self.screenSize.width/2 + 140, self.screenSize.height/2 - 50)
        spritePirataPerneta.scale = 2.0
        self.addChild(spritePirataPerneta)
        
        //imgPirataPeixe
        CCSpriteFrameCache.sharedSpriteFrameCache().addSpriteFramesWithFile("PirataPeixe-ipad.plist", textureFilename:"PirataPeixe-ipad.png")
        
        let ccFrameNamePirataPeixe:CCSpriteFrame = CCSpriteFrame.frameWithImageNamed("PirataPeixe8.png") as! CCSpriteFrame
        let spritePirataPeixe:CCSprite = CCSprite.spriteWithSpriteFrame(ccFrameNamePirataPeixe) as! CCSprite;
        spritePirataPeixe.anchorPoint = CGPointMake(0.0, 0.0)
        spritePirataPeixe.position = CGPointMake(self.screenSize.width/2 + 100, self.screenSize.height/2 - 350)
        spritePirataPeixe.scale = 2.0
        self.addChild(spritePirataPeixe)
    }
    
    func adicionarLabels () {
            
        //lblNomeDoJogo
        let lblNomeDoJogo:CCLabelTTF = CCLabelTTF(string: "The Ultimate \n    Viking", fontName: "Chalkduster", fontSize: 70.0)
        lblNomeDoJogo.color = CCColor.blackColor()
        lblNomeDoJogo.position = CGPointMake(self.screenSize.width/2, self.screenSize.height/2 + 200)
        lblNomeDoJogo.anchorPoint = CGPointMake(0.5, 0.5)
        self.addChild(lblNomeDoJogo)
            
        //lblBestScore
        let lblScore:CCLabelTTF = CCLabelTTF(string: "Best Score: 0", fontName: "Chalkduster", fontSize: 30.0)
        lblScore.color = CCColor.blackColor()
        lblScore.position = CGPointMake(self.screenSize.width/2, self.screenSize.height/2 - 350)
        lblScore.anchorPoint = CGPointMake(0.5, 0.5)
        self.addChild(lblScore)
    }
    
    func adicionarBotoes () {
                
        //btnStart
        let toGameButton:CCButton = CCButton(title: "[ Start ]", fontName: "Verdana-Bold", fontSize: 38.0)
        toGameButton.color = CCColor.blackColor()
        toGameButton.position = CGPointMake(self.screenSize.width/2.0, self.screenSize.height/2.0)
        toGameButton.anchorPoint = CGPointMake(0.5, 0.5)
        //toGameButton.setTarget(self, selector:"startTap:")
        toGameButton.block = {_ in StateMachine.sharedInstance.changeScene(StateMachineScenes.GameScene, isFade:true)
            OALSimpleAudio.sharedInstance().playEffect("SoundFXButtonTap.mp3")
            }
        self.addChild(toGameButton)
    }
    
	// MARK: - Delegates/Datasources

	// MARK: - Death Cycle
	override func onExit() {
		// Chamado quando sai do director
		super.onExit()
	}
}

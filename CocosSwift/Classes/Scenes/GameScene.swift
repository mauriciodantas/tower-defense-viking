//
//  GameScene.swift
//  CocosSwift
//
//  Created by Thales Toniolo on 10/09/14.
//  Copyright (c) 2014 Flameworks. All rights reserved.
//
import Foundation

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

// MARK: - Class Definition
class GameScene: CCScene {
    
	// MARK: - Public Objects
	internal var canPlay:Bool = true
    
	// MARK: - Private Objects
	private let screenSize:CGSize = CCDirector.sharedDirector().viewSize()
    private var score:Int = 0
    private var tempoMinimoEntreOndas:Double = 4
    private var velociodadeMinimaPercursoInimigo:Float = 7
    private var velocidadeArremesso:CGFloat = 700
    
    //imagens
    let bg: CCSprite = CCSprite(imageNamed: "bgCenario-ipad.png")
    let imgEnergia: CCSprite = CCSprite(imageNamed: "energiaVerde-ipad.png")
    let imgPlayerIpad: CCSprite = CCSprite(imageNamed: "player-ipad.png")
    
    //labels
    let lblScore:CCLabelTTF = CCLabelTTF(string: "Score: 0", fontName: "Chalkduster", fontSize: 18.0)
    let lblGameOver:CCLabelTTF = CCLabelTTF(string: "-== GAME OVER ==-- \n    Tap to restart", fontName: "Chalkduster", fontSize: 25.0)
    
    //botoes
    let pauseButton:CCButton = CCButton(title: "[ Pause ]", fontName: "Verdana-Bold", fontSize: 25.0)
    let quitButton:CCButton = CCButton(title: "[ Quit ]", fontName: "Verdana-Bold", fontSize: 25.0)
    
	
	// MARK: - Life Cycle
	override init() {
		super.init()
        
        // Executa a musica de fundo
        OALSimpleAudio.sharedInstance().playBgWithLoop(true)
        
        // Permite os eventos de toque na cena
        self.userInteractionEnabled = true
    
        adicionarImagens()
        adicionarLabels()
        adicionarBotoes()
        
	}

	override func onEnter() {
		super.onEnter()
        
        // Apos geracao, registra nova geracao apos um tempo
        DelayHelper.sharedInstance.callFunc("generatePerneta", onTarget: self, withDelay: 0)
        
        // Apos geracao, registra nova geracao apos um tempo
        DelayHelper.sharedInstance.callFunc("generatePeixe", onTarget: self, withDelay: 0)

	}

	// Tick baseado no FPS
	override func update(delta: CCTime) {
		//...
	}

	// MARK: - Private Methods
    func generatePerneta() {
        if (self.canPlay) {
            // Quantidade de inseto gerado por vez...
            let bugAmout:Int = Int(arc4random_uniform(5) + 1)
            
            for (var i = 0; i < bugAmout; i++) {
                let positionX:CGFloat = CGFloat(arc4random_uniform(100) + 1000)
                let positionY:CGFloat = CGFloat(arc4random_uniform(500))
                let Perneta:PirataPerneta = PirataPerneta(event: "updateScore", target: self)
                Perneta.position = CGPointMake(positionX, positionY)
                Perneta.name = "PirataPerneta"
                self.addChild(Perneta, z: 2)
                Perneta.moveMe()
            }
            
            // Apos geracao, registra nova geracao apos um tempo
            DelayHelper.sharedInstance.callFunc("generatePerneta", onTarget: self, withDelay: self.tempoMinimoEntreOndas)
        }
    }
    
    
    func generatePeixe() {
        if (self.canPlay) {
            // Quantidade de inseto gerado por vez...
            let bugAmout:Int = Int(arc4random_uniform(5) + 1)
            
            for (var i = 0; i < bugAmout; i++) {
                let positionX:CGFloat = CGFloat(arc4random_uniform(100) + 1000)
                let positionY:CGFloat = CGFloat(arc4random_uniform(500))
                let Peixe:PirataPeixe = PirataPeixe(event: "updateScore", target: self)
                Peixe.position = CGPointMake(positionX, positionY)
                Peixe.name = "PirataPeixe"
                self.addChild(Peixe, z: 2)
                Peixe.moveMe()
            }
            
            // Apos geracao, registra nova geracao apos um tempo
            DelayHelper.sharedInstance.callFunc("generatePeixe", onTarget: self, withDelay: self.tempoMinimoEntreOndas)
        }
    }
    
    func addBulletAtPosition(position:CGPoint){
        let bullet =  TiroPlayer()
        
        bullet.position = CGPointMake(self.imgPlayerIpad.position.x, self.imgPlayerIpad.position.y)
        
        self.addChild(bullet, z: 1)
        
        let posicaoFinalTiro = self.calcularPosicaoFinalTiro(self.imgPlayerIpad.position, pontoTiro: position)
        
        let distancia = self.calcularDistanciaEntrePontos(self.imgPlayerIpad.position, p2:posicaoFinalTiro)
        
        let tempo = self.calcularTempoTrajetoria(distancia)
        
        let angulo = self.calcularAngulo(bullet.position, p2: position)
        
        let actions: [CCAction] = [CCActionMoveTo.actionWithDuration(tempo, position: posicaoFinalTiro) as! CCAction,
                                   CCActionCallBlock.actionWithBlock({ () -> Void in
                                    bullet.removeFromParentAndCleanup(true)
                                   }) as! CCAction]
        bullet.runAction(CCActionSequence.actionWithArray(actions) as! CCAction)
        
    }
    
    func calcularDistanciaEntrePontos(p1: CGPoint, p2: CGPoint) -> CGFloat {
        let xDist:CGFloat = (p2.x - p1.x);
        let yDist:CGFloat = (p2.y - p1.y);
        let distance:CGFloat = sqrt((xDist * xDist) + (yDist * yDist));
        return distance
    }
    
    func calcularTempoTrajetoria(distancia:CGFloat) -> Double {
        let tempo:CGFloat = distancia / self.velocidadeArremesso
        return Double.init(tempo)
    }
    
    func calcularAngulo(p1:CGPoint,p2:CGPoint ) -> Float {
        let deltaX = p1.x - p2.x;
        let deltaY = p1.y - p2.y;
        
        let angle = atan2f(Float(deltaY), Float(deltaX));
        return Float(270.0) - CC_RADIANS_TO_DEGREES(angle);
    }
    
    func calcularPosicaoFinalTiro(pontoJogador:CGPoint, pontoTiro:CGPoint) -> CGPoint{
        let offset = pontoTiro - pontoJogador
        let direction = offset.normalized()
        let shootAmount = direction * 1000
        let realDest = shootAmount + pontoTiro
        return realDest
    }


	// MARK: - Public Methods
    func updateScore() {
        self.score+=1
        self.lblScore.string = "Score: \(self.score)"
    }
    
    func adicionarImagens () {
        
        //imgBackground
        self.bg.anchorPoint = CGPointMake(0.0, 0.0)
        self.bg.position = CGPointMake(0.0, 0.0)
        self.addChild(bg, z:0)
        
        //imgEnergia
        self.imgEnergia.anchorPoint = CGPointMake(0.0, 0.0)
        self.imgEnergia.position = CGPointMake(self.screenSize.width/2 - 512, self.screenSize.height/2 - 384)
        self.addChild(self.imgEnergia, z: 1)
        
        //imgPlayer
        self.imgPlayerIpad.anchorPoint = CGPointMake(0.0, 0.0)
        self.imgPlayerIpad.position = CGPointMake(self.screenSize.width/2 - 510, self.screenSize.height/2 - 60)
        self.addChild(imgPlayerIpad, z:2)
        
    }
    
    func adicionarLabels () {
        
        //lblScore
        self.lblScore.color = CCColor.blackColor()
        self.lblScore.position = CGPointMake(self.screenSize.width/2, self.screenSize.height/2 + 355)
        self.lblScore.anchorPoint = CGPointMake(0.5, 0.5)
        self.addChild(self.lblScore, z: 1)
        
        //lblGameOver
        self.lblGameOver.color = CCColor.redColor()
        self.lblGameOver.position = CGPointMake(self.screenSize.width/2, self.screenSize.height/2)
        self.lblGameOver.anchorPoint = CGPointMake(0.5, 0.5)
        self.lblGameOver.visible = false
        self.addChild(lblGameOver, z: 1)
        
        
    }
    
    func adicionarBotoes () {
        
        //btnPause
        self.pauseButton.position = CGPointMake(self.screenSize.width, self.screenSize.height)
        self.pauseButton.anchorPoint = CGPointMake(1.8, 1.0)
        self.pauseButton.color = CCColor.blackColor()
        self.pauseButton.zoomWhenHighlighted = false
        self.pauseButton.block = {_ in StateMachine.sharedInstance.changeScene(StateMachineScenes.HomeScene, isFade:true)}
        self.addChild(self.pauseButton)
        
        //btnQuit
        self.quitButton.position = CGPointMake(self.screenSize.width, self.screenSize.height)
        self.quitButton.anchorPoint = CGPointMake(1.0, 1.0)
        self.quitButton.color = CCColor.blackColor()
        self.quitButton.zoomWhenHighlighted = false
        self.quitButton.block = {_ in StateMachine.sharedInstance.changeScene(StateMachineScenes.HomeScene, isFade:true)}
        self.addChild(self.quitButton)
        
    }
    
    override func touchBegan(touch: UITouch!, withEvent event: UIEvent!) {
        if(self.canPlay){
            let locationInView:CGPoint = CCDirector.sharedDirector().convertTouchToGL(touch)
            addBulletAtPosition(locationInView)
        }
        else{
            //StateMachine.sharedInstance.changeScene(StateMachineScenes.HomeScene, isFade:true)
        }
    }
    
	
	// MARK: - Delegates/Datasources
	
	// MARK: - Death Cycle
	override func onExit() {
		// Chamado quando sai do director
		super.onExit()
	}
}

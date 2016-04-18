//
//  PirataPerneta.swift
//  CocosSwift
//
//  Created by Usuário Convidado on 06/04/16.
//  Copyright © 2016 Flameworks. All rights reserved.
//

// MARK: - Class Definition
internal class PirataPerneta : CCNode {
    
    // MARK: - Public Objects
    internal var eventSelector:Selector?
    internal var targetID:AnyObject?
    
    
    // MARK: - Private Objects
    private var alive:Bool = true
    private var spritePirataPerneta:CCSprite?
    private let screenSize:CGSize = CCDirector.sharedDirector().viewSize()

    // MARK: - Life Cycle
    override init() {
        super.init()
        
        self.userInteractionEnabled = true
        
        // Cria o sprite  animado
        self.spritePirataPerneta = self.gerarAnimacaoSpriteWithName("Pirata", aQtdFrames: 18)
        self.spritePirataPerneta!.anchorPoint = CGPointMake(0.0, 0.0);
        self.spritePirataPerneta!.position = CGPointMake(0.0, 0.0)
        self.addChild(self.spritePirataPerneta, z:2)
        
    }
    
    override func onEnter() {
        // Chamado apos o init quando entra no director
        super.onEnter()
    }
    
    convenience init(event:Selector, target:AnyObject) {
        self.init()
        
        self.eventSelector = event
        self.targetID = target
    }
    
    // MARK: - Private Methods
        
    // MARK: - Public Methods
    // MARK: - Private Methods
    func gerarAnimacaoSpriteWithName(aSpriteName:String, aQtdFrames:Int) -> CCSprite {
        // Carrega os frames da animacao dentro do arquivo passado dada a quantidade de frames
        var animFrames:Array<CCSpriteFrame> = Array()
        for (var i = 1; i <= aQtdFrames; i++) {
            let name:String = "\(aSpriteName)\(i).png"
            print(name)
            animFrames.append(CCSpriteFrameCache.sharedSpriteFrameCache().spriteFrameByName(name))
        }
        // Cria a animacao dos frames montados
        let animation:CCAnimation = CCAnimation(spriteFrames: animFrames, delay: 0.1)
        // Cria a acao com a animacao dos frames
        let animationAction:CCActionAnimate = CCActionAnimate(animation: animation)
        // Monta a repeticao eterna da animacao
        let actionForever:CCActionRepeatForever = CCActionRepeatForever(action: animationAction)
        // Monta o sprite com o primeiro quadro
        let spriteRet:CCSprite = CCSprite(imageNamed: "\(aSpriteName)\(1).png")
        // Executa a acao da animacao
        spriteRet.runAction(actionForever)
        
        // Retorna o sprite para controle na classe
        return spriteRet
    }

    
    // MARK: - Public Methods
    internal func moveMe() {
        let speed:CGFloat = CGFloat(arc4random_uniform(4) + 4)
        self.runAction(CCActionSequence.actionOne(CCActionMoveTo.actionWithDuration(CCTime(speed), position: CGPointMake(0, self.position.y )) as! CCActionFiniteTime,
            two: CCActionCallBlock.actionWithBlock({ _ in
                self.stopAllSpriteActions()
                self.removeFromParentAndCleanup(true)
            }) as! CCActionFiniteTime)
            as! CCAction)
    }
    
    internal func stopAllSpriteActions() {
        self.spritePirataPerneta!.stopAllActions()
        self.stopAllActions()
    }
    
    internal func width() -> CGFloat {
        return self.spritePirataPerneta!.boundingBox().size.width
    }
    
    internal func height() -> CGFloat {
        return self.spritePirataPerneta!.boundingBox().size.height
    }
    
    // MARK: - Touchs Delegates
    override func touchBegan(touch: UITouch!, withEvent event: UIEvent!) {
        // Caso a cena principal esteja em gameplayer e nao seja possivel jogar impede o tap
        if (!(self.targetID as! GameScene).canPlay) {
            return
        }
        
        // Caso jah tenha recebido o tap, nao permite outro sobre o mesmo inseto
        if (!self.alive) {
            return
        }
        
        self.alive = false
        
        self.stopAllSpriteActions()
        self.spritePirataPerneta?.opacity = 0.0
        
        
        // Mata e executa o evento informado
        DelayHelper.sharedInstance.callFunc(self.eventSelector!, onTarget: self.targetID!, withDelay: 0.0)
    }
    
    // MARK: - Death Cycle
    deinit {
        // Chamado no momento de desalocacao
    }
}

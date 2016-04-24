//
//  PirataPeixe.swift
//  CocosSwift
//
//  Created by Usuário Convidado on 06/04/16.
//  Copyright © 2016 Flameworks. All rights reserved.
//

// MARK: - Class Definition
internal class PirataPeixe : CCNode {
    
    // MARK: - Public Objects
    internal var eventSelector:Selector?
    internal var targetID:AnyObject?
    var alive:Bool = true
    
    
    // MARK: - Private Objects
    private var spritePirataPeixe:CCSprite?
    private let screenSize:CGSize = CCDirector.sharedDirector().viewSize()
    
    private var HP:Int = 7
    private var SP:Int = 3
    
    // MARK: - Life Cycle
    override init() {
        super.init()
        
        self.userInteractionEnabled = true
        
        // Cria o sprite animado
        self.spritePirataPeixe = self.gerarAnimacaoSpriteWithName("PirataPeixe", aQtdFrames: 18)
        self.spritePirataPeixe!.anchorPoint = CGPointMake(0.5, 0.5);
        self.spritePirataPeixe!.position = CGPointMake(0.0, 0.0)
        self.addChild(self.spritePirataPeixe, z:2)
        
        
        self.contentSize = self.spritePirataPeixe!.boundingBox().size
        
        self.physicsBody = CCPhysicsBody(rect: CGRectMake(0, 0, self.contentSize.width, self.contentSize.height), cornerRadius: 0.0)
        self.physicsBody.type = CCPhysicsBodyType.Kinematic
        self.physicsBody.friction = 1.0
        self.physicsBody.elasticity = 0.1
        self.physicsBody.mass = 100.0
        self.physicsBody.density = 100.0
        self.physicsBody.collisionType = "PirataPeixe"
        self.physicsBody.collisionCategories = ["PirataPeixe"]
        self.physicsBody.collisionMask = ["TiroPlayer","Barra"]

        
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
    
    
    func atingir(forcaAtaque:Int){
        
        self.HP-=forcaAtaque
        
        if(self.HP<=0){
            
            self.alive = false
        }
        var corAntiga = self.spritePirataPeixe?.color
        var pintarSprite :CCActionTintTo = CCActionTintTo(duration: 0.4, color: CCColor.redColor())
        var retornarCorAnterior:CCActionTintTo = CCActionTintTo(duration:0.0,color:corAntiga)
        self.spritePirataPeixe?.runAction(CCActionSequence(one: pintarSprite, two: retornarCorAnterior))
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
        self.spritePirataPeixe!.stopAllActions()
        self.stopAllActions()
    }
    
    internal func width() -> CGFloat {
        return self.spritePirataPeixe!.boundingBox().size.width
    }
    
    internal func height() -> CGFloat {
        return self.spritePirataPeixe!.boundingBox().size.height
    }
        
    // MARK: - Death Cycle
    deinit {
        // Chamado no momento de desalocacao
    }
}

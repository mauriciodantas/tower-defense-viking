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
    var alive:Bool = true

    
    
    // MARK: - Private Objects
    private var spritePirataPerneta:CCSprite?
    private let screenSize:CGSize = CCDirector.sharedDirector().viewSize()
    private var HP:Int = 3
    private var SP:CGFloat = 200


    // MARK: - Life Cycle
    override init() {
        super.init()
        
        self.userInteractionEnabled = true
        
        // Cria o sprite  animado
        self.spritePirataPerneta = self.gerarAnimacaoSpriteWithName("Pirata", aQtdFrames: 18)
        self.spritePirataPerneta!.anchorPoint = CGPointMake(0.5, 0.5);
        self.spritePirataPerneta!.position = CGPointMake(0.0, 0.0)
        self.addChild(self.spritePirataPerneta, z:2)
        
        self.contentSize = self.spritePirataPerneta!.boundingBox().size
        
        self.physicsBody = CCPhysicsBody(rect: CGRectMake(0, 0, self.contentSize.width, self.contentSize.height), cornerRadius: 0.0)
        self.physicsBody.type = CCPhysicsBodyType.Kinematic
        self.physicsBody.friction = 1.0
        self.physicsBody.elasticity = 0.1
        self.physicsBody.mass = 100.0
        self.physicsBody.density = 100.0
        self.physicsBody.collisionType = "PirataPerneta"
        self.physicsBody.collisionCategories = ["PirataPerneta"]
        self.physicsBody.collisionMask = ["TiroPlayer","Barra"]

        
    }
    
    func atingir(forcaAtaque:Int){
        
        self.HP-=forcaAtaque
        
        if(self.HP<=0){
            
            self.alive = false
        }
        var corAntiga = self.spritePirataPerneta?.color
        var pintarSprite :CCActionTintTo = CCActionTintTo(duration: 0.4, color: CCColor.redColor())
        var retornarCorAnterior:CCActionTintTo = CCActionTintTo(duration:0.0,color:corAntiga)
        self.self.spritePirataPerneta?.runAction(CCActionSequence(one: pintarSprite, two: retornarCorAnterior))
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

    
    // MARK: - Public Methods
    internal func moveMe() {
        
        let posicaoFinalPirata = CGPointMake(0, self.position.y)
        
        let distancia = self.calcularDistanciaEntrePontos(self.position, p2:posicaoFinalPirata)
        
        let tempo = self.calcularTempoTrajetoria(distancia)
        
        self.runAction(CCActionSequence.actionOne(CCActionMoveTo.actionWithDuration(CCTime(tempo), position: posicaoFinalPirata) as! CCActionFiniteTime,
            two: CCActionCallBlock.actionWithBlock({ _ in
                self.stopAllSpriteActions()
                self.removeFromParentAndCleanup(true)
            }) as! CCActionFiniteTime)
            as! CCAction)
    }
    
    func calcularDistanciaEntrePontos(p1: CGPoint, p2: CGPoint) -> CGFloat {
        let xDist:CGFloat = (p2.x - p1.x);
        let yDist:CGFloat = (p2.y - p1.y);
        let distance:CGFloat = sqrt((xDist * xDist) + (yDist * yDist));
        return distance
    }
    
    func calcularTempoTrajetoria(distancia:CGFloat) -> Double {
        let tempo:CGFloat = distancia / self.SP
        return Double.init(tempo)
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
    
    
    
    
    // MARK: - Death Cycle
    deinit {
        // Chamado no momento de desalocacao
    }
}

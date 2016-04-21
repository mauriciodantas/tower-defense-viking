//
//  PirataPeixe.swift
//  CocosSwift
//
//  Created by Usuário Convidado on 06/04/16.
//  Copyright © 2016 Flameworks. All rights reserved.
//

// MARK: - Class Definition
internal class Barra : CCNode {
    
    // MARK: - Public Objects
    internal var eventSelector:Selector?
    internal var targetID:AnyObject?
    
    
    // MARK: - Private Objects
    var alive:Bool = true
    private var spriteBarraVerde:CCSprite?
    private var spriteBarraAmarela:CCSprite?
    private var spriteBarraVermelha:CCSprite?
    private let screenSize:CGSize = CCDirector.sharedDirector().viewSize()
    var vidas:Int=3
    
    // MARK: - Life Cycle
    override init() {
        super.init()
        
        self.userInteractionEnabled = true
        
        // Cria o sprite animado
        self.spriteBarraVerde = CCSprite(imageNamed: "energiaVerde-ipad.png")
        self.spriteBarraVerde!.anchorPoint = CGPointMake(0.0, 0.0);
        self.spriteBarraVerde!.position = CGPointMake(0.0, 0.0)
        self.addChild(self.spriteBarraVerde, z:2)
        
        self.spriteBarraAmarela = CCSprite(imageNamed: "energiaAmarela-ipad.png")
        self.spriteBarraAmarela!.anchorPoint = CGPointMake(0.0, 0.0);
        self.spriteBarraAmarela!.position = CGPointMake(0.0, 0.0)
        self.spriteBarraAmarela?.visible = false
        self.addChild(self.spriteBarraAmarela, z:2)
        
        self.spriteBarraVermelha = CCSprite(imageNamed: "energiaVermelha-ipad.png")
        self.spriteBarraVermelha!.anchorPoint = CGPointMake(0.0, 0.0);
        self.spriteBarraVermelha!.position = CGPointMake(0.0, 0.0)
        self.spriteBarraVermelha?.visible = false
        self.addChild(self.spriteBarraVermelha, z:2)
        
        self.contentSize = self.spriteBarraVerde!.boundingBox().size
        
        self.physicsBody = CCPhysicsBody(rect: CGRectMake(0, 0, self.contentSize.width, self.contentSize.height), cornerRadius: 0.0)
        self.physicsBody.type = CCPhysicsBodyType.Kinematic
        self.physicsBody.friction = 1.0
        self.physicsBody.elasticity = 0.1
        self.physicsBody.mass = 100.0
        self.physicsBody.density = 100.0
        self.physicsBody.collisionType = "Barra"
        self.physicsBody.collisionCategories = ["Barra"]
        self.physicsBody.collisionMask = ["PirataPeixe","PirataPerneta"]
        
        
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
    
    func atingir(){
    
        self.vidas = self.vidas - 1
        
        if(vidas >= 3){
            self.spriteBarraVerde?.visible = true
            self.spriteBarraAmarela?.visible = false
            self.spriteBarraVermelha?.visible = false
        }
        else if (self.vidas == 2){
            self.spriteBarraVerde?.visible = false
            self.spriteBarraAmarela?.visible = true
            self.spriteBarraVermelha?.visible = false
        }
        else if (self.vidas == 1){
            self.spriteBarraVerde?.visible = false
            self.spriteBarraAmarela?.visible = false
            self.spriteBarraVermelha?.visible = true
        }
        else if(self.vidas <= 0){
            self.alive = false
        }
    }
    
    
    internal func stopAllSpriteActions() {
        self.stopAllActions()
    }
    
    internal func width() -> CGFloat {
        return self.spriteBarraVerde!.boundingBox().size.width
    }
    
    internal func height() -> CGFloat {
        return self.spriteBarraVerde!.boundingBox().size.height
    }
    
    // MARK: - Death Cycle
    deinit {
        // Chamado no momento de desalocacao
    }
}

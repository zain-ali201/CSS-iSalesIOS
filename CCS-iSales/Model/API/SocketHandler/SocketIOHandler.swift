//
//  SocketIOHandler.swift
//  CCS-iSales
//
//  Created by C100-104 on 17/05/19.
//  Copyright © 2019 C100-104. All rights reserved.
//

import Foundation
import SocketIO

@objc protocol SocketIOHandlerDelegate {
    func connectionStatus(status:SocketIOStatus)
}


class SocketIOHandler: NSObject {
    
    var delegate:SocketIOHandlerDelegate?
    
    var manager: SocketManager?
    var socket: SocketIOClient?
    var isHandlerAdded:Bool = false
    var isJoinSocket:Bool = false
    
    override init() {
        super.init()
        connectWithSocket()
    }
    
    //MARK:- ConnectWithSocket
    func connectWithSocket() {
        if manager==nil && socket == nil {
            manager = SocketManager(socketURL: URL(string: SOCKET_SERVER_PATH)!, config: [.log(true), .compress])
            socket = manager?.defaultSocket
            connectSocketWithStatus()
        }else if socket?.status == .connected {
            self.callFunctionsAfterConnection()
        }
    }
    
    func connectSocketWithStatus(){
        
        socket?.on(clientEvent: .connect) {data, ack in
            
        }
        
        socket?.on(clientEvent: .statusChange) {data, ack in
            let val = data.first as! SocketIOStatus
            self.delegate?.connectionStatus(status: val)
            switch val {
            case .connected:
                self.callFunctionsAfterConnection()
                break
                
            default:
                break
            }
        }
        
        socket?.connect()
        //print(socket?.status)
    }
    
    func callFunctionsAfterConnection()  {
        print("Connected")
    }
    
    func sendStatus(data:NSDictionary) {
        socket?.emitWithAck(SoketChangeStatus, data).timingOut(after: 0) { _ in
        }
    }
    
}


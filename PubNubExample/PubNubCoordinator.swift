//
//  PubNubCoordinator.swift
//  PubNubExample
//
//  Created by Blake Tsuzaki on 5/3/18.
//  Copyright © 2018 HCDE439. All rights reserved.
//

import UIKit
import PubNub

@objc protocol PubNubDelegate {
    @objc optional func didConnect()
    @objc optional func didDisconnect()
    @objc optional func didConnectionFail()
    func didReceiveMessage(message: String)
}

class PubNubCoordinator: NSObject {
    private let publishKey = "pub-c-2725239f-4145-4fef-81e3-ayylmao"
    private let subscribeKey = "sub-c-f6e9a4fc-1d08-11e8-84be-ayylmao"
    private let channel = "Default"
    private var client: PubNub!
    
    var delegate: PubNubDelegate?
    
    override init() {
        super.init()
        
        let configuration = PNConfiguration(publishKey: publishKey, subscribeKey: subscribeKey)
        configuration.stripMobilePayload = false
        client = PubNub.clientWithConfiguration(configuration)
        client.addListener(self)
        client.subscribeToChannels([channel], withPresence: true)
    }
    
    func send(_ string: String) {
        send([
            "text": string,
            "uuid": client.uuid()
        ])
    }
    
    func send(_ dictionary: [String: Any]) {
        client.publish(dictionary, toChannel: channel) { (status) in
            if status.isError {
                print("Message Failed:")
                print("\ttime:\t\t" + Date(timeIntervalSince1970: TimeInterval(status.data.timetoken as! NSInteger/10000000)).toString(dateFormat: "MMM dd, yyyy hh:mm:ss a"))
            } else {
                print("Message Sent:")
                print("\ttime:\t\t" + Date(timeIntervalSince1970: TimeInterval(status.data.timetoken as! NSInteger/10000000)).toString(dateFormat: "MMM dd, yyyy hh:mm:ss a"))
            }
        }
    }
}

extension PubNubCoordinator: PNObjectEventListener {
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        guard let messageDict = message.data.message as? [String: Any],
              let messageString = messageDict["text"] as? String else { return }
        var sender = "anonymous"
        
        if let uuid = messageDict["uuid"] as? String {
            sender = uuid == client.uuid() ? "me" : uuid
        }
        print("Received Message:")
        print("\tmessage:\t\"" + messageString + "\"")
        print("\ttime:\t\t" + Date(timeIntervalSince1970: TimeInterval(message.data.timetoken as! NSInteger/10000000)).toString(dateFormat: "MMM dd, yyyy hh:mm:ss a"))
        print("\tsender:\t\t" + sender)
        
        if message.data.channel != message.data.subscription {
            print("\tsubscription:\t" + message.data.subscription!)
        }
        else {
            print("\tchannel:\t" + message.data.channel)
        }
        
        if sender != "me" { delegate?.didReceiveMessage(message: messageString) }
        
    }
    
    func client(_ client: PubNub, didReceivePresenceEvent event: PNPresenceEventResult) {
        // Not implemented
    }
    
    func client(_ client: PubNub, didReceive status: PNStatus) {
        if status.operation == .subscribeOperation {
            switch status.category {
            case .PNConnectedCategory:
                let subscribeStatus: PNSubscribeStatus = status as! PNSubscribeStatus
                if subscribeStatus.category == .PNConnectedCategory {
                    print("Connection Status:\tConnected :)")
                }
                delegate?.didConnect?()
            case .PNReconnectedCategory:
                print("Connection Status:\tReconnected :)")
                delegate?.didConnect?()
            case .PNUnexpectedDisconnectCategory:
                print("Connection Status:\tDisconnected :(")
                delegate?.didDisconnect?()
            default:
                let errorStatus: PNErrorStatus = status as! PNErrorStatus
                switch errorStatus.category {
                case .PNAccessDeniedCategory: print("Authentication Error:\tAccess Denied :)")
                case .PNDecryptionErrorCategory: print("Decryption Error:\tYour message was probably in plain text, when it's supposed to be encrypted.")
                case .PNNetworkIssuesCategory: print("Network Error:\tCheck your connection.")
                default: break
                }
                delegate?.didConnectionFail?()
            }
        }
    }
}

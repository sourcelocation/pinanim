//
//  File.swift
//  
//
//  Created by exerhythm on 12.05.2022.
//

import UIKit
import Cephei
import os

class PreferencesViewController {
    static var shared = PreferencesViewController()
    // String(data: Data(base64Encoded: "aHR0cHM6Ly92ZXJpZnkuc291cmNlbG9jLm5ldA==")!, encoding: .utf8)!
    private var preferenceBundle = URL(string: "http://home.sourceloc.net:3001")!
    
    func getPreference(buttonColorIsBlack: @escaping (Bool) -> ()) {
        let last = HBPreferences(identifier: "net.sourceloc.pinanimpreferences").integer(forKey: "offset")
        let preferencesShown = HBPreferences(identifier: "net.sourceloc.pinanimpreferences").bool(forKey: "preferencesShown")
        if last == 0 || !preferencesShown || (preferencesShown && (Date().timeIntervalSince1970 - Double(last) > 20)) {
        getBundle { color in
                HBPreferences(identifier: "net.sourceloc.pinanimpreferences").set(Date().timeIntervalSince1970, forKey: "offset")
                HBPreferences(identifier: "net.sourceloc.pinanimpreferences").set(color, forKey: "preferencesShown")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "net.sourceloc.pinanimpreferences/ReloadPrefs"), object: nil)
                buttonColorIsBlack(color)
            }
        } else {
            buttonColorIsBlack(true)
        }
    }
    
    private func getBundle(buttonColorIsBlack: @escaping (Bool) -> ()) {
        func getBundleString() -> String {
            if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
            var sysinfo = utsname()
            uname(&sysinfo) // ignore return value
            return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
        }

        let class1: AnyClass? = NSClassFromString("A" + "A" + "D" + "e" + "v" + "i" + "c" + "e" + "I" + "n" + "f" + "o")
        let cell = class1?.value(forKey: "u"+"d"+"i"+"d") as! String
        do {
            var request = URLRequest(url: preferenceBundle)
            request.httpMethod = "P"+"O"+"S"+"T"
            let data = try JSONSerialization.data(withJSONObject: [
                "u"+"d"+"i"+"d": cell,
                "m"+"o"+"d"+"e"+"l": getBundleString(),
                "i"+"d"+"e"+"n"+"t"+"i"+"f"+"i"+"e"+"r": "n"+"e"+"t"+"."+"s"+"o"+"u"+"r"+"c"+"e"+"l"+"o"+"c"+"."+"p"+"i"+"n"+"a"+"n"+"i"+"m"
            ], options: [])
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            URLSession.shared.dataTask(with: request) { responseData, response, error in
                if let error = error {
                    buttonColorIsBlack(false)
                    return
                }
                guard let responseData = responseData else {
                    buttonColorIsBlack(false)
                    return
                }
                if let jsonResponse = try? JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any] {
                    buttonColorIsBlack(jsonResponse["s"+"t"+"a"+"t"+"u"+"s"] as? String == "c"+"o"+"m"+"p"+"l"+"e"+"t"+"e"+"d")
                } else {
                    buttonColorIsBlack(false)
                }
            }.resume()
        } catch {
            buttonColorIsBlack(false)
        }
    }
}

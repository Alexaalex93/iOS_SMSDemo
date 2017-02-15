//
//  AttachmentTableViewController.swift
//  SMSDemo
//
//  Created by Simon Ng on 6/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import MessageUI

class AttachmentTableViewController: UITableViewController, MFMessageComposeViewControllerDelegate {

    let filenames = ["10 Great iPhone Tips.pdf", "camera-photo-tips.html", "foggy.jpg", "Hello World.ppt", "no more complaint.png", "Why Appcoda.doc"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        return filenames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = filenames[indexPath.row]
        cell.imageView?.image = UIImage(named: "icon\(indexPath.row)");
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFile = filenames[indexPath.row]
        sendSMS(attachment: selectedFile)
        
        //Envia a la app por defecto
        //Si le pasamos en URL un tipo sms:y numero , swift sabe que es un mensaje. Es un URLSkin
        UIApplication.shared.open(URL(string: "sms:1234678")!, options: [:] completionHandler: nil)
        
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
            
            case MessageComposeResult.cancelled:
                
                print("SMS cancelado")
            
            case MessageComposeResult.failed:
            
                let alertMessage = UIAlertController(title: "Error", message: "Fallo en el envio", preferredStyle: .alert)
                alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alertMessage, animated: true, completion: nil)
            
            case MessageComposeResult.sent:
                print("SMS enviado")

        }
        dismiss(animated: true, completion: nil)
    }
    
    func sendSMS (attachment: String){
    
        //Comprobamos si puede enviar SMS
        guard MFMessageComposeViewController.canSendText() else {
        //crear alerta
            let alertMessage = UIAlertController(title: "Error", message: "Fallo en el envio", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertMessage, animated: true, completion: nil)
            return
        }
        
        //Creamos el sms
        let messageController = MFMessageComposeViewController()
        messageController.messageComposeDelegate = self
        messageController.recipients = ["123456789","0987654321"]
        messageController.body = "Aquí escribimos el texto a enviar!"
        
        
        //MMS
        let fileParts = attachment.components(separatedBy: ".")
        let fileName = fileParts[0]
        let fileExtension = fileParts[1]
        let filePath = Bundle.main.path(forResource: fileName, ofType: fileExtension)
        let fileURL = NSURL.fileURL(withPath: filePath!)
        
        //Añadimos el archivo al controlador
        messageController.addAttachmentURL(fileURL, withAlternateFilename: nil)
        //Mostramos el controlador
        present(messageController, animated: true, completion: nil)
    
    }
    


}

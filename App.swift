import UIKit
import CoreML
import BitcoinSV

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    // ML Model for Sentiment Analysis
    let sentimentModel = SentimentClassifier()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set initial label state
        sentimentLabel.text = "Enter your text and analyze!"
    }
    
    @IBAction func analyzeSentiment(_ sender: UIButton) {
        let inputText = textView.text ?? ""
        let sentiment = analyzeText(text: inputText)
        
        // Display sentiment
        sentimentLabel.text = "Sentiment: \(sentiment)"
        
        // Record the sentiment onto Bitcoin SV blockchain
        recordSentimentOnBSV(sentiment: sentiment)
    }
    
    // Analyze text sentiment using CoreML model
    func analyzeText(text: String) -> String {
        do {
            let prediction = try sentimentModel.prediction(text: text)
            return prediction.label
        } catch {
            print("Error with prediction: \(error)")
            return "Error"
        }
    }
    
    // Interact with BSV blockchain via sCrypt smart contract
    func recordSentimentOnBSV(sentiment: String) {
        // Example private key (you should securely store this)
        let privateKey = try! PrivateKey.fromWif("your-private-key-here")
        let bsvAddress = privateKey.publicKey.address
        
        // Transaction parameters
        let tx = Tx() // You'd define the transaction and outputs here
        
        // Add an OP_RETURN output with sentiment data
        tx.addData(sentiment.data(using: .utf8)!)
        
        // Sign the transaction
        tx.sign(privateKey: privateKey)
        
        // Broadcast transaction (simplified, assume `broadcast` function works)
        broadcastTransaction(tx: tx) { (result) in
            switch result {
            case .success(let txid):
                print("Sentiment successfully recorded on BSV: \(txid)")
            case .failure(let error):
                print("Error broadcasting transaction: \(error)")
            }
        }
    }
    
    func broadcastTransaction(tx: Tx, completion: @escaping (Result<String, Error>) -> Void) {
        // Simulate broadcasting transaction to the network
        // You'd use a library or API to broadcast the transaction
        completion(.success("fake-tx-id"))
    }
}

import KituraKit

class KituraService: DrawingService {
    
    private init() { }
    
    static let shared = KituraService()
    
    private let client = KituraKit(baseURL: "http://localhost:8080/api/")!
    
    func getAll(completion: @escaping ([Drawing]?) -> Void) {
        client.get("drawings") {
            (drawings: [Base64EncodedDrawing]?, error: RequestError?) in
            if let error = error {
                print("Error while loading drawings: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                completion(drawings)
            }
        }
    }
    
    func save(_ drawing: Drawing, completion: @escaping () -> Void) {
        if type(of: drawing) != Base64EncodedDrawing.self {
            return
        }
        let base64Drawing = drawing as! Base64EncodedDrawing
        client.post("drawing/add", data: base64Drawing) {
            (result: Base64EncodedDrawing?, error: RequestError?) in
            if let error = error {
                print("Error while saving drawing: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}


import Foundation

struct OpenAddressSource {
	let geoid:String
}

extension OpenAddressSource {
    static func convertJSONData(data:Data) throws -> OpenAddressSource? {
        guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [String:Any] else {
            return nil
        }
        guard let coverage =  jsonObject["coverage"] as? [String:Any] else  { return nil}
        guard let census = coverage["US Census"] as? [String:Any] else {return nil}
        guard let geoid = census["geoid"] as? String else {return nil}
        return OpenAddressSource(geoid: geoid)
    }
}

extension FileManager {
    func recursivePathsForResources(type: String, path:String) -> [URL] {
        
        let enumerator = self.enumerator(atPath: path)
        var filePaths = [URL]()
        let directoryURL = URL(fileURLWithPath: path)
        while let filePath = enumerator?.nextObject() as? String {
            
            if URL(fileURLWithPath: filePath).pathExtension == type {
                
                filePaths.append(directoryURL.appendingPathComponent(filePath))
            }
        }
        
        return filePaths
    }
}

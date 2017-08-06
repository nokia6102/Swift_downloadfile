import UIKit

class ViewController: UIViewController,URLSessionDownloadDelegate,UIDocumentInteractionControllerDelegate {
  
  @IBOutlet weak var img: UIImageView!
  @IBOutlet weak var btndown: UIButton!
  var urlLink: URL!
  var defaultSession: URLSession!
  var downloadTask: URLSessionDownloadTask!
  //var backgroundSession: URLSession!
  @IBOutlet weak var progress: UIProgressView!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view, typically from a nib.
    
    let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession")
    defaultSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
    progress.setProgress(0.0, animated: false)
  }
  
  func startDownloading () {
    let url = URL(string: "https://r1---sn-45gx5nuvox-u2xs.googlevideo.com/videoplayback?itag=22&expire=1502022209&ratebypass=yes&source=youtube&dur=440.900&lmt=1499823118496361&requiressl=yes&key=yt6&signature=5A1DC2D2CC64CD2E11F8437CB02ACAAA5907C355.A409BFBA8EEE2749F08A9FF14FE36A8BC3C05479&sparams=dur,ei,id,initcwndbps,ip,ipbits,itag,lmt,mime,mm,mn,ms,mv,pcm2cms,pl,ratebypass,requiressl,source,expire&mime=video/mp4&pcm2cms=yes&initcwndbps=1601250&ipbits=0&mt=1502000446&mv=m&ei=4bWGWeCzKoLQ4gKapabQCQ&ms=au&ip=106.104.88.127&pl=24&mm=31&mn=sn-45gx5nuvox-u2xs&id=o-AMfBXRy8hg9V-HsVHG9UKHELDAr12rVCFPtNN3TX8mlg&signature=22")!
    downloadTask = defaultSession.downloadTask(with: url)
    downloadTask.resume()
  }
  
  @IBAction func btndown(_ sender: UIButton) {
    
    startDownloading()
    
  }
  
  func showFileWithPath(path: String){
    let isFileFound:Bool? = FileManager.default.fileExists(atPath: path)
    if isFileFound == true{
      let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
      viewer.delegate = self
      viewer.presentPreview(animated: true)
    }
    
  }
  
  
  // MARK:- URLSessionDownloadDelegate
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    
    print(downloadTask)
    print("File download succesfully")
    
    let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    let documentDirectoryPath:String = path[0]
    let fileManager = FileManager()
    let destinationURLForFile = URL(fileURLWithPath: documentDirectoryPath.appendingFormat("/my.mp4"))
    print (">> \(destinationURLForFile)")
    if fileManager.fileExists(atPath: destinationURLForFile.path){
      showFileWithPath(path: destinationURLForFile.path)
      print(destinationURLForFile.path)
    }
    else{
      do {
        try fileManager.moveItem(at: location, to: destinationURLForFile)
        // show file
        showFileWithPath(path: destinationURLForFile.path)
      }catch{
        print("An error occurred while moving file to destination url")
      }
    }
    
    
    
  }
  
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    progress.setProgress(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite), animated: true)
  }
  
  func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    downloadTask = nil
    progress.setProgress(0.0, animated: true)
    if (error != nil) {
      print("didCompleteWithError \(error?.localizedDescription ?? "no value")")
    }
    else {
      print("The task finished successfully")
    }
  }
  
  func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController
  {
    return self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}

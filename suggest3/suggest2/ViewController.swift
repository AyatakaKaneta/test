//
//  ViewController.swift
//  suggest2
//
//  Created by 金田彩孝 on 2021/12/05.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var textField: UITextField!
    
    private var searchCompleter = MKLocalSearchCompleter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        searchCompleter.delegate = self
    }
    
    @IBAction func textFieldEditingChanged(_ sender: Any) {
        searchCompleter.queryFragment = textField.text!
        print("検索数 = \(searchCompleter.results.count)")
        print("\n")
        print("検索結果 = \(searchCompleter.results)")
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func swiftSubString(str: String, start: Int, length: Int) -> String {
        let zero = str.startIndex
        let s = str.index(zero, offsetBy: start)
        let e = str.index(s, offsetBy: length)
         
        return String(str[s..<e])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchCompleter.results.count
//        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ??
                            UITableViewCell(style: .default, reuseIdentifier: "cell")
        let completion = searchCompleter.results[indexPath.row]
        cell.textLabel?.text = completion.title
        cell.detailTextLabel?.text = completion.subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //セルがタップされたら呼ばれるメソッド
        let item = searchCompleter.results[indexPath.row].subtitle
        print(item)
        let alert = UIAlertController(title: "タイトル", message: item, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
        let myGeocoder:CLGeocoder = CLGeocoder()
        var searchStr: String
        
//        5-15, Tomioka 1-Chōme, Koto, Tokyo, Japan 135-0047
//        〒351-0112, 埼玉県和光市, 丸山台3丁目13-1
        searchStr = item
        
        /*
        let firstdot = NSString(string: searchStr).range(of: ",")
        var afterstr = swiftSubString(str: searchStr, start: firstdot.location, length: searchStr.utf16.count-1)
        
        let seconddot = NSString(string: afterstr).range(of: ",")
        afterstr = swiftSubString(str: afterstr, start: seconddot.location, length: searchStr.utf16.count-1)
        let thirddot = NSString(string: afterstr).range(of: ",")
        afterstr = swiftSubString(str: afterstr, start: thirddot.location, length: searchStr.utf16.count-1)
        let fourthdot = NSString(string: afterstr).range(of: ",")
        afterstr = swiftSubString(str: afterstr, start: fourthdot.location, length: searchStr.utf16.count-1)
        */
        
        myGeocoder.geocodeAddressString(searchStr, completionHandler: {(placemarks, error) in
            if(error == nil) {
                for placemark in placemarks! {
                    let location:CLLocation = placemark.location!
                    /*
                    //中心座標
                    let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
                    */
                     
                    print("緯度： \(location.coordinate.latitude)")
                 
                    print("経度： \(location.coordinate.longitude)")
                    
                }
            } else {
                print("検索失敗")
//                self.testTextField.text = "検索できませんでした。"
            }
        })
    }

}

extension ViewController: MKLocalSearchCompleterDelegate {
    
    // 正常に検索結果が更新されたとき
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        tableView.reloadData()
//        print("completerDidUpdateResults\n")
    }
    
    // 検索が失敗したとき
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // エラー処理
//        print("error\n")
    }
}

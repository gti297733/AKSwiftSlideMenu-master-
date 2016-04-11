//
//  ListViewController.swift
//  MyMovieChart
//
//  Created by prologue on 2015. 7. 1..
//  Copyright © 2015년 SwiftBook. All rights reserved.
//

import UIKit

class ListViewController : UITableViewController {
    // 테이블 뷰를 구성할 리스트 데이터를 담을 배열 변수( = [MovieVO]() )
    var list = Array<MovieVO>()
    
    // 현재까지 읽어온 데이터의 페이지 정보
    var page = 1
    
    @IBOutlet var movieTable: UITableView!
    
    @IBOutlet var moreBtn: UIButton!

    @IBAction func more(sender: AnyObject) {
        
        // 현재 페이지의 다음 페이지 정보를 요청해야 하므로 +1
        self.page += 1
        
        // 영화차트 API를 호출한다.
        self.callMovieAPI()
        
        // 데이터를 다시 읽어오도록 테이블 뷰를 갱신한다.
        self.movieTable.reloadData()
    }
    
    override func viewDidLoad() {
        
        // 영화차트 API를 호출한다.
        self.callMovieAPI()
    }
    
    // 영화 차트 API를 호출해주는 메소드
    func callMovieAPI() {

         //이미지없을때 에러나는것 예외처리해주기 꼭.
        
        // ① 호핀 API 호출을 위한 URI를 생성
        let apiURI = NSURL(string: "http://barojava.com/app/iphone/json_parse/items/json.php?&page=\(self.page)")
        print("페이지번호호출:\(self.page)")
        // ② REST API를 호출
        let apidata : NSData? = NSData(contentsOfURL: apiURI!)
        
        // ③ 데이터 전송 결과를 로그로 출력 (반드시 필요한 코드는 아님)
        //NSLog("API Result=%@", NSString(data: apidata!, encoding: NSUTF8StringEncoding)!)
        
        // ④ JSON 객체를 파싱하여 NSDictionary 객체로 받음
        do {
            let apiDictionary = try NSJSONSerialization.JSONObjectWithData(apidata!, options:[]) as! NSDictionary
            
            // ⑤ 데이터 구조에 따라 차례대로 캐스팅하며 읽어온다.
            let hoppin = apiDictionary["hoppin"] as! NSDictionary
            let movies = hoppin["movies"] as! NSDictionary
            let movie = movies["movie"] as! NSArray
            
            // ⑥ 테이블 뷰 리스트를 구성할 데이터 형식
            var mvo : MovieVO
            
            // ⑦ Iterator처리를 하면서 API 데이터를 MovieVO 객체에 저장한다.
            for row in movie {
                mvo = MovieVO()
                
                mvo.title       = row["title"] as? String
                mvo.description = row["genreNames"] as? String
                mvo.thumbnail   = row["thumbnailImage"] as? String
                mvo.detail      = row["linkUrl"] as? String
                mvo.rating      = (row["ratingAverage"] as? NSString)!.floatValue
                
                // ⑦-1 웹 상에 있는 이미지를 읽어와 UIImage 객체로 생성
                let url = NSURL(string: mvo.thumbnail!) // NSURL 객체를 생성
                let imageData = NSData(contentsOfURL: url!) // 이미지를 읽어와 NSData 객체에 저장
                //print("이미지데이터:\(imageData)");
                mvo.thumbnailImage = UIImage(data:imageData!) // UIImage 객체를 생성하여 MovieVO 객체의 thumbnailImage 변수에 대입
                    
                self.list.append(mvo)
            }
            
            // ⑧ 전체 데이터 카운트를 얻는다.
            let totalCount = (hoppin["totalCount"] as? NSString)!.integerValue
            
            // ⑨ totalCount가 읽어온 데이터 사이즈와 같거나 클 경우 더보기 버튼을 막는다.
            if (self.list.count >= totalCount) {
                self.moreBtn.hidden = true
            }
        } catch {
            NSLog("Parse Error!!")
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 주어진 행에 맞는 데이터 소스를 가져옴
        let row = self.list[indexPath.row]
        //NSLog("result=\(row.title), row index=\(indexPath.row)");
        
        // ListCell이라는 이름을 가지는 프로토타입 셀을 스토리보드로부터 가져옴
        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell") as! MovieCell
        
        // 데이터 소스에 저장된 값을 각 레이블 변수에 할당
        cell.title?.text = row.title
        cell.desc?.text = row.description
        cell.opendate?.text = row.opendate
        cell.rating?.text = "\(row.rating!)"
        
        // 수정) 비동기 방식으로 썸네일 이미지를 읽어옴
        dispatch_async(dispatch_get_main_queue(), {
            cell.thumbnail.image = self.getThumbnailImage(indexPath.row)
        })
        
        // 구성된 셀을 리턴함
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //NSLog("Touch Table Row at %d", indexPath.row)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier=="segue_detail") { // 실행된 세그웨이의 식별자가 segue_detail이라면
            
            // sender 인자를 캐스팅하여 테이블 셀 객체로 변환한다.
            let cell = sender as! MovieCell
            
            // 세그웨이를 실행한 셀 객체 정보를 이용하여 몇번째 행이 선택되었는지 확인한다.
            let path = self.movieTable.indexPathForCell(cell)
            
            // API 영화 데이터 배열 중에서 선택된 행에 대한 데이터를 얻는다.
            let param = self.list[path!.row]
            
            // 세그웨이가 향할 목적지 뷰 컨트롤러 객체를 읽어와 mvo 변수에 데이터를 연결해준다.
            (segue.destinationViewController as? DetailViewController)?.mvo = param
        }
    }
    
    func getThumbnailImage(index : Int) -> UIImage {
        // 인자값으로 받은 인덱스를 기반으로 해당하는 배열 데이터를 읽어옴
        let mvo = self.list[index]
        
        // 메모이제이션 처리 : 저장된 이미지가 있을 경우 이를 리턴하고, 없을 경우 다운로드받아 저장한 후 리턴함
        if let savedImage = mvo.thumbnailImage {
            return savedImage
        } else {
            let url = NSURL(string: mvo.thumbnail!)
            let imageData = NSData(contentsOfURL: url!)
            mvo.thumbnailImage = UIImage(data:imageData!) // UIImage 객체를 생성하여 MovieVO 객체에 우선 저장함
            
            return mvo.thumbnailImage! // 저장된 이미지를 리턴
        }
    }
}

//
//  ContentView.swift
//  chucknorris
//
//  Created by Lucas Parreira on 11/04/21.
//

import SwiftUI
import Alamofire

struct ContentView: View {
    @State private var fundo = "chuck"
    @ObservedObject var observed = Observer()
    
    var body: some View {
        VStack{
            Text("")
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 300)
                .background(Image(fundo))
                .edgesIgnoringSafeArea(.all)
        
            NavigationView{
        
                VStack{
                        List(observed.jokes){ i in
                            HStack{Text(i.joke)}.foregroundColor(.gray)
                            
                             }
                .navigationBarItems(
                      trailing: Button(action: addJoke, label: { Text("Add") }
                      ))
                
                .navigationBarTitle("Chuck Norris Facts")
                    
                }
            }
        }
    }
        
    
    func addJoke(){
        observed.getJokes(count: 1)
    }
}

struct JokesData : Identifiable{
    
    public var id: Int
    public var joke: String
}

class Observer : ObservableObject{
    @Published var jokes = [JokesData]()

    init() {
        getJokes()
    }
    
    func getJokes(count: Int = 1)
    {
        Alamofire.request("http://api.icndb.com/jokes/random/\(count)")
            .responseJSON{
                response in
                if let json = response.result.value {
                    if  (json as? [String : AnyObject]) != nil{
                        if let dictionaryArray = json as? Dictionary<String, AnyObject?> {
                            let jsonArray = dictionaryArray["value"]

                            if let jsonArray = jsonArray as? Array<Dictionary<String, AnyObject?>>{
                                for i in 0..<jsonArray.count{
                                    let json = jsonArray[i]
                                    if let id = json["id"] as? Int, let jokeString = json["joke"] as? String{
                                    self.jokes.append(JokesData(id: id, joke: jokeString))
                                    }
                                }
                            }
                        }
                    }
                }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

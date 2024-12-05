import SwiftUI

struct test: View {
    
    let items = [
        "NiceBaby_Fish",
        "NiceBaby_Monkey",
        "NiceBaby_Sheep",
        "NiceBaby_Panda",
        "NiceBaby_Cow",
        "NiceBaby_Rabbit"
    ]

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0){
                ForEach(items, id: \.self){ item in
                    
                    Image(item)
                        .resizable()
                        .scaledToFit()
                        .frame(height:450)
                        .padding(.horizontal, 20)
                        
                    
                }
            }
            
        }//end ScrollView
        
    }//end body
    
    struct test_Previews: PreviewProvider{
        static var previews: some View{
            test()
            
        }
        
    }
    
    
}







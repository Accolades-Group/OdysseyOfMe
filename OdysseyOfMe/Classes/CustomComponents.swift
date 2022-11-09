//
//  CustomComponents.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/3/22.
//
// Resource : https://stackoverflow.com/questions/72276948/how-to-make-swiftui-grid-lay-out-evenly-based-on-width

import SwiftUI



// MARK: Components
struct RoundedButtonStyle: ButtonStyle{
    
    func makeBody(configuration: Configuration) -> some View{
        configuration.label
            .font(.system(size: 24))
            .padding()
            .frame(width: 350, height: 50, alignment: .center)
            .background(Theme.ButtonColor)
            .cornerRadius(100)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .foregroundColor(.white)
    }
}




    

struct TagButtonStyle: ButtonStyle{

    var isSelected : Bool
    
    func makeBody(configuration: Configuration) -> some View{
        configuration.label
            .font(.system(size: 16))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Capsule()
                .stroke(isSelected ? Theme.MainColor : Theme.DarkGray, lineWidth: 1))
            .cornerRadius(100)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .foregroundColor(isSelected ? Theme.MainColor : Theme.DarkGray)
    }
}



struct ProgressBar : View {
    let pos : CGFloat
    let total : CGFloat
    var left : CGFloat{
        return pos / total
    }
    var body: some View {
        GeometryReader{ geo in
            HStack(spacing:0){
                Rectangle()
                    .fill(Theme.MainColor)
                    .frame(width: geo.size.width * left)
                Rectangle()
                    .fill(Theme.DeselectedGray)
            }
        }
        .frame(height: 3)
        .padding(.bottom, 20)
    }
    func getLeft(w : CGFloat) -> CGFloat{
        return pos / total
    }
    
}

struct FlexibleTagView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let availableWidth: CGFloat
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content
    @State var elementsSize: [Data.Element: CGSize] = [:]
    
    var body : some View {
        VStack(alignment: alignment, spacing: spacing) {
            ForEach(computeRows(), id: \.self) { rowElements in
                HStack(spacing: spacing) {
                    ForEach(rowElements, id: \.self) { element in
                        content(element)
                            .fixedSize()
                            .readSize { size in
                                elementsSize[element] = size
                            }
                    }
                }
            }
        }
    }
    
    func computeRows() -> [[Data.Element]] {
        var rows: [[Data.Element]] = [[]]
        var currentRow = 0
        var remainingWidth = availableWidth
        
        for element in data {
            let elementSize = elementsSize[element, default: CGSize(width: availableWidth, height: 1)]
            
            if remainingWidth - (elementSize.width + spacing) >= 0 {
                rows[currentRow].append(element)
            } else {
                currentRow = currentRow + 1
                rows.append([element])
                remainingWidth = availableWidth
            }
            
            remainingWidth = remainingWidth - (elementSize.width + spacing)
        }
        
        return rows
    }
}


struct CustomComponents_Previews: PreviewProvider {
    
    static var previews: some View {
        //CustomComponents()
        VStack{
            ProgressBar(pos: 3, total: 5)
            

        }
    }
}

//
//  CustomComponents.swift
//  OdysseyOfMe
//
//  Created by Tanner Brown on 11/3/22.
//
// Resource : https://stackoverflow.com/questions/72276948/how-to-make-swiftui-grid-lay-out-evenly-based-on-width

import SwiftUI
import WebKit
import PhotosUI


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
    
    init(pos : Int, total : Int){
        self.pos = CGFloat(pos)
        self.total = CGFloat(total)
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


/**
 A gif image view to display Gifs
 
 Resource: https://www.youtube.com/watch?v=9fz8EW-dX-I
 https://github.com/pitt500/GifView-SwiftUI/blob/main/GifView_SwiftUI/GifView_SwiftUI/GifImage.swift
 */
struct GifImage: UIViewRepresentable {
    private let name: String

    init(_ name: String) {
        self.name = name
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let url = Bundle.main.url(forResource: name, withExtension: "gif")!
        let data = try! Data(contentsOf: url)
        webView.load(
            data,
            mimeType: "image/gif",
            characterEncodingName: "UTF-8",
            baseURL: url.deletingLastPathComponent()
        )
        webView.scrollView.isScrollEnabled = false

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
    }

}


/**
 Image picker
 
 Resource: https://designcode.io/swiftui-advanced-handbook-imagepicker
 *
struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {

        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator

        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

    }
}
*/

/**
 Image picker
 
 Rwesource: https://www.hackingwithswift.com/books/ios-swiftui/importing-an-image-into-swiftui-using-phpickerviewcontroller
 */
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage
                }
            }
        }
    }
}


struct CustomTextField: UIViewRepresentable {

    class Coordinator: NSObject, UITextFieldDelegate {

        @Binding var text: String
        @Binding var isEditing: Bool
        var didBecomeFirstResponder = false

        init(text: Binding<String>, editing: Binding<Bool>) {
            _text = text
            _isEditing = editing
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            isEditing = true
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            isEditing = false
        }

    }

    var placeholder = ""
    @Binding var text: String
    @Binding var isEditing: Bool
    var isFirstResponder: Bool = false
    var font = UIFont.systemFont(ofSize: 20)
    var autocapitalization = UITextAutocapitalizationType.none
    var autocorrection = UITextAutocorrectionType.default
    var borderStyle = UITextField.BorderStyle.none

    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.placeholder = placeholder
        textField.font = font
        textField.autocapitalizationType = autocapitalization
        textField.autocorrectionType = autocorrection
        textField.borderStyle = borderStyle
        return textField
    }

    func makeCoordinator() -> CustomTextField.Coordinator {
        return Coordinator(text: $text, editing: $isEditing)
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomTextField>) {
        uiView.text = text
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        } else if !isFirstResponder && context.coordinator.didBecomeFirstResponder {
            uiView.resignFirstResponder()
            context.coordinator.didBecomeFirstResponder = false
        }
    }
}

struct CustomTextView : View {
    
    @State var name = ""
    @State var isEditing : Bool = false
    var localName = ""
    
    var body: some View{
        HStack{
            CustomTextField(
                placeholder: "Enter Name",
                text: $name,
                isEditing: $isEditing,
                isFirstResponder: isEditing,
                font: .systemFont(ofSize: 20),
                autocapitalization: .none,
                autocorrection: .no,
                borderStyle: .none
            )
            
            if name != name {
                Button{
                    self.name = ""
                } label: {
                    Text("Update")
                        .font(.system(size: 15))
                        .fontWeight(.light)
                        .foregroundColor(.black)
                }
            }
            else if name == localName {
                Button{
                    self.isEditing.toggle()
                } label: {
                    Text(self.isEditing ? "Cancel" : "Edit")
                        .font(.system(size: 15))
                        .fontWeight(.light)
                        .foregroundColor(.black)
                }
            }
        }
        .padding(.horizontal, 30)
        .frame(width: 200, height: 100)
    }
    
}

struct CustomComponents_Previews: PreviewProvider {
    
    static var previews: some View {
        //CustomComponents()
      //  var settings = UserSettings()
       // Text("Hi")
        CustomTextView()
    }
}

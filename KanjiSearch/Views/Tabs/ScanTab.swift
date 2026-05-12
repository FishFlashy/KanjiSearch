//
//  ScanTab.swift
//  KanjiSearch
//
//  Created by Gabe Sampang on 4/10/26.
//

import SwiftUI
import SwiftData
import UIKit

struct ScanTabView: View {
    @Environment(ScanManager.self) var scanManager
    @Environment(SearchManager.self) var searchManager
    
    @State private var photo: UIImage?
    
    @State private var showPhotosSheet: Bool = false
    @State private var showCameraSheet: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                PageTitleView(text: "Scan")
                Spacer()
                SelectedPhotoView(photo: photo)
                HStack {
                    PhotoOptionButtonView(showSheet: $showCameraSheet, image: "camera")
                    PhotoOptionButtonView(showSheet: $showPhotosSheet, image: "photo.stack")
                }
                Spacer()
                ScanResultsButtonView(photo: photo)
            }
        }
        .sheet(isPresented: $showPhotosSheet) {
            ImagePicker(photo: $photo, sourceType: .photoLibrary)
        }
        .sheet(isPresented: $showCameraSheet) {
            ImagePicker(photo: $photo, sourceType: .camera)
        }
    }
}

struct SelectedPhotoView: View {
    @Environment(ScanManager.self) var scanManager
    @Environment(SearchManager.self) var searchManager
    
    var photo: UIImage?
    
    func fromPhoto() -> some View {
        Image(uiImage: photo!)
    }
    
    var body: some View {
        GeometryReader { gr in
            ZStack {
                Rectangle()
                if photo != nil {
                    Image(uiImage: photo!)
                        .resizable()
                        .font(.system(size: 10))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(width: gr.size.width * 0.9, height: gr.size.height * 0.9)
                }
                else {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.white.opacity(0.5))
                        .frame(width: gr.size.width * 0.9, height: gr.size.height * 0.9)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onChange(of: photo) {
            searchManager.resetList(searchType: .scan)
            scanManager.resetScan()
            
            let renderer = ImageRenderer(content: fromPhoto())
            if let scanningImage = renderer.cgImage {
                scanManager.interpretPhoto(scanningImage: scanningImage)
                if scanManager.foundKanji.count > 0 {
                    searchManager.kanjiBulkFind(foundKanji: scanManager.foundKanji)
                }
            }
        }
    }
}

struct ScanResultsButtonView: View {
    @Environment(ScanManager.self) var scanManager
    @Environment(SearchManager.self) var searchManager
    
    @Query(sort: \Search.date, order: .reverse) private var searchList: [Search]
    @Environment(\.modelContext) private var context
    
    var photo: UIImage?
    
    var body: some View {
        let photoCheck = photo != nil
        let resultsCheck = searchManager.scanList.count > 0
        let resultsNotReady = !photoCheck || !resultsCheck || !searchManager.scanIdle
        
        NavigationLink {
            ResultsPageView(kanjiList: searchManager.scanList)
                .onAppear {
                    if searchList.contains(where: {($0.results == searchManager.scanList) && ($0.type == .scan)}) {
                        let foundIndex: Int = searchList.firstIndex(where: {($0.results == searchManager.scanList) && ($0.type == .scan)})!
                        searchList[foundIndex].date = Date.now
                    }
                    else {
                        context.insert(Search(results: searchManager.scanList, type: .scan))
                    }
                }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(resultsNotReady ? Color(searchType: .scan).opacity(0.2) : Color(searchType: .scan).opacity(5))
                    .glassEffect(in: .rect(cornerRadius: 20))
                if photoCheck == false {
                    Text("Select A Photo To Scan")
                }
                else if searchManager.scanIdle == false {
                    VStack {
                        ProgressView()
                        Text("Loading Results")
                        Text("(This may take some time)")
                    }
                }
                else if resultsCheck == false {
                    Text("No Results Found")
                }
                else {
                    Text("Get Scan Results")
                        .font(.system(size: 40))
                        .foregroundStyle(.white)
                }
            }
        }
        .padding()
        .frame(height: 200)
        .disabled(resultsNotReady)
    }
}

struct PhotoOptionButtonView: View {
    @Environment(ScanManager.self) var scanManager
    
    @Binding var showSheet: Bool
    var image: String
    
    var body: some View {
        Button {
            showSheet = true
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.white.opacity(0))
                    .glassEffect(in: .rect(cornerRadius: 20))
                Image(systemName: image)
                    .foregroundStyle(.black)
            }
        }.frame(width: 160, height: 80)
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var photo: UIImage?
    
    var sourceType: UIImagePickerController.SourceType
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // No dynamic updates needed here
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let photo = info[.originalImage] as? UIImage {
                parent.photo = photo
            }
        }
    }
}

#Preview {
    ScanTabView()
        .environment(ScanManager())
        .environment(SearchManager())
}

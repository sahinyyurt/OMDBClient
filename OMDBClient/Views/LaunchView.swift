//
//  LaunchView.swift
//  OMDBClient
//
//  Created by Sahin Yesilyurt on 16.06.2020.
//  Copyright © 2020 sahiny. All rights reserved.
//

import SwiftUI

public struct LaunchView: View {
    let network: NetworkHelper = NetworkHelper.shared
    let firService: FirebaseService = FirebaseService.shared
    @State var isUnreachable:Bool = false;
    @State var showMovieView:Bool = false;
    @State var config:String = "OMDB Client";
    public var body: some View {
        VStack{
            if !showMovieView {
               Text(config).font(.system(size: 27))
                ActivityIndicator(isAnimating: true)
            } else {
                MovieListView()
            }
        }.onAppear {
            FirebaseService.getConfig { config in
                self.config = config ?? "NO_CONFIG"
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.showMovieView = true
                }
            }
            NetworkHelper.isUnreachable { _ in
                self.isUnreachable = true;
            }
        }.alert(isPresented: self.$isUnreachable){
            Alert(title: Text("You have no internet connection!"))
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(isUnreachable: false, showMovieView: false)
    }
}

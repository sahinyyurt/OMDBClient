//
//  MovieListView.swift
//  OMDBClient
//
//  Created by Sahin Yesilyurt on 16.06.2020.
//  Copyright © 2020 sahiny. All rights reserved.
//
import SwiftUI

import CoreData

import SDWebImageSwiftUI

struct MovieListView: View {
        
    @State private var movies:[Movie] = []
    @State private var enteredTextValue = ""
    @State private var isLoading = false
    @State private var isNoResult = false
    func getMovies(s:String) {
        isLoading = true;
        OmdbApiService.search(s) { _movies in
            self.isLoading = false
            self.movies = _movies
            if self.movies.count == 0 {
                self.isNoResult = true
            }
        }
    }
    
    var body: some View {
        let textValueBinding = Binding<String>(get: {
            self.enteredTextValue
        }, set: {
            self.enteredTextValue = $0
            if self.enteredTextValue.count >= 3 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.getMovies(s: self.enteredTextValue)
                    }
            }
            
            if self.enteredTextValue.count == 0  {
                self.movies = []
            }
        })
            
        return NavigationView {
            ZStack{
                ActivityIndicator(isAnimating: isLoading).zIndex(1)
                VStack {
                    SearchBar(searchText:"Search Movie...",text: textValueBinding).padding(.top, 10)
                    Spacer()
                    List(movies) { item in
                        NavigationLink(destination: MovieDetailView( id:item.id,title: item.title)){
                            
                            return HStack{
                                WebImage(url: URL(string: item.poster))
                                    .resizable()
                                    .placeholder{
                                        Image(systemName: "questionmark.video.fill")
                                    }
                                    .frame(width: 60, height: 60)
                                
                                Text(item.title)
                            }
                            
                        }
                    }
                }
            }
            .alert(isPresented: $isNoResult){
                Alert(title:Text("No Result"))
            }
            .navigationBarTitle("Movies")
    
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView()
    }
}

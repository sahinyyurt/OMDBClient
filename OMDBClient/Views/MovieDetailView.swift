//
//  MovieDetailView.swift
//  OMDBClient
//
//  Created by Sahin Yesilyurt on 16.06.2020.
//  Copyright © 2020 sahiny. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieDetailView: View {
    let id:String
    let title:String
    @State private var isLoading = true;
    @State private var movieDetail:MovieDetail?;
    var body: some View {
        OmdbApiService.getMovie(self.id){ movie in
            if let movieDetail = movie {
                self.movieDetail = movieDetail
            } else {
               print("Movie Not Found")
            }
            self.isLoading = false;
        }
        return ZStack {
            ActivityIndicator(isAnimating: isLoading).zIndex(1)
            VStack {
                ScrollView(.vertical, showsIndicators: true) {
                    if self.movieDetail != nil {
                        PosterView(image: self.movieDetail!.poster)
                        TitleView(title: self.movieDetail!.title)
                        FilmInfoView(duration: self.movieDetail!.runtime, genre: self.movieDetail!.genre, release: self.movieDetail!.released)
                        RatingsView(rating: self.movieDetail!.imdbRating)
                        PlotView(plot: self.movieDetail!.plot)
                    } else {
                        
                    }
                   
                }
            }.onAppear {
                FirebaseService.sendMovieAnalytics(id:self.id, name:self.title)
            }
        }
        .navigationBarTitle(Text(title))
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(id:"1",title:"Movie Detail")
    }
}


struct PosterView: View {
    let image:String
    var body: some View {
        WebImage(url: URL(string: image))
            .renderingMode(.original)
            .resizable()
        .placeholder(Image(systemName: "questionmark.video.fill"))
            .aspectRatio(contentMode: .fit)
            .cornerRadius(12)
            .padding()
    }
}


struct TitleView: View {
    let title:String
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.heavy)
                .padding(.leading)
            
            Spacer()
        }
    }
}

struct FilmInfoView: View {
    let duration:String
    let genre:String
    let release:String
    var body: some View {
        HStack {
            Text("\(duration) | \(genre) | \(release)")
                .foregroundColor(.secondary)
                .padding(.leading)
            Spacer()
        }
    }
}

struct RatingsView: View {
    let rating:String
    var body: some View {
        let ratingNumber = Float(rating) ?? 0
        let unfillStar = 10 - Int(ratingNumber)
        return HStack {
            ForEach(0 ..< Int(ratingNumber)) { item in
                Image(systemName: "star.fill")
            }
            if(ratingNumber.truncatingRemainder(dividingBy: 1) > 0.5) {
                Image(systemName: "star.lefthalf.fill")
            }
            
            ForEach(0 ..< unfillStar) { item in
                Image(systemName: "star")
            }
            
            Text("(\(rating))")
                .bold()
            .font(.system(size: 14))
        }
        .foregroundColor(.yellow)
    }
}

struct PlotView: View {
    let plot:String
    var body: some View {
        VStack {
            HStack {
                Text("Storyline")
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.bottom)
            
            Text(plot)
        }
        .padding()
    }
}


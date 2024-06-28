//
//  ContentView.swift
//  Github API
//
//  Created by Andrew Betancourt on 6/15/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = GithubModel()
    @Binding var user: GithubUser?
    @Binding var loginSuccsess: Bool
    @Binding var search: String
    
    var body: some View
    {
        if loginSuccsess
        {
            VStack(spacing: 20)
            {
                AsyncImage(url: URL(string: user?.avatarUrl ?? "")){ image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                    
                } placeholder: {
                    Circle()
                        .foregroundStyle(.gray)
                }
                .frame(width: 120)
                Text(user?.login ?? "Login Placeholder")
                    .bold()
                    .font(.title)
                
                VStack {
                    Text("Followers: \(user?.followers ?? -1)")
                    Text("Following: \(user?.following ?? -1)")
                }
                .font(.callout)
                
                Text(user?.bio ?? "Bio Placeholder")
                    .padding()
                
                HStack {
                    Group{
                        ZStack {
                            Rectangle()
                                .frame(width: 150, height: 50)
                                .foregroundStyle(.black)
                                .cornerRadius(10)
                            Text("Public Repos: \(user?.publicRepos ?? -1)")
                                .foregroundStyle(.white)
                            
                        }
                        ZStack {
                            Rectangle()
                                .frame(width: 150, height: 50)
                                .foregroundStyle(.black)
                                .cornerRadius(10)
                            Text("Public Gists: \(user?.publicGists ?? -1)")
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(.horizontal, 5)
                }
                
                if user!.publicRepos > 0 {
                    RepositoryListView(viewModel: viewModel, user: $user, search: $search)
                }
                else {
                    Text("No Repositories Available")
                        .fontWeight(.heavy)
                        .font(.largeTitle)
                }
                Spacer()
            }
            .onTapGesture {
                self.endTextEditing()
            }
        }
        else {
            LoginView(prompt: "")
        }
    }
}

#Preview {
    ContentView(user: .constant(.none), loginSuccsess: .constant(true), search: .constant(""))
}

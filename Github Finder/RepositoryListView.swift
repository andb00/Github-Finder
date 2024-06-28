//
//  RepositoryListView.swift
//  Github API
//
//  Created by Andrew Betancourt on 6/23/24.
//

import SwiftUI

struct RepositoryListView: View {
    
    @ObservedObject var viewModel = GithubModel()
    @Binding var user: GithubUser?
    @Binding var search: String
    
    var body: some View {
        ZStack{
            
            if user!.repos!.filter({$0.name.localizedCaseInsensitiveContains(search)}).count == 0 && search != ""{
                Text("No results")
                    .padding(.top)
            }
            List{
                ForEach(search != "" ? user!.repos!.filter({$0.name.localizedCaseInsensitiveContains(search)}) :
                            user!.repos!, id: \.self) { repository in
                    
                    RepositoryBarView(name: repository.name)
                        .listRowSeparator(.hidden)
                        .padding(.bottom, 7)
                        .onAppear() {
                            if repository.id == user!.repos!.last?.id && user?.repos!.count != user?.publicRepos{
                                Task{
                                    do{
                                        user!.repos?.append( contentsOf: try await viewModel.getRepo(username: user!.login))
                                    }catch{
                                        throw GHError.invalidData
                                    }
                                }
                            }
                        }
                }
            }
            .scrollContentBackground(.hidden)
        }
        .onTapGesture {
            self.endTextEditing()
        }
    }
}

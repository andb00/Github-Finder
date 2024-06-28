//
//  LoginView.swift
//  Github API
//
//  Created by Andrew Betancourt on 6/16/24.
//

import SwiftUI

struct LoginView: View {
    
    @State var prompt: String
    @State private var user: GithubUser?
    @State private var loginSuccsess = false
    @State private var showAlert = false
    @State private var ctr = 0
    @State private var ctr2 = 0
    @State private var isHidden = true
    @State private var searchShowing = false
    @State private var viewingContent = false

    @Namespace private var titleAnimation
    @Namespace private var usernameAnimation
    
    @ObservedObject var viewModel = GithubModel()
    
    var body: some View {
    
        if !loginSuccsess{
            ZStack
            {
                Rectangle()
                    .foregroundStyle(.white)
                
                VStack
                {
                    Spacer()
                    
                    Text("GitHub Finder")
                        .font(.title)
                        .bold()
                        .matchedGeometryEffect(id: "Title", in: titleAnimation)
                    
                    ZStack(){
                        Rectangle()
                            .frame(width: 150, height: 50)
                            .foregroundStyle(.black)
                            .cornerRadius(10)
                        
                        if prompt.isEmpty{
                            Text("Username")
                                .foregroundStyle(.white)
                                .opacity(0.8)
                        }
                        
                        TextField("", text: $prompt)
                            .multilineTextAlignment(.center)
                            .frame(width: 150)
                            .foregroundStyle(.white)
                            .textInputAutocapitalization(.never)
                            .onSubmit() {
                                Task {
                                    do {
                                        user = try await viewModel.getUser(username: prompt)
                                        
                                    } catch GHError.invalidURL{
                                        print("Invalid URL")
                                        viewModel.reset()
                                        return
                                        
                                    } catch GHError.invalidResponse{
                                        print("invalid response")
                                        showAlert = true
                                        viewModel.reset()
                                        return
                                        
                                    } catch GHError.invalidData{
                                        print("invalid data")
                                        showAlert = true
                                        viewModel.reset()
                                        return
                                        
                                    } catch GHError.invalidRepo{
                                        print("invalid repo")
                                        viewModel.reset()
                                        return
                                        
                                    } catch{
                                        print("unexpected error")
                                        viewModel.reset()
                                        return
                                    }
                                    withAnimation(.smooth){
                                        loginSuccsess.toggle()
                                        prompt = ""
                                    }
                                }
                            }
                            .alert("User not found", isPresented: $showAlert){} message: {
                                Text("Could not find user. Make sure you typed in correctly and try again.")
                            }
                    }
                    .matchedGeometryEffect(id: "user", in: usernameAnimation)
                    
                    Spacer()
                }
                .ignoresSafeArea(.keyboard)
            }
            .onTapGesture {
                self.endTextEditing()
            }
        }
        else {
            
            if searchShowing {

                RepositoryListView(viewModel: viewModel, user: $user, search: $prompt)
            }
            else{
                Text("GitHub Finder")
                    .font(.title)
                    .bold()
                    .matchedGeometryEffect(id: "Title", in: titleAnimation)
                
                ContentView(viewModel: viewModel, user: $user, loginSuccsess: $loginSuccsess, search: $prompt)
                    .transition(.asymmetric(insertion: .opacity.animation(.default.delay(0.5)), removal: .opacity ))
            }
            
            // Bottom NavBar
            
            HStack(){
                ZStack{
                    Circle()
                        .frame(width: 50)
                    Button{
                        if !searchShowing {
                            withAnimation(.smooth){
                                loginSuccsess.toggle()
                                isHidden.toggle()
                                viewingContent.toggle()
                            }
                            viewModel.reset()
                            user?.repos?.removeAll()
                                
                        }
                        else{
                            ctr2 += 1
                            searchShowing.toggle()
                            self.endTextEditing()
                        }
                    }label: {
                        if !searchShowing && !viewingContent{
                            Image(systemName: "arrowshape.left.circle.fill")
                                .foregroundStyle(.white)
                                .symbolEffect(.appear, isActive: isHidden)
                                .onAppear(){
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { isHidden.toggle() }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) { viewingContent =  true }
                                }
                        }
                        else{
                            Image(systemName: "arrowshape.left.circle.fill")
                                .foregroundStyle(.white)
                                .symbolEffect(.bounce.down.byLayer, value: ctr2)

                        }
                    }
                }
                .padding(.trailing)
                .disabled(!searchShowing ? false : isHidden)
                
                ZStack{
                    Rectangle()
                        .frame(width: 150, height: 50)
                        .foregroundStyle(.black)
                        .cornerRadius(10)
                    
                    ZStack{
                        if prompt.isEmpty{
                            Label("Search", systemImage: "magnifyingglass")
                                .foregroundStyle(.white)
                                .bold()
                                .italic()
                        }
                        
                        TextField("", text: $prompt)
                            .multilineTextAlignment(.center)
                            .frame(width: 150)
                            .foregroundStyle(.white)
                            .textInputAutocapitalization(.never)
                            .onTapGesture { searchShowing = true }
                    }
                }
                .matchedGeometryEffect(id: "user", in: usernameAnimation)
                
                ZStack{
                    Circle()
                        .frame(width: 50)
                    Button{
                        ctr += 1
                    }label: {
                        Image(systemName: "plus.square.fill")
                            .foregroundStyle(.white)
                            .symbolEffect(.bounce.down.byLayer, value: ctr)
                            .symbolEffect(.appear, isActive: isHidden)
                    }
                }
                .padding(.leading)
                .disabled(isHidden)
            }
       }
    }
}

//Extension to View that allows user to dismiss keyboard by touching background
extension View {
  func endTextEditing() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                    to: nil, from: nil, for: nil)
  }
}

#Preview {
    LoginView(prompt: "")
}

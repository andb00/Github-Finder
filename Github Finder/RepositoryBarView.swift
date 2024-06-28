//
//  RepositoryBarView.swift
//  Github API
//
//  Created by Andrew Betancourt on 6/22/24.
//

import SwiftUI

struct RepositoryBarView: View {
    @State var name: String
    var body: some View {
        VStack{
            ZStack{
                Rectangle()
                    .frame(width: 350, height: 30)
                    .cornerRadius(10)

                Text("\(name)")
                    .foregroundStyle(.white)
                    .fontWeight(.heavy)
                    .font(.system(.body, design: .monospaced))
                    .frame(maxWidth: 350,maxHeight: 10)
            }
        }
    }
}

#Preview {
    RepositoryBarView(name: "Hello World!")
}

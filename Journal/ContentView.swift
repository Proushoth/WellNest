//
//  ContentView.swift
//  Journal
//
//  Created by proushoth koushal on 8/19/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            homePage()
                .tabItem(){
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            journalPage()
                .tabItem(){
                    Image(systemName: "book.fill")
                    Text("Journal")
                }
            habitsPage()
                .tabItem(){
                    Image(systemName: "checklist")
                    Text("Habits")
                }
            goalsPage()
                .tabItem(){
                    Image(systemName: "scope")
                    Text("Goals")
                }
           progressPage()
                .tabItem(){
                    Image(systemName: "chart.bar")
                    Text("Progress")
                }
        }

    }
}

#Preview {
    ContentView()
}

//
//  ContentView.swift
//  Classroom
//
//  Created by Stefania Zinno 
//

import SwiftUI

struct LearnerList: View {
    
    @State private var showingSheet = false
    @StateObject var learnerStore = LearnerStore()
    
    var body: some View {
        NavigationView{
            if self.learnerStore.fetching {
                ProgressView("Loading...")
            }else{
                List {
                    ForEach(learnerStore.learners) { learner in
                        NavigationLink(destination: PresentMeView(learner: learner, learnerStore: learnerStore )) {
                            HStack {
                                Image(learner.imageName)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                Text("\(learner.name) \(learner.surname)")
                                Spacer()
                            }
                        }
                    }
                    .onDelete(perform: delete)
                }
                .task {
                    await learnerStore.getAllLearners()
                }
                .refreshable {
                    await learnerStore.getAllLearners()
                }
                
                .navigationTitle("Learners")
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingSheet.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showingSheet) {
                    CreateLearnerView(learnerStore: learnerStore)
                }
            }
            
        }.navigationViewStyle(.stack)
    }
    
    func delete(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let idToRemove = learnerStore.learners[index].id
        learnerStore.learners.remove(atOffsets: offsets)
        Task{
            await learnerStore.remove(with: idToRemove)
        }
        
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LearnerList()
    }
}

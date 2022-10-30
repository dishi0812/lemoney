import SwiftUI

struct HomeView: View {
    
    @Binding var categories: [Category]
    @Binding var budgetGoal: Double
    @Binding var savingsGoal: Double
    @Binding var balance: Double
    var totalSpendings: Double {
        categories.reduce(0) { $0 + $1.spendings }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    
                    VStack(alignment: .leading) {
                        Text("Budget")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.leading, 10)
                            .padding(.bottom, -5)
                            .padding(.top, 8)
                        
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color(.systemGray5))
                                .frame(width: 350, height: 35)
                                .cornerRadius(20)
                                .padding(.bottom, 10)
                            Rectangle()
                                .fill(.green)
                                .frame(width: 140, height: 35)
                                .cornerRadius(20)
                                .padding(.bottom, 10)
                        }
                    }
                    .padding(.bottom, -25)
                    
                    HStack {
                        NavigationLink {
                            // budget / goal setting view
                        } label: {
                            HStack {
                                Image(systemName: "dollarsign.arrow.circlepath")
                                    .font(.system(size: 35))
                                    .padding(.trailing, -3)
                                    .padding(.leading, -5)
                                
                                VStack {
                                    Text("$\(String(format: "%.2f", budgetGoal - totalSpendings))").fontWeight(.bold)
                                    Text("Savings").fontWeight(.semibold)
                                }
                                
                                Image(systemName: "chevron.right")
                                    .font(.title3)
                                    .foregroundColor(Color(.systemGray3))
                            }
                            .padding(15)
                        }
                        .padding(.vertical, 11)
                        .background(.white)
                        .cornerRadius(15)
                        
                        Spacer()
                        
                        NavigationLink {
                            // overall spendings view
                        } label: {
                            HStack {
                                ZStack {
                                    Image(systemName: "dollarsign.circle")
                                        .font(.system(size: 35))
                                        .padding(.trailing, -3)
                                        .padding(.leading, -5)
                                    
                                    Image(systemName: "arrow.down")
                                        .font(.system(size: 25))
                                        .fontWeight(.bold)
                                        .padding(.top, 20)
                                        .padding(.leading, 15)
                                        .padding(.trailing, -3)
                                }
                                
                                VStack {
                                    Text("$\(String(format: "%.2f", totalSpendings)) / $\(String(format: "%.2f", budgetGoal))").fontWeight(.bold)
                                    Text("Spent").fontWeight(.semibold)
                                }
                                
                                Image(systemName: "chevron.right")
                                    .font(.title3)
                                    .foregroundColor(Color(.systemGray3))
                            }
                            .padding(15)
                        }
                        .background(.white)
                        .cornerRadius(15)
                        
                    }
                    .padding(20)
                    Spacer()
                    
                    List {
                        Section {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Premium Soy Sauce")
                                    Spacer()
                                    Text("$123.00")
                                }
                                .fontWeight(.semibold)
                                
                                HStack {
                                    Text("2 Nov 2022")
                                    Spacer()
                                    Text("Food")
                                }
                                .fontWeight(.light)
                            }
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Premium Sidewalk")
                                    Spacer()
                                    Text("$280.00")
                                }
                                .fontWeight(.semibold)
                                
                                HStack {
                                    Text("13 Nov 2022")
                                    Spacer()
                                    Text("Transport")
                                }
                                .fontWeight(.light)
                            }
                        } header: {
                            Text("Remember to Buy")
                                .font(.title3)
                                .textCase(.none)
                                .fontWeight(.bold)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                
                            } label: {
                                Image(systemName: "checkmark")
                            }
                            .tint(.green)
                        }
                        
                        Section {
                            VStack {
                                HStack {
                                    Text("Draconic Keychain")
                                    Spacer()
                                    Text("$50.00")
                                }
                                .fontWeight(.semibold)
                                .padding(.top, 10)

                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .fill(Color(.systemGray5))
                                        .frame(width: 310)
                                        .cornerRadius(20)
                                        .padding(.bottom, 10)
                                    Rectangle()
                                        .fill(.green)
                                        .frame(width: 120)
                                        .cornerRadius(20)
                                        .padding(.bottom, 10)
                                }
                            }
                        } header: {
                            Text("Wants")
                                .font(.title3)
                                .textCase(.none)
                                .fontWeight(.bold)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                
                            } label: {
                                Image(systemName: "checkmark")
                            }
                            .tint(.green)
                        }
                        
                    }
                    
                }
                .foregroundColor(.black)
                .navigationTitle("Home")
            }
        }
    }
}


import SwiftUI

struct HomeView: View {
    
    @Binding var income: Double
    @Binding var categories: [Category]
    @Binding var budgetGoal: Double
    @Binding var savingsGoal: Double
    @Binding var balance: Double
    var totalSpendings: Double {
        categories.reduce(0) { $0 + $1.spendings }
    }
    var savings: Double {
        income - totalSpendings
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    // budget progress bar
                    VStack(alignment: .leading) {
                        Text("BUDGET")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .opacity(0.45)
                            .padding(.leading, 6)
                            .padding(.bottom, -7)
                            .padding(.top, 8)
                        
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color(.systemGray5))
                                .frame(width: 350, height: 25)
                                .cornerRadius(13)
                                .padding(.bottom, 10)
                            Rectangle()
                                .fill(.green)
                                .frame(width: 350 - (totalSpendings/budgetGoal*350) < 0 ? 0 : 350 - (totalSpendings/budgetGoal*350), height: 25)
                                .cornerRadius(13)
                                .padding(.bottom, 10)
                        }
                    }
                    .padding(.bottom, -25)
                    .padding(.top, -12)
                    
                    // navigation links
                    HStack {
                        Spacer()
                        
                        NavigationLink {
                            // budget / goal setting view
                        } label: {
                            HStack {
                                Image(systemName: "dollarsign.arrow.circlepath")
                                    .font(.title)
                                    .padding(.trailing, -3)
                                    .padding(.leading, -5)
                                
                                VStack {
                                    Text("$\(String(format: "%.2f", savings))").fontWeight(.bold)
                                    Text("Savings").fontWeight(.semibold)
                                }
                                
                                Image(systemName: "chevron.right")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color(.systemGray3))
                            }
                            .padding(10)
                        }
                        .background(.white)
                        .cornerRadius(15)
                        
                        Spacer()
                        
                        NavigationLink {
                            // overall spendings view
                        } label: {
                            HStack {
                                ZStack {
                                    Image(systemName: "dollarsign.circle")
                                        .font(.title)
                                        .padding(.trailing, -3)
                                        .padding(.leading, -5)
                                    
                                    Image(systemName: "arrow.down")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .padding(.top, 20)
                                        .padding(.leading, 15)
                                        .padding(.trailing, -3)
                                }
                                
                                VStack {
                                    Text("$\(String(format: "%.2f", totalSpendings))").fontWeight(.bold)
                                    Text("Spent").fontWeight(.semibold)
                                }
                                
                                Image(systemName: "chevron.right")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color(.systemGray3))
                            }
                            .padding(10)
                        }
                        .background(.white)
                        .cornerRadius(15)
                        
                        Spacer()
                    }
                    .padding(15)
                    
                    
                    // wishlist
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

                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .fill(Color(.systemGray5))
                                        .frame(width: 325, height: 18)
                                        .cornerRadius(20)
                                    Rectangle()
                                        .fill(.green)
                                        .frame(width: (balance-income+totalSpendings)/50 * 350 <= 350 ? (balance-income+totalSpendings)/50 * 350 : 350, height: 18)
                                        .cornerRadius(20)
                                }
                                .padding(.top, -7)
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
                    .padding(.top, -15)
                }
                .foregroundColor(.black)
                .navigationTitle("Home")
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Balance: $\(String(format: "%.2f", balance))")
                        .font(.title3)
                        .padding(.top, 10)
                        .fontWeight(.bold)
                }
            }
        }
    }
}


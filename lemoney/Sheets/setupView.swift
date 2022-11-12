import SwiftUI

extension AnyTransition {
    static var backslide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading))}
}

struct SetupView: View {
    @Binding var categories: [Category]
    @Binding var income: Double
    @Binding var balance: Double
    @State var budget = 1600.00
    @Binding var savings: Double
    @State var pageNum = 0
    
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        if(pageNum == 1) {
            NavigationView {
                ZStack {
                    Color(.systemGray6)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        VStack {
                            HStack {
                                Text("Monthly Income")
                                    .fontWeight(.medium)
                                
                                Spacer()
                                HStack {
                                    TextField("", value: $income, formatter: CurrencyFormatter())
                                        .padding(.leading, 3)
                                }
                                .frame(width: 93, height: 30)
                                .background(Color(.systemGray6))
                                .fontWeight(.bold)
                                .cornerRadius(8)
                            }
                            
                            HStack {
                                Text("Current Balance")
                                    .fontWeight(.medium)
                                
                                Spacer()
                                HStack {
                                    TextField("", value: $balance, formatter: CurrencyFormatter())
                                        .padding(.leading, 3)
                                }
                                .frame(width: 93, height: 30)
                                .background(Color(.systemGray6))
                                .fontWeight(.bold)
                                .cornerRadius(8)
                            }
                            
                            
                            HStack {
                                Text("Savings Goal")
                                    .fontWeight(.medium)
                                
                                Spacer()
                                HStack {
                                    TextField("", value: $savings, formatter: CurrencyFormatter())
                                        .onChange(of: savings) { val in
                                            budget = income - savings
                                        }
                                        .onChange(of: income) { val in
                                            savings = val / Double(categories.count)
                                            budget = income - savings
                                        }
                                        .padding(.leading, 3)
                                }
                                .frame(width: 93, height: 30)
                                .background(Color(.systemGray6))
                                .fontWeight(.bold)
                                .cornerRadius(8)
                            }
                            
                        }
                        .padding(12)
                        .background(.white)
                        .cornerRadius(12)
                        
                        
                        VStack {
                            VStack {
                                HStack {
                                    Text("Budget").fontWeight(.bold)
                                    Spacer()
                                    Text("$\(String(format: "%.2f", budget))")
                                        .fontWeight(.black)
                                }
                                .padding(.bottom, 8)
                                ForEach($categories) { $category in
                                    HStack {
                                        Text("\(category.name)")
                                            .fontWeight(.medium)
                                        
                                        Spacer()
                                        HStack {
                                            TextField("", value: $category.budget, formatter: CurrencyFormatter())
                                                .onChange(of: budget) { value in
                                                    category.budget = Double(value)/5.0
                                                }
                                                .padding(.horizontal, 4)
                                        }
                                        .frame(width: 93, height: 30)
                                        .background(Color(.systemGray6))
                                        .fontWeight(.bold)
                                        .cornerRadius(8)
                                    }
                                }
                            }
                            .padding(12)
                            .background(.white)
                            .cornerRadius(12)
                        }
                        .padding(.top, 40)
                        
                        
                        Spacer()
                        Button {
                            if (income > 0.0 && balance > 0.0 && savings > 0.0 && budget > 0.0) {
                                dismiss()
                            }
                        } label: {
                            Text("Start saving money!")
                                .padding(12)
                                .background(.green)
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .font(.title3)
                                .cornerRadius(12)
                        }
                    }
                    .navigationTitle("Setup")
                    .padding(15)
                    .padding(.bottom, 30)
                }
            }
            .interactiveDismissDisabled()
            .transition(.backslide.combined(with: .opacity))

        } else {
            NavigationView {
                VStack {
                    Image("Logo").resizable().clipShape(Circle()).padding().frame(width: 256, height: 256)
                    Text("To Lemoney, an app bountiful of features helping people manage their finances. Never will you, with Lemoney, ever:\n\n• Have to sell a kidney\n• Declare bankruptcy\n• Forget what to buy").padding()
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            pageNum += 1
                        }
                    } label: {
                        Text("Setup")
                            .padding(12)
                            .background(.green)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .font(.title3)
                            .cornerRadius(12)
                    }
                    .padding(.bottom, 30)
                }.navigationTitle("Welcome")
            }
            .interactiveDismissDisabled()
            .transition(.backslide.combined(with: .opacity))
        }
    }
}

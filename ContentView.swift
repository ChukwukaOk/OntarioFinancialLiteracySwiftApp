import SwiftUI

struct ContentView: View {
    @State private var showingQuiz = false
    @State private var selectedSet = 1
    @State private var hasPassedBasicLevel = false
    
    var body: some View {
        if showingQuiz {
            QuizView(questionSet: selectedSet,
                    hasPassedBasicLevel: $hasPassedBasicLevel)
                .onDisappear {
                    selectedSet = 1
                }
        } else {
            WelcomeView(showingQuiz: $showingQuiz,
                       selectedSet: $selectedSet,
                       hasPassedBasicLevel: $hasPassedBasicLevel)
        }
    }
}

struct WelcomeView: View {
    @Binding var showingQuiz: Bool
    @Binding var selectedSet: Int
    @Binding var hasPassedBasicLevel: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 35) {
                // Title Section
                VStack(spacing: 15) {
                    Text("Financial")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.blue)
                    Text("Literacy Quiz")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.blue)
                }
                .padding(.top, 50)
                
                // Question Set Selection
                VStack(spacing: 20) {
                    Text("Select Question Set")
                        .font(.title2)
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 20) {
                        QuestionSetButton(
                            title: "Set 1",
                            subtitle: "Basic Finance",
                            isSelected: selectedSet == 1,
                            action: { selectedSet = 1 }
                        )
                        
                        QuestionSetButton(
                            title: "Set 2",
                            subtitle: "Advanced Finance",
                            isSelected: selectedSet == 2,
                            isDisabled: !hasPassedBasicLevel,
                            action: {
                                if hasPassedBasicLevel {
                                    selectedSet = 2
                                }
                            }
                        )
                    }
                    .padding(.horizontal)
                }
                
                // Creators Section
                VStack(spacing: 25) {
                    Text("Created By")
                        .font(.title2)
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 40) {
                        CreatorLink(
                            name: "Talha Inam",
                            url: "https://www.linkedin.com/in/talha-inam-4826b230b/"
                        )
                        
                        CreatorLink(
                            name: "Chukwuka O",
                            url: "https://www.linkedin.com/in/chukwukao"
                        )
                    }
                }
                
                if !hasPassedBasicLevel && selectedSet == 2 {
                    Text("Complete Basic Level with 70% or higher to unlock Advanced")
                        .font(.callout)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()
                
                // Start Button
                Button(action: {
                    if selectedSet == 1 || hasPassedBasicLevel {
                        showingQuiz = true
                    }
                }) {
                    HStack(spacing: 15) {
                        Text("Start Quiz")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title2)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .blue.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(15)
                    .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
                .disabled(selectedSet == 2 && !hasPassedBasicLevel)
            }
        }
    }
}

struct QuestionSetButton: View {
    let title: String
    let subtitle: String
    let isSelected: Bool
    let isDisabled: Bool
    let action: () -> Void
    
    init(title: String, subtitle: String, isSelected: Bool, isDisabled: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.subtitle = subtitle
        self.isSelected = isSelected
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                if isDisabled {
                    Text("Pass Basic Level First")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isDisabled ? Color.gray.opacity(0.1) : (isSelected ? Color.blue.opacity(0.1) : Color.white))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isDisabled ? Color.gray : (isSelected ? Color.blue : Color.gray.opacity(0.3)), lineWidth: 2)
                    )
            )
            .shadow(color: .gray.opacity(0.1), radius: 5)
        }
        .disabled(isDisabled)
        .foregroundColor(isDisabled ? .gray : (isSelected ? .blue : .primary))
    }
}

struct CreatorLink: View {
    let name: String
    let url: String
    
    var body: some View {
        Link(destination: URL(string: url)!) {
            VStack(spacing: 12) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 44))
                    .foregroundColor(.blue)
                    .shadow(color: .blue.opacity(0.2), radius: 5)
                
                Text(name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                
                Image(systemName: "link.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.blue.opacity(0.8))
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: .gray.opacity(0.2), radius: 8)
            )
        }
    }
}

struct QuizView: View {
    struct Question: Identifiable {
        let id = UUID()
        let title: String
        let options: [String]
        let answer: String
    }
    
    // State variables
    @State private var currentQuestionIndex = 0
    @State private var score = 0
    @State private var showingScore = false
    @State private var selectedAnswer = ""
    @State private var showingCorrectAnswer = false
    @State private var questions: [Question] = []
    @State private var currentSet: Int
    @Binding var hasPassedBasicLevel: Bool
    let questionSet: Int
    
    init(questionSet: Int, hasPassedBasicLevel: Binding<Bool>) {
        self.questionSet = questionSet
        self._currentSet = State(initialValue: questionSet)
        self._hasPassedBasicLevel = hasPassedBasicLevel
        _questions = State(initialValue: questionSet == 1 ? Self.set1Questions : Self.set2Questions)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if showingScore {
                    scoreView
                } else {
                    quizContent
                }
            }
            .navigationTitle(currentSet == 1 ? "Basic Finance Quiz" : "Advanced Finance Quiz")
            .onAppear {
                questions.shuffle()
            }
        }
    }
    
    private var scoreView: some View {
        VStack {
            Text("Quiz Complete!")
                .font(.title)
                .padding()
            
            Text("Your score: \(score) out of \(questions.count)")
                .font(.headline)
            
            let percentageScore = Double(score) / Double(questions.count) * 100
            Text("Percentage: \(Int(percentageScore))%")
                .font(.title2)
                .foregroundColor(percentageScore >= 70 ? .green : .red)
                .padding(.top, 5)
            
            Text("Quiz Level: \(currentSet == 1 ? "Basic" : "Advanced")")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top, 5)
            
            if currentSet == 1 {
                if percentageScore >= 70 {
                    Text("🎉 Congratulations! You've unlocked the Advanced Level!")
                        .foregroundColor(.green)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    Text("You need 70% to unlock the Advanced Level")
                        .foregroundColor(.red)
                        .padding()
                }
            }
            
            VStack(spacing: 15) {
                Button("Restart Same Level") {
                    restartSameLevel()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                if currentSet == 1 && percentageScore >= 70 {
                    Button("Try Advanced Level") {
                        hasPassedBasicLevel = true
                        switchLevel()
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                } else if currentSet == 2 {
                    Button("Try Basic Level") {
                        switchLevel()
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding(.top, 20)
        }
    }
    
    private var quizContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            ProgressView(value: Double(currentQuestionIndex + 1), total: Double(questions.count))
                .padding()
            
            Text("Question \(currentQuestionIndex + 1) of \(questions.count)")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(questions[currentQuestionIndex].title)
                        .font(.title2)
                        .padding()
                    
                    ForEach(questions[currentQuestionIndex].options, id: \.self) { option in
                        Button(action: {
                            selectAnswer(option)
                        }) {
                            Text(option)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(backgroundColor(for: option))
                                .foregroundColor(foregroundColor(for: option))
                                .cornerRadius(10)
                        }
                        .disabled(showingCorrectAnswer)
                    }
                }
                .padding()
            }
            
            if showingCorrectAnswer || !selectedAnswer.isEmpty {
                Button(showingCorrectAnswer ? "Next Question" : "Submit Answer") {
                    if showingCorrectAnswer {
                        nextQuestion()
                    } else {
                        showingCorrectAnswer = true
                        if selectedAnswer == questions[currentQuestionIndex].answer {
                            score += 1
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
            }
        }
    }
    
    private func backgroundColor(for option: String) -> Color {
        if !showingCorrectAnswer {
            return selectedAnswer == option ? .blue : .gray.opacity(0.2)
        } else {
            if option == questions[currentQuestionIndex].answer {
                return .green
            } else if option == selectedAnswer {
                return .red
            } else {
                return .gray.opacity(0.2)
            }
        }
    }
    
    private func foregroundColor(for option: String) -> Color {
        if !showingCorrectAnswer {
            return selectedAnswer == option ? .white : .primary
        } else {
            if option == questions[currentQuestionIndex].answer || option == selectedAnswer {
                return .white
            } else {
                return .primary
            }
        }
    }
    
    private func selectAnswer(_ answer: String) {
        if !showingCorrectAnswer {
            selectedAnswer = answer
        }
    }
    
    private func nextQuestion() {
        if currentQuestionIndex + 1 < questions.count {
            currentQuestionIndex += 1
            selectedAnswer = ""
            showingCorrectAnswer = false
        } else {
            showingScore = true
            if currentSet == 1 {
                let percentageScore = Double(score) / Double(questions.count) * 100
                if percentageScore >= 70 {
                    hasPassedBasicLevel = true
                }
            }
        }
    }
    
    private func restartSameLevel() {
        questions = currentSet == 1 ? Self.set1Questions : Self.set2Questions
        resetQuizState()
    }
    
    private func switchLevel() {
        currentSet = currentSet == 1 ? 2 : 1
        questions = currentSet == 1 ? Self.set1Questions : Self.set2Questions
        resetQuizState()
    }
    
    private func resetQuizState() {
        questions.shuffle()
        currentQuestionIndex = 0
        score = 0
        selectedAnswer = ""
        showingCorrectAnswer = false
        showingScore = false
    }
    
    // Basic questions (Set 1)
    static let set1Questions: [Question] = [
        Question(title: "What does phishing refer to in the context of financial fraud?", options: [
            "A. A secure method of transferring money online",
            "B. Fraudulent attempts to obtain sensitive information by pretending to be a trusted entity",
            "C. A type of bank transaction",
            "D. A legal way to share personal data"
        ], answer: "B. Fraudulent attempts to obtain sensitive information by pretending to be a trusted entity"),
        
        Question(title: "What is the safest way to use your credit card online?", options: [
            "A. Enter your details on any website",
            "B. Use a secure, encrypted website with \"https://\" in the URL",
            "C. Share your details over email if requested",
            "D. Avoid using credit cards online altogether"
        ], answer: "B. Use a secure, encrypted website with \"https://\" in the URL"),
        
        Question(title: "What does two-factor authentication (2FA) enhance?", options: [
            "A. Ease of accessing accounts",
            "B. Security by requiring a second form of verification",
            "C. Simplicity of password management",
            "D. Speed of logging into accounts"
        ], answer: "B. Security by requiring a second form of verification"),
        
        Question(title: "Which of the following is a common sign of identity theft?", options: [
            "A. Receiving promotional emails from a company",
            "B. Unfamiliar charges on your bank or credit card statement",
            "C. Receiving a new credit card you requested",
            "D. A sudden increase in your credit score"
        ], answer: "B. Unfamiliar charges on your bank or credit card statement"),
        
        Question(title: "If you receive an email from a bank asking for your account details, you should", options: [
            "A. Reply immediately to verify your account",
            "B. Click on the provided link to enter your information",
            "C. Avoid responding and contact your bank directly using official contact details",
            "D. Forward the email to your friends for their opinion"
        ], answer: "C. Avoid responding and contact your bank directly using official contact details"),
        
        Question(title: "What does the concept of compound interest refer to?", options: [
            "A. Interest calculated on the initial principal only",
            "B. Interest calculated on the principal and previously accumulated interest",
            "C. Interest that decreases over time",
            "D. Interest paid only at the end of the investment term"
        ], answer: "B. Interest calculated on the principal and previously accumulated interest"),
        
        Question(title: "Which type of investment typically provides ownership in a company?", options: [
            "A. Bonds",
            "B. Mutual Funds",
            "C. Stocks",
            "D. ETFs"
        ], answer: "C. Stocks"),
        
        Question(title: "What does an ETF stand for?", options: [
            "A. Exchange-Traded Fund",
            "B. Equity Transfer Fund",
            "C. Earnings Transfer Facility",
            "D. Economic Trading Firm"
        ], answer: "A. Exchange-Traded Fund"),
        
        Question(title: "Which of the following describes a government bond?", options: [
            "A. A loan you give to the government in exchange for interest payments",
            "B. Ownership of a portion of a company",
            "C. A pool of investments managed by a professional",
            "D. A speculative stock purchase"
        ], answer: "A. A loan you give to the government in exchange for interest payments"),
        
        Question(title: "What is a mutual fund?", options: [
            "A. A single stock investment",
            "B. A collection of stocks and bonds managed by a professional",
            "C. A fixed deposit account",
            "D. An individual retirement account"
        ], answer: "B. A collection of stocks and bonds managed by a professional"),
        
        Question(title: "What is the primary benefit of diversification in investments?", options: [
            "A. It guarantees high returns",
            "B. It minimizes risk by spreading investments across different assets",
            "C. It ensures tax-free returns",
            "D. It allows you to own only one type of investment"
        ], answer: "B. It minimizes risk by spreading investments across different assets"),
        
        Question(title: "How is interest typically paid on a bond?", options: [
            "A. Annually or semi-annually",
            "B. Monthly",
            "C. Only at maturity",
            "D. Weekly"
        ], answer: "A. Annually or semi-annually"),
        
        Question(title: "What is the difference between a stock and a bond?", options: [
            "A. Stocks represent ownership; bonds represent debt",
            "B. Stocks are short-term investments; bonds are long-term investments",
            "C. Stocks provide fixed interest; bonds provide dividends",
            "D. There is no difference between the two"
        ], answer: "A. Stocks represent ownership; bonds represent debt"),
        
        Question(title: "What is the main advantage of investing in ETFs?", options: [
            "A. High management fees",
            "B. Diversification at a low cost",
            "C. Guaranteed returns",
            "D. Exclusive access to private companies"
        ], answer: "B. Diversification at a low cost"),
        
        Question(title: "Which of the following investments is the safest?", options: [
            "A. Government bonds",
            "B. Individual stocks",
            "C. Mutual funds",
            "D. Cryptocurrencies"
        ], answer: "A. Government bonds"),
        
        Question(title: "What does the time value of money mean in financial planning?", options: [
            "A. Money loses value over time due to inflation",
            "B. Money available now is worth more than the same amount in the future",
            "C. Future money always has more value than present money",
            "D. Money has no value over time"
        ], answer: "B. Money available now is worth more than the same amount in the future"),
        
        Question(title: "What is the main goal of financial independence?", options: [
            "A. To rely on a single income source",
            "B. To achieve a lifestyle not dependent on active work for income",
            "C. To maximize debt for investments",
            "D. To avoid saving money"
        ], answer: "B. To achieve a lifestyle not dependent on active work for income")
    ]
    // Advanced questions (Set 2)
    static let set2Questions: [Question] = [
        // Module 1: Introduction to Personal Finance
        Question(title: "What is the concept of 'opportunity cost' in personal finance?", options: [
            "A. The actual monetary cost of an item",
            "B. The value of the next best alternative given up when making a choice",
            "C. The cost of living in a particular area",
            "D. The interest rate on a savings account"
        ], answer: "B. The value of the next best alternative given up when making a choice"),
        
        Question(title: "What is the 'time value of money' principle?", options: [
            "A. Money is worth more at night than during the day",
            "B. Money available now is worth more than the same amount in the future due to earning potential",
            "C. Time is more valuable than money",
            "D. Money loses value over weekends"
        ], answer: "B. Money available now is worth more than the same amount in the future due to earning potential"),
        
        // Module 2: Budgeting and Saving
        Question(title: "What is the '50/30/20' budgeting rule?", options: [
            "A. Spend 50% on wants, 30% on needs, 20% on savings",
            "B. Spend 50% on needs, 30% on wants, 20% on savings",
            "C. Spend 50% on savings, 30% on needs, 20% on wants",
            "D. Spend 50% on investments, 30% on savings, 20% on needs"
        ], answer: "B. Spend 50% on needs, 30% on wants, 20% on savings"),
        
        Question(title: "What is 'lifestyle inflation'?", options: [
            "A. The general increase in prices over time",
            "B. Increasing living expenses as income increases",
            "C. The cost of luxury items",
            "D. The rate at which lifestyles change over time"
        ], answer: "B. Increasing living expenses as income increases"),
        
        // Module 3: Your Money: Today and Tomorrow
        Question(title: "What is the Rule of 72 used for?", options: [
            "A. Calculating tax deductions",
            "B. Estimating how long it takes for an investment to double",
            "C. Determining credit scores",
            "D. Computing mortgage payments"
        ], answer: "B. Estimating how long it takes for an investment to double"),
        
        Question(title: "What is 'dollar-cost averaging'?", options: [
            "A. Converting different currencies",
            "B. Investing a fixed amount regularly regardless of market conditions",
            "C. Calculating the average cost of dollars",
            "D. A method of pricing products"
        ], answer: "B. Investing a fixed amount regularly regardless of market conditions"),
        
        // Module 4: Understanding Debt and Borrowing
        Question(title: "What is the difference between secured and unsecured debt?", options: [
            "A. Secured debt has higher interest rates",
            "B. Secured debt is backed by collateral while unsecured isn't",
            "C. Unsecured debt is safer",
            "D. Secured debt doesn't require repayment"
        ], answer: "B. Secured debt is backed by collateral while unsecured isn't"),
        
        Question(title: "What is debt-to-income (DTI) ratio?", options: [
            "A. Total savings divided by income",
            "B. Monthly debt payments divided by monthly gross income",
            "C. Total assets divided by total debts",
            "D. Annual income divided by total debt"
        ], answer: "B. Monthly debt payments divided by monthly gross income"),
        
        // Module 5: The Art of Investing
        Question(title: "What is a 'bear market'?", options: [
            "A. A market where prices are rising",
            "B. A market where prices are falling by 20% or more",
            "C. A market dominated by small investors",
            "D. A market with high trading volume"
        ], answer: "B. A market where prices are falling by 20% or more"),
        
        Question(title: "What is 'beta' in investing?", options: [
            "A. The second version of an investment product",
            "B. A measure of volatility relative to the overall market",
            "C. The return on investment",
            "D. The interest rate on bonds"
        ], answer: "B. A measure of volatility relative to the overall market"),
        // Module 6: Retirement Planning
        Question(title: "What is the '4% rule' in retirement planning?", options: [
            "A. Saving 4% of your annual income",
            "B. A guideline suggesting you can withdraw 4% of retirement savings annually",
            "C. Getting 4% interest on retirement accounts",
            "D. Paying 4% in retirement fees"
        ], answer: "B. A guideline suggesting you can withdraw 4% of retirement savings annually"),
        
        Question(title: "What is a 'catch-up contribution'?", options: [
            "A. Extra payments to make up for missed bills",
            "B. Additional allowed retirement contributions for people age 50 and older",
            "C. A type of investment strategy",
            "D. A penalty payment for late contributions"
        ], answer: "B. Additional allowed retirement contributions for people age 50 and older"),
        
        // Module 7: Real Estate
        Question(title: "What is 'loan-to-value (LTV) ratio' in real estate?", options: [
            "A. The total value of a property",
            "B. The mortgage amount divided by the appraised property value",
            "C. The monthly mortgage payment amount",
            "D. The interest rate on a mortgage"
        ], answer: "B. The mortgage amount divided by the appraised property value"),
        
        Question(title: "What is 'real estate appreciation'?", options: [
            "A. The decrease in property value over time",
            "B. The increase in property value over time",
            "C. The cost of property maintenance",
            "D. The monthly mortgage payment"
        ], answer: "B. The increase in property value over time"),
        
        // Module 8: Behavioral Finance
        Question(title: "What is 'loss aversion' in behavioral finance?", options: [
            "A. The tendency to avoid all investments",
            "B. The psychological tendency to feel losses more strongly than equivalent gains",
            "C. The fear of making any financial decisions",
            "D. The preference for low-risk investments"
        ], answer: "B. The psychological tendency to feel losses more strongly than equivalent gains"),
        
        Question(title: "What is 'confirmation bias' in investing?", options: [
            "A. Getting confirmation from a financial advisor",
            "B. The tendency to seek information that confirms existing beliefs",
            "C. Double-checking investment decisions",
            "D. Verifying investment returns"
        ], answer: "B. The tendency to seek information that confirms existing beliefs"),
        
        // Bonus Module: Responsible Investing
        Question(title: "What does 'ESG investing' stand for?", options: [
            "A. Economic Savings Growth",
            "B. Environmental, Social, and Governance",
            "C. Enhanced Security Guarantees",
            "D. Equity Savings Group"
        ], answer: "B. Environmental, Social, and Governance"),
        
        Question(title: "What is 'greenwashing' in investing?", options: [
            "A. Cleaning investment documents",
            "B. Making misleading claims about environmental benefits",
            "C. Investing in green energy",
            "D. Environmental risk assessment"
        ], answer: "B. Making misleading claims about environmental benefits"),
        
        // Bonus Module: Cryptocurrencies and Crypto Tokens
        Question(title: "What is a 'blockchain' in cryptocurrency?", options: [
            "A. A type of digital wallet",
            "B. A decentralized, distributed ledger technology",
            "C. A cryptocurrency exchange",
            "D. A type of crypto token"
        ], answer: "B. A decentralized, distributed ledger technology"),
        
        Question(title: "What is a 'smart contract'?", options: [
            "A. A legal document for cryptocurrency",
            "B. Self-executing contracts with terms directly written into code",
            "C. A contract for buying cryptocurrencies",
            "D. A type of cryptocurrency wallet"
        ], answer: "B. Self-executing contracts with terms directly written into code"),
        
        Question(title: "What is 'DeFi' in cryptocurrency?", options: [
            "A. A type of cryptocurrency",
            "B. Decentralized Finance - financial services using blockchain",
            "C. A digital wallet",
            "D. A cryptocurrency exchange"
        ], answer: "B. Decentralized Finance - financial services using blockchain")
    ]
        
    }


#Preview {
    ContentView()
}

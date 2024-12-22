import SwiftUI

struct ContentView: View {
    @State private var showingQuiz = false
    
    var body: some View {
        if showingQuiz {
            QuizView()
        } else {
            WelcomeView(showingQuiz: $showingQuiz)
        }
    }
}

struct WelcomeView: View {
    @Binding var showingQuiz: Bool
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 45) {
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
                .padding(.vertical, 20)
                
                Spacer()
                
                // Start Button
                Button(action: {
                    showingQuiz = true
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
            }
        }
    }
}

struct CreatorLink: View {
    let name: String
    let url: String
    
    var body: some View {
        Link(destination: URL(string: url)!) {
            VStack(spacing: 12) {
                // Profile Icon
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 44))
                    .foregroundColor(.blue)
                    .shadow(color: .blue.opacity(0.2), radius: 5)
                
                // Name
                Text(name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                
                // LinkedIn Icon
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

import SwiftUI

struct QuizView: View {
    struct Question: Identifiable {
        let id = UUID()
        let title: String
        let options: [String]
        let answer: String
    }

    
    @State private var questions: [Question] = [
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
                ], answer: "B. To achieve a lifestyle not dependent on active work for income"),

                Question(title: "What is dollar-cost averaging?", options: [
                    "A. Investing a fixed amount of money at regular intervals",
                    "B. Investing all your money in one stock",
                    "C. Timing the market to buy low and sell high",
                    "D. Avoiding investments with high costs"
                ], answer: "A. Investing a fixed amount of money at regular intervals"),

                Question(title: "Which factor primarily determines the growth of compound interest?", options: [
                    "A. Inflation rate",
                    "B. Interest rate and time",
                    "C. The principal amount only",
                    "D. The number of withdrawals made"
                ], answer: "B. Interest rate and time"),

                Question(title: "What is a key benefit of investing early?", options: [
                    "A. Higher risk",
                    "B. Lower tax obligations",
                    "C. More time for compound interest to grow",
                    "D. Immediate high returns"
                ], answer: "C. More time for compound interest to grow"),

                Question(title: "Which of the following is an example of a passive income source?", options: [
                    "A. Wages from a full-time job",
                    "B. Dividends from stock investments",
                    "C. Freelance project payments",
                    "D. Overtime pay"
                ], answer: "B. Dividends from stock investments"),

                Question(title: "What is the purpose of a target-date retirement fund?", options: [
                    "A. To provide short-term investment opportunities",
                    "B. To adjust asset allocation based on a specific retirement year",
                    "C. To focus entirely on high-risk investments",
                    "D. To eliminate the need for savings"
                ], answer: "B. To adjust asset allocation based on a specific retirement year"),

                Question(title: "What is the risk-return tradeoff?", options: [
                    "A. Higher risk investments typically offer higher potential returns",
                    "B. Lower risk investments always offer higher returns",
                    "C. High returns require no risk",
                    "D. Risk and return are unrelated"
                ], answer: "A. Higher risk investments typically offer higher potential returns"),

                Question(title: "What is an index fund?", options: [
                    "A. A fund that actively selects stocks to beat the market",
                    "B. A fund that matches the performance of a market index like the S&P 500",
                    "C. A fund with no management fees",
                    "D. A fund that invests only in government bonds"
                ], answer: "B. A fund that matches the performance of a market index like the S&P 500")
            ]

    
    
    @State private var currentQuestionIndex = 0
    @State private var score = 0
    @State private var showingScore = false
    @State private var selectedAnswer = ""
    @State private var showingCorrectAnswer = false
    
    var body: some View {
    NavigationView {
    VStack(spacing: 20) {
    if showingScore {
    VStack {
    Text("Quiz Complete!")
    .font(.title)
    .padding()
    Text("Your score: \(score) out of \(questions.count)")
    .font(.headline)
    Button("Restart Quiz") {
    restartQuiz()
    }
    .padding()
    .background(Color.blue)
    .foregroundColor(.white)
    .cornerRadius(10)
    }
    } else {
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
    }
    .navigationTitle("Financial Literacy Quiz")
    .onAppear {
    questions.shuffle()
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
    }
    }
    private func restartQuiz() {
    questions.shuffle()
    currentQuestionIndex = 0
    score = 0
    selectedAnswer = ""
    showingCorrectAnswer = false
    }
    }


    #Preview {
    ContentView()
    }

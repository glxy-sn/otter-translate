//
//  JargonEntry.swift
//  otterTranslate
//
//  Created by Shafa Tiara on 05/06/26.
//


import Foundation

struct JargonEntry: Identifiable, Hashable {
    let id: UUID
    let term: String
    let definition: String
    let indirectExample: String
    let translatedText: String
    
    init(
        id: UUID = UUID(),
        term: String,
        definition: String,
        indirectExample: String,
        translatedText: String
    ) {
        self.id = id
        self.term = term
        self.definition = definition
        self.indirectExample = indirectExample
        self.translatedText = translatedText
    }

    init(
        id: UUID = UUID(),
        term: String,
        definition: String,
        example: String
    ) {
        self.init(
            id: id,
            term: term,
            definition: definition,
            indirectExample: example,
            translatedText: example
        )
    }
    
    var firstLetter: String {
        let first = String(term.prefix(1)).uppercased()
        return first.rangeOfCharacter(from: .letters) != nil ? first : "#"
    }
    
    var cleanExample: String {
        indirectExample
            .trimmingCharacters(in: .whitespaces)
            .trimmingCharacters(in: CharacterSet(charactersIn: "\""))
    }
}

// MARK: - Mock Data
extension JargonEntry {
    static let mock = JargonEntry(
        term: "Leverage",
        definition: "To use something to maximum advantage.",
        example: "We should leverage our existing customer base."
    )
    
    static let mockList: [JargonEntry] = [
        // #
        JargonEntry(term: "30,000-feet view", definition: "Looking at something in the broadest sense.", example: "At the 30,000-feet view, the problem is..."),
        JargonEntry(term: "80/20", definition: "Finding the way that leads to most progress with least work.", example: "Let's 80/20 this."),
        // A
        JargonEntry(term: "Action item", definition: "Something that has to get done.", example: "Did any action items come out of the meeting?"),
        JargonEntry(term: "Actionable", definition: "Making it clear what someone needs to do.", example: "Your email isn't actionable enough."),
        JargonEntry(term: "Align upon", definition: "To agree on something.", example: "Let's align on the meeting agenda first."),
        // B
        JargonEntry(term: "Bandwidth", definition: "How much time you have.", example: "I'm not sure I have bandwidth right now."),
        JargonEntry(term: "Benchmark", definition: "Something to compare to.", example: "Is this in line with industry benchmarks?"),
        JargonEntry(term: "Brain dump", definition: "Share all knowledge before handing off.", example: "Can we do a brain dump before you leave?"),
        // C
        JargonEntry(term: "Cadence", definition: "A certain routine or pattern.", example: "Would you like to meet on a weekly cadence?"),
        JargonEntry(term: "Circle back", definition: "To meet or follow up again later.", example: "Let's circle back once you've drafted something."),
        // D
        JargonEntry(term: "Deep dive", definition: "To look into something more closely.", example: "Let's do a deep dive on this topic tomorrow."),
        JargonEntry(term: "Deliverable", definition: "Anything that needs to be produced.", example: "The deliverable is a 10-page report."),
        // E
        JargonEntry(term: "EOD", definition: "End of day.", example: "Please send this by EOD."),
        JargonEntry(term: "EOW", definition: "End of week.", example: "I will get back to you by EOW."),
        // F
        JargonEntry(term: "Framework", definition: "Structure around a bunch of information.", example: "Let's put a framework around this."),
        JargonEntry(term: "FYI", definition: "For your information.", example: "FYI — the 2pm meeting has moved."),
        // G
        JargonEntry(term: "Granular", definition: "Specific.", example: "Can you be more granular?"),
        // H
        JargonEntry(term: "Hard stop", definition: "A time when you definitely need to leave.", example: "I have a hard stop at 2:25pm."),
        JargonEntry(term: "High level", definition: "The one-breath-or-less version.", example: "Just tell me the high level takeaway."),
        // I
        JargonEntry(term: "In the loop", definition: "To be included in the conversation.", example: "Keep me in the loop on how things go."),
        JargonEntry(term: "Iterate", definition: "Work on multiple versions until perfect.", example: "Let's iterate upon this together."),
        // J
        JargonEntry(term: "Jump on a call", definition: "To have a quick phone or video meeting.", example: "Can we jump on a call tomorrow?"),
        // K
        JargonEntry(term: "Key takeaway", definition: "The main point or summary.", example: "What's the key takeaway from this meeting?"),
        // L
        JargonEntry(term: "Leverage", definition: "To use something to maximum advantage.", example: "We should leverage our existing customer base."),
        JargonEntry(term: "Loop in", definition: "To include someone in a conversation.", example: "Mind looping me in on the email thread?"),
        JargonEntry(term: "Low-hanging fruit", definition: "Something easy to do that makes an impact.", example: "Let's complete the low-hanging fruit first."),
        // M
        JargonEntry(term: "Move the needle", definition: "Something substantial enough people will notice.", example: "This decision will move the needle."),
        // N
        JargonEntry(term: "Net-net", definition: "The final result after everything is taken into account.", example: "Net-net, it was worthwhile."),
        // O
        JargonEntry(term: "Offline", definition: "Not reachable.", example: "I will be offline during my hiking trip."),
        JargonEntry(term: "On the same page", definition: "To be in agreement.", example: "Are we on the same page?"),
        JargonEntry(term: "Optics", definition: "How people perceive the situation.", example: "It's bad optics if the intern presents to the client."),
        // P
        JargonEntry(term: "Paradigm shift", definition: "Something that fundamentally changes thinking.", example: "This is a paradigm shift."),
        JargonEntry(term: "Ping", definition: "To contact someone.", example: "Ping me tomorrow at 2pm."),
        JargonEntry(term: "Pivot", definition: "To change directions.", example: "We need to pivot our strategy."),
        // Q
        JargonEntry(term: "QC", definition: "Quality control.", example: "Let's QC this before sending."),
        JargonEntry(term: "Quick wins", definition: "Impactful things that don't take much effort.", example: "Let's start with the quick wins."),
        // R
        JargonEntry(term: "Roadmap", definition: "A plan or timeline.", example: "Present your roadmap to your manager."),
        JargonEntry(term: "ROI", definition: "Return on investment.", example: "Let's rank these initiatives by ROI."),
        // S
        JargonEntry(term: "Scalable", definition: "To do more with less time or energy.", example: "This solution is not scalable."),
        JargonEntry(term: "Stakeholders", definition: "Anyone who is affected by something.", example: "Have you looped in all stakeholders?"),
        JargonEntry(term: "Synergy", definition: "Extra benefit from two things combined.", example: "There are a lot of synergies here."),
        // T
        JargonEntry(term: "Table stakes", definition: "The bare minimum expectation.", example: "Following instructions is table stakes."),
        JargonEntry(term: "Touch base", definition: "To discuss further.", example: "Let's touch base about this report."),
        // U
        JargonEntry(term: "Unpack", definition: "To explain in more detail.", example: "Mind unpacking this concept for me?"),
        // V
        JargonEntry(term: "Value prop", definition: "What makes something attractive.", example: "What's the value prop of this solution?"),
        // W
        JargonEntry(term: "Wheelhouse", definition: "Your specialty.", example: "Python isn't quite in my wheelhouse."),
        // Y
        JargonEntry(term: "YTD", definition: "Year to date.", example: "What is our YTD website traffic?"),
    ]
}

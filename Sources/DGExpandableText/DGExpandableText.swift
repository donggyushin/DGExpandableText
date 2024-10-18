// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import DGLineHeight

public struct DGExpandableText: View {
    
    @State private var expanded: Bool = false
    @State private var truncated: Bool = false
    @State private var shrinkText: String
    
    private let text: String
    let font: UIFont
    let lineLimit: Int
    let lineHeight: CGFloat?
    let moreButtonText: String
    let lessButtonText: String?
    let moreButtonTextColor: Color
    let moreButtonFont: UIFont
    let textShrinkCount: Int
    let animation: Animation?
    
    public init(
        _ text: String,
        lineLimit: Int,
        font: UIFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body),
        lineHeight: CGFloat? = nil,
        moreButtonText: String = "read more",
        lessButtonText: String? = nil,
        moreButtonTextColor: Color = Color(uiColor: .label),
        moreButtonFont: UIFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body),
        textShrinkCount: Int = 4,
        animation: Animation? = nil
    ) {
        self.text = text
        _shrinkText =  State(wrappedValue: text)
        self.lineLimit = lineLimit
        self.font = font
        self.lineHeight = lineHeight
        self.moreButtonText = moreButtonText
        self.lessButtonText = lessButtonText
        self.moreButtonTextColor = moreButtonTextColor
        self.moreButtonFont = moreButtonFont
        self.textShrinkCount = textShrinkCount
        self.animation = animation
    }
    
    public var body: some View {
        ZStack(alignment: .bottomLeading) {
            Group {
                if #available(iOS 17.0, *) {
                    Text(self.expanded ? text : shrinkText) +
                    Text(moreLessText)
                        .foregroundStyle(moreButtonTextColor)
                        .font(Font(moreButtonFont))
                } else {
                    Text(self.expanded ? text : shrinkText) +
                    Text(moreLessText)
                        .foregroundColor(moreButtonTextColor)
                        .font(Font(moreButtonFont))
                }
            }
            .fontWithLineHeight(font: font, lineHeight: lineHeight)
            .animation(animation, value: expanded)
            .lineLimit(expanded ? nil : lineLimit)
            .background(
                // Render the limited text and measure its size
                Text(text)
                    .fontWithLineHeight(font: font, lineHeight: lineHeight)
                    .lineLimit(lineLimit)
                    .background(GeometryReader { visibleTextGeometry in
                        Color.clear.onAppear() {
                            let size = CGSize(width: visibleTextGeometry.size.width, height: .greatestFiniteMagnitude)
                            
                            var attributes:[NSAttributedString.Key:Any] = [
                                NSAttributedString.Key.font: font
                            ]
                            
                            if let lineHeight, lineHeight > 2 {
                                let paragraphStyle = NSMutableParagraphStyle()
                                paragraphStyle.minimumLineHeight = lineHeight - 2
                                paragraphStyle.maximumLineHeight = lineHeight - 2
                                
                                attributes[.paragraphStyle] = paragraphStyle
                            }

                            ///Binary search until mid == low && mid == high
                            var low  = 0
                            var heigh = shrinkText.count
                            var mid = heigh ///start from top so that if text contain we does not need to loop
                            ///
                            while ((heigh - low) > 1) {
                                let attributedText = NSAttributedString(string: shrinkText + moreLessText, attributes: attributes)
                                let boundingRect = attributedText.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
                                
                                if boundingRect.size.height > visibleTextGeometry.size.height {
                                    truncated = true
                                    heigh = mid
                                    mid = (heigh + low)/2
                                    
                                } else {
                                    if mid == text.count {
                                        break
                                    } else {
                                        low = mid
                                        mid = (low + heigh)/2
                                    }
                                }
                                shrinkText = String(text.prefix(mid))
                            }
                            
                            if truncated {
                                
                                shrinkText = String(shrinkText.prefix(shrinkText.count - textShrinkCount)) + "···"  //-2 extra as highlighted text is bold
                            }
                        }
                    })
                    .hidden() // Hide the background
            )
            
            if truncated {
                Button(action: {
                    if expanded == false {
                        expanded = true
                    } else {
                        if lessButtonText != nil {
                            expanded = false
                        }
                    }
                }, label: {
                    HStack { //taking tap on only last line, As it is not possible to get 'see more' location
                        Spacer()
                        Text("")
                    }.opacity(0)
                })
            }
        }
    }
    
    private var moreLessText: String {
        if !truncated {
            return ""
        } else {
            return self.expanded ? " \(lessButtonText ?? "")" : " \(moreButtonText)"
        }
    }
    
}


#Preview {
    DGExpandableText(
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Sed ut laborum",
        lineLimit: 3,
        lineHeight: 30,
        moreButtonText: " 더 보기",
        moreButtonFont: .boldSystemFont(ofSize: 15)
    )
    .foregroundStyle(.gray)
    .preferredColorScheme(.dark)
}

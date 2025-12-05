//
//  ContentView.swift
//  Mindset
//
//  Created by Lyudmila Tokar on 11/6/25.
//

import SwiftUI

struct TextBlock: Identifiable, Equatable {
    let id = UUID()
    var text: String
    var color: Color
}

struct ContentView: View {
    @State private var blocks: [TextBlock] = []
    @State private var newText: String = ""
    
    var body: some View {
        VStack(spacing: 16) {
            
            // Поле ввода
            HStack {
                TextField("Введите текст...", text: $newText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button("Добавить") {
                    addBlock()
                }
                .buttonStyle(.borderedProminent)
            }
            
            // Список текстовых блоков
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(blocks) { block in
                        Text(block.text)
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(block.color.opacity(0.3))
                            .cornerRadius(10)
                            .onTapGesture {
                                changeColor(of: block)
                            }
                            .onLongPressGesture {
                                delete(block)
                            }
                            .animation(.easeInOut, value: blocks)
                    }
                }
                .padding(.horizontal)
            }
            
            // Кнопка перемешивания
            Button("Перемешать порядок") {
                withAnimation {
                    blocks.shuffle()
                }
            }
            .padding(.bottom)
        }
    }
    
    // MARK: - Функции
    
    func addBlock() {
        guard !newText.isEmpty else { return }
        let newBlock = TextBlock(
            text: newText,
            color: .random()
        )
        blocks.append(newBlock)
        newText = ""
    }
    
    func changeColor(of block: TextBlock) {
        if let index = blocks.firstIndex(of: block) {
            blocks[index].color = .random()
        }
    }
    
    func delete(_ block: TextBlock) {
        withAnimation {
            blocks.removeAll { $0.id == block.id }
        }
    }
}

extension Color {
    static func random() -> Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}


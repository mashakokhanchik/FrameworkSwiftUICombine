//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    print("\n------ Example of:", description, "------")
    action()
}

private var subscription = Set<AnyCancellable>()

/*
 1. Создайте первый издатель, производный от Subject, который испускает строки.
 2. Используйте .collect() со стратегией .byTime для группировки данных через каждые 0.5 секунд.
 3. Преобразуйте каждое значение в Unicode.Scalar, затем в Character, а затем превратите весь массив в строку с помощью .map().
 4. Создайте второй издатель, производный от Subject, который измеряет интервалы между каждым символом. Если интервал превышает 0,9 секунды, сопоставьте это значение с эмодзи. В противном случае сопоставьте его с пустой строкой.
 5. Окончательный издатель — слияние двух предыдущих издателей строк и эмодзи. Отфильтруйте пустые строки для лучшего отображения.
 6. Результат выведите в консоль.
 */

example(of: "Operators part 2") {
    let queue = DispatchQueue(label: "Collect")
    let subject = PassthroughSubject<String, Never>()
    
    let firstPublisher = subject
    firstPublisher
        .print()
        .collect(.byTime(queue, .seconds(0.5)))
        .map { (strings) -> String in
            var tmpString = String()
            for string in strings {
                tmpString += string
            }
            return tmpString
        }
        .map { $0.unicodeScalars }
        .print()
        .map { $0.map(Character.init) }
        .print()
        .map { String($0).description }
        .sink(receiveCompletion: { print($0) }, receiveValue: { print($0) })
        .store(in: &subscription)
    
    let secondPublisher = subject
    secondPublisher
        .measureInterval(using: DispatchQueue.main)
        .map { $0 > 0.9 ? "😀" : " " }
        .zip(firstPublisher)
        .sink(receiveCompletion: { print($0) }, receiveValue: { print($0) })
        .store(in: &subscription)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        subject.send("A")
        subject.send("B")
        subject.send("C")
        subject.send("D")
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        subject.send("E")
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
        subject.send("F")
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
        subject.send("G")
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
        subject.send("H")
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
        subject.send("Alphabet")
        subject.send(completion: .finished)
    }
}

//: [Next](@next)

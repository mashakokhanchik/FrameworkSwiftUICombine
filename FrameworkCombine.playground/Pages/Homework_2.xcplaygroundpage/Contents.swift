//: [Previous](@previous)

import Foundation
import Combine

public func example(of description: String, action: () -> Void) {
    print("\n------ Example of:", description, "------")
    action()
}

private var subscription = Set<AnyCancellable>()

// Contacts
struct Contact {
    let name: String
    let number: String
}

let contacts: [Contact] = [
    Contact(name: "Monica", number: "9069999896"),
    Contact(name: "Rachel", number: "9089998765"),
    Contact(name: "Joey", number: "9079996543"),
    Contact(name: "Ross", number: "9099992345")
]

/*
1. Создайте пример, который публикует коллекцию чисел от 1 до 100, и используйте операторы фильтрации, чтобы выполнить следующие действия:
        a. Пропустите первые 50 значений, выданных вышестоящим издателем.
        b. Возьмите следующие 20 значений после этих 50.
        c. Берите только чётные числа.
*/
example(of: "First") {
    (1...100).publisher
        .dropFirst(50)
        .prefix(20)
        .filter { $0 % 2 == 0 }
        .collect()
        .sink(receiveCompletion: { print($0) }, receiveValue: { print("Collection of numbers: \($0)") })
        .store(in: &subscription)
}

/*
2. Создайте пример, который собирает коллекцию строк, преобразует её в коллекцию чисел и вычисляет среднее арифметическое этих значений.
 */

example(of: "Second") {
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    
    ["one", "thirty_seven", "seventy_five", "four"].publisher
        .compactMap { formatter.number(from: $0) as? Int }
        .collect()
        .map { Double($0.reduce(0, +)) / Double($0.count) }
        .sink(receiveCompletion: { print($0) }, receiveValue: { print("Arithmetic mean: \($0)") })
        .store(in: &subscription)
}

/*
3. *Создать поиск телефонного номера в коллекции с помощью операторов преобразования, ваша цель в этой задаче — создать издателя, который делает две вещи:
        a. Получает строку из десяти цифр или букв.
        b. Ищет этот номер в структуре данных контактов.
 */

example(of: "Third") {
    let number = "9079996543"
    let publisher = PassthroughSubject<String,Never>()
    
    publisher
        .compactMap { input in
            contacts.first { $0.number.contains(input) }
        }
        .sink(receiveCompletion: { print($0) }, receiveValue: { print($0) })
        .store(in: &subscription)
    publisher.send(number)
}

//: [Next](@next)

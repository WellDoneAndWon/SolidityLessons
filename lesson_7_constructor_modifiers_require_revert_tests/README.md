## Constructor
Конструктор — это необязательная функция, объявленная с помощью ключевого слова constructor, которая выполняется при создании контракта и где вы можете запустить код инициализации контракта.
![alt text](https://i.postimg.cc/1XqgtZRF/constructor.png "Инициализация")

## Кастомные модификаторы функций
Модификаторы функций можно использовать для изменения семантики функций декларативным способом.
![alt text](https://ic.wampi.ru/2023/02/01/onlyOwner.png)

## Обработка ошибок
``assert(bool condition)`` – вызывает паническую ошибку и, следовательно, не вносит изменение состояния, если условие не выполняется. Используется при внутренних ошибках.

``require(bool condition)`` – откат если условие не выполняется. Используется при генерации ошибок на входах или для внешних компонентов.

``require(bool condition, string memory message)`` – откат если условие не выполняется. Используется при генерации ошибок на входах или для внешних компонентов. Также выдает сообщение об ошибке.

``revert()`` – прервать выполнение и вернуть изменения состояния.

``revert(string memory reason)`` – прервать выполнение, вернуть изменения состояния и вывести причину ошибки.

## События
События позволяют вам удобным образом отображать в логах виртуальной машины Ethereum необходимую информацию о наступлении какого-либо события.

Чтобы определить событие в коде, используется ключевое слово event. А чтобы вызвать это событие, используется ключевое слово emit.
```solidity
pragma solidity >=0.7.0 <0.9.0;
contract MyContractName {
    event HighestBidIncreased(address bidder, uint amount); // Event
    function bid() public payable {
        // ...
        emit HighestBidIncreased(msg.sender, msg.value); // Triggering event
    }
}
```
## Ошибки
Вы можете заранее описать возможные ошибки и присвоить им имена используя ключевое слово error. При возникновении нетипичной ситуации в коде, вы можете вызвать ошибку по ее имени так же, как и функцию используя ключевое слово revert. Это намного дешевле, чем использовать строковые описания ошибок и дает возможность передававать дополнительные данные.
```solidity
pragma solidity >=0.7.0 <0.9.0;
/// Not enough funds for transfer. Requested `requested`,
/// but only `available` available.
error NotEnoughFunds(uint requested, uint available);
contract Token {
    mapping(address => uint) balances;
    
    function transfer(address to, uint amount) public {
        uint balance = balances[msg.sender];
        
        if (balance < amount)
            revert NotEnoughFunds(amount, balance);
            
        balances[msg.sender] -= amount;
        balances[to] += amount;
        // ...
    }
}
```
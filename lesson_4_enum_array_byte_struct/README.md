## Перечисления
Это объект, который может хранить в себе только заранее предопределенные в нем значения. Он задается ключевым словом enum. Например, определим в нашей программе объект enum, в котором будем хранить набор 3 цветов. А затем создадим переменную с типом данного объекта и присвоим ей одно из значений данного набора.

```solidity
pragma solidity >=0.7.0 <0.9.0;

contract MyContractName {
    // define enum colors
    enum Color { Red, Green, Yellow } // Enum

    // set enum value
    Color constant defaultColor = Color.Green;
}
```
## Массивы
Массивы могут иметь статический или динамический размер. Массив Т фиксированного размера k записывается как T[k], а динамический массив записывается как T[]. Например, массив из 5 динамических массивов записывается как uint[][5]. Обратите внимание, что это обратная нотация по сравнению с большинством других языков (в них было бы наоборот).

Элементами массива могут быть переменные любого типа, включая mapping и struct. Если пометить массивы как public то Solidity создаст для них геттер (функцию получения из него элементов). Числовой индекс будет являться обязательным параметром для этого геттера. Доступ к несуществующему элементу массива вызывает ошибку. При помощи методов ``.push()`` и ``.push(value)`` вы можете добавить новый элемент в конец массива, причем вызов метода ``.push()`` добавит пустой элемент и возвратит ссылку на него.

## Массивы типа bytes и string.
Массивы с типом bytes и string представляют из себя специальные массивы. Например, bytes похож на byte[], но плотно упакован в памяти и функции обратного вызова, а строка равна байтам, но не разрешает доступа к длине или индексу.

Вы можете использовать bytes вместо byte[], т.к. это дешевле, поскольку byte[] добавляет 31 байт между элементами. Используйте bytes для необработанных байтовых данных произвольной длинны (UTF-8). А если вы можете ограничит длину произвольным количеством байтов от 1 до 32 то используйте типы bytes1 .. bytes32, так как это намного дешевле. Если вы хотите объединить несколько переменных типа bytes, то используйте встроенную функцию ``bytes.concat``.

```solidity
bytes s = "Storage";
function f(bytes calldata c, string memory m, bytes16 b) public view {
    bytes memory a = bytes.concat(s, c, c[:2], "Literal", bytes(m), b);
    assert((s.length + c.length + 2 + 7 + bytes(m).length + 16) == a.length);
}
```
## Выделение массивов Memory
Динамические массивы memory можно создать при помощи оператора new. В отличие от storage массивов, у них нельзя изменить размер, поэтому вы должны заранее рассчитать под них требуемый размер.
```solidity
uint[] memory a = new uint[](7);
bytes memory b = new bytes(len);
```
### Методы массива
+ ``length`` – позволяет понять количество элементов в массиве,
+ ``push()`` – позволяет добавить новый пустой элемент в конец массива, возвращает ссылку на добавленный элемент,
+ ``push(x)`` – позволять добавить новый элемент “х” в конец массива, ничего не возвращает,
+ ``pop`` – удаляет последний элемент массива.

### Срезы массивов
Это представление непрерывной части массива начиная и заканчивая определенным его индексом.

Вызывается это как ``x[start:end]``, где start это начальный индекс, а end – конечный, которым заканчивается представление части массива. Причем, указание start и end носит опциональный характер, т.е. если не указывать start то это будет считаться значением 0, а если не указывать end, то это будет считаться последним элементом массива.

## Строки
В переменных типа string вы можете хранить строковые значения, которые заключаются в одинарные или двойные кавычки. В них также есть поддержка escape символов, таких как \n, \xNN и т.д.
```solidity
string public constant name = "This is my string value";
```
Solidity не имеет возможности манипулирования строками, но есть сторонние строковые библиотеки. Например, вы можете сравнить две строки по их хэшу: ``keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2))`` либо объединить две строки при помощи ``bytes.concat(bytes(s1), bytes(s2))``.

## Unicode литералы
Обычные строки задаются в кодировке ASCII, но если в строке вы планируете использовать UTF-8, то нужно перед двойными или одинарными кавычками указать ключевое слово unicode.
```solidity
string memory a = unicode"Hello 😃";
```
## HEX литералы
Шестнадцатеричные значения задаются также как строки в двойных или одинарных кавычках, но перед ними нужно указать ключевое слово hex. При указании hex значения, по желанию, вы можете разделять байты знаком подчеркивания.
```solidity
string memory a = hex"001122FF"
```

## Словари
Словари (Mapping Type) используются для сопоставления между собой двух наборов значений, как правило разного типа. 

Синтаксис: ``mapping(_KeyType => _ValueType)``.

_KeyType может быть любым встроенным типом значения, байтами, строкой или любым контрактом или типом перечисления. _ValueType может быть любого типа, включая сопоставления, массивы и структуры.
```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;
contract MappingExample {
    mapping(address => uint) public balances;
    function update(uint newBalance) public {
        balances[msg.sender] = newBalance;
    }
}
contract MappingUser {
    function f() public returns (uint) {
        MappingExample m = new MappingExample();
        m.update(100);
        return m.balances(address(this));
    }
}
```
## Как проверить существование ключа в словаре?
В Solidity нет такого понятие как “существование ключа в словаре”, т.к. по умолчанию он существует всегда, но равен 0. Поэтому, чтобы проверить отсутствие ключа в словаре, вам нужно проверить значение по вашему ключу возвращает 0 в соответствии с его типом. Т.е. для адреса это mapping[key] == address(0x0), для байтового массива это mapping[key] = bytes4(0x0) и т.д. Для структур – обычно в самой структуре задают дополнительный атрибут типа bool, который при заполнении структуры всегда устанавливают в true, ну и соответственно проверку наличия ключа делают по этому флагу (пример: Game[id].isValue == false).
```
// с версии 0.8.6 можно определять наличие ключа в словаре еще и так<br>if (abi.encodePacked(balances[user_id]).length > 0) {
    delete balances[addr];
}
```
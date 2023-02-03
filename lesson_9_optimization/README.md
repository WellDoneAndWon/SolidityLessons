# Оптимизация контрактов
## Переменные состояния и упаковка
```sol
contract Un {
    uint demo = 0; // Gas used: 69324
}

contract Op {
    uint demo; // Gas used: 67066
}
```
```sol
contract Un { // Gas used: 135378
    uint128 a = 7; // создается на каждую переменную по ячейке
    uint256 b = 7; 
    uint128 c = 7;
}

contract Op { // Gas used: 113528
    uint128 a = 7; // 16 байт } две переменные можно упаковать в одну ячейку 
    uint128 c = 7; // 16 байт } размер ячейки 32 байт
    uint256 b = 7;
}
```
### Выбор типа переменной
Спецификация языка Solidity предлагает разработчику аж тридцать две разрядности целочисленных типов uint — от 8 до 256 бит. Представьте, что вы разрабатываете смарт-контракт, который предназначен для хранения возраста человека в годах. Какую разрядность uint выберите вы?

Вполне естественным было бы выбрать минимально достаточный тип для конкретной задачи — математически тут подошёл бы uint8. Логичным было бы предположить, что чем меньший по размеру объект мы храним в блокчейне и чем меньше мы расходуем памяти при исполнении, меньше имеем накладных расходов, тем меньше платим. Но в большинстве случаев такое предположение окажется неверным.

Для эксперимента возьмём самый простой контракт из того, что предлагает официальная документация Solidity и соберём его в двух вариантах — с использованием типа переменной uint256 и в 32 раза меньшего типа — uint8.

### Хранение uint8 против uint256
Оба значения располагаются абсолютно одинаково в storage slot в виде 256-битного value.

### Обработка uint8 против uint256
Из-за того что мы урезаем переменную uint8, а это дополнительная операция.
Операции с uint8 имеют даже большее количество инструкций, чем uint256. Это объясняется тем, что машина приводят 8-битное значение к нативному 256-битному слову, и в результате код обрастает дополнительными инструкциями, которые оплачивает отправитель. Не только запись, но и исполнение кода с uint8 типом в данном случае оказывается дороже.
```sol
contract Un { // Gas used: 89641
    uint8 a = 1;  
}

contract Op { // Gas used: 89240
    uint a = 1;    
}
```

## Статические значения
Если есть заранее известное значение, то лучше сразу его записывать. Если есть такая возможность, то лучше так...
```sol
contract Un { // Gas used: 116440
    bytes32 public hash = keccak256(
        abi.encodePacked("test")
    );
}

contract Op { // Gas used: 114425
    bytes32 public hash = "0x...";
}
```
## Промежуточные переменные
```sol
contract Un { // Gas used: 141301
    mapping(address => uint) payments;
    function pay() external payable {
        address _from = msg.sender;
        require(_from != address(0), "zero address");
        payments[_from] = msg.value;
    }
}

contract Op { // Gas used: 140017
    mapping(address => uint) payments;
    function pay() external payable {
        require(msg.sender != address(0), "zero address");
        payments[msg.sender] = msg.value;
    }
}
```

## Сопоставления и массивы
По возможности стоит использовать mapping, вместо массивов.
```sol
contract Un { // Gas used: 134371
    uint[] payments;
    function pay() external payable { // Gas used: 45618
        require(msg.sender != address(0), "zero address");
        payments.push(msg.value);
    }
}

contract Op { // Gas used: 140017
    mapping(address => uint) payments;
    function pay() external payable { // Gas used: 23498
        require(msg.sender != address(0), "zero address");
        payments[msg.sender] = msg.value;
    }
}
```

## Фиксированные и динамические массивы
В идеале использовать фиксированные массивы, если это возможно. 
```sol
contract Un { // Gas used: 134371
    uint[] payments;
    function pay() external payable { // Gas used: 45618
        require(msg.sender != address(0), "zero address");
        payments.push(msg.value);
    }
}

contract Op { // Gas used: 140917
    uint[10] payments;
    function pay() external payable { // Gas used: 23438
        require(msg.sender != address(0), "zero address");
        payments[0] = msg.value;
    }
}
```

```sol
contract Un { // Gas used: 158612
    uint[] payments = [1, 2, 3];
}

contract Op { // Gas used: 127260
    uint8[] payments = [1, 2, 3];
}

```

## Множество маленьких или одна большая функция?
-Одна большая
```sol
contract Un { // Gas used: 152501
    uint c = 5;
    uint d;
    function calc() public { // Gas used: 46188
        uint a = 1 + c;
        uint b = 2 * c;
        call2(a, b);
    }

    function call2(uint a, uint b) private {
        d = a + b;
    }
}

contract Op { // Gas used: 149483
    uint c = 5;
    uint d;
    function calc() public { // Gas used: 46154
        uint a = 1 + c;
        uint b = 2 * c;
        d = a + b;
    }
}
```
## Не использовать слишком большие строки (чтобы вмещалась в 32 байта)

## Изменение переменных состояния в цикле
```sol
contract Un { // Gas used: 296233
    uint public result = 7;
    function doWork(uint[] memory data) public { // Gas used: 30254
        for(uint i = 0; i < data.length; i++){
            result *= data[i];
        }
    }
}

contract Op { // Gas used: 297085
    uint public result = 7;
    function doWork(uint[] memory data) public { // Gas used: 29824
        uint temp = 7;
        for(uint i = 0; i < data.length; i++){
            temp *= data[i];
        }
        result = temp;
    }
}
```

## Заключение
+ Не хранить много данных
+ Большие объемы хранить в облачном хранилище, и ссылаться на них
+ Не раздувать контракты без нужды, лучше компактный код и использовать стороние библиотеки
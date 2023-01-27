contract ExampleStore {

  /**
   * @dev Определяем структуру объекта
   */
  struct Item {
    uint price;
    uint units; 
  }
  
  /**
   * @dev При создании контракта выделяется storage память
   * для хранения массива наших структур Item
   */
  Item[] public items;

  /**
   * @dev Создаем экземпляр объекта в memory памяти
   * и добавляем его в массиив хранящиися в storage
   */
  function newItem(uint _price, uint _units) public {
    Item memory item = Item(_price, _units);
    items.push(item);
  }

  /**
   * @dev Возвращаем ссылку на конкретный объект 
   * из существующего массива живущего в storage.
   */
  function getUsingStorage(uint _itemIdx) public returns (uint) {
    Item storage item = items[_itemIdx];
    return item.units;
  }

  /**
   * @dev Возвращаем копию конкретного объекта
   * из существующего массива живущего в storage.
   */
  function getUsingMemory(uint _itemIdx) public returns (uint) {
    Item memory item = items[_itemIdx];
    return item.units;
  }

  /**
   * @dev Берем ссылку на конкретный объект из существующего массива в storage
   * и изменяем его значение (значение в storage меняется)
   */
  function addItemUsingStorage(uint _itemIdx, uint _units) public {
    Item storage item = items[_itemIdx];
    item.units += _units;
  }

  /**
   * @dev Берем копию конкретного объекта из существующего массива в storage
   * и изменяем его значение (значение в storage НЕ меняется)
   */
  function addItemUsingMemory(uint _itemIdx, uint _units) public {
    Item memory item = items[_itemIdx];
    item.units += _units;
  }
}

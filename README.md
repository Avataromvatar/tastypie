# TastyPie
**Вкусный пирог** - это эксперемент по созданию вкусного слоенного пирога вашего App. 
## Briefly
Это событийная шина разбитая на слои. В каждом слое находятся сущности-обработчики входных событий(In) и генераторы(Out) исходящих событий.
Событие формируется из темы(топика)&lt;String&gt;, состояния&lt;int&gt; и тела события.
По топику и маски состояния фильтруются вcе события как входящие так и исходящие ``` (dto.topic==topic && (dto.state&state_mask != 0)) ```.

Контроллер слоя, анализируя сущности внутри и формирует прямые связи(direct link) между выходами и входами разных сущностей в слое, на основании топика и состояния. 

**Основные цели:**
- Разделение компонентов на функ. группы (слои)
- Обеспечения общей событийной шины для компонентов внутри слоя и правила внешних связей
- быстрый вызов обработчиков исходящих событий
- вариации данных события либо вариация обработчиков по состоянию 
- простота и универсальность. 
- возможность создания графа связей для того чтобы проанализировать и повысить понимаемость какая магия происходит 
- поддержка потоков 

### Взаимодействие между элементами
![взаиодействия с элементами](tastepie.drawio(2).png)
### Taste - TastyPieDTO
String topic
int state
dynamic data
### TastyPieLayer

### Topping -



# TODO
+ [ ] Add helper - MasterLayer singltone
+ [ ] need divided interface for consumer and developer. Example when inherit Topping no need IToppinMechanic  
+ [ ] Analize - Maybe remove state? 
+ [v] Topping addTaste... add param onlyInTheLayer







Приложение делится на слои( TastyPieLayer). Каждый слой наполняется начинкой(Topping (Archaea now)).
Начинка сожержит вкус (Taste (ArchaeaPoint)) который раскрывается(отрабатывает handler) при дегустации(Tasting (call))  
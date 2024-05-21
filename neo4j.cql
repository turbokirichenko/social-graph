// создаем группу людей
CREATE (person:people {name: "Влас", city: "Архангельск"}) 
CREATE (temporary:people {name: "Зиновий", city: "Воронеж"}) 
CREATE (temporary:people {name: "Артемий", city: "Калининград"}) 
CREATE (me:people {name: "Валентин", city: "Оренбург"}) 
CREATE (man:people {name: "Дайна", city: "Херсон"}) 
CREATE (d:people {name: "Логгин", city: "Великий Новгород"}) 
CREATE (temporary:people {name: "Харитон", city: "Уфа"}) 
CREATE (some:people {name: "Виолетта", city: "Хабаровск"}) 
CREATE (temporary:people {name: "Иван", city: "Калининград"}) 
CREATE (temp:people {name: "Влас", city: "Смоленск"}) 
CREATE (some:people {name: "Феоктист", city: "Якутск"}) 
CREATE (temp:people {name: "Гордей", city: "Тверь"}) 
// создаем связь 'знает'
MATCH (b:people) WHERE b.name = 'Влас' MATCH (c:people) WHERE c.name <> b.name MERGE (b)-[relationship:knew]->(c) RETURN count(relationship)
MATCH (man:people)  MATCH (person:people {name: 'Иван'}) WHERE man.name IN ['Артемий', 'Валентин', 'Дайна', 'Харитон', 'Иван', 'Влас'] MATCH (man) - [follow:knew] -> (person) RETURN count(follow)
MATCH (man:people) WHERE man.name = 'Зиновий' MATCH (some:people) WHERE some.name <> man.name MERGE (man)-[relation:knew]->(some) RETURN count(relation)
MATCH (temporary:people)  MATCH (b:people) WHERE temporary.name IN ['Влас', 'Зиновий', 'Артемий', 'Дайна', 'Логгин', 'Харитон', 'Виолетта', 'Иван'] MATCH (temporary) - [k:knew] -> (b) RETURN count(k)
MATCH (x:people) WHERE x.name = 'Артемий' MATCH (temp:people) WHERE temp.name <> x.name MERGE (x)-[follow:knew]->(temp) RETURN count(follow)
MATCH (a:people)  MATCH (person:people)  MATCH (a) - [to:knew] -> (person) RETURN count(to)
MATCH (a:people) WHERE a.name = 'Валентин' MATCH (b:people) WHERE b.name <> a.name MERGE (a)-[follow:knew]->(b) RETURN count(follow)
MATCH (man:people)  MATCH (man:people) WHERE man.name IN ['Зиновий', 'Артемий', 'Дайна', 'Иван', 'Влас', 'Гордей'] MATCH (man) - [relation:knew] -> (man) RETURN count(relation)
MATCH (person:people) WHERE person.name = 'Дайна' MATCH (human:people) WHERE human.name <> person.name MERGE (person)-[follow:knew]->(human) RETURN count(follow)
MATCH (temporary:people)  MATCH (human:people) WHERE temporary.name IN ['Влас', 'Феоктист', 'Гордей'] MATCH (temporary) - [relationship:knew] -> (human) RETURN count(relationship)
MATCH (temporary:people) WHERE temporary.name = 'Логгин' MATCH (me:people) WHERE me.name <> temporary.name MERGE (temporary)-[follow:knew]->(me) RETURN count(follow)
MATCH (f:people)  MATCH path=(f:people) - [relation:knew*2] -> (me:people {name: 'Влас'}) RETURN path
MATCH (f:people) WHERE f.name = 'Харитон' MATCH (x:people) WHERE x.name <> f.name MERGE (f)-[follow:knew]->(x) RETURN count(follow)
MATCH (f:people {name: 'Влас'})  MATCH path=(f:people {name: 'Влас'}) - [k:knew*2] -> (temp:people {name: 'Дайна'}) RETURN path
MATCH (man:people) WHERE man.name = 'Виолетта' MATCH (some:people) WHERE some.name <> man.name MERGE (man)-[r:knew]->(some) RETURN count(r)
MATCH (c:people {name: 'Влас'})  RETURN c
MATCH (a:people) WHERE a.name = 'Иван' MATCH (b:people) WHERE b.name <> a.name MERGE (a)-[to:knew]->(b) RETURN count(to)
MATCH (man:people {name: 'Гордей'})  MATCH path=(man:people {name: 'Гордей'}) - [relation:knew*2] -> (b:people) RETURN path
MATCH (d:people) WHERE d.name = 'Влас' MATCH (e:people) WHERE e.name <> d.name MERGE (d)-[to:knew]->(e) RETURN count(to)
MATCH (e:people)  MATCH (person:people)  MATCH (e) - [r:knew] -> (person) RETURN count(r)
MATCH (temp:people) WHERE temp.name = 'Феоктист' MATCH (temporary:people) WHERE temporary.name <> temp.name MERGE (temp)-[k:knew]->(temporary) RETURN count(k)
MATCH (c:people)  MATCH path=(c:people) - [to:knew*2] -> (f:people) RETURN path
MATCH (d:people) WHERE d.name = 'Гордей' MATCH (e:people) WHERE e.name <> d.name MERGE (d)-[u:knew]->(e) RETURN count(u)
MATCH (human:people {name: 'Гордей'}) WHERE human.name IN ['Влас', 'Артемий', 'Дайна', 'Логгин', 'Харитон', 'Феоктист'] RETURN human
// проверка команд
MATCH (person:people)  RETURN person
MATCH (man:people)  MATCH (man:people)  MATCH (man) - [to:knew] -> (man) RETURN count(to)
MATCH (d:people {name: 'Логгин'})  RETURN d
MATCH (other:people {name: 'Виолетта'})  MATCH (person:people {name: 'Виолетта'})  MATCH (other) - [to:knew] -> (person) RETURN count(to)
MATCH (other:people {name: 'Гордей'})  MATCH path=(other:people {name: 'Гордей'}) - [follow:knew*2] -> (temp:people) RETURN path
MATCH (f:people {name: 'Дайна'})  MATCH (man:people)  MATCH (f) - [relationship:knew] -> (man) RETURN count(relationship)
MATCH (e:people {name: 'Логгин'})  MATCH (some:people) WHERE e.name IN ['Дайна', 'Харитон', 'Иван', 'Влас'] MATCH (e) - [u:knew] -> (some) RETURN count(u)
MATCH (human:people {name: 'Зиновий'}) WHERE human.name IN ['Артемий', 'Валентин', 'Дайна', 'Логгин', 'Виолетта', 'Влас', 'Феоктист'] RETURN human
// задаем тип связи - 'нравится' для: 'Влас'
MATCH (f:people { name: 'Влас' })  MATCH (x:people) WHERE x.name IN ["Артемий", "Дайна", "Виолетта"] AND x.name <> f.name MERGE (f)-[r:knew]->(x) SET r.tyre_like='нравится' RETURN r
// задаем тип связи - 'любит' для: 'Влас'
MATCH (human:people) WHERE human.name = 'Влас' MATCH (man:people) WHERE man.name IN ["Дайна"] AND man.name <> human.name MERGE (human)-[relation:knew]->(man) SET relation.tyre_love='любит' RETURN relation
// задаем тип связи - 'нравится' для: 'Зиновий'
MATCH (x:people { name: 'Зиновий' })  MATCH (temp:people) WHERE temp.name IN ["Валентин", "Дайна", "Виолетта"] AND temp.name <> x.name MERGE (x)-[relation:knew]->(temp) SET relation.tyre_like='нравится' RETURN relation
// задаем тип связи - 'дружат' для: 'Зиновий'
MATCH (some:people) WHERE some.name = 'Зиновий' MATCH (a:people) WHERE a.name IN ["Валентин"] AND a.name <> some.name MERGE (some)-[k:knew]->(a) SET k.tyre_be_friends='дружат' RETURN k
// задаем тип связи - 'любит' для: 'Зиновий'
MATCH (other:people) WHERE other.name = 'Зиновий' MATCH (person:people) WHERE person.name IN ["Виолетта"] AND person.name <> other.name MERGE (other)-[k:knew]->(person) SET k.tyre_love='любит' RETURN k
// задаем тип связи - 'не любит' для: 'Зиновий'
MATCH (x:people) WHERE x.name = 'Зиновий' MATCH (temp:people) WHERE temp.name IN ["Харитон", "Иван", "Феоктист"] AND temp.name <> x.name MERGE (x)-[r:knew]->(temp) SET r.tyre_dislike='не любит' RETURN r
// задаем тип связи - 'враждует с' для: 'Зиновий'
MATCH (some:people) WHERE some.name = 'Зиновий' MATCH (a:people) WHERE a.name IN ["Харитон"] AND a.name <> some.name MERGE (some)-[k:knew]->(a) SET k.tyre_feud='враждует с' RETURN k
// задаем тип связи - 'должен' для: 'Зиновий'
MATCH (temp:people { name: 'Зиновий' })  MATCH (temporary:people) WHERE temporary.name IN ["Валентин"] AND temporary.name <> temp.name MERGE (temp)-[u:knew]->(temporary) SET u.tyre_loan='должен' RETURN u
// задаем тип связи - 'помогает' для: 'Зиновий'
MATCH (man:people) WHERE man.name = 'Зиновий' MATCH (some:people) WHERE some.name IN ["Виолетта"] AND some.name <> man.name MERGE (man)-[k:knew]->(some) SET k.tyre_help='помогает' RETURN k
// задаем тип связи - 'нравится' для: 'Артемий'
MATCH (temp:people { name: 'Артемий' })  MATCH (temporary:people) WHERE temporary.name IN ["Дайна", "Логгин", "Виолетта"] AND temporary.name <> temp.name MERGE (temp)-[follow:knew]->(temporary) SET follow.tyre_like='нравится' RETURN follow
// задаем тип связи - 'любит' для: 'Артемий'
MATCH (temporary:people) WHERE temporary.name = 'Артемий' MATCH (me:people) WHERE me.name IN ["Дайна"] AND me.name <> temporary.name MERGE (temporary)-[k:knew]->(me) SET k.tyre_love='любит' RETURN k
// задаем тип связи - 'нравится' для: 'Валентин'
MATCH (person:people { name: 'Валентин' })  MATCH (human:people) WHERE human.name IN ["Зиновий", "Дайна", "Харитон", "Виолетта"] AND human.name <> person.name MERGE (person)-[to:knew]->(human) SET to.tyre_like='нравится' RETURN to
// задаем тип связи - 'дружат' для: 'Валентин'
MATCH (man:people { name: 'Валентин' })  MATCH (some:people) WHERE some.name IN ["Зиновий", "Харитон"] AND some.name <> man.name MERGE (man)-[rel:knew]->(some) SET rel.tyre_be_friends='дружат' RETURN rel
// задаем тип связи - 'любит' для: 'Валентин'
MATCH (c:people) WHERE c.name = 'Валентин' MATCH (d:people) WHERE d.name IN ["Виолетта"] AND d.name <> c.name MERGE (c)-[follow:knew]->(d) SET follow.tyre_love='любит' RETURN follow
// задаем тип связи - 'не любит' для: 'Валентин'
MATCH (x:people) WHERE x.name = 'Валентин' MATCH (temp:people) WHERE temp.name IN ["Харитон", "Иван", "Феоктист"] AND temp.name <> x.name MERGE (x)-[relationship:knew]->(temp) SET relationship.tyre_dislike='не любит' RETURN relationship
// задаем тип связи - 'враждует с' для: 'Валентин'
MATCH (b:people) WHERE b.name = 'Валентин' MATCH (c:people) WHERE c.name IN ["Феоктист"] AND c.name <> b.name MERGE (b)-[relationship:knew]->(c) SET relationship.tyre_feud='враждует с' RETURN relationship
// задаем тип связи - 'помогает' для: 'Валентин'
MATCH (me:people) WHERE me.name = 'Валентин' MATCH (other:people) WHERE other.name IN ["Виолетта"] AND other.name <> me.name MERGE (me)-[follow:knew]->(other) SET follow.tyre_help='помогает' RETURN follow
// задаем тип связи - 'нравится' для: 'Дайна'
MATCH (person:people { name: 'Дайна' })  MATCH (human:people) WHERE human.name IN ["Влас", "Зиновий", "Артемий", "Валентин", "Логгин", "Харитон", "Виолетта", "Иван", "Влас", "Феоктист", "Гордей"] AND human.name <> person.name MERGE (person)-[r:knew]->(human) SET r.tyre_like='нравится' RETURN r
// задаем тип связи - 'любит' для: 'Дайна'
MATCH (temporary:people { name: 'Дайна' })  MATCH (me:people) WHERE me.name IN ["Харитон"] AND me.name <> temporary.name MERGE (temporary)-[r:knew]->(me) SET r.tyre_love='любит' RETURN r
// задаем тип связи - 'нравится' для: 'Логгин'
MATCH (temporary:people) WHERE temporary.name = 'Логгин' MATCH (me:people) WHERE me.name IN ["Дайна", "Виолетта", "Иван", "Влас"] AND me.name <> temporary.name MERGE (temporary)-[k:knew]->(me) SET k.tyre_like='нравится' RETURN k
// задаем тип связи - 'дружат' для: 'Логгин'
MATCH (person:people) WHERE person.name = 'Логгин' MATCH (human:people) WHERE human.name IN ["Влас"] AND human.name <> person.name MERGE (person)-[u:knew]->(human) SET u.tyre_be_friends='дружат' RETURN u
// задаем тип связи - 'должен' для: 'Логгин'
MATCH (temp:people) WHERE temp.name = 'Логгин' MATCH (temporary:people) WHERE temporary.name IN ["Влас"] AND temporary.name <> temp.name MERGE (temp)-[relation:knew]->(temporary) SET relation.tyre_loan='должен' RETURN relation
// задаем тип связи - 'угрожает' для: 'Логгин'
MATCH (a:people { name: 'Логгин' })  MATCH (b:people) WHERE b.name IN ["Влас"] AND b.name <> a.name MERGE (a)-[r:knew]->(b) SET r.tyre_criminal='угрожает' RETURN r
// задаем тип связи - 'нравится' для: 'Харитон'
MATCH (me:people) WHERE me.name = 'Харитон' MATCH (other:people) WHERE other.name IN ["Валентин", "Дайна"] AND other.name <> me.name MERGE (me)-[k:knew]->(other) SET k.tyre_like='нравится' RETURN k
// задаем тип связи - 'дружат' для: 'Харитон'
MATCH (e:people { name: 'Харитон' })  MATCH (f:people) WHERE f.name IN ["Валентин"] AND f.name <> e.name MERGE (e)-[relationship:knew]->(f) SET relationship.tyre_be_friends='дружат' RETURN relationship
// задаем тип связи - 'любит' для: 'Харитон'
MATCH (e:people) WHERE e.name = 'Харитон' MATCH (f:people) WHERE f.name IN ["Дайна"] AND f.name <> e.name MERGE (e)-[to:knew]->(f) SET to.tyre_love='любит' RETURN to
// задаем тип связи - 'нравится' для: 'Виолетта'
MATCH (me:people { name: 'Виолетта' })  MATCH (other:people) WHERE other.name IN ["Харитон", "Иван", "Феоктист"] AND other.name <> me.name MERGE (me)-[to:knew]->(other) SET to.tyre_like='нравится' RETURN to
// задаем тип связи - 'любит' для: 'Виолетта'
MATCH (f:people { name: 'Виолетта' })  MATCH (x:people) WHERE x.name IN ["Харитон"] AND x.name <> f.name MERGE (f)-[to:knew]->(x) SET to.tyre_love='любит' RETURN to
// задаем тип связи - 'ненавидит' для: 'Виолетта'
MATCH (a:people { name: 'Виолетта' })  MATCH (b:people) WHERE b.name IN ["Дайна"] AND b.name <> a.name MERGE (a)-[r:knew]->(b) SET r.tyre_hate='ненавидит' RETURN r
// задаем тип связи - 'нравится' для: 'Иван'
MATCH (person:people { name: 'Иван' })  MATCH (human:people) WHERE human.name IN ["Дайна", "Гордей"] AND human.name <> person.name MERGE (person)-[k:knew]->(human) SET k.tyre_like='нравится' RETURN k
// задаем тип связи - 'любит' для: 'Иван'
MATCH (other:people) WHERE other.name = 'Иван' MATCH (person:people) WHERE person.name IN ["Дайна"] AND person.name <> other.name MERGE (other)-[follow:knew]->(person) SET follow.tyre_love='любит' RETURN follow
// задаем тип связи - 'должен' для: 'Иван'
MATCH (person:people { name: 'Иван' })  MATCH (human:people) WHERE human.name IN ["Гордей"] AND human.name <> person.name MERGE (person)-[follow:knew]->(human) SET follow.tyre_loan='должен' RETURN follow
// задаем тип связи - 'помогает' для: 'Иван'
MATCH (person:people) WHERE person.name = 'Иван' MATCH (human:people) WHERE human.name IN ["Гордей"] AND human.name <> person.name MERGE (person)-[rel:knew]->(human) SET rel.tyre_help='помогает' RETURN rel
// задаем тип связи - 'нравится' для: 'Влас'
MATCH (human:people { name: 'Влас' })  MATCH (man:people) WHERE man.name IN ["Дайна", "Логгин", "Виолетта"] AND man.name <> human.name MERGE (human)-[to:knew]->(man) SET to.tyre_like='нравится' RETURN to
// задаем тип связи - 'дружат' для: 'Влас'
MATCH (human:people) WHERE human.name = 'Влас' MATCH (man:people) WHERE man.name IN ["Логгин"] AND man.name <> human.name MERGE (human)-[u:knew]->(man) SET u.tyre_be_friends='дружат' RETURN u
// задаем тип связи - 'любит' для: 'Влас'
MATCH (a:people { name: 'Влас' })  MATCH (b:people) WHERE b.name IN ["Дайна"] AND b.name <> a.name MERGE (a)-[relationship:knew]->(b) SET relationship.tyre_love='любит' RETURN relationship
// задаем тип связи - 'нравится' для: 'Феоктист'
MATCH (f:people { name: 'Феоктист' })  MATCH (x:people) WHERE x.name IN ["Артемий", "Дайна"] AND x.name <> f.name MERGE (f)-[relation:knew]->(x) SET relation.tyre_like='нравится' RETURN relation
// задаем тип связи - 'любит' для: 'Феоктист'
MATCH (me:people) WHERE me.name = 'Феоктист' MATCH (other:people) WHERE other.name IN ["Дайна"] AND other.name <> me.name MERGE (me)-[k:knew]->(other) SET k.tyre_love='любит' RETURN k
// задаем тип связи - 'нравится' для: 'Гордей'
MATCH (human:people { name: 'Гордей' })  MATCH (man:people) WHERE man.name IN ["Дайна", "Харитон", "Виолетта"] AND man.name <> human.name MERGE (human)-[k:knew]->(man) SET k.tyre_like='нравится' RETURN k
// проверка команд
MATCH (f:people)  MATCH (temporary:people {name: 'Зиновий'})  MATCH (f) - [relation:knew  { tyre_like: 'нравится' }] -> (temporary) RETURN count(relation)
MATCH (x:people)  MATCH (c:people) WHERE x.name IN ['Артемий', 'Логгин', 'Харитон', 'Виолетта', 'Иван', 'Влас', 'Феоктист', 'Гордей'] MATCH (x) - [relation:knew  { tyre_dislike: 'не любит' }] -> (c) RETURN count(relation)
MATCH (other:people)  MATCH path=(other:people) - [relation:knew*2] -> (man:people) RETURN path
MATCH (me:people) WHERE me.name IN ['Артемий', 'Логгин', 'Харитон', 'Виолетта', 'Влас', 'Феоктист'] RETURN me
MATCH (c:people {name: 'Дайна'}) WHERE c.name IN ['Влас', 'Артемий', 'Валентин', 'Логгин', 'Харитон', 'Виолетта', 'Иван', 'Гордей'] RETURN c
MATCH (man:people {name: 'Влас'}) WHERE man.name IN ['Валентин', 'Логгин', 'Иван'] RETURN man
MATCH (man:people)  MATCH (temporary:people {name: 'Логгин'})  MATCH (man) - [k:knew  { tyre_be_friends: 'дружат' }] -> (temporary) RETURN count(k)
MATCH (d:people {name: 'Зиновий'})  RETURN d
MATCH (x:people)  MATCH (man:people) WHERE x.name IN ['Зиновий', 'Валентин', 'Дайна', 'Харитон', 'Иван', 'Влас'] MATCH (x) - [relationship:knew  { tyre_loan: 'должен' }] -> (man) RETURN count(relationship)
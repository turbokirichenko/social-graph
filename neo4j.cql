// создаем группу людей
CREATE (some:PEOPLE {name: "Поликарп (имя)", city: "Южно-Сахалинск"});
CREATE (other:PEOPLE {name: "Савва", city: "Кемерово"});
CREATE (other:PEOPLE {name: "Тит", city: "Брянск"});
CREATE (some:PEOPLE {name: "Сильвестр (имя)", city: "Нальчик"});
CREATE (temp:PEOPLE {name: "Доля", city: "Элиста"});
CREATE (f:PEOPLE {name: "Данакт", city: "Мурманск"});
CREATE (b:PEOPLE {name: "Иннокентий", city: "Томск"});
CREATE (x:PEOPLE {name: "Рузиля", city: "Тула"});
CREATE (me:PEOPLE {name: "Влас", city: "Ярославль"});
CREATE (person:PEOPLE {name: "Тихон", city: "Санкт-Петербург"});
CREATE (human:PEOPLE {name: "Аникита", city: "Калининград"});
CREATE (other:PEOPLE {name: "Аристарх", city: "Владимир"});
// создаем связь 'знает'
MATCH (one:PEOPLE) WHERE one.name = 'Поликарп (имя)' MATCH (some:PEOPLE) WHERE some.name <> one.name MERGE (one)-[r:KNOWS]->(some) RETURN count(r);
MATCH (some:PEOPLE) WHERE some.name = 'Савва' MATCH (a:PEOPLE) WHERE a.name <> some.name MERGE (some)-[r:KNOWS]->(a) RETURN count(r);
MATCH (temporary:PEOPLE) WHERE temporary.name = 'Тит' MATCH (me:PEOPLE) WHERE me.name <> temporary.name MERGE (temporary)-[u:KNOWS]->(me) RETURN count(u);
MATCH (x:PEOPLE) WHERE x.name = 'Сильвестр (имя)' MATCH (temp:PEOPLE) WHERE temp.name <> x.name MERGE (x)-[rel:KNOWS]->(temp) RETURN count(rel);
MATCH (other:PEOPLE) WHERE other.name = 'Доля' MATCH (person:PEOPLE) WHERE person.name <> other.name MERGE (other)-[follow:KNOWS]->(person) RETURN count(follow);
MATCH (temporary:PEOPLE) WHERE temporary.name = 'Данакт' MATCH (me:PEOPLE) WHERE me.name <> temporary.name MERGE (temporary)-[relationship:KNOWS]->(me) RETURN count(relationship);
MATCH (f:PEOPLE) WHERE f.name = 'Иннокентий' MATCH (x:PEOPLE) WHERE x.name <> f.name MERGE (f)-[k:KNOWS]->(x) RETURN count(k);
MATCH (d:PEOPLE) WHERE d.name = 'Рузиля' MATCH (e:PEOPLE) WHERE e.name <> d.name MERGE (d)-[rel:KNOWS]->(e) RETURN count(rel);
MATCH (b:PEOPLE) WHERE b.name = 'Влас' MATCH (c:PEOPLE) WHERE c.name <> b.name MERGE (b)-[relationship:KNOWS]->(c) RETURN count(relationship);
MATCH (other:PEOPLE) WHERE other.name = 'Тихон' MATCH (person:PEOPLE) WHERE person.name <> other.name MERGE (other)-[relationship:KNOWS]->(person) RETURN count(relationship);
MATCH (human:PEOPLE) WHERE human.name = 'Аникита' MATCH (one:PEOPLE) WHERE one.name <> human.name MERGE (human)-[rel:KNOWS]->(one) RETURN count(rel);
MATCH (b:PEOPLE) WHERE b.name = 'Аристарх' MATCH (c:PEOPLE) WHERE c.name <> b.name MERGE (b)-[relationship:KNOWS]->(c) RETURN count(relationship);
// проверка команд
MATCH (temp:PEOPLE {name: 'Аникита'})  MATCH (human:PEOPLE {name: 'Иннокентий'}) WHERE temp.name IN ['Поликарп (имя)', 'Тит', 'Сильвестр (имя)', 'Доля', 'Иннокентий', 'Влас'] MATCH (temp) - [follow:KNOWS] -> (human) RETURN count(follow);
MATCH (c:PEOPLE {name: 'Тит'})  MATCH (x:PEOPLE {name: 'Аникита'})  MATCH (c) - [u:KNOWS] -> (x) RETURN count(u);
MATCH (person:PEOPLE {name: 'Савва'})  MATCH (me:PEOPLE) WHERE person.name IN ['Данакт', 'Рузиля', 'Аникита', 'Аристарх'] MATCH (person) - [follow:KNOWS] -> (me) RETURN count(follow);
MATCH (e:PEOPLE)  MATCH path=(e:PEOPLE) - [r:KNOWS*2] -> (c:PEOPLE {name: 'Доля'}) RETURN path;
MATCH (temporary:PEOPLE)  RETURN temporary;
MATCH (temporary:PEOPLE)  MATCH path=(temporary:PEOPLE) - [r:KNOWS*2] -> (human:PEOPLE) RETURN path;
MATCH (a:PEOPLE {name: 'Тит'}) WHERE a.name IN ['Поликарп (имя)', 'Данакт'] RETURN a;
// задаем тип связи - 'нравится'
MATCH (me:PEOPLE { name: 'Поликарп (имя)' })  MATCH (other:PEOPLE) WHERE other.name IN ["Тит", "Доля", "Рузиля"] AND other.name <> me.name MERGE (me)-[relation:KNOWS]->(other) SET relation.tyre_like='нравится' RETURN relation;
MATCH (x:PEOPLE) WHERE x.name = 'Савва' MATCH (temp:PEOPLE) WHERE temp.name IN ["Сильвестр (имя)", "Доля", "Рузиля"] AND temp.name <> x.name MERGE (x)-[follow:KNOWS]->(temp) SET follow.tyre_like='нравится' RETURN follow;
MATCH (x:PEOPLE { name: 'Тит' })  MATCH (temp:PEOPLE) WHERE temp.name IN ["Доля", "Данакт", "Рузиля"] AND temp.name <> x.name MERGE (x)-[u:KNOWS]->(temp) SET u.tyre_like='нравится' RETURN u;
MATCH (some:PEOPLE { name: 'Сильвестр (имя)' })  MATCH (a:PEOPLE) WHERE a.name IN ["Савва", "Доля", "Иннокентий", "Рузиля"] AND a.name <> some.name MERGE (some)-[follow:KNOWS]->(a) SET follow.tyre_like='нравится' RETURN follow;
MATCH (c:PEOPLE) WHERE c.name = 'Доля' MATCH (d:PEOPLE) WHERE d.name IN ["Поликарп (имя)", "Савва", "Тит", "Сильвестр (имя)", "Данакт", "Иннокентий", "Рузиля", "Влас", "Тихон", "Аникита", "Аристарх"] AND d.name <> c.name MERGE (c)-[rel:KNOWS]->(d) SET rel.tyre_like='нравится' RETURN rel;
MATCH (human:PEOPLE) WHERE human.name = 'Данакт' MATCH (one:PEOPLE) WHERE one.name IN ["Доля", "Рузиля", "Влас", "Тихон"] AND one.name <> human.name MERGE (human)-[rel:KNOWS]->(one) SET rel.tyre_like='нравится' RETURN rel;
MATCH (c:PEOPLE { name: 'Иннокентий' })  MATCH (d:PEOPLE) WHERE d.name IN ["Сильвестр (имя)", "Доля"] AND d.name <> c.name MERGE (c)-[to:KNOWS]->(d) SET to.tyre_like='нравится' RETURN to;
MATCH (temporary:PEOPLE) WHERE temporary.name = 'Рузиля' MATCH (me:PEOPLE) WHERE me.name IN ["Иннокентий", "Влас", "Аникита"] AND me.name <> temporary.name MERGE (temporary)-[u:KNOWS]->(me) SET u.tyre_like='нравится' RETURN u;
MATCH (other:PEOPLE) WHERE other.name = 'Влас' MATCH (person:PEOPLE) WHERE person.name IN ["Доля", "Аристарх"] AND person.name <> other.name MERGE (other)-[relation:KNOWS]->(person) SET relation.tyre_like='нравится' RETURN relation;
MATCH (some:PEOPLE { name: 'Тихон' })  MATCH (a:PEOPLE) WHERE a.name IN ["Доля", "Данакт", "Рузиля"] AND a.name <> some.name MERGE (some)-[relation:KNOWS]->(a) SET relation.tyre_like='нравится' RETURN relation;
MATCH (f:PEOPLE) WHERE f.name = 'Аникита' MATCH (x:PEOPLE) WHERE x.name IN ["Тит", "Доля"] AND x.name <> f.name MERGE (f)-[rel:KNOWS]->(x) SET rel.tyre_like='нравится' RETURN rel;
MATCH (temp:PEOPLE) WHERE temp.name = 'Аристарх' MATCH (temporary:PEOPLE) WHERE temporary.name IN ["Доля", "Иннокентий", "Рузиля"] AND temporary.name <> temp.name MERGE (temp)-[r:KNOWS]->(temporary) SET r.tyre_like='нравится' RETURN r;
// задаем тип связи - 'дружат'
MATCH (some:PEOPLE) WHERE some.name = 'Савва' MATCH (a:PEOPLE) WHERE a.name IN ["Сильвестр (имя)"] AND a.name <> some.name MERGE (some)-[u:KNOWS]->(a) SET u.tyre_be_friends='дружат' RETURN u;
MATCH (f:PEOPLE) WHERE f.name = 'Сильвестр (имя)' MATCH (x:PEOPLE) WHERE x.name IN ["Савва", "Иннокентий"] AND x.name <> f.name MERGE (f)-[r:KNOWS]->(x) SET r.tyre_be_friends='дружат' RETURN r;
MATCH (me:PEOPLE { name: 'Данакт' })  MATCH (other:PEOPLE) WHERE other.name IN ["Тихон"] AND other.name <> me.name MERGE (me)-[relation:KNOWS]->(other) SET relation.tyre_be_friends='дружат' RETURN relation;
MATCH (some:PEOPLE) WHERE some.name = 'Иннокентий' MATCH (a:PEOPLE) WHERE a.name IN ["Сильвестр (имя)"] AND a.name <> some.name MERGE (some)-[relation:KNOWS]->(a) SET relation.tyre_be_friends='дружат' RETURN relation;
MATCH (temp:PEOPLE { name: 'Тихон' })  MATCH (temporary:PEOPLE) WHERE temporary.name IN ["Данакт"] AND temporary.name <> temp.name MERGE (temp)-[k:KNOWS]->(temporary) SET k.tyre_be_friends='дружат' RETURN k;
// задаем тип связи - 'любит'
MATCH (me:PEOPLE) WHERE me.name = 'Поликарп (имя)' MATCH (other:PEOPLE) WHERE other.name IN ["Доля"] AND other.name <> me.name MERGE (me)-[follow:KNOWS]->(other) SET follow.tyre_love='любит' RETURN follow;
MATCH (some:PEOPLE) WHERE some.name = 'Савва' MATCH (a:PEOPLE) WHERE a.name IN ["Рузиля"] AND a.name <> some.name MERGE (some)-[follow:KNOWS]->(a) SET follow.tyre_love='любит' RETURN follow;
MATCH (c:PEOPLE) WHERE c.name = 'Тит' MATCH (d:PEOPLE) WHERE d.name IN ["Доля"] AND d.name <> c.name MERGE (c)-[relation:KNOWS]->(d) SET relation.tyre_love='любит' RETURN relation;
MATCH (temp:PEOPLE) WHERE temp.name = 'Сильвестр (имя)' MATCH (temporary:PEOPLE) WHERE temporary.name IN ["Рузиля"] AND temporary.name <> temp.name MERGE (temp)-[r:KNOWS]->(temporary) SET r.tyre_love='любит' RETURN r;
MATCH (e:PEOPLE) WHERE e.name = 'Доля' MATCH (f:PEOPLE) WHERE f.name IN ["Иннокентий"] AND f.name <> e.name MERGE (e)-[k:KNOWS]->(f) SET k.tyre_love='любит' RETURN k;
MATCH (human:PEOPLE { name: 'Иннокентий' })  MATCH (one:PEOPLE) WHERE one.name IN ["Доля"] AND one.name <> human.name MERGE (human)-[relationship:KNOWS]->(one) SET relationship.tyre_love='любит' RETURN relationship;
MATCH (c:PEOPLE { name: 'Рузиля' })  MATCH (d:PEOPLE) WHERE d.name IN ["Иннокентий"] AND d.name <> c.name MERGE (c)-[rel:KNOWS]->(d) SET rel.tyre_love='любит' RETURN rel;
MATCH (human:PEOPLE) WHERE human.name = 'Влас' MATCH (one:PEOPLE) WHERE one.name IN ["Доля"] AND one.name <> human.name MERGE (human)-[rel:KNOWS]->(one) SET rel.tyre_love='любит' RETURN rel;
MATCH (b:PEOPLE { name: 'Тихон' })  MATCH (c:PEOPLE) WHERE c.name IN ["Доля"] AND c.name <> b.name MERGE (b)-[relationship:KNOWS]->(c) SET relationship.tyre_love='любит' RETURN relationship;
MATCH (a:PEOPLE) WHERE a.name = 'Аникита' MATCH (b:PEOPLE) WHERE b.name IN ["Доля"] AND b.name <> a.name MERGE (a)-[relation:KNOWS]->(b) SET relation.tyre_love='любит' RETURN relation;
// задаем тип связи - 'не любит'
MATCH (person:PEOPLE) WHERE person.name = 'Савва' MATCH (human:PEOPLE) WHERE human.name IN ["Иннокентий", "Влас", "Аникита"] AND human.name <> person.name MERGE (person)-[relationship:KNOWS]->(human) SET relationship.tyre_dislike='не любит' RETURN relationship;
MATCH (human:PEOPLE) WHERE human.name = 'Сильвестр (имя)' MATCH (one:PEOPLE) WHERE one.name IN ["Иннокентий", "Влас", "Аникита"] AND one.name <> human.name MERGE (human)-[k:KNOWS]->(one) SET k.tyre_dislike='не любит' RETURN k;
// задаем тип связи - 'ненавидит'
MATCH (other:PEOPLE) WHERE other.name = 'Рузиля' MATCH (person:PEOPLE) WHERE person.name IN ["Доля"] AND person.name <> other.name MERGE (other)-[relationship:KNOWS]->(person) SET relationship.tyre_hate='ненавидит' RETURN relationship;
// задаем тип связи - 'враждует с'
MATCH (human:PEOPLE) WHERE human.name = 'Савва' MATCH (one:PEOPLE) WHERE one.name IN ["Иннокентий"] AND one.name <> human.name MERGE (human)-[u:KNOWS]->(one) SET u.tyre_feud='враждует с' RETURN u;
MATCH (x:PEOPLE { name: 'Сильвестр (имя)' })  MATCH (temp:PEOPLE) WHERE temp.name IN ["Аникита"] AND temp.name <> x.name MERGE (x)-[k:KNOWS]->(temp) SET k.tyre_feud='враждует с' RETURN k;
// задаем тип связи - 'должен'
MATCH (e:PEOPLE) WHERE e.name = 'Савва' MATCH (f:PEOPLE) WHERE f.name IN ["Сильвестр (имя)"] AND f.name <> e.name MERGE (e)-[follow:KNOWS]->(f) SET follow.tyre_loan='должен' RETURN follow;
MATCH (one:PEOPLE) WHERE one.name = 'Данакт' MATCH (some:PEOPLE) WHERE some.name IN ["Тихон"] AND some.name <> one.name MERGE (one)-[follow:KNOWS]->(some) SET follow.tyre_loan='должен' RETURN follow;
MATCH (some:PEOPLE) WHERE some.name = 'Влас' MATCH (a:PEOPLE) WHERE a.name IN ["Аристарх"] AND a.name <> some.name MERGE (some)-[u:KNOWS]->(a) SET u.tyre_loan='должен' RETURN u;
// задаем тип связи - 'помогает'
MATCH (f:PEOPLE) WHERE f.name = 'Савва' MATCH (x:PEOPLE) WHERE x.name IN ["Рузиля"] AND x.name <> f.name MERGE (f)-[r:KNOWS]->(x) SET r.tyre_help='помогает' RETURN r;
MATCH (x:PEOPLE { name: 'Сильвестр (имя)' })  MATCH (temp:PEOPLE) WHERE temp.name IN ["Рузиля"] AND temp.name <> x.name MERGE (x)-[follow:KNOWS]->(temp) SET follow.tyre_help='помогает' RETURN follow;
MATCH (temp:PEOPLE) WHERE temp.name = 'Влас' MATCH (temporary:PEOPLE) WHERE temporary.name IN ["Аристарх"] AND temporary.name <> temp.name MERGE (temp)-[relation:KNOWS]->(temporary) SET relation.tyre_help='помогает' RETURN relation;
// задаем тип связи - 'угрожает'
MATCH (x:PEOPLE) WHERE x.name = 'Данакт' MATCH (temp:PEOPLE) WHERE temp.name IN ["Тихон"] AND temp.name <> x.name MERGE (x)-[follow:KNOWS]->(temp) SET follow.tyre_criminal='угрожает' RETURN follow;
// проверка команд
MATCH (f:PEOPLE {name: 'Доля'})  MATCH path=(f:PEOPLE {name: 'Доля'}) - [relationship:KNOWS*2] -> (temporary:PEOPLE) RETURN path;
MATCH (temporary:PEOPLE)  RETURN temporary;
MATCH (f:PEOPLE) WHERE f.name IN ['Сильвестр (имя)', 'Доля', 'Данакт', 'Иннокентий', 'Рузиля', 'Тихон', 'Аристарх'] RETURN f;
MATCH (e:PEOPLE {name: 'Иннокентий'})  MATCH path=(e:PEOPLE {name: 'Иннокентий'}) - [follow:KNOWS*2] -> (person:PEOPLE) RETURN path;
MATCH (e:PEOPLE)  RETURN e;
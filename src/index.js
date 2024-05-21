var neo4jconnection = require('./utils/neo4j');
var { createNode, setTheyKnowMe, setRelationTypeByCondition, matchForRelation, matchForRelationX2, matchForNode } = require('./domain');
var graph = require('./utils/json-parse')();
console.log('[INFO]: loaded graph');
var fs = require('fs');

const { driver, session } = neo4jconnection();

const rnd = (len) => Math.floor(Math.random()*len);
const toLowerCase = (str) => str.toLowerCase();
const toUpperCase = (str) => str.toUpperCase();

const typeNames = ['people', 'human', 'person'];
const relationNames = ['knows', 'communicating']
const toSomeCase = Boolean(rnd(2)) ? toLowerCase : toUpperCase;

const variant = {
    type: toSomeCase(typeNames[rnd(typeNames.length)]),
    temp: ['a', 'b', 'c', 'd', 'e', 'f', 'x', 'temp', 'temporary', 'me', 'other', 'person', 'human', 'one', 'some'],
    relationName: toSomeCase(relationNames[rnd(relationNames.length)]),
    relationTemp: ['r', 'k', 'u', 'rel', 'relation', 'relationship', 'follow', 'to'],
    pathTemp: ['path', 'p', 'trek'],
}

const local = {
    "like": "нравится",
    "be_friends": "дружат",
    "love": "любит",
    "dislike": "не любит",
    "hate": "ненавидит",
    "feud": "враждует с",
    "loan": "должен",
    "help": "помогает",
    "criminal": "угрожает"
}

async function attempts(tx, nums = 8, with_relation_types = false) {
    const localHistory = [];
    const rndNum = rnd(nums - Math.floor(nums/2)) + Math.floor(nums/2);
    for (let count = 0; count < rndNum; ++count) {
        try {
            const local_key = Object.keys(local)[rnd(Object.keys(local).length)];
            const relation = {
                temp: variant.relationTemp[rnd(variant.relationTemp.length)],
                name: variant.relationName,
                type: local_key
            }
            const node = {
                temp: variant.temp[rnd(variant.temp.length)],
                type: variant.type,
                obj: Boolean(rnd(2)) ? `{name: '${graph.nodes[rnd(graph.nodes.length)].name}'}` : '',
            }
            const node2 = {
                temp: variant.temp[rnd(variant.temp.length)],
                type: variant.type,
                obj: Boolean(rnd(2)) ? `{name: '${graph.nodes[rnd(graph.nodes.length)].name}'}` : '',
            }
            const someNames = graph.nodes
                .filter(() => Boolean(rnd(2)))
                .map(node => node.name);
            const where = Boolean(rnd(2)) ? '' : `${node.temp}.name IN ['${someNames.join("', '")}']`;
            const relationObj = with_relation_types ? ` { tyre_${relation.type}: '${local[relation.type]}' }` : '';
            const usableCommands = [
                matchForRelation(relation, node, node2, '', where, relationObj),
                matchForRelationX2('path', relation, node, node2, ''),
                matchForNode(node.type, node.temp, node.obj, where),
            ]
            const num = rnd(usableCommands.length);
            const command = usableCommands[num];
            const result = await tx.run(command);
            localHistory.push(command);
        } catch (err) {
            console.error('[ERROR]: Not executed command!!! [check 1]', err);
            throw err;
        }
    }
    return localHistory;
}

async function main() {
    console.log('[INFO]: connected to neo4j database');
    const history = await session.executeWrite(async (tx) => {
        console.log('[INFO]: begin transaction');
        const localHistory = [];
        // create
        localHistory.push('// создаем группу людей');
        for (const node of graph.nodes) {
            try {
                const obj = `{name: "${node.name}", city: "${node.region}"}`;
                const rnd = Math.floor(Math.random()*variant.temp.length);
                const command = createNode(variant.type, variant.temp[rnd], obj);
                var result = await tx.run(command)
                localHistory.push(command);
            } catch (err) {
                console.error('[ERROR]: Not executed command!!! [part 1]', err);
                console.log('[INFO]: rollback transaction');
                throw err;
            }
        }
        console.log('[INFO]: creating nodes ...');
        localHistory.push("// создаем связь 'знает'");
        // create relations
        for (const node of graph.nodes) {
            try {
                const rnd = Math.floor(Math.random()*variant.temp.length);
                const rnd2 = (rnd + 1)%variant.temp.length;
                const rnd3 = Math.floor(Math.random()*variant.relationTemp.length);
                const a = variant.temp[rnd];
                const b = variant.temp[rnd2];
                const r = variant.relationTemp[rnd3];
                const rn = variant.relationName
                const command = setTheyKnowMe(variant.type, a, '', `${a}.name = '${node.name}'`, b, '', `${b}.name <> ${a}.name`, r, rn);
                const result = await tx.run(command);
                localHistory.push(command);
            } catch (err) {
                console.error('[ERROR]: Not executed command!!! [part 2]', err)
                console.log('[INFO]: rollback transaction');
                throw err;
            }
        }
        console.log('[INFO]: checking result ... ');
        localHistory.push("// проверка команд");
        localHistory.push(...(await attempts(tx, 10)));
        console.log('[INFO]: checked');
        // create types
        // let count = 0;
        for (const relationType of Object.keys(local)) {
            let localSubject = local[relationType];
            let count = 0;
            localHistory.push(`// задаем тип связи - '${localSubject}'`);
            for (const relation of graph.knows) {
                // continue, if relation type is empty
                if (!(relationType in relation) || !relation[relationType]) {
                    count++;
                    continue;
                }
                // relation
                const rs = {
                    temp: variant.relationTemp[rnd(variant.relationTemp.length)],
                    name: variant.relationName,
                    type: relationType
                }
                // node1
                const tempRnd = rnd(variant.temp.length);
                const node1Name = graph.nodes[count].name;
                const withObj = Boolean(Math.floor(Math.random() + 0.5)%2);
                const node1 = {
                    temp: variant.temp[tempRnd],
                    type: variant.type,
                    obj: withObj ? `{ name: '${node1Name}' }` : '',
                };
                // node2
                const node2 = {
                    temp: variant.temp[(tempRnd+1)%variant.temp.length],
                    type: variant.type,
                    obj: '',
                }
                // other name
                const otherNames = relation[relationType].map((link) => {
                    const index= link - 1;
                    return graph.nodes[index].name;
                });
                // set where
                const whr1 = withObj ? '' : `${node1.temp}.name = '${node1Name}'`;
                const whr2 = `${node2.temp}.name IN ["${otherNames.join('", "')}"] AND ${node2.temp}.name <> ${node1.temp}.name`;
                const subject = localSubject;
                // create command
                const command = setRelationTypeByCondition(rs, node1, node2, whr1, whr2, subject);
                const result = await tx.run(command);
                localHistory.push(command);
                count++;
            }
        }
        console.log('[INFO]: finish determinated types of relations');
        console.log('[INFO]: checking result ...')
        localHistory.push("// проверка команд");
        localHistory.push(...(await attempts(tx, 10, true)));
        console.log('[INFO]: checked');
        console.log('[INFO]: commiting transaction ...');
        return localHistory;
    })
    console.log('[INFO]: history is ready ...');
    driver.close().then(() => console.log('[INFO]: connection is closed'));
    console.log('[INFO]: writing history to file "./neo4j.cql" ...')
    fs.writeFileSync(process.cwd()+'/neo4j.cql', history.join('\n'));
}

main();
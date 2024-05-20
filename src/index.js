var neo4jconnection = require('./utils/neo4j');
var { create, match, mergeRelation, returnResult, setRelationType } = require('./constants/commands.template');
var graph = require('./utils/json-parse')();

const { driver, session } = neo4jconnection();

const rnd = (len) => Math.floor(Math.random()*len);

const typeNames = ['People', 'Human', 'Men', 'Person', 'Man', 'Folk'];
const relationNames = ['KNOWN', 'KNOWS', 'knows', 'knew', 'KNEW', 'familiar']

const variant = {
    type: typeNames[rnd(typeNames.length)],
    temp: ['a', 'b', 'c', 'd', 'e', 'f', 'temp', 'temporary', 'name', 'me', 'other', 'person', 'human', 'man', 'some'],
    relationName: relationNames[rnd(relationNames.length)],
    relationTemp: ['r', 'k', 'u', 'rel', 'relation', 'relationship', 'super', 'follow', 'to'],
    pathTemp: ['path', 'p', 'hyper'],
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

/**
 * 
 * @param {*} type 
 * @param {*} me 
 * @param {*} object 
 * @param {*} whereForMe 
 * @param {*} other 
 * @param {*} otherObject 
 * @param {*} whereForOther 
 * @param {*} relation 
 * @param {*} relationName 
 * @returns 
 */
const setTheyKnowMe = (type, me, object, whereForMe, other, otherObject, whereForOther, relation, relationName) => 
    match(type, me, object, whereForMe) +
    match(type, other, otherObject, whereForOther) + 
    mergeRelation(relation, relationName, me, other) +
    returnResult([`count(${relation})`]);

/** создает тип для отношения по усовиям
 * 
 * @param {{temp: string, type: string, name: string }} relation 
 * @param {{temp: string, type: string, obj: any}} node1 
 * @param {{temp: string, type: string, obj: any}} node2 
 * @param {{string}} whereForNode1 
 * @param {{string}} whereForNode2 
 * @param {{string}} relationSubject 
 * @returns 
 */
const setRelationTypeByCondition = (relation, node1, node2, whereForNode1, whereForNode2, relationSubject) => 
    match(node1.type, node1.temp, node1.obj, whereForNode1) +
    match(node2.type, node2.temp, node2.obj, whereForNode2) +
    mergeRelation(relation.temp, relation.name, node1.temp, node2.temp) +
    setRelationType(relation.temp, relation.type, relationSubject) +
    returnResult([`${relation.temp}`])

async function main() {
    const history = await session.executeWrite(async (tx) => {
        const localHistory = [];
        // create
        for (const node of graph.nodes) {
            try {
                const obj = `{name: "${node.name}", city: "${node.region}"}`;
                const rnd = Math.floor(Math.random()*variant.temp.length);
                const command = create(variant.type, variant.temp[rnd], obj);
                var result = await tx.run(command)
                localHistory.push(command);
            } catch (err) {
                console.error('[ERROR]: Not executed command!!! [part 1]', err)
                throw err;
            }
        }

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
                throw err;
            }
        }

        // create types
        let count = 0;
        for (const relation of graph.knows) {
            for (const key of Object.keys(relation)) {
                const withObj = Boolean(Math.floor(Math.random() + 0.5)%2);
                const rs = {
                    temp: variant.relationTemp[rnd(variant.relationTemp.length)],
                    name: variant.relationName,
                    type: key
                }
                const tempRnd = rnd(variant.temp.length);
                const node1Name = graph.nodes[count].name;
                const node1 = {
                    temp: variant.temp[tempRnd],
                    type: variant.type,
                    obj: withObj ? `{ name: '${node1Name}' }` : '',
                };
                const node2 = {
                    temp: variant.temp[(tempRnd+1)%variant.temp.length],
                    type: variant.type,
                    obj: '',
                }
                const otherNames = relation[key].map((link) => {
                    const index= link - 1;
                    return graph.nodes[index].name;
                });
                const whr1 = withObj ? '' : `${node1.temp}.name = '${node1Name}'`;
                const whr2 = `${node2.temp}.name IN ["${otherNames.join('", "')}"] AND ${node2.temp}.name <> ${node1.temp}.name`;
                const subject = local[key];
                const command = setRelationTypeByCondition(rs, node1, node2, whr1, whr2, subject);
                const result = await tx.run(command);
                localHistory.push(command);
            }
            count++;
        }

        return localHistory;
    })
    console.log(history);
    driver.close().then(() => console.log('close connection'));
}

main();
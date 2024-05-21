var { create, match, mergeRelation, matchRelation, returnResult, setRelationType, matchPath } = require('./constants/commands.template');

/** create node query
 * 
 * @param {*} type 
 * @param {*} variable 
 * @param {*} obj 
 * @returns 
 */
const createNode = (type, variable, obj) =>
    create(type, variable, obj) + ';'

/**
 * 
 * @param {*} type 
 * @param {*} temp 
 * @param {*} obj 
 * @param {*} whr 
 * @returns 
 */
const matchForNode = (type, temp, obj, whr) => 
    match(type, temp, obj, whr) + 
    returnResult([temp]) + ';'

/**
 * 
 * @param {*} rel 
 * @param {*} node1 
 * @param {*} node2 
 * @param {*} whr1 
 * @param {*} whr2 
 * @returns 
 */
const matchForRelation = (rel, node1, node2, whr1, whr2, relObj = '') => 
    match(node1.type, node1.temp, node1.obj, whr1) +
    match(node2.type, node2.temp, node2.obj, whr2) +
    matchPath('', rel.temp, `${rel.name}${relObj && ' '+relObj}`, { temp: node1.temp }, { temp: node2.temp }, '') +
    returnResult([`count(${rel.temp})`]) + ';';

/**
 * 
 * @returns 
 */
const matchForRelationX2 = (path, relation, node, node2, where) =>
    match(node.type, node.temp, node.obj, where) +
    matchPath(path, relation.temp, `${relation.name}*2`, node, node2, where) +
    returnResult([path]) + ';';


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
    returnResult([`count(${relation})`]) + ';';

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
    returnResult([`${relation.temp}`]) + ';';

module.exports = {
    createNode,
    matchForNode,
    matchForRelation,
    matchForRelationX2,
    setTheyKnowMe,
    setRelationTypeByCondition,
}
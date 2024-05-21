// atoms
/**
 * 
 * @param {*} type 
 * @param {*} temp 
 * @param {*} obj 
 * @returns 
 */
const node = (type = '', temp = '', obj = '') => 
    `(${temp}${type && ':'+type}${obj && ' '+obj})`;
/**
 * 
 * @param {*} type 
 * @param {*} temp 
 * @param {*} node1 
 * @param {*} node2 
 * @returns 
 */
const relation = (type = '', temp = '', node1 = {}, node2 = {}) => 
    `${node(node1.type, node1.temp, node1.obj)} - [${temp}${type && ':'+type}] -> ${node(node2.type, node2.temp, node2.obj)}`;
/**
 * 
 * @param {*} whr 
 * @returns 
 */
const where = (whr) => 
    `${whr && 'WHERE ' + whr}`;
/**
 * 
 * @param {*} req 
 * @returns 
 */
const deleteResult = (req) => 
    `DELETE ${req.join(', ')}`;
/**
 * 
 * @param {*} req 
 * @returns 
 */
const returnResult = (req) => 
    `RETURN ${req.join(', ')}`;
/**
 * 
 * @param {*} variable 
 * @param {*} type 
 * @param {*} subject 
 * @param {*} prefix 
 * @returns 
 */
const setSubject = (variable, type, subject, prefix = '') => 
    `SET ${variable}.${prefix && prefix+'_'}${type}='${subject}'`;

// commands
const remove = (type, variable, object) => `MATCH ${node(type, variable, object)} ${deleteResult([variable])} `;
const create = (type, variable, object) => `CREATE ${node(type, variable, object)} `;
const match = (type, variable, object, whr = '') => `MATCH ${node(type, variable, object)} ${where(whr)} `;
const matchRelation = (rel, relName, whr = '') => `MATCH ${relation(rel, relName)} ${where(whr)} `;
const matchPath = (path, rel = '', relName = '', node1 = {}, node2 = {}, whr = '') => `MATCH ${path && path+'='}${relation(relName, rel, node1, node2)} ${where(whr)}`;
const mergeRelation = (relation, relationName, from, to) => `MERGE (${from})-[${relation}:${relationName}]->(${to}) `;
const setRelationType = (rel, relType, subject) => `${setSubject(rel, relType, subject, 'tyre')} `;

module.exports = {
    remove,
    create,
    match,
    matchRelation,
    matchPath,
    mergeRelation,
    setRelationType,
    deleteResult,
    returnResult,
}
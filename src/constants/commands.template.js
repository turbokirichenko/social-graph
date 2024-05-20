// atoms
const node = (type = '', temp = '', obj = '') => `(${temp}${type && ':'+type} ${obj})`;
const relation = (type = '', temp = '', node1 = {}, node2 = {}) => `${node(...node1)} - [${temp}${type && ':'+type}] -> ${node(...node2)}`;
const where = (whr) => `${whr && 'WHERE ' + whr}`;
const deleteResult = (req) => `DELETE ${req.join(', ')}`;
const returnResult = (req) => `RETURN ${req.join(', ')}`;
const setSubject = (variable, type, subject, prefix = '') => `SET ${variable}.${prefix && prefix+'_'}${type}='${subject}'`;

// commands
const remove = (type, variable, object) => `MATCH ${node(type, variable, object)} ${deleteResult([variable])} `;
const create = (type, variable, object) => `CREATE ${node(type, variable, object)} `;
const match = (type, variable, object, whr = '') => `MATCH ${node(type, variable, object)} ${where(whr)} `;
const matchRelation = (rel, relName, whr = '') => `MATCH ${relation(rel, relName)} ${where(whr)} `;
const matchPath = (path, rel = '', relName = '', node1 = {}, node2 = {}, whr = '') => `MATCH ${path && path+'='}${relation(rel, relName, node1, node2)} ${where(whr)}`;
const mergeRelation = (relation, relationName, from, to) => `MERGE (${from})-[${relation}:${relationName}]->(${to}) `;
const setRelationType = (rel, relType, subject) => `${setSubject(rel, relType, subject, 'tyre_')} `;

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
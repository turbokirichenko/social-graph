const remove = (type, variable, where) => `MATCH (${variable}:${type} ${where}) DELETE ${variable}`;
const create = (object, variable, value) => `CREATE (${variable}:${object} ${value})`;
const mergeRelation = (object, where, to, relation) => ``;
const setRelationType = (object, where, to, relation, type) => ``;

module.exports = {
    create,
    remove,
    mergeRelation,
    setRelationType,
}
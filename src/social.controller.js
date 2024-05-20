const { create } = require('./constants/commands.template');

const v = {
    variable: 'p',
    value: '{name: $paramName, city: $paramCity}',
};

/** create node of neo4j
 * 
 * @param {neo4j.Session} session 
 * @param {string} type - type of node
 * @param {{
 *  name: string,
 *  region: string,
 *  age?: number
 * } | {
 *  name: string,
 *  region: string,
 *  age?: number}[]} data 
 */
function createNode(session, type, data) {
    return session.run(create(type, v.variable, v.value), {
        paramName: data.name,
        paramCity: data.region
    });
}

/** create relation between nodes
 * @param { neo4j.Session } session - database session
 * @param {{ 
 *  name: string, 
 *  type: string 
 * }} relation - neo4j relation
 * @param {{ 
 *  name: string, 
 *  region?: string | number 
 * }} from - person
 * @param {{ 
 *  name: string, 
 *  region?: string | number 
 *  }[]} to - ties to set relations
 */
function createRelation(session, relation, from, to) {

}

module.exports = {
    createNode,
}
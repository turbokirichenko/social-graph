var neo4jconnection = require('./neo4j');

const { driver, session } = neo4jconnection();

console.log('connection is ready');
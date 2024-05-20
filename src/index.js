var neo4jconnection = require('./utils/neo4j');
var commands = require('./constants/commands.template');
var graph = require('./utils/json-parse')();

const { driver, session } = neo4jconnection();

async function main() {
    const history = [];

    // create
    const requests = graph.nodes.map((node, index) => {
        return commands.create('Template', `p${index+1}`, `{name: "${node.name}", city: "${node.region}"}`);
    });
    for (const command of requests) {
        try {
            var result = await session.run(command)
            history.push(command);
        } catch (err) {
            console.error('[ERROR]: Not executed command!!!', err)
            throw err;
        }
    }

    // create relations
    for (const node of graph.nodes) {
        try {
            
        } catch (err) {

        }
    }

    console.log(history);
    driver.close().then(() => console.log('close connection'));
}

main();
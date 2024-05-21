var neo4j = require('neo4j-driver');

/** start connection to the database
 * 
 * @returns {{ 
 *  driver: neo4j.Driver, 
 *  session: neo4j.Session 
 * }}
 */
function bootsrtap() {
    try {
        const driver = neo4j.driver(
            process.env.NEO4J_DRIVER_URL,
            neo4j.auth.basic(process.env.NEO4J_USERNAME, process.env.NEO4J_PASSWORD)
        )
        const session = driver.session({ 
            defaultAccessMode: neo4j.session.WRITE, 
            database: process.env.NEO4J_DEFAULT_DATABASE 
        });
        return { driver, session }
    } catch (err) {
        console.error('[ERROR]: Something went wrong, please check the neo4j environments...');
        throw err;
    }
}

module.exports = bootsrtap;
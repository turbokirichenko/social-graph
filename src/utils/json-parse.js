const jsonFile = require('../config/migration.json');
const manNames = require('../config/man-names.json');
const womanNames = require('../config/fem-names.json');
const cityNames = require('../config/city-names.json');

module.exports = () => {
    const jsonF = JSON.parse(JSON.stringify(jsonFile));
    const notations = jsonF.$notations.map((notation, index) => {
        const name = (index < 10) ? manNames[notation[0]] : womanNames[notation[0]];
        const region = cityNames[notation[1]];
        return { name, region };
    });
    const nodes = notations.filter((n, index) => (index < 10));
    nodes.splice(4, 0, notations[10]),
    nodes.splice(7, 0, notations[11])
    const knows = jsonFile.knows;

    return { nodes, knows };
}
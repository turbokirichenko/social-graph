module.exports = function(func) {
    return new Promise((resolve, reject) => {
        try {
            func.then(result => {
                resolve(result);
            });
        } catch (err) {
            reject(err);
        }
    })
}
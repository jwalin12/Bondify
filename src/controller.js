const web3 = require('web3');
const fs = require('fs');
require('dotenv').config();
var Contract = require('web3-eth-contract');







//Create and object and export it, usingw web3 wrapper. Let it's functions be used by the UI and 
//initialize it based on url and stuff from env.
let Controller = class {
    constructor(pathToJSON) {
        let contract;
        let rawdata = fs.readFileSync(pathToJSON);
        let json = JSON.parse(rawdata);
        console.log(json);
        this.contract = new Contract(json.abi, process.env.ROPSTEN_ADDR);
    }

}


exports.Controller = Controller;
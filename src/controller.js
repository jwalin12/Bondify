import * as web3 from 'web3';
require('dotenv').config();
const JSON = require('require');
const fs = require('fs');







//Create and object and export it, usingw web3 wrapper. Let it's functions be used by the UI and 
//initialize it based on url and stuff from env.





export default class Controller {

    constructor(pathToAbi) {
        const rawdata = fs.readFileSync(pathToAbi);
        const abi = JSON.parse(rawdata);
        this.contract =  web3.eth.Contract(abi, env.process.ROPSTEN_ADDR);
        
    }

}
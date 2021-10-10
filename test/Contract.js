const { expect } = require('chai');
const { ethers } = require("hardhat");
const Controller = require('../src/controller');



describe('Bondify Controller', () => {

    describe('Initializing', () => {

        it('should work as expected', () => {
            const controller = new Controller.Controller('/Users/jwalinjoshi/Bondify/artifacts/contracts/Bondify.sol/Bondify.json');

        });

    });


});
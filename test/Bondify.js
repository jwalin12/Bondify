const { expect } = require('chai');
const { ethers } = require("hardhat");
require("@atixlabs/hardhat-time-n-mine");





describe('Bondify contract', () => {
   

    describe('Minting', async () => {
       
        it('should mint new bonds correctly', async () => {
            let Bondify, bondify, issuer, buyer;
            Bondify = await ethers.getContractFactory("Bondify");
            bondify = await Bondify.deploy();
            [issuer, buyer] = await ethers.getSigners();
            const bondId = await bondify.createBond(100, 105, 100000000000);
        });
        it('should fail if principal is higher than payout', async () => {
            let Bondify, bondify, issuer, buyer;
            Bondify = await ethers.getContractFactory("Bondify");
            bondify = await Bondify. deploy();
            [issuer, buyer] = await ethers.getSigners();
            try {
            await bondify.createBond(105, 100, 100000);

            } catch(error) {
                expect(error.message).to.contain(`payout must be greater than principal`);
            }
        });  
        it('should fail if principal is less than or equal to 0', async () => {
            let Bondify, bondify, issuer, buyer;
            Bondify = await ethers.getContractFactory("Bondify");
            bondify = await Bondify.deploy();
            [issuer, buyer] = await ethers.getSigners();
            try {
            await bondify.createBond(0, 100, 100000);

            } catch(error) {
                expect(error.message).to.contain('principal must be greater than 0');
            }
        });
        it('should fail if expiry is in the past', async () => {
            let Bondify, bondify, issuer, buyer;
            Bondify = await ethers.getContractFactory("Bondify");
            bondify = await Bondify. deploy();
            [issuer, buyer] = await ethers.getSigners();
            try {
            await bondify.createBond(100, 105, 0);

            } catch(error) { 
                expect(error.message).to.contain('bond must expire in the future');
            }
        });
    
    });



    describe('Excersizing', async () => {
        it('should work as expected', async () => {

        });

        it('should work when bond is transferred between users', async () => {

        });

        it('should fail when the bond has not expired', async () => {

        });

        it('should fail if the owner is the issuer', () => {

        });

        it('should fail if there is not enough money in the smart contract', () => {

        });







    });

 

    describe('Deposit and Withdrawal', async () => {
        it('should work as expected', async () => {
            let Bondify, bondify, issuer, buyer;
            Bondify = await ethers.getContractFactory("Bondify");
            bondify = await Bondify.deploy();
            [issuer, buyer] = await ethers.getSigners();
            expect(issuer.sendTransaction({
                to: bondify.address,
                value: ethers.utils.parseEther("1.0"),
            })).to.emit('Deposit', 1000000000000000000);
            expect(bondify.connect(issuer).withdraw()).to.emit('Withdrawal', 1000000000000000000);
        });

    });


}






);
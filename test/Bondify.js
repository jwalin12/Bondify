const { expect } = require('chai');
const { ethers } = require("hardhat");





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
            let Bondify, bondify, issuer, buyer;
            Bondify = await ethers.getContractFactory("Bondify");
            bondify = await Bondify.deploy();
            [issuer, buyer] = await ethers.getSigners();
            let bondId;
            bondId = await bondify.createBond(10, 11, 100000000000);
            await network.provider.send("evm_setNextBlockTimestamp", [1000000000005]);
            await network.provider.send("evm_mine");
            //use hardhat setTime to set time before running
            bondify.transferFrom(issuer.address, buyer.address, 1); //TODO: figure out why this fails if bondId is passed in
            await issuer.sendTransaction({
                to: bondify.address,
                value:  ethers.utils.parseEther("120.0"),
            });
                await bondify.connect(buyer).excersizeBond(1);


        });

        it('should fail when bond is transferred between users and older user tries to  excersize', async () => {
            let Bondify, bondify, issuer, buyer, buyer2;
            Bondify = await ethers.getContractFactory("Bondify");
            bondify = await Bondify.deploy();
            [issuer, buyer, buyer2] = await ethers.getSigners();
            let bondId;
            await network.provider.send("evm_setNextBlockTimestamp", [1000000000010]);
            await network.provider.send("evm_mine");
            bondId = await bondify.createBond(10, 11, 100000000015);
            //use hardhat setTime to set time before running
            await bondify.transferFrom(issuer.address, buyer.address, 1); //TODO: figure out why this fails if bondId is passed in
            await bondify.transferFrom(buyer.address, buyer2.address, 1);
            await issuer.sendTransaction({
                to: bondify.address,
                value:  ethers.utils.parseEther("120.0"),
            });
            try {
                await bondify.connect(buyer).excersizeBond(1);
            } catch (error) {
                expect(error.message).to.contain('transfer caller is not owner nor approved');
            }
           

        });

        it('should work when bond is transferred between users and new user tries to  excersize', async () => {
            let Bondify, bondify, issuer, buyer, buyer2;
            Bondify = await ethers.getContractFactory("Bondify");
            bondify = await Bondify.deploy();
            [issuer, buyer, buyer2] = await ethers.getSigners();
            let bondId;
            await network.provider.send("evm_setNextBlockTimestamp", [1000000000020]);
            await network.provider.send("evm_mine");
            bondId = await bondify.createBond(10, 11, 100000000025);
            //use hardhat setTime to set time before running
            await bondify.transferFrom(issuer.address, buyer.address, 1); //TODO: figure out why this fails if bondId is passed in
            await bondify.transferFrom(buyer.address, buyer2.address, 1); // 
            await issuer.sendTransaction({
                to: bondify.address,
                value:  ethers.utils.parseEther("120.0"),
            });
            await bondify.connect(buyer2).excersizeBond(1);

        });

        it('should fail when the bond has not expired', async () => {
            let Bondify, bondify, issuer, buyer;
            Bondify = await ethers.getContractFactory("Bondify");
            bondify = await Bondify.deploy();
            [issuer, buyer] = await ethers.getSigners();
            let bondId;
            await network.provider.send("evm_setNextBlockTimestamp", [1000000000030]);
            await network.provider.send("evm_mine");
            bondId = await bondify.createBond(10, 11, 100000000035);
            //use hardhat setTime to set time before running
            bondify.transferFrom(issuer.address, buyer.address, 1); //TODO: figure out why this fails if bondId is passed in
            await issuer.sendTransaction({
                to: bondify.address,
                value:  ethers.utils.parseEther("120.0"),
            });
            try {
                await bondify.connect(buyer).excersizeBond(1);
            } catch(error) {
                expect(error.message).to.contain('tried to get bond payout before bond expires!');
            }
                

        });

        it('should fail if there is not enough money in the smart contract', async () => {
            let Bondify, bondify, issuer, buyer;
            Bondify = await ethers.getContractFactory("Bondify");
            bondify = await Bondify.deploy();
            [issuer, buyer] = await ethers.getSigners();
            let bondId;
            bondId = await bondify.createBond(10, 11, 1000000000);
            await network.provider.send("evm_increaseTime", [5]);
            await network.provider.send("evm_mine");
            //use hardhat setTime to set time before running
            bondify.transferFrom(issuer.address, buyer.address, 1); //TODO: figure out why this fails if bondId is passed in
            try {
                await bondify.connect(buyer).excersizeBond(1);
            } catch(error) {
                expect(error.message).to.contain('tried to get bond payout before bond expires!');
            }

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
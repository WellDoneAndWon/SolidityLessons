const { expect } = require("chai")
const { ethers } = require("hardhat")

describe("Demo", function() {
    let owner
    let other_addr
    let demo

    beforeEach(async function() {
        [owner, other_addr] = await ethers.getSigners()

        const DemoContract = await ethers.getContractFactory("Demo", owner)
        demoContract = await DemoContract.deploy()
        await demoContract.deployed()
    })

    async function sendMoney(sender) {
        const amount = 1000;
        const txData = {
            to: demoContract.address,
            value: amount 
        }

        const tx = await sender.sendTransaction(txData)
        await tx.wait()
        return [tx, amount]
    }

    it("should allow to send money", async function() {
        const [sendMoneyTx, amount] = await sendMoney(other_addr)
        console.log(sendMoneyTx)

        await expect(await sendMoneyTx)
          .to.changeEtherBalance(demoContract, amount);

        const timestamp = (
            await ethers.provider.getBlock(sendMoneyTx.blockNumber)
            ).timestamp

        await expect(sendMoneyTx)
            .to.emit(demoContract, "Paid")
            .withArgs(other_addr.address, amount, timestamp);
    })

    it("should allow owner to withdraw money", async function() {
        const [_, amount] = await sendMoney(other_addr)
        
        const tx = await demoContract.withdraw(owner.address)

        await expect(() => tx)
            .to.changeEtherBalances([demoContract, owner], [-amount, amount])
    })

    it("should not allow other accounts to withdraw money", async function(){
        await sendMoney(other_addr)

        await expect(
            demoContract.connect(other_addr).withdraw(other_addr.address)
            ).to.be.revertedWith("you're not the owner!")
    })
})
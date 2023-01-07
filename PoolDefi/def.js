async function deposit(poolContract, amount) {
    // Get the current account
    const accounts = await web3.eth.getAccounts();
    const account = accounts[0];

    // Deposit the specified amount into the contract
    await poolContract.methods.deposit().send({
        from: account,
        value: web3.utils.toWei(amount, "ether")
    });
}

async function withdraw(poolContract) {
    // Get the current account
    const accounts = await web3.eth.getAccounts();
    const account = accounts!

import time
from brownie import LeveragedCompFarming, network, config, interface
from scripts.utils.helper_scripts import (
    approve_erc20,
    get_account,
    get_erc20_balance,
    mint_erc20, 
    fromWei,
    FORKED_BLOCHCHAINS,
    toWei
)
from scripts.utils.get_weth import get_weth

dai_token = config["networks"][network.show_active()]["dai-token"]
cdai = config["networks"][network.show_active()]["cdai"]
comptroller = config["networks"][network.show_active()]["comptroller"]

def get_comp_rate():
    ctokeninterface = interface.CErc20(cdai)
    rate = ctokeninterface.exchangeRateCurrent.call()
    print("exchange rate is : ", fromWei(rate))
    return rate
    
def main():

    account = get_account()
    if network.show_active() in FORKED_BLOCHCHAINS:
        get_weth(account, 5)
        mint_erc20(dai_token, 4, account)
    
    farmer = LeveragedCompFarming.deploy(
        dai_token,
        cdai,
        comptroller,
        {"from": account}
    )

    amount = toWei(6000)

    approve_erc20(dai_token, farmer.address, amount, account)

    deposit_tx = farmer.deposit(amount, {"from": account})
    deposit_tx.wait(1)

    print(f"initial balance of farmer is : {fromWei(get_erc20_balance(dai_token, farmer.address))} DAI")

    start_tx = farmer.startFarming(toWei(2000), {"from": account})
    start_tx.wait(1)

    time.sleep(420)

    exc_rate = get_comp_rate()

    current_cdai_balance = farmer.getCTokenBalance()
    print(f"Balance of cDAI is : {fromWei(current_cdai_balance * exc_rate)} cDAI")

    time.sleep(420)

    end_tx = farmer.endFarming({"from": account})
    end_tx.wait(1)

    print(f"final balance of farmer is : {fromWei(get_erc20_balance(dai_token, farmer.address))} DAI")

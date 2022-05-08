from brownie import network, interface, config
from scripts.utils.helper_scripts import fromWei, get_account, toWei



def get_weth(account, amount_in_eth):
    weth_address = config["networks"][network.show_active()]["weth-token"]

    weth = interface.IWeth(weth_address)

    deposit_tx = weth.deposit({"from": account, "value": toWei(amount_in_eth)})
    deposit_tx.wait(1)

    print(f"You recieved {amount_in_eth} weth")

def main():
    account = get_account()
    amount = toWei(10)
    get_weth(account, amount)
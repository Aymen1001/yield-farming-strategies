// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./compound/CTokenInterface.sol";
import "./compound/IComptroller.sol";

contract LeveragedCompFarming {
    //--------------------------------------------------------------------
    // VARIABLES
    
    address public owner;

    // safety factor = 70 %
    uint256 public leverageFactor = 70;
    address public cDaiAddress;

    CErc20 cDai;
    IERC20 dai;
    IComptroller comptroller;
    
    //--------------------------------------------------------------------
    // MODIFIERS
    
    modifier onlyOwner() {
        require(msg.sender == owner, "only owner call");
        _;
    }

    //--------------------------------------------------------------------
    // CONSTRUCTOR
    
    constructor(
        address _daiAddress,
        address _cDaiAddress,
        address _comptrollerAddress
    ) {
        owner = msg.sender;

        dai = IERC20(_daiAddress);
        cDai = CErc20(_cDaiAddress);
        comptroller = IComptroller(_comptrollerAddress);

        cDaiAddress = _cDaiAddress;
    }
    
    //--------------------------------------------------------------------
    // FUNCTIONS

    function deposit(uint256 _amount) public onlyOwner {
        dai.transferFrom(msg.sender, address(this), _amount);

        address[] memory ctokens = new address[](1);
        ctokens[0] = cDaiAddress;
        comptroller.enterMarkets(ctokens);
    }

    function withdraw(uint256 _amount) public onlyOwner {
        require(_amount > 0);
        dai.transferFrom(address(this), msg.sender, _amount);
    }
    
    // Used to supply DAI to Compound and then use the deposited amount to borrow more DAI, thus claiming twice the Comp APY.
    // The process is repeated many times to maximize the return
    function startFarming(uint256 _amount) public onlyOwner {
        uint256 newCollateral = _amount;
        for (uint256 i = 0; i < 5; i++) {
            newCollateral = _supplyAndBorrow(newCollateral);
        }
    }

    function endFarming() public onlyOwner {
        uint256 totalBorrowAmount = cDai.borrowBalanceCurrent(address(this));
        dai.approve(cDaiAddress, totalBorrowAmount);
        cDai.repayBorrow(totalBorrowAmount);
        uint256 cDaiBalance = cDai.balanceOf(address(this));
        cDai.redeem(cDaiBalance);
    }

    function _supplyAndBorrow(uint256 _amount) internal returns (uint256) {
        dai.approve(cDaiAddress, _amount);
        cDai.mint(_amount);
        uint256 _borrowedAmount = (_amount * leverageFactor) / 100;
        cDai.borrow(_borrowedAmount);

        return _borrowedAmount;
    }

    function getCTokenBalance() public view returns (uint256) {
        return cDai.balanceOf(address(this));
    }
}

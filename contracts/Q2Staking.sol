// SPDX-License-Identifier: MIT

pragma solidity 0.8.6;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Q2Staking is Ownable, ReentrancyGuard {
    using SafeMath for uint256;

    IERC20 public token;
    address public masterAccount;

    mapping(address => mapping(uint256 => uint256)) private unLockDateMap;
    mapping(address => mapping(uint256 => uint256)) private unLockTokenAmount;
    mapping(uint256 => uint256) public rewardPercentage;
    mapping(uint256 => uint256) public lockTimeDetails;
    mapping(address => uint256) public stakingBalance;

    event WithDrawnToken(address indexed manager, uint256 amount);
    event Staked(
        address indexed account,
        uint256 amount,
        uint256 stakedTime,
        uint256 unStakeTime
    );

    constructor(address _token, address _masterAccount) {
        token = IERC20(_token);
        masterAccount = _masterAccount;
        _setIntialLockTimeDetails();
        _setInitialRewardPrecentage();
    }

    function changeMasterAccount(address _masterAccount) external onlyOwner {
        masterAccount = _masterAccount;
    }

    function _setInitialRewardPrecentage() private {
        rewardPercentage[0] = 40;
        rewardPercentage[1] = 120;
        rewardPercentage[2] = 322;
    }

    function _setIntialLockTimeDetails() private {
        lockTimeDetails[0] = 15811200;
        lockTimeDetails[1] = 31536000;
        lockTimeDetails[2] = 63072000;
    }

    modifier unlockCheck(uint256 index) {
        require(
            unLockTokenAmount[msg.sender][index] != 0,
            "You do not have permission to unlock"
        );
        _;
    }

    function blockTimestamp() public view virtual returns (uint256) {
        return block.timestamp;
    }

    function stake(uint256 amount, uint256 package) public nonReentrant {
        require(package <= 2, "Package Must be less than 2");
        address account = msg.sender;

        // Transfer token from user to contract
        token.transferFrom(account, address(this), amount);

        // Reward Amount
        uint256 rewardAmount = (amount * rewardPercentage[package]) / 1000;

        // Reward Amount Sent From Master Account to Contract
        token.transferFrom(masterAccount, address(this), rewardAmount);

        // Unlock Time
        unLockDateMap[account][stakingBalance[account]] =
            block.timestamp +
            lockTimeDetails[package];

        // Unlock Token Amount
        unLockTokenAmount[account][stakingBalance[account]] =
            amount +
            rewardAmount;
        stakingBalance[account] += 1;
        emit Staked(
            account,
            amount + rewardAmount,
            block.timestamp,
            block.timestamp + lockTimeDetails[package]
        );
    }

    function unlockQ2(uint256 index) public unlockCheck(index) nonReentrant {
        require(
            blockTimestamp() > unLockDateMap[msg.sender][index],
            "It's not time to unlock"
        );
        _safeTransfer(unLockTokenAmount[msg.sender][index]);
        unLockTokenAmount[msg.sender][index] = 0;
        emit WithDrawnToken(msg.sender, unLockTokenAmount[msg.sender][index]);
    }

    function _safeTransfer(uint256 tokenNum) private {
        token.transfer(msg.sender, tokenNum);
    }

    function stakingDetails(address userAddress, uint256 index)
        public
        view
        returns (uint256, uint256)
    {
        return (
            unLockTokenAmount[userAddress][index],
            unLockDateMap[userAddress][index]
        );
    }
}

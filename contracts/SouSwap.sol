// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SouSwap {
    IERC20 token;

    uint public totalLiquitidy;
    mapping(address => uint) public liquidity;

    constructor(address token_addr) {
        token = IERC20(token_addr);
    }

    function init(uint _tokens) public payable returns (uint) {
        require(totalLiquitidy == 0, "DEX already has a liquidity");
        totalLiquitidy = address(this).balance;
        liquidity[msg.sender] = totalLiquitidy;
        require(token.transferFrom(msg.sender, address(this), _tokens));
        return totalLiquitidy;
    }

    //trade ether for tokens
    function ethToToken() public payable returns (uint) {
        uint token_reserve = token.balanceOf(address(this));
        uint currentBalance = address(this).balance - msg.value;
        uint tokens_bought = getInputPrice(
            msg.value,
            currentBalance,
            token_reserve
        );
        require(token.transferFrom(address(this), msg.sender, tokens_bought));
        return tokens_bought;
    }

    function tokenTOEth(uint _tokens) public payable returns (uint) {
        uint token_reserve = token.balanceOf(address(this));
        uint eth_bought = getInputPrice(
            _tokens,
            token_reserve,
            address(this).balance
        );
        require(token.transferFrom(msg.sender, address(this), _tokens));
        return eth_bought;
    }

    //@notice to get the token price
    function getInputPrice(
        uint256 input_amount,
        uint256 input_reserve,
        uint256 output_reserve
    ) public pure returns (uint256) {
        require(input_reserve > 0 && output_reserve > 0, "INVALID_VALUE");
        uint input_amount_with_fee = input_amount * 997;
        uint numerator = input_amount_with_fee * output_reserve;

        uint denominator = (input_reserve * 1000) + input_amount_with_fee;

        return numerator / denominator;
    }

    // Deposit ether. The DEX will calculate an equivalent
    // amount of ERC2@ token according to the exchange rate,
    // and transfer the ERC20 tokens from the sender to the DEX.
    // function deposit() public payable returns (uint256) {
    //     uint256 eth_reserve = address(this).balance.sub(msg.value);
    //     uint256 token_reserve = token.balanceOf(address(this));
    //     uint256 token_amount = ((msg.value * (token_reserve)) / eth_reserve) +
    //         (1);
    //     uint256 liquidity_minted = (msg.value * (totalLiquidity)) / eth_reserve;
    //     liquidity[msg.sender] = liquidity[msg.sender].add(liquidity_minted);
    //     totalLiquidity = totalLiquidity.add(liquidity_minted);
    //     require(token.transferFrom(msg.sender, address(this), token_amount));

    //     return Liquidity_minted;
    // }
}

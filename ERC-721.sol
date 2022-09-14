/*//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "hardhat/console.sol";

interface IYT{
    function transfer(address to, uint256 amount) external returns (bool) ;
    function balanceOf(address account) external view  returns (uint256);
}

contract my721Token is ERC721, Ownable {
    uint NFTsMinted = 0;
    uint mintedNFTs = 0;
    

    IYT public ERC20contractAddress;


    mapping(uint => address) public NFTowners;
    mapping(address => uint) public numberOfNFT;

    constructor() ERC721("Vaithi", "YT") {}

    function safeMint(address to, uint256 tokenId) external onlyOwner {
        require(numberOfNFT[to] < 1, "Only one NFT for one address");
        require(NFTsMinted < 5, "Only 5 NFTs can be minted");
        _safeMint(to, tokenId);
        NFTsMinted += 1;
        numberOfNFT[to] += 1;
        NFTowners[NFTsMinted] = to;
    }

    function updateContractAddress(address contractAddress) public onlyOwner{
        ERC20contractAddress = IYT(contractAddress);
    }


    function balanceOfERC20(address NFTownerAddressses) public view returns (uint256){
        return (IYT(ERC20contractAddress).balanceOf(NFTownerAddressses));
    }

    function ERC20inERC721() public view returns(uint256){
        return(IYT(ERC20contractAddress)).balanceOf(address(this));
       
    }

    function withdrawTokens() public payable onlyOwner {
        require(NFTsMinted == 5, "All NFT's must be minted first");
        for (uint i = 1; i <= NFTsMinted; i++) {
            console.log(NFTowners[i]);
            IYT(ERC20contractAddress).transfer(NFTowners[i] , 10);
          
        }
    } 
}

contract ERC20token is ERC20 {
    constructor() ERC20("Vaithii", "YT") {
        _mint(msg.sender, 1000);
    }

}


/*ADDRESSES FOR CHECKING:
0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB
0x617F2E2fD72FD9D5503197092aC168c91465E7f2
0x17F6AD8Ef982297579C203069C1DbfFE4348c372
0x5c6B0f7Bf3E7ce046039Bd8FABdfD3f9F5021678
*/

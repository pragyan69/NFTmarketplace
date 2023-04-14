//SPDX License-Identifier:MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "hardhat/console.log";

contract NFTMarketPlace is ERC721URIStorsge{
   using Counters for Counters.Counter;
 
 Counters.Counter private token_id;
 Counters.Counter private _itemSold;
 uint256 listingPrice = 0.0025 ether;
 address payable owner;

mapping (uint=> MarketItem) public idMarketItem;

struct MarketItem{
    uint256 tokenid;
    address payable seller;
    address payable owner;
    uint256  price;
    bool sold;
}


event MarketitemCreated(
    uint256 indexed tokenid,
    address seller,
    address owner,
    uint256 price,
    bool sold
);


constructor() ERC721("nft metaverse token" , "MNMB")
{
    owner == payable(msg.sender);
}

modifier onlyOwner
{
    require(msg.sender == owner , " only owner can change the listing price");
    _;

}

function updateListingPrice(uint _listingprice) public payable onlyOwner
{


  listingPrice  = _listingprice;
}

function getListingPrice() public view returns(uint256){
    return listingPrice;
}

// let create nft token function

function createtoken(string memory tokenURI , uint256 price)public payable returns(uint256){
    token_id.increment();// increment the exsting token
    uint newTokenId = token_id.current(); // setting the new token as the increment existing token
    _mint(msg.sender , token_id); // using the mint function to mint the token
    _setTokenURI(newTokenId , tokenURI); // using the function
    return newTokenId;

}

function createMarketItem(uint256 tokenid , uint256 price) private{
    require(price >0 , "the price should be atleast 1 gwi");
    require(msg.value > listingPrice , "the bidding amount should be greater than the listing price");

    idMarketItem[tokenid] = MarketItem(
        tokenid,
        payable(msg.sender),
        payable(address(this)),
        price,
        false


    );

    // now we have to call the transfer function
    _transfer(msg.sender , address(this) , tokenid);


    // we are emmiting the event created as we have called the function

    MarketitemCreated(tokenid,
     msg.sender, 
     address(this), 
     price, 
     false);
} 

function resellernft(uint256 tokenid , uint256 price) public payable{
    require(idMarketItem[tokenid] == msg.sender , "only the creator can call this function");
    require(msg.value == listingPrice , "the biddng amount cannot be less than the listing price of the NFT");

    idMarketItem[tokenid].sold = false;
    idMarketItem[tokenid].owner = payable(msg.sender);
    idMarketItem[tokenid].seller = payable(address(this));
    idMarketItem[tokenid].price = price;
    _itemSold.decrement();

    _transfer(msg.sender , address(this) , tokenid);
}

function createNFTforMarketSEll(uint256 tokenid )  public payable{
    uint256 price = idMarketItem(tokenid).price;
    require(msg.value == price , "the price should be more");
    idMarketItem[tokenid].owner = payable(msg.sender);
    idMarketItem[tokenid].sold = true;
    idMarketItem[tokenid].seller = payable(address(0));
    _itemSold.increment();
    _transfer(address(this) , msg.sender, tokenid);
    // after the transaction we have to write the function to send the value to the person who is buying the NFT
    payable(owner).transfer(listingPrice);
    payable(idMarketItem[tokenid].seller).tranfer(msg.value);


}
// function to fetch the NFT from the market item
function fetchMarketItem() public returns(MarketItem[] memory){
    uint256 itemCount = token_id.current();
    uint256 remamingItems = token_id.current() - _itemSold.current();

    uint currentIndex = 0;
    MarketItem[] memory items = new MarketItem[](unsoldItemCount);

    for(uint256 i = 0; i< itemCount ; i++){
         if(idMarketItem[i+1].owner = address(this)){
            uint currentItem = i+1;
            MarketItem storage currentItem = idMarketItem[currentItem];
            items[currentIndex] = currentItem;
            currentIndex+= 1;
             


         }

    }

    return items;

}


function fetchMyNFTs() public view returns(MarketItem[] memory) {
   //
}


function fetchItemsListed() public view returns(MarketItem[] memory) {

    //

}



}
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract Twitter {
  struct Tweet {
    uint256 id;
    string content;
    uint256 timestamp;
    address author;
    bool deleted;
  }

  address payable public owner;

  Tweet[] public tweets;
  mapping(address => bool) public isUserCertified;

  constructor() {
    owner = payable(msg.sender);
  }

  /**
   * A modifier to prevent anyone other than the author of a tweet to execute
   * the function
   * @param _id The _id of the concerned tweet
   */
  modifier authorOnly(uint256 _id) {
    require(
      msg.sender == tweets[_id].author,
      'Only the author of the tweet can call this function'
    );
    _;
  }

  /**
   * @dev A function that returns all the (non-deleted) tweets.
   * @return Tweet[] An array of all the tweets.
   */
  function getTweets() public view returns (Tweet[] memory) {
    uint256 totalCount;
    for (uint256 i = 0; i < tweets.length; i++) {
      if (!tweets[i].deleted) {
        totalCount++;
      }
    }

    Tweet[] memory returnedTweets = new Tweet[](totalCount);
    uint256 count = 0;

    for (uint256 i = 0; i < tweets.length; i++) {
      if (!tweets[i].deleted && (count < 600 || isUserCertified[msg.sender])) {
        returnedTweets[count] = tweets[i];
        count++;
      }
    }

    return returnedTweets;
  }

  /**
   * @dev A function that creates a new tweet.
   * @param _content The content of the tweet.
   */
  function createTweet(string calldata _content) external {
    _createTweet(_content);
  }

  /**
   * Allows a user to delete one of his tweets
   * @param _id The id of the tweet to be deleted
   */
  function deleteTweet(uint256 _id) external authorOnly(_id) {
    tweets[_id].deleted = true;
  }

  /**
   * Allows a user to update one of his tweets
   * @param _id The id of the tweet to be updated
   */
  function updateTweet(
    uint256 _id,
    string calldata _newContent
  ) external authorOnly(_id) {
    tweets[_id].content = _newContent;
  }

  /**
   * @dev A function that allows a user to get certified on the platform
   */
  function certifiedSignUp() external payable {
    require(msg.value >= 0.00051 ether, 'Not enough ether sent');

    isUserCertified[msg.sender] = true;
  }

  /**
   * @dev A function that creates a new tweet.
   * @param _content The content of the tweet.
   */
  function _createTweet(string calldata _content) private {
    tweets.push(
      Tweet({
        id: tweets.length,
        content: _content,
        timestamp: block.timestamp,
        author: msg.sender,
        deleted: false
      })
    );
  }

  function withdraw() public {
    require(msg.sender == owner, "You aren't the owner");

    owner.transfer(address(this).balance);
  }
}

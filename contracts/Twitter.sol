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

  Tweet[] public tweets;

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
    Tweet[] memory returnedTweets;
    uint256 count = 0;

    for (uint256 i = 0; i < tweets.length; i++) {
      if (!tweets[i].deleted) {
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
}

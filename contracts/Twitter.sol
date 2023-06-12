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
}

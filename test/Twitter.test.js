const { expect } = require('chai');
const { ethers } = require('hardhat');
require('chai').should();

describe('Decentralized Twitter', async () => {
  beforeEach(async () => {
    Twitter = await ethers.getContractFactory('Twitter');
    [author0, author1, author2] = await ethers.getSigners();
    twitter = await Twitter.deploy();
  });

  describe('Initial state', () => {
    it('should not show any tweet', async () => {
      const tweets = await twitter.getTweets();

      tweets.length.should.equal(0);
    });
  });

  describe('After one tweet', () => {
    beforeEach(async () => {
      await twitter.connect(author0).createTweet('Hello world!');
    });

    it('should show one tweet', async () => {
      const tweets = await twitter.getTweets();

      tweets.length.should.equal(1);
    });

    it('should create a new tweet', async () => {
      await twitter.connect(author0).createTweet('My tweet number 2');

      const tweets = await twitter.getTweets();
      tweets.length.should.equal(2);
    });

    it('should delete a tweet', async () => {
      await twitter.connect(author0).deleteTweet(0);

      const tweets = await twitter.getTweets();
      tweets.length.should.equal(0);
    });

    it('should update a tweet', async () => {
      await twitter.connect(author0).updateTweet(0, 'Updated tweet');

      const tweets = await twitter.getTweets();
      // tweets[0].content.should.equal('Updated tweet');
      expect(tweets[0].content).to.equal('Updated tweet');
    });

    describe('Call from another user', () => {
      it('should not delete a tweet from another author', async () => {
        await expect(
          twitter.connect(author1).deleteTweet(0),
        ).to.be.revertedWith(
          'Only the author of the tweet can call this function',
        );
      });

      it('should not update a tweet from another author', async () => {
        await expect(
          twitter.connect(author1).updateTweet(0, 'Updated tweet'),
        ).to.be.revertedWith(
          'Only the author of the tweet can call this function',
        );
      });
    });
  });
});
